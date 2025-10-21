---
title: '{{ replace .File.ContentBaseName "-" " " | title }}'
date: '{{ .Date }}'
draft: true
type: 'insight'
tags: ['consulting', 'strategy']
categories: ['career', 'freelance']
summary: 'Strategic insight on {{ replace .File.ContentBaseName "-" " " | humanize }}'
description: '{{ replace .File.ContentBaseName "-" " " | humanize }}'
slug: '{{ .File.ContentBaseName }}'
layout: 'insight'
toc: true
keywords: []
aliases: []
---