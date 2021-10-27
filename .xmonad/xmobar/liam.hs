Config {
-- Set font and default foreground/background colors. Note that
-- the height of xmobar is controlled by the font you use.
font = "xft:CozetteVector-9",
bgColor = "#282828",
fgColor = "grey",
--position = BottomW C 80,
position = Static { xpos = 120, ypos = 1053, width = 1690, height = 20},
commands = [
	-- Gather and format CPU usage information.
	-- If it's above 70%, we consider it high usage and make it red.
	Run Cpu [
	"-L", "3",
	"-H", "70",
	"--normal", "#98971a",
	"--high","red"
	]
	100,

	Run Network "enp0s31f6" ["-L","0","-H","32","--normal","green","--high","red"] 10,
	Run Network "wlp58s0" ["-L","0","-H","32","--normal","green","--high","red"] 10,


	-- Gather and format memory usage information
	Run Memory [
	"-t","Mem: <usedratio>%"
	] 100,
	Run DiskU [("/", "hdd <usedbar> (<used>)")] [] 3600,
	-- Date formatting
	--Run Date "%k:%M:%S" "date" 10,
	Run Date "%a %d %b %Y - %H:%M:%S" "date" 10,

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

	Run Com "echo" ["swag"] "note" 0,
	Run Com "volume" [""] "vol" 10,
	Run Com "date" [""] "time" 10,
	Run Com "uname" ["-r"] "kernal" 0,
	--Brightness
	Run Com "brightnessctl" ["-d", "intel_backlight", "g"]  "mybright" 60,
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
template = " | %StdinReader% }{ %enp0s31f6%%wlp58s0% | <fc=#d79921>%battery%</fc> | %cpu% | %memory% | Vol: %vol% | <fc=#458588>%disku%</fc> | Lum: %mybright% | <fc=#e6744c>%date%</fc> | %kernal% | %note% | "
}

