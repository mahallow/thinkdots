{ config, pkgs, ... }:

{
programs.home-manager.enable = true;
programs.bat.enable = true;
programs.neovim = {
	enable = true;
        vimAlias = true;
        extraConfig = ''
            set t_Co=256
            set paste
            set number relativenumber
            colorscheme gruvbox 
            set ignorecase
            set smartcase
            set mouse=a
            set noswapfile
            let NERDTreeShowHidden = 1
            map<F7> :NERDTree <CR>
          '';

	plugins = with pkgs.vimPlugins; [
	vim-nix
	vim-pandoc
        multiple-cursors
        oceanic-next
        gruvbox
        molokai
	vim-airline
	vim-surround
	nerdtree
	];
  };

home.sessionVariables = {
	EDITOR = "vim";
  };

home.packages = with pkgs; [
   #system 
	pulsemixer
	sutils
        dmenu
	qemu
	virt-manager
   #Browsers
	brave
	qutebrowser
	nyxt
   #TUI Utils
	youtube-dl
	fontpreview
        newsboat
	cmus
	texlive.combined.scheme-full
	i3lock-fancy-rapid
	mpv-with-scripts
	sc-im
	pandoc
   #Other
	obs-studio
  ];

}
