# docker-python-ssl
A docker container ready for testing Python SSL applications

Intended as a test environment for applications which utilize the SSL library.
Certificates are generated at build time, and it is reccomended that these images
be built as needed rather than storing them in an image registry.

By default, the server certificate is for "localhost" and "test-server".
This can be altered by editing v3.ext

# Build
```
docker build -t python-ssl-test:dev .
```