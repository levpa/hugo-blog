---
title: '{{ replace .File.ContentBaseName "-" " " | title }}'
date: '{{ .Date }}'
draft: true
type: 'tutorial'
tags: ['how-to', 'automation']
categories: ['cloud', 'devops']
summary: 'Step-by-step guide to {{ replace .File.ContentBaseName "-" " " | humanize }}'
description: '{{ replace .File.ContentBaseName "-" " " | humanize }}'
slug: '{{ .File.ContentBaseName }}'
layout: 'tutorial'
toc: true
series: ''
keywords: []
canonicalURL: ''
cover: ''
aliases: []
---