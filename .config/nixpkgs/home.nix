{ config, pkgs, ... }:

{
programs.home-manager.enable = true;
programs.bat.enable = true;

home.packages = with pkgs; [
   #system 
	cmus
	pulsemixer
	sutils
	qemu
	virt-manager
   #Browsers
	brave
	qutebrowser
	nyxt
	youtube-dl
	texlive.combined.scheme-full
	i3lock-fancy-rapid
	mpv-with-scripts
	sc-im
	pandoc
  ];

}
