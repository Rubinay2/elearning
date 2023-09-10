# Use Nginx as base image
FROM nginx:latest

# Copy index.html file to the container
COPY index.html /usr/share/nginx/html/

# Expose port 80 and 443 for incoming traffic
EXPOSE 80 443

# Start nginx server on container lunch
CMD [ "nginx", "-g", "daemon off;" ]
