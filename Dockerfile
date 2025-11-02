FROM ruby:3.2-alpine

WORKDIR /app
COPY Gemfile* ./
RUN apk add --no-cache build-base && bundle install && apk del build-base

COPY . .

EXPOSE 8081
CMD ["bundle", "exec", "puma", "-p", "8081", "config.ru"]