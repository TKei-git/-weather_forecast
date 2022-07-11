FROM ruby:3.1

#ENV RAILS_ENV=production

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

#COPY start.sh /start.sh
#RUN chmod 744 /start.sh
#CMD ["sh", "/start.sh"]

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
