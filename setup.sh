#!/bin/bash

URL="http://localhost:8080/"
JAR="${HOME}/jenkins-cli.jar"
CLI="java -jar ${JAR} -s $URL"

set -ex

if [ ! -f $JAR ]; then
    echo "Downloading the jenkins-cli.jar file."
    wget -q -O ${JAR} ${URL%/}/jnlpJars/jenkins-cli.jar
fi

$CLI login
$CLI install-plugin analysis-core
$CLI install-plugin analysis-collector
$CLI install-plugin build-failure-analyzer
$CLI install-plugin checkstyle
$CLI install-plugin envinject
$CLI install-plugin findbugs
$CLI install-plugin pmd
$CLI install-plugin git-client
$CLI install-plugin git
$CLI install-plugin parameterized-trigger
$CLI install-plugin shared-objects
$CLI install-plugin violations
$CLI install-plugin warnings
$CLI restart
