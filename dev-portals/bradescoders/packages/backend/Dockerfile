# This dockerfile builds an image for the backend package.
# It should be executed with the root of the repo as docker context.
#
# Before building this image, be sure to have run the following commands in the repo root:
#
# yarn install
# yarn tsc
# yarn build
#
# Once the commands have been run, you can build the image using `yarn build-image`

#FROM mcr.microsoft.com/appsvc/node:16-lts_20220624.1 # due MS remove
FROM ghcr.io/arnaldoprado74/node:16-lts_20220624.1

WORKDIR /app

# install dependencies
RUN npm cache clean -f && npm install -g n && n 16.13.2 && \
    curl --insecure -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo 'deb http://dl.yarnpkg.com/debian/ stable main' | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends python3 build-essential supervisor gcc musl-dev curl graphviz fonts-dejavu fontconfig plantuml python3-pip python3-wheel yarn && \
    echo 'root:Docker!' | chpasswd && \
    rm -rf /var/lib/apt/lists/* && \
    yarn config set python /usr/bin/python3  && \
    pip3 install setuptools && \
    pip3 install mkdocs-techdocs-core==1.1.2

# azure SSH
COPY dev-portals/bradescoders/packages/backend/sshd_config /etc/ssh/
RUN mkdir -p /tmp
COPY dev-portals/bradescoders/packages/backend/ssh_setup /tmp
RUN chmod +x /tmp/ssh_setup && \
    (sleep 1; /tmp/ssh_setup 2>&1 > /dev/null)

# copy repo skeleton first, to avoid unnecessary docker cache invalidation.
# The skeleton contains the package.json of each package in the monorepo,
# and along with yarn.lock and the root package.json, that's enough to run yarn install.
COPY ./dev-portals/bradescoders/yarn.lock ./dev-portals/bradescoders/package.json ./dev-portals/bradescoders/packages/backend/dist/skeleton.tar.gz ./
RUN mkdir -p packages/backend/ca
COPY ./dev-portals/bradescoders/packages/backend/ca/db.crt ./packages/backend/ca
RUN tar xzf ./skeleton.tar.gz && rm ./skeleton.tar.gz

# install package.json deps
RUN yarn install --production --network-timeout 300000 && rm -rf "$(yarn cache dir)"
#RUN yarn install && rm -rf "$(yarn cache dir)"

# then copy the rest of the backend bundle, along with any other files we might want.
COPY dev-portals/bradescoders/packages/backend/dist/bundle.tar.gz dev-portals/bradescoders/app-config.yaml ./
RUN tar xzf bundle.tar.gz && rm bundle.tar.gz

# finally copy static resources
RUN mkdir -p ./static/bradesco/catalog-model
COPY ./oss/backstage/packages/catalog-model/examples ./static/bradesco/catalog-model

# copy plugins
RUN mkdir -p ./plugins
COPY ./oss/backstage/plugins ./plugins

# copy cypress
RUN mkdir -p ./cypress
COPY ./oss/backstage/cypress ./cypress

# copy process manager config
COPY ./dev-portals/bradescoders/packages/backend/supervisord.conf /etc/

EXPOSE 7007 2222

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
