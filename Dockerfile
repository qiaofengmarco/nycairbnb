FROM qiaofengmarco/my_heroku_docker
ENV PORT=8080
CMD ["/usr/bin/R", "--no-save", "--gui-none", "-f", "./run.R"]