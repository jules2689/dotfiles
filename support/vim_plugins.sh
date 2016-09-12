set -euo pipefail

dir="$(dirname "${BASH_SOURCE[0]}")"

mkdir -p ~/.vim/bundle

children=()

while read -r line; do
  if [[ "${line}" == "#"* || "${line}" == "" ]]; then
    continue
  fi

  (
    repo="$(basename "${line}" .git)"
    if [[ -d ~/.vim/bundle/${repo} ]]; then
      echo "%% Pulling ${repo}"
      git -C ~/.vim/bundle/${repo} pull
    else
      echo "%% Cloning ${repo}"
      git -C ~/.vim/bundle clone "${line}"
    fi
  ) &
  children+=($!)
done < "${dir}/vim_plugins"

# shellcheck disable=SC2086
wait ${children[*]}
