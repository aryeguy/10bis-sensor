#!/bin/sh
docker build . -t 10bis-sensor
docker run -e USERNAME='guya@evercompliant.com' -e PASSWORD='T8G6f^O7JD$8'-it 10bis-sensor
