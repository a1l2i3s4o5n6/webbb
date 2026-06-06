FROM perl:5.38

RUN apt-get update && apt-get install -y \
    libcgi-pm-perl \
    libplack-perl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

VOLUME ["/app"]

CMD ["plackup", "-p", "8080", "/app/app.psgi"]
