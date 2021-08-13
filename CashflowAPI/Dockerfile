FROM rocker/tidyverse:latest
LABEL maintainer="Kenneth Ezirim <kezirim@deloitte.com>"

# install plumber
RUN R -e "install.packages('plumber')"

COPY ./scripts/main.R /
COPY ./R/controller.R /
COPY ./R/model.R

ENTRYPOINT [ "Rscript", "main.R" ]