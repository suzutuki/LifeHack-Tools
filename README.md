<h2 align="center">LifeHack Tools : あなたの習慣化や目標達成をアシストします</h2>
目標達成のための複数のライフハックをツール化したものです。

Todoリスト(一括登録、削除ができます。)

MACの原則(現時点で効果の高いゴール(目標)設定ができます)

If-Thenテクニック(現時点で効果の高い習慣化を助けるツールで一括登録、削除ができます)

Exercise Tracking(運動時間を記録してグラフ化します)

レスポンシブ対応しているのでスマホからもご確認いただけます。

![Lifehack](https://user-images.githubusercontent.com/61527476/113125422-89647300-9251-11eb-8811-a81b9d310f9a.png)

## App URL https://suzutuki-portfolio.com/

## インフラ構成図

<img width="1204" alt="インフラ構成図" src="https://user-images.githubusercontent.com/61527476/158512827-cf490ac3-582f-41a4-9acb-e14c67eecd4a.png">


## 使用技術

・Ruby          2.5.1<br>
・Ruby on Rails 5.2.3<br>
・Mysql         8.0<br>
・nginx         1.20.0<br>
・puma<br>
・AWS<br>
   ・VPC<br>
   ・EC2<br>
   ・RDS<br>
   ・Route53<br>
   ・S3<br>
   ・Certificate Manager<br>
   ・IAM<br>
・Docker/Docker-compose<br>
・minitest<br>

## アプリケーション内で使用している技術一覧

### 1:JavaScript

ヒーロースライダー機能(Swiper)

ページローダー機能(pace.js)

フェードインアニメーション

カバースライドアニメーション

スクロール検知機能

テキストアニメーション

グラフ作成機能・編集機能(chart-js-rails)

カレンダー(flatpickr)

モバイルメニュー

### 2:Ruby on Rails

かんたんログイン(ワンクリックログイン)機能・サインアップ・ログイン・ログアウト機能、

Remember me機能(bcrypt)・退会機能(ユーザー情報削除機能)

記事作成・編集機能・記事削除

記事一括作成・一括編集・一括削除機能

ページネーション機能(kaminari)

フラッシュメッセージ

画像投稿機能(fog-aws, rmagick, carrierwave)

フレンドリーフォワーディング機能
