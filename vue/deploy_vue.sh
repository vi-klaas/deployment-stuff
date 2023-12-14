#!/bin/sh

docker run --rm -v static_storage:/static_files --name temp-red_vue-deployer ghcr.io/vi-klaas/red_vue:latest

# docker run --rm -v static_storage:/static_files --name temp-vue-builder -it ghcr.io/vi-klaas/red_vue:latest sh
