// テキストアニメーションを定義
class TextAnimation {
    constructor(el) {
        this.DOM = {};
        // elがDOMのときthis.Dom.elに格納、falseのときdocument.querySelector(el);でDOMを取得する
        this.DOM.el = el instanceof HTMLElement ? el : document.querySelector(el);
        this.chars = this.DOM.el.innerHTML.trim().split("");
        this.DOM.el.innerHTML = this._splitText();
    }
    _splitText() {
        return this.chars.reduce((acc, curr) => {
            curr = curr.replace(/\s+/, '&nbsp;');
            return `${acc}<span class="char">${curr}</span>`;
        }, "");
    }
    animate() {
        this.DOM.el.classList.toggle('inview');
    }
}
class TweenTextAnimation extends TextAnimation {
    constructor(el) {
        super(el);
        this.DOM.chars = this.DOM.el.querySelectorAll('.char');
    }

    animate() {
        // inviewをつける
        this.DOM.el.classList.add('inview');
        // TweenMaxの書き方(toメソッド)対象となるDOMアニメーションの間隔
        this.DOM.chars.forEach((c, i) => {
        // オプションeaseファンクション,delayの間隔,オプション
            TweenMax.to(c, .6, {
                ease: Back.easeOut,
                delay: i * .05,
                // アニメーションの始まる状態
                startAt: { y: '-50%', opacity: 0},
                // 終了時の状態
                y: '0%',
                opacity: 1
            });
        });
    }
}
