docker run -d --name shiny_dev -p 3839:3838 \
  --restart unless-stopped \
  -v /srv/shiny/apps-test:/srv/shiny-server \
  -v /srv/shiny/shiny-server.conf:/etc/shiny-server/shiny-server.conf \
  -u $(id -u apprunner):$(id -g apprunner) \
   sorc_shiny_image
