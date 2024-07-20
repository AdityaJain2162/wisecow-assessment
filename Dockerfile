FROM debian:latest

# Set the working directory in the container
WORKDIR /app

# Install required packages, including Netcat
RUN apt-get update && \
    apt-get install -y \
    fortune-mod \
    cowsay \
    netcat-openbsd \
    dos2unix \
    && rm -rf /var/lib/apt/lists/*

# Copy the shell script into the container
COPY wisecow.sh /app/wisecow.sh

# Convert line endings from CRLF to LF
RUN dos2unix /app/wisecow.sh

# Make the script executable
RUN chmod +x /app/wisecow.sh

# Update PATH to include /usr/games
ENV PATH="/usr/games:${PATH}"

# Example Dockerfile snippet
EXPOSE 4499

# Specify the default command to run the script
ENTRYPOINT ["/app/wisecow.sh"]
