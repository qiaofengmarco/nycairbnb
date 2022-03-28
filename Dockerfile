FROM qiaofengmarco/my_heroku_docker
COPY . /app
ENV PORT=8080
CMD ["/usr/bin/R", "--no-save", "--gui-none", "-f", "/app/run.R"]