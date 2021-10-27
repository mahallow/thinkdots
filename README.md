# NixOS Dotfiles

You have just fumbled your config, tried to ```sudo pacman -Rns``` some font you weren't using, and you removed font manager, its time again to begin the Arch inst.... STOP! There is another way! If you're here, you are one for dotfiles. You might not think so, but I can see it in you. What if I told you, you could essentially dotfile your machine, with the continual ability to switch between changes on the fly.  

In steps [NixOS](www.nixos.org) to solve your problems. The "do it yourself" distro for grownups. 

This is some XMonad on some ThinkPad. 

![xmonad](https://raw.githubusercontent.com/mahallow/thinkdots/master/scrots/new.png) 
![update](https://heinicke.xyz/nixos/comf.png)

# Installation & Details

This is where things need to be improved. You can of course still copy or use these configs, though the install process is pretty diy. 

1. ```sudo dd if=/dev/null of=/dev/sda``` your machine
2. Download NixOS and make a bootable USB. Feel free to use the Gnome version or whatever, what is actually installed is based entirely off of what is in ```/etc/nixos/configuration.nix```
3. ```git clone https://github.com/mahallow/thinkdots.git``` in the home directory or wherever on the live instance of Nix you'ure running
4. Go through the NixOS manual on partitioning, formatting, mounting, then creating the default configuration
5. Open up both the default configuration and the one from the git repo
6. Change the name of the drive and wifi and ethernet cards in the configuration from the repo to match that which were auto generated. Also change your username unless you're also a Liam
7. Delete default config, place new one in same folder.
8. ```nixos-install```

At this point you will have a functional install! To get anything to look normal though, once you reboot you will want to clone the repo again and put everything in your ```~/.home``` folder. Logout, back in and bam. 

## General usage

Right now I am working my way through learning how 'home-manager' works and how it can be used in conjunction with the installation process and setup you see here. There are other applications or files that may be added to the repo without much explination and they likely related to this. Once I figure out a clean way to define this in the overall 'configuration.nix' I will make the appropiate changes and explain here. 

There is no browser by default in the config. In the screenshot I am using QuteBrowser, for which there are theme config files in the repo. You can either add that to the ```configuration.nix``` or ```nix-env -iA nixos.qutebrowser``` to make it for just your user. 

Wallpapers are set with Nitrogen, restored in the Xmonad.hs file on startup. I have included only the apps used to get the config working out of the box.  

Also to note, you may try and edit your config and go for the classic ```sudo nixos-rebuid switch``` and find that you cannot. Not to worry, your user should be set to do administrative tasks, just with ```doas```. Command ```sudo``` cannot be found.


There are also a few different XMobar configs included. Feel free to change between them by:
1. ```rm .xmonad/xmobar/xmobarrc```
2. ```ln -s {choose one} xmobarrc```
3. Then recompile/restart XMonad with mod/super + Q

Thats it for now!

---
LH 
