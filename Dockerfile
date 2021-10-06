FROM maven:3.8.3-jdk-11
ARG ARTIFACTREGISTRY_MAVEN_WAGON_VERSION=2.1.2
ARG SPRING_BOOT_STARTER_PARENT_VERSION=2.2.5.RELEASE
RUN apt-get update \
  && apt-get install -y --no-install-recommends jq libxml2-utils \
  && rm -rf /var/lib/apt/lists/*
RUN mvn dependency:get -Dartifact=com.google.cloud.artifactregistry:artifactregistry-maven-wagon:${ARTIFACTREGISTRY_MAVEN_WAGON_VERSION} \
  && mvn dependency:get -Dartifact=org.springframework.boot:spring-boot-starter-parent:${SPRING_BOOT_STARTER_PARENT_VERSION}:pom
COPY settings.xml /root/.m2/settings.xml
COPY assets/ /opt/resource/
RUN cd /opt/resource/ \
  && chmod +x ./in ./out ./check ./common.sh \
  && sed s/\{\{VERSION\}\}/$ARTIFACTREGISTRY_MAVEN_WAGON_VERSION/ -i .mvn/extensions.xml