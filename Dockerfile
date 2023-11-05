# Stage 1: Build the Node.js application
FROM node:14 AS build
WORKDIR /sampleNodeApp
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Build the Nginx image and copy the built application
FROM nginx:latest

# Copy the custom app logs to the D:\ directory on the Windows host
COPY ./app-logs /mnt/app-logs

# Configure Nginx to log access and error logs
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]