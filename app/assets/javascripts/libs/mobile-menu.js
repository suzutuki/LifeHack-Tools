class MobileMenu {
    // コストラクタ関数を用意する
    constructor() {
        // オブジェクトリテラルで初期化
        this.DOM = {};
        this.DOM.btn = document.querySelector('.mobile-menu__btn');
        this.DOM.cover = document.querySelector('.mobile-menu__cover');
        // this.DOM.containerでないとエラーになるよ
        this.DOM.container = document.querySelector('#global-container');
        // スマホとデスクトップ対応するため
        this.eventType = this._getEventType();
        this.__addEvent();
    }

    // プライベートメソッドにする修正や保守のしやすさのため
    _getEventType() {
        // クリックかタッチかでわける
        return window.ontouchstart ? "touchstart" : "click";
    }

    _toggle() {
        // global-containerにクリックするたびにmenu-openを付加、解除
        this.DOM.container.classList.toggle("menu-open");
    }
    __addEvent() {
        // スマホとデスクトップ対応するため
        this.DOM.btn.addEventListener(this.eventType, this._toggle.bind(this));
        // カバーにクリックしたときに発火
        this.DOM.cover.addEventListener(this.eventType, this._toggle.bind(this));
    }
}

