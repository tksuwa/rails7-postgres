# FROMでベースイメージを設定
FROM ruby:3.1
# nodeやyarn等の必要なライブラリをインストール
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
# Railsアプリを配置するフォルダをコンテナ内に作成
RUN mkdir /myapp
# 作成したディレクトリをワークディレクトリとして設定
WORKDIR /myapp
# ルート配下のGemfileをコンテナ内のRailsアプリを配置場所にコピー
COPY Gemfile /myapp/Gemfile
# Gemfile.lockも同様にコンテナ内にコピーする
COPY Gemfile.lock /myapp/Gemfile.lock
# Gemfileの記述を元にbundle installを実行
RUN bundle install
COPY . /myapp

# ローカルで作成したentrypoint.shファイル(後で記述)を/usr/bin/へコピー
COPY entrypoint.sh /usr/bin/
# /usr/bin/entrypoint.shに対して実行権限を付与している(chmod +x)
# これによってシェルスクリプトファイルを実行可能にする
RUN chmod +x /usr/bin/entrypoint.sh
# exec形式でデフォルトで実行するコマンドラインの引数としてentrypoint.shを指定
ENTRYPOINT ["entrypoint.sh"]
# ネットワーク上のポートを指定する
EXPOSE 3000

# Railsサーバーを稼働させる
CMD ["rails", "server", "-b", "0.0.0.0"]
