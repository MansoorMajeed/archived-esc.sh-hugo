---
author: Mansoor A
date: "2013-06-15T16:09:13Z"
description: ""
draft: false
title: What to do when your computer running ubuntu freezes?
url: blog/what-to-do-when-your-computer-running-ubuntu-freezes
---


This is what you can do when your Ubuntu freezes

There are different types of freezing, from a single program stops responding, to the entire system lock up. I will try to address them one by one.

### A single program stops responding
This is the most common one. This happens very often. And this can be dealt easily. 

When a single window stops responding, you can simply click the close button in the 
window and chances are it will give you an option to force close it. 

But, sometimes it does not. In that case, press `Alt+F2` and type `xkill` and press enter. 

The mouse pointer will turn into an `X`. Now, if you left click on any window, that window will be killed, no questions asked. If you click the right button, the mouse pointer will get back to its normal form.

If that doesn't work, you can open up a terminal window (by pressing `Ctrl+Alt+T`). 

(If you are not able to open up a terminal window, press `Ctrl+Alt+F1` and login to the tty. You can press `Ctrl+Alt+F7` to go back to GUI) and find the process id of the process that is offending.

For example, if vlc player is the one that is giving me headache, I will issue the following command to find the process id of vlc.

```shell
pgrep vlc
```

Make note of the process id, and kill it with the following command.
```shell
kill -9 <process id>

# Example: kill -9 2343
```

The process should be gone for good.

### But, what to do when even the mouse is not working?

In that case, You need to open a terminal. You could try `Ctrl+Alt+T`, 
if that does not work, type `Alt+F2` and then type in `gnome-terminal` and press enter. 

Sometimes, it won't work either. If that's the case, you need to type `Ctrl+Alt+F1` to get into the tty. 

Once you are in the command line, type in

```shell
sudo service lightdm restart
```
This should bring you back to the login screen.


### When the whole system is locked up, and nothing works?

This does not happen usually, but if it happens, you can do the following to get the system back on.

Press and hold the `Alt` key along with `SysReq (Print Screen)` key. Now, type in the following keys, `R E I S U B` ( give a second or two of interval between each key stroke). If you have a hard time remembering the keys, try this:  

**R**eboot; **E**ven; **I**f; **S**ystem; **U**tterly; **B**roken.

If you need to know what just happened, this is what happened.

> R: Switch to XLATE mode
  
> E: Send Terminate signal to all processes except for init
  
> I: Send Kill signal to all processes except for init
  
> S: Sync all mounted file-systems
  
> U: Remount file-systems as read-only
  
> B: Reboot

None of the above methods were helpful? Well, then you know what to do. That's right, the restart button. If there's none, hold down the power button for a few seconds, and then, you know the drill. Probably, that's what most of us do when things get ugly.

