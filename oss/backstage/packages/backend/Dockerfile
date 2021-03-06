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

FROM node:16-bullseye-slim

WORKDIR /app

# install sqlite3 dependencies, you can skip this if you don't use sqlite3 in the image
RUN apt-get update && \
    apt-get install -y --no-install-recommends libsqlite3-dev python3 build-essential openssh-server supervisor && \
    echo "root:Docker!" | chpasswd && \
    rm -rf /var/lib/apt/lists/* && \
    yarn config set python /usr/bin/python3

# Azure SSH
COPY oss/backstage/packages/backend/sshd_config /etc/ssh/
RUN mkdir -p /tmp
COPY oss/backstage/packages/backend/ssh_setup /tmp
RUN chmod +x /tmp/ssh_setup && \
    (sleep 1; /tmp/ssh_setup 2>&1 > /dev/null)

# Copy repo skeleton first, to avoid unnecessary docker cache invalidation.
# The skeleton contains the package.json of each package in the monorepo,
# and along with yarn.lock and the root package.json, that's enough to run yarn install.
COPY ./oss/backstage/yarn.lock oss/backstage/package.json ./oss/backstage/packages/backend/dist/skeleton.tar.gz ./
RUN tar xzf ./skeleton.tar.gz && rm ./skeleton.tar.gz

#RUN yarn install --frozen-lockfile --production --network-timeout 300000 && rm -rf "$(yarn cache dir)"
RUN yarn install --production --network-timeout 300000 && rm -rf "$(yarn cache dir)"

# Then copy the rest of the backend bundle, along with any other files we might want.
COPY oss/backstage/packages/backend/dist/bundle.tar.gz oss/backstage/app-config.yaml ./
RUN tar xzf bundle.tar.gz && rm bundle.tar.gz

COPY ./oss/backstage/packages/backend/supervisord.conf /etc/

EXPOSE 7007 2222

#CMD [ "node", "packages/backend", "--config", "app-config.yaml"]
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]
