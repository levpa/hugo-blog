---
title: '{{ replace .File.ContentBaseName "-" " " | title }}'
date: '{{ .Date }}'
slug: '{{ .File.ContentBaseName }}'
draft: true
description: >
  {{ replace .File.ContentBaseName "-" " " | humanize }}
tags: []
categories: []
author: 'Lev'
summary: >
  ''
cover:
  image: "{{ .File.ContentBaseName }}.png"
  alt: "Cover image for {{ replace .File.ContentBaseName "-" " " | title }}"
canonicalURL: ''
toc: true
keywords: []
series: ''
aliases: []
layout: 'post'
---