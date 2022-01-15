FROM python:3-alpine

LABEL maintainer="Serhii serhii@example.com>" \
      version="0.1.0"

RUN pip install --upgrade pip

RUN adduser -D time
USER time

WORKDIR /app

COPY --chown=time:time requirements.txt requirements.txt
RUN pip install --user -r requirements.txt

ENV MyName="DevOps" \
    ENV="demo" \
    PATH="/home/time/.local/bin:${PATH}"

COPY --chown=time:time app.py .

EXPOSE 5000

ENTRYPOINT ["python"]
CMD ["app.py"]