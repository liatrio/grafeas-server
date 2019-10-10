FROM us.gcr.io/grafeas/grafeas-server:v0.1.1
RUN apk add curl
RUN echo 'curl -v --cacert /certificates/ca.crt --key /certificates/tls.key --cert /certificates/tls.crt https://localhost/v1beta1/projects' >> /home/check.sh
RUN chmod +x /home/check.sh
