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
  if ! openssl s_client -connect "$DOMAIN:443" -servername "$DOMAIN" \
  < /dev/null 2>/dev/null | grep "Verify return code"; then
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

echo -e "\n🔐 SSL check:"
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
