---
title: '{{ replace .File.ContentBaseName "-" " " | title }}'
slug: '{{ .File.ContentBaseName }}'
date: '{{ .Date }}'
author: 'Lev Pasichnyi'
type: 'post'
layout: 'post'
description: >
  {{ replace .File.ContentBaseName "-" " " | humanize }}
summary: >
  ''
canonicalURL: ''
keywords: []
aliases: []
tags: []
categories: [devops, automation, aws, azure]
series: ''
cover:
  image: "{{ .File.ContentBaseName }}.png"
  alt: "Cover image for {{ replace .File.ContentBaseName "-" " " | title }}"
toc: true
---