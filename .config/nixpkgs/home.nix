{ config, pkgs, ... }:

{
programs.home-manager.enable = true;
programs.bat.enable = true;

home.packages = with pkgs; [
	cmus
	brave
	pulsemixer
	nyxt
	youtube-dl
	texlive.combined.scheme-full
	sutils
	qutebrowser
	qemu
	virt-manager
	i3lock-fancy-rapid
	mpv-with-scripts
	sc-im
	pandoc
  ];

}
