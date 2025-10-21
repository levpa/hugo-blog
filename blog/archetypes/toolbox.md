---
title: '{{ replace .File.ContentBaseName "-" " " | title }}'
date: '{{ .Date }}'
draft: true
type: 'toolbox'
tags: ['makefile', 'git', 'workflow']
categories: ['automation']
summary: 'Reusable tool: {{ replace .File.ContentBaseName "-" " " | humanize }}'
description: '{{ replace .File.ContentBaseName "-" " " | humanize }}'
slug: '{{ .File.ContentBaseName }}'
layout: 'toolbox'
toc: false
aliases: []
---