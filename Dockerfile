# Use Google base image for NodeJS
FROM node:12.18.1

COPY . /app/

# Change the working directory
WORKDIR /app

# Install dependencies.
RUN npm install

# Start the Express app
CMD ["node", "server.js"]

