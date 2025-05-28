FROM python:3.12.3
RUN pip install django==5.2.1

COPY . .

RUN python manage.py migrate
EXPOSE 8000
CMD ["python","manage.py","runserver","0.0.0.0:8000"]


