FROM python:3.11.0a1-alpine3.14
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
COPY ./application/ /home/appuser/wa3/
WORKDIR /home/appuser/wa3/
RUN pip3 install aiohttp multidict==4.5.2 yarl==1.3.0 && python3 setup.py install
USER appuser
#RUN sleep infinity
CMD ["python3","-m","demo"]
