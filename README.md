# README

## 概要
- 工数管理用のエクセルシートの代わりとなるWEBシステム

## 実行手順

1. 環境変数を設定する

    |  変数名  |  内容  |
    | ---- | ---- |
    |  TZ  |  実行環境のタイムゾーン．"Asia/Tokyo"など．  |
    |  VALID_EMAIL_REGEX  |  ユーザーのメールアドレスのバリデーション．正規表現で記述する．  |
    |  USER_DEFAULT_PASSWORD  |  ユーザーのパスワードの初期値．  |
    |  ADMIN_USER_DEFAULT_EMAIL  |  管理者ユーザーのメールアドレスの初期値．|
    |  ADMIN_USER_DEFAULT_PASSWORD  |  管理者ユーザーのパスワードの初期値．|

2. 次のコマンドを実行し、管理者ユーザーを作成する
    ```
    rails db:seed
    ```
3. テストを実施し、エラー及びテスト失敗がないことを確認する
    ```
    rails t
    ```
4. サーバーを起動する
    ```
    rails s
    ```