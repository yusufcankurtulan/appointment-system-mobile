FROM node:20-alpine
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm ci --silent || npm i --silent
COPY . .
RUN npm run build
EXPOSE 5173
CMD ["npm", "run", "preview"]
