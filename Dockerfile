FROM google/cloud-sdk:slim

ENV APP_ROOT=/app
RUN mkdir ${APP_ROOT}
WORKDIR ${APP_ROOT}

COPY apply.sh ${APP_ROOT}/apply.sh
COPY check.sh ${APP_ROOT}/check.sh

CMD ["/app/apply.sh"]
