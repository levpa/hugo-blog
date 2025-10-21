---
title: '{{ replace .File.ContentBaseName "-" " " | title }}'
date: '{{ .Date }}'
draft: true
description: '{{ replace .File.ContentBaseName "-" " " | humanize }}'
slug: '{{ .File.ContentBaseName }}'
tags: []
categories: []
author: 'Lev'
summary: ''
cover:
  image: "/images/{{ .File.ContentBaseName }}-cover.png"
  alt: "Cover image for {{ replace .File.ContentBaseName "-" " " | title }}"
canonicalURL: ''
toc: true
keywords: []
series: ''
aliases: []
layout: 'post'
---