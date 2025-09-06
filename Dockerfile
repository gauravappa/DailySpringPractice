FROM gradle:8.14.3-jdk24 AS build
#We can use jdk as base image but it do not have all the depenencies required for gradlew to work so gradle base image

WORKDIR DailySpringPractice/

COPY gradlew .
COPY gradle ./gradle
COPY build.gradle .
COPY settings.gradle .
RUN ./gradlew --version

RUN ./gradlew dependencies --no-daemon  #do not use --write-locks in prod as it might refresh dependency instead of locked dependenecy in gradle.lock file

COPY src ./src

RUN ./gradlew bootJar -x test --no-daemon

RUN ls -l build/libs

FROM amazoncorretto:24-jdk

WORKDIR DailySpringPractice/

COPY --from=build home/gradle/DailySpringPractice/build/libs/DailySpringPractice-0.0.1-SNAPSHOT.jar .

EXPOSE 8080

ENTRYPOINT ["java","-jar","DailySpringPractice-0.0.1-SNAPSHOT.jar"]



