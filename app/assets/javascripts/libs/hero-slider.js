class HeroSlider {
    constructor(el) {
        this.el = el;
        this.swiper = this._initSwiper();
    }

    // returnでインスタンスに返す
    _initSwiper() {
        return new Swiper(this.el, {
            loop: true,
            grabCursor: true,
            effect: "coverflow",
            // スライダーを中央揃えにする
            centeredSlides: true,
            // 1枚だけ表示する
            slidesPerView: 1,
            speed: 1000,
            breakpoints: {
                // 1024px以上は2枚表示する
                1024: {
                    slidesPerView: 2,
                }
            },
        });
    }

// 空のオブジェクトを作る
// マウスで変更したあとでも4秒後、またオートでトランジション開始する
    start(options = {}) {
        options = Object.assign({
            delay: 4000,
            disableOnInteraction: false
        }, options);

        this.swiper.params.autoplay = options;
        this.swiper.autoplay.start();
    }

    stop() {
        this.swiper.autoplay.stop();
    }
}