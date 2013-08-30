#!/bin/sh

echo 'build project'
ant build

echo 'run the application to recognise the letters and digits'
java -mx312m -jar bin/annotation4conv.jar

