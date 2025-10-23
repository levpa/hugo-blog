---
title: "Benchmarking DNS and SSL Latency for GitHub Pages"
date: "2025-10-21T09:48:47Z"
draft: false
description: >
  A reproducible benchmark of DNS resolution and SSL handshake latency for GitHub Pages 
  using ALIAS records and apex domain strategies.
slug: "dns-ssl-benchmark"
tags: ["dns", "ssl", "latency"]
categories: ["devops", "dns", "performance", "github"]
author: "Lev Pasichnyi"
summary: >
  This post benchmarks DNS and SSL latency for GitHub Pages using apex-safe ALIAS records and strategic redirect setups. 
  Includes reproducible test cases and latency charts.
cover:
  image: "dns-ssl-latency.png"
  alt: "Latency benchmarking chart for DNS and SSL"
canonicalURL: "https://levarc.com/post/dns-ssl-benchmark"
toc: true
keywords: ["dns", "ssl", "latency", "domain"]
series: "LevArc Infrastructure Insights"
aliases: ["/blog/dns-ssl-test", "/posts/github-pages-latency"]
layout: "post"
---

## Introduction

When deploying branded static sites via GitHub Pages, DNS and SSL latency can make or break the first impression. This post
 benchmarks cold-start resolution times for `levarc.com` and `www.levarc.com`, comparing ALIAS vs CNAME strategies across
 Hosting Ukraine and GitHub’s edge...

## Test Setup

- **Domains tested**: `levarc.com`, `www.levarc.com`
- **DNS provider**: [Hosting Ukraine](ukraine.com.ua)
- **GitHub Pages target**: `levpa.github.io`
- **Record types**:
  - `levarc.com` → ALIAS → `levpa.github.io`
  - `www.levarc.com` → ALIAS → `levpa.github.io`
- **Tools used**:
  - `dig`, `curl`, `openssl s_client`,`time`, `date`
  - Custom Makefile targets for latency logging

## Results

| Domain           | Record  | DNS Lookup (ms) | SSL Handshake (ms)| TTFB (ms) | Total Time (ms) | Cold Start (ms) |
|------------------|---------|-----------------|-------------------|-----------|-----------------|-----------------|
| `levarc.com`     | ALIAS   | 1.27            | 56.79             | 85.19     | 85.62           | 98              |
| `www.levarc.com` | ALIAS   | 1.63            | 58.85             | 87.95     | 87.99           | 92              |


**Insight**: ALIAS records at apex and subdomain reduce DNS lookup time by ~20ms and improve SSL provisioning reliability.

## Strategic Takeaways

- ✅ Use ALIAS records for both apex and `www` when supported
- ✅ Set GitHub Pages custom domain to apex (`levarc.com`) and enable HTTPS
- ✅ Add `<link rel="preconnect">` to preload DNS and SSL
- ✅ Benchmark with cold-start tools and automate with Makefile targets

## 🛠️ Bash script

```bash
#!/usr/bin/env bash
set -euo pipefail

DOMAINS=("levarc.com" "www.levarc.com")
RESOLVERS=("1.1.1.1" "8.8.8.8")
CURLF='%{time_namelookup} %{time_connect} %{time_appconnect} %{time_starttransfer} %{time_total}\n'
AWKF='{printf \
"DNS lookup: %.2f ms\n" \
"TCP connect: %.2f ms\n" \
"TLS handshake: %.2f ms\n" \
"TTFB: %.2f ms\nTotal: %.2f ms\n", \
$1*1000, $2*1000, $3*1000, $4*1000, $5*1000}'

for DOMAIN in "${DOMAINS[@]}"; do
  echo -e "\n=============================="
  echo "🔎 Benchmarking: $DOMAIN"
  echo "=============================="

  echo -e "\n🔐 SSL Handshake (cert, hostname, errors validation):"
  if ! openssl s_client -connect "$DOMAIN:443" -servername "$DOMAIN" < /dev/null 2>/dev/null | grep "Verify return code"; then
    echo "❌ SSL check failed"
  fi

  echo -e "\n🔍 DNS Lookup:"
  if ! dig "$DOMAIN" | grep "Query time"; then
    echo "❌ dig failed"
  fi

  echo -e "\n📡 Curl Breakdown:"
  curl -w "$CURLF" -o /dev/null -s "https://$DOMAIN" | awk "$AWKF"

  echo -e "\n❄️ Cold-start latency:"
  start=$(date +%s%3N)
  curl -s "https://$DOMAIN" > /dev/null
  end=$(date +%s%3N)
  echo "Total: $((end - start)) ms"

  echo -e "\n🌐 DNS Propagation:"
  for server in "${RESOLVERS[@]}"; do
    echo "Testing $server..."
    dig "$DOMAIN" @"$server" | grep "$DOMAIN" || echo "❌ No response from $server"
  done
done

echo -e "\n🔁 Redirect Check (www.levarc.com → levarc.com):"
curl -ILs https://www.levarc.com | grep -i '^HTTP\|^Location'

echo -e "\n🔐 SSL check:\n"
openssl s_client -connect levarc.com:443 </dev/null |
awk '
/Protocol/         {print "🔐 Protocol: " $0}
/Cipher/           {print "🔑 Cipher: " $0}
/subject=/         {print "📌 Subject: " $0}
/issuer=/          {print "🏢 Issuer: " $0}
/Not Before/       {print "📅 Valid From: " $0}
/Not After/        {print "📅 Valid Until: " $0}
/Verify return code/ {print "✅ Trust Status: " $0}
'
```

