json=$(cat)

model=$(jq -r '.model.display_name // .model.id // "unknown"' <<< "$json")
ctx_pct=$(jq -r '(.context_window.used_percentage // 0) | floor' <<< "$json")
cost_raw=$(jq -r '.cost.total_cost_usd // 0' <<< "$json")
cost=$(printf "%.2f" "$cost_raw")

files_changed=0
lines_added=0
lines_deleted=0

if git rev-parse --git-dir > /dev/null 2>&1; then
  if git rev-parse HEAD > /dev/null 2>&1; then
    diff_ref="HEAD"
  else
    diff_ref="--cached"
  fi

  while IFS=$'\t' read -r a d _f; do
    if [[ "${a}" =~ ^[0-9]+$ ]]; then
      lines_added=$(( lines_added + a ))
      lines_deleted=$(( lines_deleted + d ))
      files_changed=$(( files_changed + 1 ))
    fi
  done < <(git diff "${diff_ref}" --numstat 2>/dev/null || true)

  while IFS= read -r uf; do
    if [[ -f "${uf}" ]]; then
      uf_lines=$(wc -l < "${uf}" 2>/dev/null || echo 0)
      lines_added=$(( lines_added + uf_lines ))
      files_changed=$(( files_changed + 1 ))
    fi
  done < <(git ls-files --others --exclude-standard 2>/dev/null || true)
fi

echo "${model} | 🧠 ${ctx_pct}% | \$${cost} | 🌿 ~${files_changed} (+${lines_added} -${lines_deleted})"
