---
author: Mansoor A
date: "2021-06-09T06:02:14Z"
description: ""
draft: false
summary: 'How to disable mouse acceleration in MacOS '
title: Disabling Mouse Acceleration in MacOS
url: disabling-mouse-acceleration-in-mac
---


Open a terminal and run

```
defaults write -g com.apple.mouse.scaling -integer -1
```

Now, logout and log back in - this is very important. The changes do not take effect until you have done that.

Tested this on MacOS Big Sur

