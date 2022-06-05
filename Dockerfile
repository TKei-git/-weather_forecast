FROM ruby:3.1

RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/
COPY Gemfile.lock /myapp/
RUN bundle install
COPY . /myapp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
RUN apt-get update -qq && \
    apt-get install -y cron

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
