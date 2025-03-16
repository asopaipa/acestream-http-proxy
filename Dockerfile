# syntax=docker/dockerfile:1

FROM ubuntu:22.04

LABEL \
    maintainer="Martin Bjeldbak Madsen <me@martinbjeldbak.com>" \
    org.opencontainers.image.title="acestream-http-proxy" \
    org.opencontainers.image.description="Stream AceStream sources on macOS and other systems without needing to install AceStream player" \
    org.opencontainers.image.authors="Martin Bjeldbak Madsen <me@martinbjeldbak.com>" \
    org.opencontainers.image.url="https://github.com/martinbjeldbak/acestream-http-proxy" \
    org.opencontainers.image.vendor="https://martinbjeldbak.com"

ARG TARGETPLATFORM


COPY resources/ /tmp/files/
COPY run-arm.sh /tmp/files/
COPY run-amd64.sh /tmp/files/



RUN apt-get update \
  && apt-get install --no-install-recommends -y \
      python3.10 ca-certificates wget sudo unzip findutils binutils build-essential libc6 file \
  && rm -rf /var/lib/apt/lists/*


SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN case "${TARGETPLATFORM}" in \
    "linux/amd64") \
      export ACESTREAM_VERSION="3.2.3_ubuntu_22.04_x86_64_py3.10" \
      && wget --progress=dot:giga "https://download.acestream.media/linux/acestream_${ACESTREAM_VERSION}.tar.gz" \
      && mkdir acestream \
      && cp /tmp/files/run-amd64.sh /run.sh \
      && tar zxf "acestream_${ACESTREAM_VERSION}.tar.gz" -C acestream \
      && rm "acestream_${ACESTREAM_VERSION}.tar.gz" \
      && mv acestream /opt/acestream \
      && pushd /opt/acestream || exit \
      && bash ./install_dependencies.sh \
      && popd || exit \
      ;; \
    "linux/arm64") \
      export ACESTREAM_VERSION="3.2.8/org.acestream.node_arm64_v8" \
      && wget --progress=dot:giga "https://github.com/asopaipa/acestream_arm_apk/releases/download/${ACESTREAM_VERSION}.apk" -O acestream.apk \
      && mkdir -p /opt/acestream \
      && mkdir -p /acestream \
      && unzip -o acestream.apk -d /opt/acestream \
      && unzip -o /opt/acestream/assets/engine/arm64-v8a_private_res.zip -d /acestream \
      && unzip -o /opt/acestream/assets/engine/arm64-v8a_private_py.zip -d /acestream \
      && cp -r /tmp/files/*.py /acestream/ \
      && cp -r /tmp/files/system/ /system/ \
      && cp /tmp/files/run-arm.sh /run.sh \
      && rm -f acestream.apk \
      && rm -rf /opt/acestream \
      && chmod +x /acestream/python/bin/python \
      ;; \
    "linux/arm/v7") \
      export ACESTREAM_VERSION="3.2.8/org.acestream.node_armv7" \
      && wget --progress=dot:giga "https://github.com/asopaipa/acestream_arm_apk/releases/download/${ACESTREAM_VERSION}.apk" -O acestream.apk \
      && mkdir -p /opt/acestream \
      && mkdir -p /acestream \
      && unzip -o acestream.apk -d /opt/acestream \
      && unzip -o /opt/acestream/assets/engine/armeabi-v7a_private_res.zip -d /acestream \
      && unzip -o /opt/acestream/assets/engine/armeabi-v7a_private_py.zip -d /acestream \
      && cp -r /tmp/files/*.py /acestream/ \
      && cp -r /tmp/files/system/ /system/ \
      && cp /tmp/files/run-arm.sh /run.sh \
      && rm -f acestream.apk \
      && rm -rf /opt/acestream \
      && chmod +x /acestream/python/bin/python \
      ;; \
    *) \
      echo "Not supported architecture: ${TARGETPLATFORM}" \
      && exit 1 \
      ;; \
  esac

ENV ALLOW_REMOTE_ACCESS="no"
ENV HTTP_PORT=6878
ENV EXTRA_FLAGS=''

RUN chmod a+x /run.sh
ENTRYPOINT ["/run.sh"]
CMD ["/run.sh"]

EXPOSE 6878/tcp

