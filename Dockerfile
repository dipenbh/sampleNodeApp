# Stage 1: Build the Node.js application
FROM ubuntu:20.04 AS build

# Set the working directory in the container
WORKDIR /sampleNodeApp

# Update the package list
RUN apt-get update

# Install Node.js and npm
RUN apt-get install -y nodejs npm

# Clean up
RUN apt-get clean

# Install Git and other required tools
#RUN apt-get update && \
#    apt-get install -y git && \
#    apt-get clean
# RUN apt-get install nano

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Install Node.js dependencies
RUN npm install


COPY . .
RUN npm run build

# Stage 2: Build the Nginx image and copy the built application
FROM nginx:latest


# Copy the custom app logs to the D:\ directory on the Windows host
#COPY ./app-logs /docker-log

# Copy the built application from the "build" stage
COPY --from=build /sampleNodeApp /usr/share/nginx/html

# Copy your custom Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the contents of a local folder into the Nginx HTML directory
#COPY . /usr/share/nginx/html/local-folder

# Configure Nginx to log access and error logs
RUN ln -sf /dev/stdout /var/access.log
RUN ln -sf /dev/stderr /var/error.log

EXPOSE 80

CMD ["nginx", "-g", "daemon off;", "npm", "run", "dev"]
#CMD ["npm", "run", "dev"]