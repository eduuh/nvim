FROM node:14.15.4-buster
COPY . /.config/nvim
ENTRYPOINT [ "nvim" ]
