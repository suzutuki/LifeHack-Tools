/* Fires these events on list elements:

     - slip:swipe
        スワイプが行われた後、指を離したときに、要素が元の位置に戻ってアニメーションします。
        event.preventDefault()を実行すると元の位置に戻ります。
        それ以外の場合は、リストから外れてアニメーションし、display:noneに設定されます。

    • slip:beforeswipe
        最初のスワイプ移動が始まる前に発生します。
        event.preventDefault()を実行すると、要素は全く動きません。

    • slip:cancelswipe
        ユーザーがスワイプを開始した後に発生しますが、実際には左右にスワイプせずに離脱させます。

    • slip:animateswipe
        ユーザーが要素から手を離す前に、スワイプ中に発火されます。
        event.detail.xにはx方向の移動量が含まれます。

    • slip:reorder
       要素が新しい場所にドロップされました。 event.detailには以下のような内容が含まれています。
            - insertBefore。要素がドロップされた前のDOMノード(nullはリストの末尾)。
            node.insertBefore() と一緒に使用します。
            - spliceIndex。現在の要素が削除された前の要素のインデックス。
             リストが何らかの配列内のオブジェクトを反映している場合に、Array.splice()と一緒に使用します。
            - originalIndex。並び替えられる前の要素の元のインデックス。

    • slip:beforereorder
        並び替えが開始されると動き出します。
        並び替えられた要素はクラス `slip-reordering` を取得します。
        event.preventDefault()を実行すると、要素は全く動きません。

    • slip:beforewait
        event.preventDefault() を実行すると、すぐに並び替えが始まり、ページのスクロールができなくなります。

    • slip:tap
       要素がスワイプ/順序付けされずにタップされた場合。event.target` をチェックすることで、
       その動作をドラッグハンドルに限定することができます。

Usage:

    CSS:
         リスト要素には `user-select:none` (と WebKit prefixes, sigh) を設定する必要があります。
        そうしないとiOSのテキスト選択が止まらなくなったり、グリッチしたりして邪魔になってしまいます。

        コンテナやボディの上で `overflow-x: hidden` を設定しておくと、水平スクロールバーを防ぐことができます。
        要素がリストからスワイプされたときに表示されるようになりました。


    var list = document.querySelector('ul#slippylist');
    new Slip(list);

    list.addEventListener('slip:beforeswipe', function(e) {
        if (shouldNotSwipe(e.target)) e.preventDefault();
    });

    list.addEventListener('slip:swipe', function(e) {
        // e.target swiped
        if (thatWasSwipeToRemove) {
            e.target.parentNode.removeChild(e.target);
        } else {
            e.preventDefault(); // will animate back to original position
        }
    });

    list.addEventListener('slip:beforereorder', function(e) {
        if (shouldNotReorder(e.target)) e.preventDefault();
    });

    list.addEventListener('slip:reorder', function(e) {
        // e.target reordered.
        if (reorderedOK) {
            e.target.parentNode.insertBefore(e.target, e.detail.insertBefore);
        } else {
            e.preventDefault();
        }
    });

Requires:
    • Touch events
    • CSS transforms
    • Function.bind()

注意:
     - 並び替えやスワイプ中に要素のサイズを変更してはいけません（そうしないと視覚的に同期しなくなります）。
*/

