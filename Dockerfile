FROM python:3.9.6-alpine3.14
RUN apk add --no-cache openssl
COPY cert_templates /var/certs

# Create root private key
RUN openssl genrsa -des3 -passout pass:12345 -out /var/certs/testCA.key 2048

# Generate root certificate
RUN openssl req \
    -x509 \
    -new \
    -nodes \
    -passin pass:12345 \
    -key /var/certs/testCA.key \
    -sha256 \
    -days 1460 \
    -out /var/certs/testCA.pem \
    -subj "/C=US/ST=MI/L=Ypsilanti/O=Engineering/OU=QA/CN=qa-root"

# Add root certificate to trusted store
RUN cp /var/certs/testCA.pem /usr/local/share/ca-certificates/ \
    && chmod 644 /usr/local/share/ca-certificates/testCA.pem
RUN update-ca-certificates

# Create localhost certificate signing request
RUN openssl req \
    -new \
    -sha256 \
    -nodes \
    -out /var/certs/server.csr \
    -newkey rsa:2048 \
    -keyout /var/certs/server.key \
    -config /var/certs/server.csr.cnf

# Sign localhost certificate
RUN openssl x509 \
    -req \
    -passin pass:12345 \
    -in /var/certs/server.csr \
    -CA /var/certs/testCA.pem \
    -CAkey /var/certs/testCA.key \
    -CAcreateserial \
    -out /var/certs/server.crt \
    -days 500 \
    -sha256 \
    -extfile /var/certs/v3.ext