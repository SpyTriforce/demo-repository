yaml_file="api.yaml"

title=$(awk -F': ' '/title: "/{print $2}' "$yaml_file")
title="${title%\"}"
title="${title#\"}"

echo "$title"