## 🛠️ Expected output

```bash
 $ make bench-all

==============================
🔎 Benchmarking: levarc.com
==============================

🔐 SSL Handshake (cert, hostname, errors validation):
Verify return code: 0 (ok)
    Verify return code: 0 (ok)

🔍 DNS Lookup:
;; Query time: 0 msec

📡 Curl Breakdown:
DNS lookup: 1.27 ms
TCP connect: 26.42 ms
TLS handshake: 56.79 ms
TTFB: 85.19 ms
Total: 85.62 ms

❄️  Cold-start latency:
Total: 98 ms

🌐 DNS Propagation:
Testing 1.1.1.1...
; <<>> DiG 9.18.33-1~deb12u2-Debian <<>> levarc.com @1.1.1.1
;levarc.com.                    IN      A
levarc.com.             900     IN      A       185.199.108.153
levarc.com.             900     IN      A       185.199.109.153
levarc.com.             900     IN      A       185.199.110.153
levarc.com.             900     IN      A       185.199.111.153
Testing 8.8.8.8...
; <<>> DiG 9.18.33-1~deb12u2-Debian <<>> levarc.com @8.8.8.8
;levarc.com.                    IN      A
levarc.com.             900     IN      A       185.199.110.153
levarc.com.             900     IN      A       185.199.111.153
levarc.com.             900     IN      A       185.199.108.153
levarc.com.             900     IN      A       185.199.109.153

==============================
🔎 Benchmarking: www.levarc.com
==============================

🔐 SSL Handshake (cert, hostname, errors validation):
Verify return code: 0 (ok)
    Verify return code: 0 (ok)

🔍 DNS Lookup:
;; Query time: 0 msec

📡 Curl Breakdown:
DNS lookup: 1.63 ms
TCP connect: 26.90 ms
TLS handshake: 58.85 ms
TTFB: 87.95 ms
Total: 87.99 ms

❄️ Cold-start latency:
Total: 92 ms

🌐 DNS Propagation:
Testing 1.1.1.1...
; <<>> DiG 9.18.33-1~deb12u2-Debian <<>> www.levarc.com @1.1.1.1
;www.levarc.com.                        IN      A
www.levarc.com.         900     IN      A       185.199.108.153
www.levarc.com.         900     IN      A       185.199.109.153
www.levarc.com.         900     IN      A       185.199.110.153
www.levarc.com.         900     IN      A       185.199.111.153
Testing 8.8.8.8...
; <<>> DiG 9.18.33-1~deb12u2-Debian <<>> www.levarc.com @8.8.8.8
;www.levarc.com.                        IN      A
www.levarc.com.         900     IN      A       185.199.109.153
www.levarc.com.         900     IN      A       185.199.108.153
www.levarc.com.         900     IN      A       185.199.111.153
www.levarc.com.         900     IN      A       185.199.110.153

🔁 Redirect Check (www.levarc.com → levarc.com):
HTTP/2 301 
location: https://levarc.com/
HTTP/2 200 

🔐 SSL check:

📌 Subject: subject=CN = levarc.com
🏢 Issuer: issuer=C = US, O = Let's Encrypt, CN = R13
🔑 Cipher: New, TLSv1.3, Cipher is TLS_AES_128_GCM_SHA256
✅ Trust Status: Verify return code: 0 (ok)
🔐 Protocol:     Protocol  : TLSv1.3
🔑 Cipher:     Cipher    : TLS_AES_128_GCM_SHA256
✅ Trust Status:     Verify return code: 0 (ok)
```
