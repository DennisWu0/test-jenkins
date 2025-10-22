# Use an official Nginx image as a base
FROM nginx:stable-alpine-perl

# Copy the static website files into the Nginx default public directory
COPY . /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80
