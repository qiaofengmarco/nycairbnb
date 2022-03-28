FROM qiaofengmarco/my_heroku_docker
ONBUILD COPY . /app
WORKDIR /app
ENV PORT=8080
CMD ["/usr/bin/R", "--no-save", "--gui-none", "-f", "/app/run.R"]