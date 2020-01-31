FROM ruby:alpine

COPY crun-tools/Gemfile /app/Gemfile
COPY crun-tools/Gemfile.lock /app/Gemfile.lock

WORKDIR /app

RUN gem install bundler:1.17.2 && bundle install

COPY crun-tools /app
COPY crun.sh /data/crun.sh
COPY VERSION /data/VERSION

ENTRYPOINT ["ruby", "generate.rb"]
CMD ["usage"]
