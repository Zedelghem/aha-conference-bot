#!/bin/zsh

curl "https://www.historians.org/events/aha-events-calendar/?_year=$(date "+%Y")" | \
pup 'div.card-content' > .events.html

if [ -f .aha_events ]; then
    mv .aha_events .old_aha_events
else
    touch .old_aha_events
fi

# Ugly sed: remove empty lines, remove leading whitespace
# Removed "" wrapping as unnecessary (s/^/"/; s/$/"/)
# additional ugly sed on the first line: replace all multi-whitespaces with single space (just in case, it is s a messy field)

cat .events.html | pup 'p.card-date text{}' | sed '/^[[:space:]]*$/d; s/^[ \\t]*//' | sed -e "s/[[:space:]]\+/ /g" > .dates
cat .events.html | pup 'h5.card-title a text{}' | sed '/^[[:space:]]*$/d; s/^[ \\t]*//' > .titles
cat .events.html | pup 'h5.card-title a attr{href}'  > .links

# -t sets separating character
# -o narrows down output fields
# =() is a zsh/new bash operator; will not work in older bash
join -o 1.2,2.2 -t $'\t' =(cat -n .titles) =(cat -n .links) > .tlinks
join -o 1.2,2.2,2.3 -t $'\t' =(cat -n .dates) =(cat -n .tlinks) > .aha_events

# If they differ
if ! cmp -s .aha_events .old_aha_events; then
    comm -23 .aha_events .old_aha_events > .new_aha_events

    while read line; do
      DATE=$(echo $line | cut -f1)
      TITLE=$(echo $line | cut -f2)
      LINK=$(echo $line | cut -f3)

      grrr --appId ConferenceBot --title "New AHA event!" --subtitle "$DATE" --open "$LINK" --sound default "$TITLE"

    done < .new_aha_events

    rm .new_aha_events

fi

rm .titles .links .tlinks .dates .events.html
