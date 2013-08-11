#!/bin/bash

URL="http://localhost:8080/"
JAR="${HOME}/jenkins-cli.jar"
CLI="java -jar ${JAR} -s $URL"

set -ex

if [ ! -f $JAR ]; then
    echo "Downloading the jenkins-cli.jar file."
    wget -q -O ${JAR} ${URL%/}/jnlpJars/jenkins-cli.jar
fi

for jfile in jobs/*.xml; do
    jobname=${jfile%.xml}
    jobname=${jobname#*/}
    
    $CLI delete-job $jobname || true
    $CLI create-job $jobname < $jfile
done
