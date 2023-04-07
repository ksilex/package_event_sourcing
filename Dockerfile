FROM ruby:3.1.3-alpine
ENV BUNDLER_VERSION=2.3.26
RUN apk add --update build-base libpq-dev postgresql-dev postgresql-client tzdata
WORKDIR /app
RUN gem install bundler -v ${BUNDLER_VERSION}
COPY Gemfile Gemfile.lock ./
RUN bundle check || bundle install
COPY . ./
ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]
