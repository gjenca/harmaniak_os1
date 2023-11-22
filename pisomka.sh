#!/bin/bash

cat <<THE_END
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-type" content="text/html;charset=UTF-8" >
</head>
<body>
THE_END

ZOZ=false

while IFS= read -r LINE; do

    if [[ "$LINE" =~ ^[[:space:]]*$ ]]; then  
        echo "<p>"
        continue
    fi

    if [[ "$LINE" =~ ^#\ +(.+)$ ]]; then
        if [ "$ZOZ" = true ]; then
            echo "</ul>"
            ZOZ=false
        fi
        echo "<h1>${BASH_REMATCH[1]}</h1>"
        continue
    elif [[ "$LINE" =~ ^##\ +(.+)$ ]]; then
        if [ "$ZOZ" = true ]; then
            echo "</ul>"
            ZOZ=false
        fi
        echo "<h2>${BASH_REMATCH[1]}</h2>"
        continue
    elif [[ "$LINE" =~ ^-\ (.+)$ ]]; then
        if [ "$ZOZ" = false ]; then
            echo "<ul>"
            ZOZ=true
        fi
        echo "<li>${BASH_REMATCH[1]}</li>"
        continue
    elif [ "$ZOZ" == true ]; then
        echo "</ul>"
        ZOZ=false
    fi
    
    LINE=$(echo "$LINE" | sed -E 's/__([^_]+)__/\<strong\>\1\<\/strong\>/g')
    LINE=$(echo "$LINE" | sed -E 's/_([^_]+)_/\<em\>\1\<\/em\>/g')
    LINE=$(echo "$LINE" | sed -E 's/<(https:\/\/[^>]+)>/<a href="\1">\1<\/a>/g')

    echo "$LINE"
done

echo "</body>"
echo "</html>"

