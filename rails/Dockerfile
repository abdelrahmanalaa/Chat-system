FROM ruby:2.5
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y curl sudo mariadb-client default-libmysqlclient-dev
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
COPY . /myapp

EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]