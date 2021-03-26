// スクロールの監視を定義する
class ScrollObserver {
    //第2引数にコールバック関数第三引数にオプション
    constructor(els, cb, options) {
      this.els = document.querySelectorAll(els);
      const defaultOptions = {
        root: null,
        rootMargin: "0px",
        threshold: 0,
        once: true
      };
      this.cb = cb;
      // assignというメソッドでdefaultOptionsとoptionsをマージする
      this.options = Object.assign(defaultOptions, options);
      this.once = this.options.once;
      this._init();
    }
    // 初期化処理を記載して変数の記載漏れを防ぐ
  _init() {
      const callback = function (entries, observer) {
        entries.forEach(entry => {
          if (entry.isIntersecting) {
            this.cb(entry.target, true);
            if (this.once) {
              observer.unobserve(entry.target);
            }
          } else {
            this.cb(entry.target, false);
          }
        });
      };
      // thisをbindで束縛するとScrollObserverのcbを参照する
      this.io = new IntersectionObserver(callback.bind(this), this.options);
      // 後方互換性のためPolyfillの設定をする
      this.io.POLL_INTERVAL = 100;
      this.els.forEach(el => this.io.observe(el));
    }
    // デストロイメソッドの追加
    destroy() {
      this.io.disconnect();
    }
  }
  