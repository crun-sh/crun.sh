FROM ruby:alpine

COPY crun-tools/Gemfile /app/Gemfile
COPY crun-tools/Gemfile.lock /app/Gemfile.lock

WORKDIR /app

RUN bundle install

COPY crun-tools /app
COPY crun.sh /data/crun.sh
COPY VERSION /data/VERSION

ENTRYPOINT ["ruby", "generate.rb"]
CMD ["usage"]
