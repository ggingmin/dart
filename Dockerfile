FROM dart:stable AS build

RUN addgroup --system --gid 1000 worker
RUN adduser --system --uid 1000 --ingroup worker --disabled-password worker

WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

COPY . .
RUN dart pub get --offline
RUN dart compile exe bin/server.dart -o bin/server


FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/

COPY --from=build /app/public/ /public

USER worker:worker

EXPOSE 8080
CMD ["/app/bin/server"]
