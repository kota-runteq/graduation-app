FROM ruby:3.2.8
ENV LANG C.UTF-8
ENV TZ Asia/Tokyo
RUN apt-get update -qq \
&& apt-get install -y curl gnupg ca-certificates build-essential libpq-dev libsqlite3-dev wget
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
&& apt-get install -y nodejs
RUN corepack enable
RUN mkdir /graduation-app
WORKDIR /graduation-app
RUN gem install bundler -v 2.5.6
COPY ./package.json ./yarn.lock ./
RUN yarn install
COPY ./Gemfile ./Gemfile.lock ./
RUN bundle install
COPY . .
ENTRYPOINT ["./bin/entrypoint.sh"]
CMD ["./bin/dev", "-b", "0.0.0.0"]
ENTRYPOINT ["./bin/entrypoint.sh"]
