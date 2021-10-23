#Maintained by Vitali Kuts. Vitalik@playtika.com
FROM python:alpine
COPY ./application/ /home/appuser/wa3/
WORKDIR /home/appuser/wa3/
RUN addgroup -S appgroup && adduser -S appuser -G appgroup && pip3 install --no-cache-dir aiohttp multidict==4.5.2 yarl==1.3.0 && python3 setup.py install
USER appuser
#EXPOSE 8080
CMD ["python3", "-m", "demo"]
