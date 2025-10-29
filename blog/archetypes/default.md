---
title: '{{ replace .File.ContentBaseName "-" " " | title }}'
slug: '{{ .File.ContentBaseName }}'
date: '{{ .Date }}'
type: 'default'
description: >
  {{ replace .File.ContentBaseName "-" " " | humanize }}
summary: >
  ''
author: 'Lev Pasichnyi'
layout: 'single'
draft: true
toc: false
---
