FROM ruby:3.2.2

WORKDIR /home/geo-api

RUN apt-get update && apt-get -y install curl vim
RUN gem install bundler --version="2.4.10"

# copy project
WORKDIR /home/geo-api
COPY Gemfile /home/geo-api/Gemfile
COPY Gemfile.lock /home/geo-api/Gemfile.lock
RUN bundle install
COPY . /home/geo-api

ENV PORT 3000
EXPOSE $PORT

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
CMD ["/bin/bash", "/usr/bin/entrypoint.sh"]