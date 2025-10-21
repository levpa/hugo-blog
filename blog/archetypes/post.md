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
cover: ''
canonicalURL: ''
toc: true
keywords: []
series: ''
aliases: []
layout: 'post'
---