window['Slip'] = (function () {
    'use strict';

    var accessibility = {
        // Slipに管理させたくない場合は、値をfalseに設定します
        container: {
            ariaRole: "listbox",
            tabIndex: 0,
            focus: false, // focuses after drop
        },
        items: {
            ariaRole: "option", // optionで項目をフラットにする場合は、"group"を試してみてください:
            tabIndex: -1, // 0 を指定するとすべての項目がタブ可能になりますが、これは必ずしも便利ではありません。
            focus: false, // ドラッグしているときのフォーカス
        },
    };

    var damnYouChrome = /Chrome\/[3-5]/.test(navigator.userAgent); // プログラムで検出できないバグのために :( Chrome 30-40 のすべてのバージョンをキャッチすることを意図しています。
    var needsBodyHandlerHack = damnYouChrome; // そうしないと、タッチスタートイベントが発生せず、クリックだけになってしまうことがあります。

    /* Chromeで要素を下にドラッグすると（テスト済み34-37）、ドラッグした要素が静止した要素の下に表示されることがあります。
       WebKitのバグ#61824のようですが、iOSのSafariではこの問題はありません。 */
    var compositorDoesNotOrderLayers = damnYouChrome;

    // -webkit-mess
    var testElementStyle = document.createElement('div').style;

    var transitionJSPropertyName = "transition" in testElementStyle ? "transition" : "webkitTransition";
    var transformJSPropertyName = "transform" in testElementStyle ? "transform" : "webkitTransform";
    var transformCSSPropertyName = transformJSPropertyName === "webkitTransform" ? "-webkit-transform" : "transform";
    var userSelectJSPropertyName = "userSelect" in testElementStyle ? "userSelect" : "webkitUserSelect";

    testElementStyle[transformJSPropertyName] = 'translateZ(0)';
    var hwLayerMagicStyle = testElementStyle[transformJSPropertyName] ? 'translateZ(0) ' : '';
    var hwTopLayerMagicStyle = testElementStyle[transformJSPropertyName] ? 'translateZ(1px) ' : '';
    testElementStyle = null;

    var globalInstances = 0;
    var attachedBodyHandlerHack = false;
    var nullHandler = function () {
    };

    function Slip(container, options) {
        if ('string' === typeof container) container = document.querySelector(container);
        if (!container || !container.addEventListener) throw new Error("Please specify DOM node to attach to");

        if (!this || this === window) return new Slip(container, options);

        this.options = options = options || {};
        this.options.keepSwipingPercent = options.keepSwipingPercent || 0;
        this.options.minimumSwipeVelocity = options.minimumSwipeVelocity || 1;
        this.options.minimumSwipeTime = options.minimumSwipeTime || 110;
        this.options.ignoredElements = options.ignoredElements || [];

        if (!Array.isArray(this.options.ignoredElements)) throw new Error("ignoredElements must be an Array");

        // イベントハンドラとして使用される関数は、使用可能な`this`が必要であり、リムーバブルなものに変更してはいけません。
        this.cancel = this.setState.bind(this, this.states.idle);
        this.onTouchStart = this.onTouchStart.bind(this);
        this.onTouchMove = this.onTouchMove.bind(this);
        this.onTouchEnd = this.onTouchEnd.bind(this);
        this.onMouseDown = this.onMouseDown.bind(this);
        this.onMouseMove = this.onMouseMove.bind(this);
        this.onMouseUp = this.onMouseUp.bind(this);
        this.onMouseLeave = this.onMouseLeave.bind(this);
        this.onSelection = this.onSelection.bind(this);
        this.onContainerFocus = this.onContainerFocus.bind(this);

        this.setState(this.states.idle);
        this.attach(container);
    }

    function getTransform(node) {
        var transform = node.style[transformJSPropertyName];
        if (transform) {
            return {
                value: transform,
                original: transform,
            };
        }

        if (window.getComputedStyle) {
            var style = window.getComputedStyle(node).getPropertyValue(transformCSSPropertyName);
            if (style && style !== 'none') return {value: style, original: ''};
        }
        return {value: '', original: ''};
    }

    function findIndex(target, nodes) {
        var originalIndex = 0;
        var listCount = 0;

        for (var i = 0; i < nodes.length; i++) {
            if (nodes[i].nodeType === 1) {
                listCount++;
                if (nodes[i] === target.node) {
                    originalIndex = listCount - 1;
                }
            }
        }

        return originalIndex;
    }

    // ステート内のすべての関数は Slip オブジェクトのコンテキストで実行されます。
    Slip.prototype = {

        container: null,
        options: {},
        state: null,

        target: null, // the tapped/swiped/reordered node with height and backed up styles

        usingTouch: false, // there's no good way to detect touchscreen preference other than receiving a touch event (really, trust me).
        mouseHandlersAttached: false,

        startPosition: null, // x,y,time where first touch began
        latestPosition: null, // x,y,time where the finger is currently
        previousPosition: null, // x,y,time where the finger was ~100ms ago (for velocity calculation)

        canPreventScrolling: false,

        states: {
            idle: function idleStateInit() {
                this.removeMouseHandlers();
                if (this.target) {
                    this.target.node.style.willChange = '';
                    this.target = null;
                }
                this.usingTouch = false;

                return {
                    allowTextSelection: true,
                };
            },

            undecided: function undecidedStateInit() {
                this.target.height = this.target.node.offsetHeight;
                this.target.node.style.willChange = transformCSSPropertyName;
                this.target.node.style[transitionJSPropertyName] = '';

                if (!this.dispatch(this.target.originalTarget, 'beforewait')) {
                    if (this.dispatch(this.target.originalTarget, 'beforereorder')) {
                        this.setState(this.states.reorder);
                    }
                } else {
                    var holdTimer = setTimeout(function () {
                        var move = this.getAbsoluteMovement();
                        if (this.canPreventScrolling && move.x < 15 && move.y < 25) {
                            if (this.dispatch(this.target.originalTarget, 'beforereorder')) {
                                this.setState(this.states.reorder);
                            }
                        }
                    }.bind(this), 300);
                }

                return {
                    leaveState: function () {
                        clearTimeout(holdTimer);
                    },

                    onMove: function () {
                        var move = this.getAbsoluteMovement();

                        if (move.x > 20 && move.y < Math.max(100, this.target.height)) {
                            if (this.dispatch(this.target.originalTarget, 'beforeswipe', {
                                directionX: move.directionX,
                                directionY: move.directionY
                            })) {
                                this.setState(this.states.swipe);
                                return false;
                            } else {
                                this.setState(this.states.idle);
                            }
                        }
                        if (move.y > 20) {
                            this.setState(this.states.idle);
                        }

                        // Chrome likes sideways scrolling :(
                        if (move.x > move.y * 1.2) return false;
                    },

                    onLeave: function () {
                        this.setState(this.states.idle);
                    },

                    onEnd: function () {
                        var allowDefault = this.dispatch(this.target.originalTarget, 'tap');
                        this.setState(this.states.idle);
                        return allowDefault;
                    },
                };
            },

            swipe: function swipeStateInit() {
                var swipeSuccess = false;
                var container = this.container;

                var originalIndex = findIndex(this.target, this.container.childNodes);

                container.classList.add('slip-swiping-container');

                function removeClass() {
                    container.classList.remove('slip-swiping-container');
                }

                this.target.height = this.target.node.offsetHeight;

                return {
                    leaveState: function () {
                        if (swipeSuccess) {
                            this.animateSwipe(function (target) {
                                target.node.style[transformJSPropertyName] = target.baseTransform.original;
                                target.node.style[transitionJSPropertyName] = '';
                                if (this.dispatch(target.node, 'afterswipe')) {
                                    removeClass();
                                    return true;
                                } else {
                                    this.animateToZero(undefined, target);
                                }
                            }.bind(this));
                        } else {
                            this.animateToZero(removeClass);
                        }
                    },

                    onMove: function () {
                        var move = this.getTotalMovement();

                        if (Math.abs(move.y) < this.target.height + 20) {
                            if (this.dispatch(this.target.node, 'animateswipe', {
                                x: move.x,
                                originalIndex: originalIndex
                            })) {
                                this.target.node.style[transformJSPropertyName] = 'translate(' + move.x + 'px,0) ' + hwLayerMagicStyle + this.target.baseTransform.value;
                            }
                            return false;
                        } else {
                            this.dispatch(this.target.node, 'cancelswipe');
                            this.setState(this.states.idle);
                        }
                    },

                    onLeave: function () {
                        this.state.onEnd.call(this);
                    },

                    onEnd: function () {
                        var move = this.getAbsoluteMovement();
                        var velocity = move.x / move.time;

                        // How far out has the item been swiped?
                        var swipedPercent = Math.abs((this.startPosition.x - this.previousPosition.x) / this.container.clientWidth) * 100;

                        var swiped = (velocity > this.options.minimumSwipeVelocity && move.time > this.options.minimumSwipeTime) || (this.options.keepSwipingPercent && swipedPercent > this.options.keepSwipingPercent);

                        if (swiped) {
                            if (this.dispatch(this.target.node, 'swipe', {
                                direction: move.directionX,
                                originalIndex: originalIndex
                            })) {
                                swipeSuccess = true; // can't animate here, leaveState overrides anim
                            }
                        } else {
                            this.dispatch(this.target.node, 'cancelswipe');
                        }
                        this.setState(this.states.idle);
                        return !swiped;
                    },
                };
            },

            reorder: function reorderStateInit() {
                if (this.target.node.focus && accessibility.items.focus) {
                    this.target.node.focus();
                }

                this.target.height = this.target.node.offsetHeight;

                var nodes;
                if (this.options.ignoredElements.length) {
                    var container = this.container;
                    var query = container.tagName.toLowerCase();
                    if (container.getAttribute('id')) {
                        query = '#' + container.getAttribute('id');
                    } else if (container.classList.length) {
                        query += '.' + container.getAttribute('class').replace(' ', '.');
                    }
                    query += ' > ';
                    this.options.ignoredElements.forEach(function (selector) {
                        query += ':not(' + selector + ')';
                    });
                    try {
                        nodes = container.parentNode.querySelectorAll(query);
                    } catch (err) {
                        if (err instanceof DOMException && err.name === 'SyntaxError')
                            throw new Error('ignoredElements you specified contain invalid query');
                        else
                            throw err;
                    }
                } else {
                    nodes = this.container.childNodes;
                }
                var originalIndex = findIndex(this.target, nodes);
                var mouseOutsideTimer;
                var zero = this.target.node.offsetTop + this.target.height / 2;
                var otherNodes = [];
                for (var i = 0; i < nodes.length; i++) {
                    if (nodes[i].nodeType != 1 || nodes[i] === this.target.node) continue;
                    var t = nodes[i].offsetTop;
                    nodes[i].style[transitionJSPropertyName] = transformCSSPropertyName + ' 0.2s ease-in-out';
                    otherNodes.push({
                        node: nodes[i],
                        baseTransform: getTransform(nodes[i]),
                        pos: t + (t < zero ? nodes[i].offsetHeight : 0) - zero,
                    });
                }

                this.target.node.classList.add('slip-reordering');
                this.target.node.style.zIndex = '99999';
                this.target.node.style[userSelectJSPropertyName] = 'none';
                if (compositorDoesNotOrderLayers) {
                    // Chrome's compositor doesn't sort 2D layers
                    this.container.style.webkitTransformStyle = 'preserve-3d';
                }

                function onMove() {
                    /*jshint validthis:true */

                    this.updateScrolling();

                    if (mouseOutsideTimer) {
                        // don't care where the mouse is as long as it moves
                        clearTimeout(mouseOutsideTimer);
                        mouseOutsideTimer = null;
                    }

                    var move = this.getTotalMovement();
                    this.target.node.style[transformJSPropertyName] = 'translate(0,' + move.y + 'px) ' + hwTopLayerMagicStyle + this.target.baseTransform.value;

                    var height = this.target.height;
                    otherNodes.forEach(function (o) {
                        var off = 0;
                        if (o.pos < 0 && move.y < 0 && o.pos > move.y) {
                            off = height;
                        } else if (o.pos > 0 && move.y > 0 && o.pos < move.y) {
                            off = -height;
                        }
                        // FIXME: should change accelerated/non-accelerated state lazily
                        o.node.style[transformJSPropertyName] = off ? 'translate(0,' + off + 'px) ' + hwLayerMagicStyle + o.baseTransform.value : o.baseTransform.original;
                    });
                    return false;
                }

                onMove.call(this);

                return {
                    leaveState: function () {
                        if (mouseOutsideTimer) clearTimeout(mouseOutsideTimer);

                        if (compositorDoesNotOrderLayers) {
                            this.container.style.webkitTransformStyle = '';
                        }

                        if (this.container.focus && accessibility.container.focus) {
                            this.container.focus();
                        }

                        this.target.node.classList.remove('slip-reordering');
                        this.target.node.style[userSelectJSPropertyName] = '';

                        this.animateToZero(function (target) {
                            target.node.style.zIndex = '';
                        });
                        otherNodes.forEach(function (o) {
                            o.node.style[transformJSPropertyName] = o.baseTransform.original;
                            o.node.style[transitionJSPropertyName] = ''; // FIXME: animate to new position
                        });
                    },

                    onMove: onMove,

                    onLeave: function () {
                        // don't let element get stuck if mouse left the window
                        // but don't cancel immediately as it'd be annoying near window edges
                        if (mouseOutsideTimer) clearTimeout(mouseOutsideTimer);
                        mouseOutsideTimer = setTimeout(function () {
                            mouseOutsideTimer = null;
                            this.cancel();
                        }.bind(this), 700);
                    },

                    onEnd: function () {
                        var move = this.getTotalMovement();
                        var i, spliceIndex;
                        if (move.y < 0) {
                            for (i = 0; i < otherNodes.length; i++) {
                                if (otherNodes[i].pos > move.y) {
                                    break;
                                }
                            }
                            spliceIndex = i;
                        } else {
                            for (i = otherNodes.length - 1; i >= 0; i--) {
                                if (otherNodes[i].pos < move.y) {
                                    break;
                                }
                            }
                            spliceIndex = i + 1;
                        }

                        this.dispatch(this.target.node, 'reorder', {
                            spliceIndex: spliceIndex,
                            originalIndex: originalIndex,
                            insertBefore: otherNodes[spliceIndex] ? otherNodes[spliceIndex].node : null,
                        });

                        this.setState(this.states.idle);
                        return false;
                    },
                };
            },
        },

        attach: function (container) {
            globalInstances++;
            if (this.container) this.detach();

            // In some cases taps on list elements send *only* click events and no touch events. Spotted only in Chrome 32+
            // Having event listener on body seems to solve the issue (although AFAIK may disable smooth scrolling as a side-effect)
            if (!attachedBodyHandlerHack && needsBodyHandlerHack) {
                attachedBodyHandlerHack = true;
                document.body.addEventListener('touchstart', nullHandler, false);
            }

            this.container = container;

            // Accessibility
            if (false !== accessibility.container.tabIndex) {
                this.container.tabIndex = accessibility.container.tabIndex;
            }
            if (accessibility.container.ariaRole) {
                this.container.setAttribute('aria-role', accessibility.container.ariaRole);
            }
            this.setChildNodesAriaRoles();
            this.container.addEventListener('focus', this.onContainerFocus, false);

            this.otherNodes = [];

            // selection on iOS interferes with reordering
            document.addEventListener("selectionchange", this.onSelection, false);

            // cancel is called e.g. when iOS detects multitasking gesture
            this.container.addEventListener('touchcancel', this.cancel, false);
            this.container.addEventListener('touchstart', this.onTouchStart, false);
            this.container.addEventListener('touchmove', this.onTouchMove, false);
            this.container.addEventListener('touchend', this.onTouchEnd, false);
            this.container.addEventListener('mousedown', this.onMouseDown, false);
            // mousemove and mouseup are attached dynamically
        },

        detach: function () {
            this.cancel();

            this.container.removeEventListener('mousedown', this.onMouseDown, false);
            this.container.removeEventListener('touchend', this.onTouchEnd, false);
            this.container.removeEventListener('touchmove', this.onTouchMove, false);
            this.container.removeEventListener('touchstart', this.onTouchStart, false);
            this.container.removeEventListener('touchcancel', this.cancel, false);

            document.removeEventListener("selectionchange", this.onSelection, false);

            if (false !== accessibility.container.tabIndex) {
                this.container.removeAttribute('tabIndex');
            }
            if (accessibility.container.ariaRole) {
                this.container.removeAttribute('aria-role');
            }
            this.unSetChildNodesAriaRoles();

            globalInstances--;
            if (!globalInstances && attachedBodyHandlerHack) {
                attachedBodyHandlerHack = false;
                document.body.removeEventListener('touchstart', nullHandler, false);
            }
        },

        setState: function (newStateCtor) {
            if (this.state) {
                if (this.state.ctor === newStateCtor) return;
                if (this.state.leaveState) this.state.leaveState.call(this);
            }

            // Must be re-entrant in case ctor changes state
            var prevState = this.state;
            var nextState = newStateCtor.call(this);
            if (this.state === prevState) {
                nextState.ctor = newStateCtor;
                this.state = nextState;
            }
        },

        findTargetNode: function (targetNode) {
            while (targetNode && targetNode.parentNode !== this.container) {
                targetNode = targetNode.parentNode;
            }
            return targetNode;
        },

        onContainerFocus: function (e) {
            e.stopPropagation();
            this.setChildNodesAriaRoles();
        },

        setChildNodesAriaRoles: function () {
            var nodes = this.container.childNodes;
            for (var i = 0; i < nodes.length; i++) {
                if (nodes[i].nodeType != 1) continue;
                if (accessibility.items.ariaRole) {
                    nodes[i].setAttribute('aria-role', accessibility.items.ariaRole);
                }
                if (false !== accessibility.items.tabIndex) {
                    nodes[i].tabIndex = accessibility.items.tabIndex;
                }
            }
        },

        unSetChildNodesAriaRoles: function () {
            var nodes = this.container.childNodes;
            for (var i = 0; i < nodes.length; i++) {
                if (nodes[i].nodeType != 1) continue;
                if (accessibility.items.ariaRole) {
                    nodes[i].removeAttribute('aria-role');
                }
                if (false !== accessibility.items.tabIndex) {
                    nodes[i].removeAttribute('tabIndex');
                }
            }
        },
        onSelection: function (e) {
            e.stopPropagation();
            var isRelated = e.target === document || this.findTargetNode(e);
            var iOS = /(iPhone|iPad|iPod)/i.test(navigator.userAgent) && !/(Android|Windows)/i.test(navigator.userAgent);
            if (!isRelated) return;

            if (iOS) {
                // iOS doesn't allow selection to be prevented
                this.setState(this.states.idle);
            } else {
                if (!this.state.allowTextSelection) {
                    e.preventDefault();
                }
            }
        },

        addMouseHandlers: function () {
            // unlike touch events, mousemove/up is not conveniently fired on the same element,
            // but I don't need to listen to unrelated events all the time
            if (!this.mouseHandlersAttached) {
                this.mouseHandlersAttached = true;
                document.documentElement.addEventListener('mouseleave', this.onMouseLeave, false);
                window.addEventListener('mousemove', this.onMouseMove, true);
                window.addEventListener('mouseup', this.onMouseUp, true);
                window.addEventListener('blur', this.cancel, false);
            }
        },

        removeMouseHandlers: function () {
            if (this.mouseHandlersAttached) {
                this.mouseHandlersAttached = false;
                document.documentElement.removeEventListener('mouseleave', this.onMouseLeave, false);
                window.removeEventListener('mousemove', this.onMouseMove, true);
                window.removeEventListener('mouseup', this.onMouseUp, true);
                window.removeEventListener('blur', this.cancel, false);
            }
        },

        onMouseLeave: function (e) {
            e.stopPropagation();
            if (this.usingTouch) return;

            if (e.target === document.documentElement || e.relatedTarget === document.documentElement) {
                if (this.state.onLeave) {
                    this.state.onLeave.call(this);
                }
            }
        },

        onMouseDown: function (e) {
            e.stopPropagation();
            if (this.usingTouch || e.button != 0 || !this.setTarget(e)) return;

            this.addMouseHandlers(); // mouseup, etc.

            this.canPreventScrolling = true; // or rather it doesn't apply to mouse

            this.startAtPosition({
                x: e.clientX,
                y: e.clientY,
                time: e.timeStamp,
            });
        },

        onTouchStart: function (e) {
            e.stopPropagation();
            this.usingTouch = true;
            this.canPreventScrolling = true;

            // This implementation cares only about single touch
            if (e.touches.length > 1) {
                this.setState(this.states.idle);
                return;
            }

            if (!this.setTarget(e)) return;

            this.startAtPosition({
                x: e.touches[0].clientX,
                y: e.touches[0].clientY,
                time: e.timeStamp,
            });
        },

        setTarget: function (e) {
            var targetNode = this.findTargetNode(e.target);
            if (!targetNode) {
                this.setState(this.states.idle);
                return false;
            }

            // scrollContainer may be explicitly set via options, otherwise search upwards for a parent with an overflow-y property
            // fallback to document.scrollingElement (or documentElement on IE), and do not use document.body
            var scrollContainer = this.options.scrollContainer;
            if (!scrollContainer) {
                var top = document.scrollingElement || document.documentElement;
                scrollContainer = targetNode.parentNode;
                while (scrollContainer) {
                    if (scrollContainer == top) break;
                    if (scrollContainer != document.body && scrollContainer.scrollHeight > scrollContainer.clientHeight && window.getComputedStyle(scrollContainer)['overflow-y'] != 'visible') break;
                    scrollContainer = scrollContainer.parentNode;
                }
                scrollContainer = scrollContainer || top;
            }

            this.target = {
                originalTarget: e.target,
                node: targetNode,
                scrollContainer: scrollContainer,
                origScrollTop: scrollContainer.scrollTop,
                origScrollHeight: scrollContainer.scrollHeight,
                baseTransform: getTransform(targetNode),
            };
            return true;
        },

        startAtPosition: function (pos) {
            this.startPosition = this.previousPosition = this.latestPosition = pos;
            this.setState(this.states.undecided);
        },

        updatePosition: function (e, pos) {
            if (this.target == null) {
                return;
            }
            this.latestPosition = pos;

            if (this.state.onMove) {
                if (this.state.onMove.call(this) === false) {
                    e.preventDefault();
                }
            }

            // sample latestPosition 100ms for velocity
            if (this.latestPosition.time - this.previousPosition.time > 100) {
                this.previousPosition = this.latestPosition;
            }
        },

        onMouseMove: function (e) {
            e.stopPropagation();
            this.updatePosition(e, {
                x: e.clientX,
                y: e.clientY,
                time: e.timeStamp,
            });
        },

        onTouchMove: function (e) {
            e.stopPropagation();
            this.updatePosition(e, {
                x: e.touches[0].clientX,
                y: e.touches[0].clientY,
                time: e.timeStamp,
            });

            // In Apple's touch model only the first move event after touchstart can prevent scrolling (and event.cancelable is broken)
            this.canPreventScrolling = false;
        },

        onMouseUp: function (e) {
            e.stopPropagation();
            if (this.usingTouch || e.button !== 0) return;

            if (this.state.onEnd && false === this.state.onEnd.call(this)) {
                e.preventDefault();
            }
        },

        onTouchEnd: function (e) {
            e.stopPropagation();
            if (e.touches.length > 1) {
                this.cancel();
            } else if (this.state.onEnd && false === this.state.onEnd.call(this)) {
                e.preventDefault();
            }
        },

        getTotalMovement: function () {
            var scrollOffset = this.target.scrollContainer.scrollTop - this.target.origScrollTop;
            return {
                x: this.latestPosition.x - this.startPosition.x,
                y: this.latestPosition.y - this.startPosition.y + scrollOffset,
                time: this.latestPosition.time - this.startPosition.time,
            };
        },

        getAbsoluteMovement: function () {
            var move = this.getTotalMovement();
            return {
                x: Math.abs(move.x),
                y: Math.abs(move.y),
                time: move.time,
                directionX: move.x < 0 ? 'left' : 'right',
                directionY: move.y < 0 ? 'up' : 'down',
            };
        },

        updateScrolling: function () {
            var triggerOffset = 40,
                offset = 0;

            var scrollable = this.target.scrollContainer,
                containerRect = scrollable.getBoundingClientRect(),
                targetRect = this.target.node.getBoundingClientRect(),
                bottomOffset = Math.min(containerRect.bottom, window.innerHeight) - targetRect.bottom,
                topOffset = targetRect.top - Math.max(containerRect.top, 0),
                maxScrollTop = this.target.origScrollHeight - Math.min(scrollable.clientHeight, window.innerHeight);

            if (bottomOffset < triggerOffset) {
                offset = Math.min(triggerOffset, triggerOffset - bottomOffset);
            } else if (topOffset < triggerOffset) {
                offset = Math.max(-triggerOffset, topOffset - triggerOffset);
            }

            scrollable.scrollTop = Math.max(0, Math.min(maxScrollTop, scrollable.scrollTop + offset));
        },

        dispatch: function (targetNode, eventName, detail) {
            var event = document.createEvent('CustomEvent');
            if (event && event.initCustomEvent) {
                event.initCustomEvent('slip:' + eventName, true, true, detail);
            } else {
                event = document.createEvent('Event');
                event.initEvent('slip:' + eventName, true, true);
                event.detail = detail;
            }
            return targetNode.dispatchEvent(event);
        },

        getSiblings: function (target) {
            var siblings = [];
            var tmp = target.node.nextSibling;
            while (tmp) {
                if (tmp.nodeType == 1) siblings.push({
                    node: tmp,
                    baseTransform: getTransform(tmp),
                });
                tmp = tmp.nextSibling;
            }
            return siblings;
        },

        animateToZero: function (callback, target) {
            // save, because this.target/container could change during animation
            target = target || this.target;

            target.node.style[transitionJSPropertyName] = transformCSSPropertyName + ' 0.1s ease-out';
            target.node.style[transformJSPropertyName] = 'translate(0,0) ' + hwLayerMagicStyle + target.baseTransform.value;
            setTimeout(function () {
                target.node.style[transitionJSPropertyName] = '';
                target.node.style[transformJSPropertyName] = target.baseTransform.original;
                if (callback) callback.call(this, target);
            }.bind(this), 101);
        },

        animateSwipe: function (callback) {
            var target = this.target;
            var siblings = this.getSiblings(target);
            var emptySpaceTransformStyle = 'translate(0,' + this.target.height + 'px) ' + hwLayerMagicStyle + ' ';

            // FIXME: animate with real velocity
            target.node.style[transitionJSPropertyName] = 'all 0.1s linear';
            target.node.style[transformJSPropertyName] = ' translate(' + (this.getTotalMovement().x > 0 ? '' : '-') + '100%,0) ' + hwLayerMagicStyle + target.baseTransform.value;

            setTimeout(function () {
                if (callback.call(this, target)) {
                    siblings.forEach(function (o) {
                        o.node.style[transitionJSPropertyName] = '';
                        o.node.style[transformJSPropertyName] = emptySpaceTransformStyle + o.baseTransform.value;
                    });
                    setTimeout(function () {
                        siblings.forEach(function (o) {
                            o.node.style[transitionJSPropertyName] = transformCSSPropertyName + ' 0.1s ease-in-out';
                            o.node.style[transformJSPropertyName] = 'translate(0,0) ' + hwLayerMagicStyle + o.baseTransform.value;
                        });
                        setTimeout(function () {
                            siblings.forEach(function (o) {
                                o.node.style[transitionJSPropertyName] = '';
                                o.node.style[transformJSPropertyName] = o.baseTransform.original;
                            });
                        }, 101);
                    }, 1);
                }
            }.bind(this), 101);
        },
    };

    // AMD
    if ('function' === typeof define && define.amd) {
        define(function () {
            return Slip;
        });
    }
    // CJS
    if ('object' === typeof module && module.exports) {
        module.exports = Slip;
    }
    return Slip;
})();

