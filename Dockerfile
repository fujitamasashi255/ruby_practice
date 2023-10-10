FROM ruby:3.2.2
RUN apt-get update
RUN apt-get install -y vim

# bundlerをインストール
RUN gem install bundler -v 2.3.7

WORKDIR /app

# gemはvendor/bundleにインストール
RUN bundle config set path 'vendor/bundle'
