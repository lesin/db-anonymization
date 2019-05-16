FROM ruby:2.5-alpine

WORKDIR /app
RUN apk update && \
  apk add make build-base postgresql-libs postgresql-dev --no-cache

COPY Gemfile .

RUN gem install bundler && bundle

COPY . .

CMD  ["bundle", "exec", "ruby", "app/main.rb"]
