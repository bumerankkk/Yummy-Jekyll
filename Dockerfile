#FROM ubuntu:16.04
FROM jekyll/jekyll

RUN apt-get update && \
    apt-get install -y \
        git \
        ruby-full \
        npm \
        gcc \
        make \
        libssl-dev
RUN gem install bundler
COPY Gemfile /build/
COPY Gemfile.lock /build/
WORKDIR /build/
RUN bundle install --path vendor/bundle
#COPY package.json /build/
#COPY server.js /build/
#RUN npm install --production
RUN npm install -g bower
COPY bower.json /build/
RUN bower install --allow-root
COPY . /srv/jekyll
RUN bundle exec jekyll build --source /site

CMD ["npm", "start"]

EXPOSE 8080
