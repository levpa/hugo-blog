---
title: '{{ replace .File.ContentBaseName "-" " " | title }}'
slug: '{{ .File.ContentBaseName }}'
date: '{{ .Date }}'
description: >
  {{ replace .File.ContentBaseName "-" " " | humanize }}
summary: >
  ''
author: 'Lev Pasichnyi'
layout: 'page'
canonicalURL: ''
keywords: []
aliases: []
cover:
  image: "{{ .File.ContentBaseName }}.png"
  alt: "Cover image for {{ replace .File.ContentBaseName "-" " " | title }}"
toc: true
draft: false
type: 'page'
---