---
title: "Ffmpeg Useful Commands"
description: ""
lead: ""
url: blog/ffmpeg-cheatsheet
date: 2022-08-19T10:45:01-04:00
lastmod: 2022-08-19T10:45:01-04:00
draft: false
weight: 50
images: ["ffmpeg-useful-commands.jpg"]
contributors: []
---

## What is it?

This is basically a quick reference for myself, but I thought it could be useful to someone searching
certain ffmpeg commands as well. Feel free to improve

## Converting a directory full of webm to mp4

```bash
for i in *.webm;do ffmpeg -fflags +genpts -i "$i" -r 60 "${i%.*}.mp4" ;done
```

replace `-r 60` with appropriate frames per second

