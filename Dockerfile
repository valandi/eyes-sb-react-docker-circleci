FROM node:16-alpine
ENV NPM_CONFIG_LOGLEVEL warn
WORKDIR /usr/src/app
COPY . .
RUN npm set progress=false && npm install
EXPOSE 8086
CMD ["npm", "run", "storybook"]