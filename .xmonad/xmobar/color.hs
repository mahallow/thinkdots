Config { font = "xft:CozetteVector:pixelsize=12:antialias=true:hinting=true"
       , additionalFonts = [ "xft:FontAwesome:pixelsize=13" ]
       , bgColor = "#323232"
       , fgColor = "#B45BCF"
       , position = Top
       , lowerOnStart = True
       , hideOnStart = False
       , allDesktops = True
       , persistent = True
       , iconRoot = "/home/mindaugas/.xmonad/xpm/"  -- default: "."
       , commands = [ 
	  Run Date "%a, %b %d %Y, %H:%M:%S" "date" 10
        , Run Network "wlp58s0" ["-t", "<icon=net_up_20.xpm/>up <rxbar> <icon=net_down_20.xpm/>dn <txbar>"] 10
	, Run Com "uname" ["-r"] "" 3600
        , Run Cpu ["-t", "<icon=cpu_20.xpm/> cpu <bar> (<total>%)","-H","50","--high","red"] 10
        , Run Memory ["-t", "<icon=memory-icon_20.xpm/> mem <usedbar> (<usedratio>%)"] 10
        , Run DiskU [("/", "<icon=harddisk-icon_20.xpm/> hdd <usedbar> (<used>)")] [] 3600
       	, Run Com "volume" [""] "vol" 10
	, Run Battery [
	"-t", "<acstatus>: <left>% - <timeleft>",
	"--",
	--"-c", "charge_full",
	"-O", "AC",
	"-o", "Bat",
	"-h", "green",
	"-l", "red"
	] 100
	, Run Com "brightnessctl" ["-d", "intel_backlight", "g"]  "mybright" 60




		    , Run UnsafeStdinReader
                    ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = " <icon=haskell_20.xpm/> <fc=#c3e88d>swag</fc> <fc=#666666>|</fc> %UnsafeStdinReader% }{ | Vol: %vol% | <fc=#FFB86C>%cpu%</fc> | <fc=#FF5555>%memory%</fc> | <fc=#82AAFF>%disku%</fc> | <fc=#c3e88d>%wlp58s0%</fc> | <fc=#c5a900>%battery%</fc> | <fc=#e5e5e5>Lum: %mybright%</fc> |  <fc=#8BE9FD>%date%</fc> | <fc=#82AAFF>%uname%</fc> "
       }
