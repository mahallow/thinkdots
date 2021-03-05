
Config {
-- Set font and default foreground/background colors. Note that
-- the height of xmobar is controlled by the font you use.
font = "xft:CozetteVector-9",
bgColor = "black",
fgColor = "grey",
position = TopW L 100,

-- list of commands which gather information about your system for
-- presentation in the bar.
commands = [
	-- Gather and format CPU usage information.
	-- If it's above 70%, we consider it high usage and make it red.
	Run Cpu [
	"-L", "3",
	"-H", "70",
	"--normal", "green",
	"--high","red"
	]
	100,

	Run Network "enp0s31f6" ["-L","0","-H","32","--normal","green","--high","red"] 10,
	Run Network "wlp58s0" ["-L","0","-H","32","--normal","green","--high","red"] 10,

	--Run Brightness ["-t", ""] 60,

	-- Gather and format memory usage information
	Run Memory [
	"-t","Mem: <usedratio>%"
	] 100,

	-- Date formatting
	--Run Date "%k:%M:%S" "date" 10,
	Run DateZone "%a %d %b %Y - %H:%M:%S" "us_EN.UTF-8" "UTC" "date" 10,

	-- Battery information. This is likely to require some customization
	-- based upon your specific hardware. Or, for a desktop you may want
	-- to just remove this section entirely.
	Run Battery [
	"-t", "<acstatus>: <left>% - <timeleft>",
	"--",
	--"-c", "charge_full",
	"-O", "AC",
	"-o", "Bat",
	"-h", "green",
	"-l", "red"
	] 100,
	-- To get volume information, we run a custom bash script.
	-- This is because the built-in volume support in xmobar is disabled
	-- in Debian and derivatives like Ubuntu.
	--Run Com "~/bin/get-volume.sh" [] "myvolume" 10,
	-- /!\ https://github.com/jaor/xmobar/issues/127
	--Run Com "/bin/bash" ["-c", "~/.xmonad/get-volume.sh"]  "myvolume" 1,
	Run Com "amixer" ["-R | grep 'Front Left: Playback'" ]  "myvolume" 1,


	--Run Com "/bin/bash" ["-c", "echo `xbacklight -get | grep -oE '^.[0-9]{0,3}'`%"]  "mybright" 1,
	Run Com "brightnessctl" ["-d", "intel_backlight", "g"]  "mybright" 600,
	--Run Com "~/bin/get-volume.sh" [] "vol",
	--Run Weather "KNYC" ["-t", "KNYC: <tempC>C/<skyCondition>"] 36000,
	-- This line tells xmobar to read input from stdin. That's how we
	-- get the information that xmonad is sending it for display.
	Run StdinReader
],

-- Separator character used to wrape variables in the xmobar template
sepChar = "%",

-- Alignment separater characer used in the xmobar template. Everything
-- before this will be aligned left, everything after aligned right.
alignSep = "}{",

-- Overall template for the layout of the xmobar contents. Note that
-- space is significant and can be used to add padding.
template = "| %StdinReader% }{ %enp0s31f6%%wlp58s0% | %battery% | %cpu% | %memory% | %myvolume% | Lum: %mybright% | <fc=#e6744c>%date%</fc> | "
}

