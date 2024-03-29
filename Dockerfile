FROM ubuntu AS build
RUN apt-get update
RUN apt-get -y install make zip python3 pandoc
COPY ./youtube-dl /youtube-dl
WORKDIR /youtube-dl
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN make

FROM alpine
COPY --from=build /youtube-dl/youtube-dl /usr/local/bin/youtube-dl
RUN apk add --update --no-cache curl py-pip
RUN apk add --update ffmpeg
RUN chmod a+rx /usr/local/bin/youtube-dl
RUN ln -sf /usr/bin/python3 /usr/bin/python
WORKDIR /mnt
CMD [ "sh", "-c", "youtube-dl --verbose $url" ]
