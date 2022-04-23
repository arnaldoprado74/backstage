# Corporate Backstage Base Project

Requirements:
  - node LTS version
  - nvm installed
  - yarn
  - docker/podman
  
Steps:
  - Enter directory (backstage or dev-portals/<portal-name>)
  - yarn install
  - yarn tsc    

    Tips:
    - To run tsc, add more memory to it, e.g.:
      export NODE_OPTIONS="--max-old-space-size=5120" yarn tsc
  - yarn build
