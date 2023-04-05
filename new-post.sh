#!/bin/bash
#
# Create a new post.
#

month_names=(null January  February  March \
                  April    May       June \
                  July     August    September \
                  October  November  December)

slugify() {
    echo "$@" | tr -d [:punct:] | tr A-Z a-z | tr ' ' '-'
}

peers() {
    awk '/key:/ { key=$3 } /lastname:/ { printf("%s:%s\n", key, $2) }' _data/peers.yml
}

default_year="$(date +%Y)"
default_month="$(date +%m)"
default_day="$(date +%d)"
default_month_name="$(date +%B)"

read -e -p "Title: " title
read -e -p "Year [$default_year]: " year
read -e -p "Month [$default_month]: " month
read -e -p "Day [$default_day]: " day

PS3="Select presenter: "
select name in $(peers | cut -f2 -d:); do
    peer=$(peers | grep ":$name" | cut -f1 -d:)
    break
done
read -e -p "Description: " long_description

title=${title:-Untitled}
year=${year:-$default_year}
month=${month:-$default_month}
day=${day:-$default_day}
long_description=${long_description:-Description}

date=$(printf '%04d-%02d-%02d' $year $month $day)
month_name="${month_names[$month]}"

filename="_posts/$date-$(slugify ${title}).md"
if [ -f "$filename" ]; then
    echo "File $filename already exists." >&2
    exit 1
fi

cat <<__POST__ >${filename}
---
layout: post
title: ${title}
date: ${year}-${month}-${day}
tags: [meeting]
fpage: a
peer: ${peer}
---

${long_description}

${month_name} ${day}, ${year}, 7 PM to 9 PM EDT. See [Meetup]({{site.meetupurl}}).
__POST__

echo "Created $filename"
if [ "x$EDITOR" != "x" ]; then
    $EDITOR $filename
fi
