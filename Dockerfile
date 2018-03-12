FROM alpine:latest

RUN apk update && apk upgrade
RUN apk add python py2-pip ca-certificates openssl alpine-sdk python-dev postgresql-dev
RUN update-ca-certificates
RUN pip install --upgrade pip

RUN cd /tmp
RUN wget https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v2.1/pip/pgadmin4-2.1-py2.py3-none-any.whl
RUN pip install ./pgadmin4-2.1-py2.py3-none-any.whl

RUN apk del alpine-sdk
RUN rm ./pgadmin4-2.1-py2.py3-none-any.whl

WORKDIR /usr/lib/python2.7/site-packages/pgadmin4
RUN sed \
	-e "s/DEFAULT_SERVER = \'127.0.0.1\'/DEFAULT_SERVER = \'0.0.0.0\'/g" \
	./config.py > /tmp/config.py && \
	mv ./config.py ./config.py.original && \
	mv /tmp/config.py ./config.py

EXPOSE 5050
CMD ["python", "/usr/lib/python2.7/site-packages/pgadmin4/pgAdmin4.py"]