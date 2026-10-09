# go-vanity

Serves `go-import` meta tags for `go.smritikosh.in/*` module paths. **No code
lives here** — only the tags Go needs to find the real, private repositories.

## Why this exists

ADR-028 chose vanity module paths so that source code never embeds the GitHub
organisation name, and the organisation can be renamed or moved without
touching a single import. That only works if something serves the meta tag.

## Why a subdomain, not the apex

`smritikosh.in` itself stays untouched. The apex is the one scarce name on a
domain, and it is wanted later for the product site or an AWS load balancer —
pointing it elsewhere would silently break every `go get`, presenting as a Go
problem rather than a DNS one. A subdomain is free, unlimited, and immune to
that.

`smritikosh.com` is likewise left with no dependencies, so it can redirect
wherever it likes.

## This repository is public

It must be: `go get` reads the tag unauthenticated. It exposes the organisation
and repository names and nothing else — the repositories themselves stay
private and return 404 to anyone without access.

## Adding a module

One line in `MODULES` in `generate.sh`, then run it:

```
./generate.sh && git commit -am "add <module>" && git push
```

CI verifies every page carries a well-formed tag.
