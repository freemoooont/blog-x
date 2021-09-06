FROM node:13

USER node

RUN mkdir -p /home/node/app && chown -R node:node /home/node/app

# setting working directory in the container
WORKDIR /home/node/app

# grant permission of node project directory to node user
COPY --chown=node:node .. .

# installing the dependencies into the container
RUN npm install

# container exposed network port number
EXPOSE 3000

# command to run within the container
CMD [ "npm", "dev" ]