FROM node:20-bullseye
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm ci --silent || npm i --silent
COPY . .
# generate Prisma client for the container platform and then build
RUN npx prisma generate
RUN npm run build
EXPOSE 4000
CMD ["npm", "start"]
