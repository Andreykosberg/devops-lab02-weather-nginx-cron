#!/bin/bash
# weather.sh - fetch current temperature and humidity for a city from wttr.in
# and render them into the default nginx site's index.html.
#
# Usage: ./weather.sh <city>
#
# Requires: curl, jq

set -euo pipefail

CITY="${1:-Moscow}"
INDEX_FILE="/var/www/html/index.html"

WEATHER_JSON="$(curl -s "wttr.in/${CITY}?format=j1")"

TEMP_C="$(echo "$WEATHER_JSON" | jq -r '.current_condition[0].temp_C')"
HUMIDITY="$(echo "$WEATHER_JSON" | jq -r '.current_condition[0].humidity')"
OBS_TIME="$(echo "$WEATHER_JSON" | jq -r '.current_condition[0].observation_time')"
NOW="$(date '+%Y-%m-%d %H:%M:%S %Z')"

cat > "$INDEX_FILE" <<HTML
<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8">
  <title>Weather: ${CITY}</title>
</head>
<body>
  <h1>Погода в городе ${CITY}</h1>
  <p>Температура: ${TEMP_C} &deg;C</p>
  <p>Влажность: ${HUMIDITY}%</p>
  <p>Время наблюдения (wttr.in): ${OBS_TIME}</p>
  <p>Скрипт обновлён cron: ${NOW}</p>
</body>
</html>
HTML
