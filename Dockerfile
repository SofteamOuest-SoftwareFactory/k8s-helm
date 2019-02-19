FROM alpine

LABEL maintainer="Mehdi EL KOUHEN <mehdi.elkouhen@gmail.com>"

ARG VCS_REF
ARG BUILD_DATE

# Metadata
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/SofteamOuest-SoftwareFactory/k8s-helm.git " \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.docker.dockerfile="/Dockerfile"

ENV HELM_LATEST_VERSION="v2.9.1"
ENV HELMFILE_LATEST_VERSION="v0.45.3"

RUN apk add --update ca-certificates \
 && apk add --update -t deps wget \
 && apk add --update -t git gnupg ssh \
 && wget https://storage.googleapis.com/kubernetes-helm/helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
 && wget https://github.com/roboll/helmfile/releases/download/${HELMFILE_LATEST_VERSION}/helmfile_linux_amd64 \
 && tar -xvf helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz \
 && mv linux-amd64/helm /usr/local/bin \
 && mv helmfile_linux_amd64 /usr/local/bin \
 && apk del --purge deps \
 && rm /var/cache/apk/* \
 && rm -f /helm-${HELM_LATEST_VERSION}-linux-amd64.tar.gz

RUN /bin/sh -c "apk add --no-cache curl bash gnupg"

RUN helm init --client-only\
 && helm plugin install https://github.com/futuresimple/helm-secrets

ENTRYPOINT ["helm"]
CMD ["help"]
