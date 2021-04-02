document.addEventListener('DOMContentLoaded', function () {
    // mainにMainを格納してインスタンス化して呼び出す
    const main = new Main();
});
// 新しくメインクラスを作りそのなかにプライベートメソッドを格納
class Main {
    constructor() {
        // headerやsideのDOMをクエリーセレクターで取得
        this.header = document.querySelector('.header');
        this.sides = document.querySelectorAll('.side');
        // 配列にScrollObserverのインスタンスを格納する 変数_observersを初期化
        this._observers = [];
        // _Initを呼ぶ
        this._init();
    }
// インスタンス化されたオブジェクトが配列に格納される(セッターメソッド)
    set observers(val) {
        this._observers.push(val);
    }
// ゲッターメソッド(値を取得する方のメソッド)
    get observers() {
        return this._observers;
    }

    _init() {
        //ここでモバイルメニューとヒーロースライダーを呼んでいる
        new MobileMenu();
        this.hero = new HeroSlider('.swiper-container');
        Pace.on('done', this._paceDone.bind(this));
    }
    // ロードが完了した段階でアニメーションするようにする
    _paceDone() {
        this._scrollInit();
    }

    _inviewAnimation(el, inview) {
        // もし画面内に入ってきたらinviewを付加
        if(inview) {
            el.classList.add('inview');
            // 画面外になったらinviewを削除
        }else {
            el.classList.remove('inview');
        }
    }
    _navAnimation(el, inview) {
        // 画面の中に入ったらtriggeredという関数を削除
        if(inview) {
            this.header.classList.remove('triggered');
            // 画面の外に出たらtriggeredという関数を付与
        } else {
            this.header.classList.add('triggered');
        }
    }
// サイドバーのアニメーションの設定
    _sideAnimation(el, inview) {
        if(inview) {
            this.sides.forEach(side => side.classList.add('inview'));
        } else {
            this.sides.forEach(side => side.classList.remove('inview'));
        }
    }
    _textAnimation(el, inview) {
        if(inview) {
            // tweenを使うときは書き換える(Tweenを追加)TweenTextAnimationを呼んでいる
            const ta = new TweenTextAnimation(el);
            ta.animate();
        }
    }
    _toggleSlideAnimation(el, inview) {
        // 画面の中に入ったらヒーロースライダーを開始
        if(inview) {
            this.hero.start();
            // 画面の外に出たらヒーロースライダーを止めてパフォーマンスを下げないようにする
        } else {
            this.hero.stop();
        }
    }
    _destroyObservers() {
        this.observers.forEach(ob => {
            ob.destroy();
        });
    }
// デストロイメソッドの追加
    destroy() {
        this._destroyObservers();
    }

    _scrollInit() {
// セッターメソッドを呼んでいて右辺の値が(val)に格納される
// this._navAnimation.bind(this)でないとエラー(プライベートメソッド内でthisを使っているため)
// スクロール監視が何度でも発動するように{once: false}する
        this.observers = new ScrollObserver('.nav-trigger', this._navAnimation.bind(this), {once: false});
// カバースライドに対してのインスタンス化利用するためにthis.が必要
        this.observers = new ScrollObserver('.cover-slide', this._inviewAnimation);
        this.observers = new ScrollObserver('.cover-slide__exercise', this._inviewAnimation);
// this._navAnimation.bind(this)でないとエラー(プライベートメソッド内でthisを使っているため)
        this.observers = new ScrollObserver('.appear', this._inviewAnimation, {rootMargin: "-100px 0px"});
        // テキストアニメーションの設定
        this.observers = new ScrollObserver('.tween-animate-title', this._textAnimation);
//  スワイパーコンテナーを監視する
        this.observers = new ScrollObserver('.swiper-container', this._toggleSlideAnimation.bind(this), {once: false});
// rootMarginで発火するタイミングを制御できる
        this.observers = new ScrollObserver('#main-content', this._sideAnimation.bind(this), {once: false, rootMargin: "-200px 0px"});
    }
}
 

