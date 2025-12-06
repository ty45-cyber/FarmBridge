FROM dart:stable AS build

WORKDIR /app
COPY pubspec.yaml ./
RUN dart pub get

COPY . .
RUN dart compile exe bin/server.dart -o farmbridge-server

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/farmbridge-server /app/

EXPOSE 8080
ENTRYPOINT ["/app/farmbridge-server"]