#!/usr/bin/env bash
# git-handbook.html 内の href="#xxx" に対応する id="xxx" が存在するかを検証する。
set -uo pipefail

FILE="${1:-git-handbook.html}"

if [ ! -f "$FILE" ]; then
  echo "NG: $FILE が見つかりません" >&2
  exit 1
fi

ids=$(grep -o 'id="[^"]*"' "$FILE" | sed 's/id="//;s/"//' | sort -u)
hrefs=$(grep -o 'href="#[^"]*"' "$FILE" | sed 's/href="#//;s/"//' | sort -u)

missing=0
total=0
while IFS= read -r h; do
  [ -z "$h" ] && continue
  total=$((total + 1))
  if ! printf '%s\n' "$ids" | grep -qx "$h"; then
    echo "NG: href=\"#$h\" に対応する id がありません"
    missing=$((missing + 1))
  fi
done <<< "$hrefs"

if [ "$missing" -gt 0 ]; then
  echo "NG: $missing 件のリンク切れ"
  exit 1
fi

echo "OK: all $total anchors resolve"
