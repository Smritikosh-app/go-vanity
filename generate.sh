#!/usr/bin/env bash
# Regenerate the go-import pages. Adding a Go module is one line in MODULES.
#
# `go get go.smritikosh.in/<module>` fetches https://go.smritikosh.in/<module>?go-get=1
# and reads the go-import meta tag to learn which repository holds the module.
# The tag must be served at the EXACT path, which is why there is one directory
# per module rather than a single redirect.
set -euo pipefail

ORG=smritikosh-app
HOST=go.smritikosh.in

# module path suffix -> GitHub repository
MODULES="
contracts:smritikosh-contracts
ingestion:smritikosh-ingestion
scheduler:smritikosh-scheduler
notification:smritikosh-notification
"

page() {
  local path="$1" repo="$2"
  cat <<HTML
<!DOCTYPE html>
<meta charset="utf-8">
<meta name="go-import" content="${HOST}/${path} git https://github.com/${ORG}/${repo}">
<meta name="go-source" content="${HOST}/${path} https://github.com/${ORG}/${repo} https://github.com/${ORG}/${repo}/tree/main{/dir} https://github.com/${ORG}/${repo}/blob/main{/dir}/{file}#L{line}">
<meta http-equiv="refresh" content="0; url=https://github.com/${ORG}/${repo}">
<title>${HOST}/${path}</title>
<p>Go module <code>${HOST}/${path}</code> lives in a private repository.
Set <code>GOPRIVATE=${HOST}/*</code> and authenticate to GitHub to fetch it.
HTML
}

for entry in $MODULES; do
  path="${entry%%:*}"
  repo="${entry##*:}"
  mkdir -p "$path"
  page "$path" "$repo" > "$path/index.html"
  echo "wrote $path/index.html -> $repo"
done
