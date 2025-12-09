FROM node:18

# Install curl for smoke tests
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install app dependencies
COPY app/package.json ./
RUN npm install

# Copy app source
COPY app ./

EXPOSE 3000

CMD ["npm", "start"]
