#!/bin/sh
input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name // empty')
size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
used=$(echo "$input" | jq -r '
  .context_window.current_usage as $u |
  if $u then
    (($u.input_tokens // 0) + ($u.cache_creation_input_tokens // 0) + ($u.cache_read_input_tokens // 0))
  else empty end
')

[ -z "$model" ] && exit 0

h() {
  echo "$1" | awk '{
    if ($1 >= 1000000) { v=$1/1000000; u="m" }
    else if ($1 >= 1000) { v=$1/1000; u="k" }
    else { printf "%d", $1; exit }
    s = (v == int(v)) ? sprintf("%d", v) : sprintf("%.1f", v)
    printf "%s%s", s, u
  }'
}

if [ -n "$size" ] && [ -n "$pct" ]; then
  [ -z "$used" ] && used=$(awk -v p="$pct" -v s="$size" 'BEGIN { printf "%d", p/100*s }')
  printf "[%s] %s/%s tokens (%d%%)\n" "$model" "$(h "$used")" "$(h "$size")" "$pct"
else
  printf "[%s]\n" "$model"
fi
