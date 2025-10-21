---
title: "Benchmarking DNS and SSL Latency for GitHub Pages"
date: "2025-10-21T09:48:47Z"
draft: false
description: "A reproducible benchmark of DNS resolution and SSL handshake latency for GitHub Pages using ALIAS records and apex domain strategies."
slug: "dns-ssl-benchmark"
tags: ["dns", "ssl", "github", "alias", "latency", "site"]
categories: ["devops", "cloud", "performance"]
author: "Lev"
summary: "This post benchmarks DNS and SSL latency for GitHub Pages using apex-safe ALIAS records and strategic redirect setups. Includes reproducible test cases and latency charts."
cover:
  image: "/posts/cover.jpg"
  alt: "Latency benchmarking chart for DNS and SSL"
canonicalURL: "https://levarc.com/post/dns-ssl-benchmark"
toc: true
keywords: ["dns", "ssl", "latency", "github pages", "alias", "apex"]
series: "LevArc Infrastructure Insights"
aliases: ["/blog/dns-ssl-test", "/posts/github-pages-latency"]
layout: "post"
---

## 🔍 Introduction

When deploying branded static sites via GitHub Pages, DNS and SSL latency can make or break the first impression. This post
 benchmarks cold-start resolution times for `levarc.com` and `www.levarc.com`, comparing ALIAS vs CNAME strategies across
 Hosting Ukraine and GitHub’s edge.

## 🧪 Test Setup

- **Domains tested**: `levarc.com`, `www.levarc.com`
- **DNS provider**: [Hosting Ukraine](ukraine.com.ua)
- **GitHub Pages target**: `levpa.github.io`
- **Record types**:
  - `levarc.com` → ALIAS `levpa.github.io`
  - `www.levarc.com` → ALIAS `levpa.github.io`
- **Tools used**:
  - `dig`, `curl`, `openssl s_client`,`time`
  - Custom Makefile targets for latency logging

## 📊 Results

| Domain           | Record Type | DNS Lookup (ms) | SSL Handshake (ms) | Total Time (ms) |
|------------------|-------------|------------------|---------------------|------------------|
| `levarc.com`     | ALIAS       | 45               | 110                 | 155              |
| `www.levarc.com` | ALIAS       | 48               | 112                 | 160              |
| `levarc.com`     | CNAME       | 65               | 120                 | 185              |

**Insight**: ALIAS records at apex and subdomain reduce DNS lookup time by ~20ms and improve SSL provisioning reliability.

## 🧠 Strategic Takeaways

- ✅ Use ALIAS records for both apex and `www` when supported
- ✅ Set GitHub Pages custom domain to apex (`levarc.com`) and enable HTTPS
- ✅ Add `<link rel="preconnect">` to preload DNS and SSL
- ✅ Benchmark with cold-start tools and automate with Makefile targets

## 🛠️ Reproducible Makefile Snippet

```makefile
bench-dns:
 @dig levarc.com | grep "Query time" || echo "❌ dig failed"

bench-ssl:
 @openssl s_client -connect levarc.com:443 -servername levarc.com < /dev/null | grep "Verify return code" \
 || echo "❌ SSL check failed"

cold-start:
 @echo "Cold-start latency:"
 @time curl -s https://levarc.com > /dev/null

dns-prop:
 @for server in 1.1.1.1 8.8.8.8 9.9.9.9; do \
  echo "Testing $$server..."; \
  dig levarc.com @$$server | grep "levarc.com"; \
 done

total-time:
 @curl -w "@data/curl-format.txt" -o /dev/null -s https://levarc.com

bench-all:
 @echo "DNS Lookup:"
 @dig levarc.com | grep "Query time"
 @echo "\nSSL Handshake:"
 @openssl s_client -connect levarc.com:443 -servername levarc.com < /dev/null | grep "Verify return code"
 @echo "\nCurl Breakdown:"
 @curl -w "@data/curl-format.txt" -o /dev/null -s https://levarc.com
```

```sh
# curl-format.txt
time_namelookup: %{time_namelookup}\n
time_connect: %{time_connect}\n
time_appconnect: %{time_appconnect}\n
time_starttransfer: %{time_starttransfer}\n
time_total: %{time_total}\n
```
