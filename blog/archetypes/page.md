---
title: '{{ replace .File.ContentBaseName "-" " " | title }}'
slug: '{{ .File.ContentBaseName }}'
date: '{{ .Date }}'
author: 'Lev Pasichnyi'
layout: 'page'
type: 'page'
description: >
  {{ replace .File.ContentBaseName "-" " " | humanize }}
summary: >
  ''
canonicalURL: ''
keywords: []
aliases: []
cover:
  image: "{{ .File.ContentBaseName }}.png"
  alt: "Cover image for {{ replace .File.ContentBaseName "-" " " | title }}"
toc: true
draft: false
---