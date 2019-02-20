FROM python:3.6.0-alpine

ENV APP_HOME /app
WORKDIR $APP_HOME
COPY requirements.txt helpers.py post_app.py VERSION $APP_HOME/

RUN apk --no-cache add gcc=5.3.0-r0 musl-dev=1.1.14-r16 \
    && pip install -r /app/requirements.txt \
    && rm -rf /root/.cache \
    && rm -rf /app/requirements.txt \
    && apk --no-cache del gcc musl-dev

ENV POST_DATABASE_HOST post_db
ENV POST_DATABASE posts

ENTRYPOINT ["python3", "post_app.py"]
