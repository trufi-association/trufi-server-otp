# OpenTripPlanner 2.10.0 — same layout as the images trufi-server-otp builds
# (Dockerfiles/<version>/{Dockerfile,app/run.sh}); only the base image and the
# release jar change. OTP >= 2.9 requires Java 25 (jib base in upstream pom:
# eclipse-temurin:25-jre). Release: 2026-09-09.
FROM eclipse-temurin:25-jre-noble

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends wget ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# jar first, run.sh last: editing run.sh must not invalidate the 191 MB download layer
ARG OTP_VERSION=2.10.0
RUN wget -q -O otp-shaded.jar \
    https://github.com/opentripplanner/OpenTripPlanner/releases/download/v${OTP_VERSION}/otp-shaded-${OTP_VERSION}.jar \
    && ls -la otp-shaded.jar

ADD ./app .

EXPOSE 8080 8081

ENTRYPOINT [ "sh", "./run.sh" ]
