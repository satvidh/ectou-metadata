FROM python:3.8.6-buster

WORKDIR /app

COPY requirements.txt .
COPY ./ .

RUN pip install --upgrade pip \
    && pip install -r requirements.txt --upgrade

ENTRYPOINT ["python", "app.py"]
