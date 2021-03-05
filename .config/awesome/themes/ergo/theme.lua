--[[

     Ergo Awesome WM theme 1.0
     github.com/papungag

--]]

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local os    = { getenv = os.getenv }

local theme                                     = {}
theme.default_dir                               = require("awful.util").get_themes_dir() .. "default"
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/themes/ergo"
theme.wallpaper                                 = os.getenv("HOME") .. "/Pictures/Wallpapers/bariloche.JPG"
theme.font                                      = "Misc Tamsyn Regular 9"
theme.fg_normal                                 = "#DDDDFF"
theme.fg_focus                                  = "#DDDCFF"
theme.fg_urgent                                 = "#DDDDFF"
theme.bg_normal                                 = "#1A1A1A"
theme.bg_focus					= "#313131"
theme.bg_urgent                                 = "#1A1A1A"
theme.border_width                              = 0 
theme.border_normal                             = "#3F3F3F"
theme.border_focus                              = "#7F7F7F"
theme.border_marked                             = "#3F3F3F"
theme.taglist_fg_focus                          = "#197278"
theme.taglist_bg_focus                          = "#1A1A1A"
theme.taglist_squares_sel                       = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"
theme.tasklist_fg_focus                         = "#c44536"
theme.tasklist_bg_focus                         = "#1A1A1A"
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = true
theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"
theme.menu_height                               = 16
theme.menu_width                                = 110
theme.useless_gap                               = 8 
theme.layout_txt_tile                           = "[*]"
theme.layout_txt_tileleft                       = "[#]"
theme.layout_txt_tilebottom                     = "[=]"
theme.layout_txt_tiletop                        = "[f]"
theme.layout_txt_fairv                          = "[v]"
theme.layout_txt_fairh                          = "[fh]"
theme.layout_txt_spiral                         = "[s]"
theme.layout_txt_dwindle                        = "[d]"
theme.layout_txt_max                            = "[m]"
theme.layout_txt_fullscreen                     = "[F]"
theme.layout_txt_magnifier                      = "[M]"
theme.layout_txt_floating                       = "[+]"

awful.util.tagnames   = { "web", "dev", "work", "media", "other" }

-- lain related
theme.layout_txt_cascade                        = "[cascade]"
theme.layout_txt_cascadetile                    = "[cascadetile]"
theme.layout_txt_centerwork                     = "[centerwork]"
theme.layout_txt_termfair                       = "[termfair]"
theme.layout_txt_centerfair                     = "[centerfair]"

local markup = lain.util.markup
local white  = theme.fg_normal
local gray   = theme.taglist_fg_focus

-- Textclock
local mytextclock = wibox.widget.textclock(" %H:%M ")
mytextclock.font = theme.font

-- Calendar
lain.widgets.calendar({
    attach_to = { mytextclock },
    notification_preset = {
        font = theme.font,
        fg   = theme.fg_normal,
        bg   = theme.bg_normal
    }
})

--[[ Mail IMAP check
-- commented because it needs to be set before use
local mail = lain.widgets.imap({
    timeout  = 180,
    server   = "server",
    mail     = "mail",
    password = "keyring get mail",
    settings = function()
        mail_notification_preset.fg = white

        mail  = ""
        count = ""

        if mailcount > 0 then
            mail = "mail "
            count = mailcount .. " "
        end

        widget:set_markup(markup.font(theme.font, markup(gray, mail) .. markup(white, count)))
    end
})
]]

-- fs
theme.fs = lain.widgets.fs({
    options = "--exclude-type=tmpfs",
    --partition = "/home",
    notification_preset = { fg = theme.fg_normal, bg = theme.bg_normal, font = theme.font },
})

-- MPD
theme.mpd = lain.widgets.mpd({
    settings = function()
        mpd_notification_preset.fg = white

        artist = mpd_now.artist .. " "
        title  = mpd_now.title  .. " "

        if mpd_now.state == "pause" then
            artist = "mpd "
            title  = "paused "
        elseif mpd_now.state == "stop" then
            artist = ""
            title  = ""
        end

        widget:set_markup(markup.font(theme.font, markup("#EA6F81", artist) .. markup(white, title)))
    end
})

-- ALSA volume
theme.volume = lain.widgets.alsa({
    settings = function()
        header = " vol "
        vlevel  = volume_now.level

        if volume_now.status == "off" then
            vlevel = vlevel .. "M "
        else
            vlevel = vlevel .. " "
        end

        widget:set_markup(markup.font(theme.font, markup(gray, header) .. vlevel))
    end
})

-- MEM
local mem = lain.widgets.mem({
    settings = function()
        widget:set_markup(markup.font(theme.font, markup(gray, " mem ") .. mem_now.used .. " "))
    end
})

-- CPU
local cpu = lain.widgets.sysload({
    settings = function()
        widget:set_markup(markup.font(theme.font, markup(gray, " cpu ") .. load_1 .. " "))
    end
})

-- Coretemp
local temp = lain.widgets.temp({
    settings = function()
        widget:set_markup(markup.font(theme.font, markup(gray, " temp ") .. coretemp_now .. " "))
    end
})

-- Net
local net = lain.widgets.net({
    settings = function()
        widget:set_markup(markup.font(theme.font, markup(gray, " net ") .. net_now.received)
                          .. " " ..
                          markup.font(theme.font, markup(gray, " " ) .. net_now.sent .. " "))
    end
})

-- Battery
local bat = lain.widgets.bat({
    settings = function()
        bat_perc = bat_now.perc
        if bat_now.ac_status == 1 then bat_perc = "ac" end
        widget:set_markup(markup.font(theme.font, markup(gray, " bat ") .. bat_perc .. " "))
    end
})

-- Weather
theme.weather = lain.widgets.weather({
    city_id = 611717, -- placeholder (London)
    notification_preset = { font = theme.font, fg = white }
})

-- Separators
local spr       = wibox.widget.textbox(' ')
local small_spr = wibox.widget.textbox(markup.font("Tamsyn 4", " "))
local bar_spr   = wibox.widget.textbox(markup.font("Tamsyn 3", " ") .. markup.fontfg(theme.font, "#edddd4", "|") .. markup.font("Tamsyn 5", " "))

local function update_txt_layoutbox(s)
    -- Writes a string representation of the current layout in a textbox widget
    local txt_l = theme["layout_txt_" .. awful.layout.getname(awful.layout.get(s))] or ""
    s.mytxtlayoutbox:set_text(txt_l)
end

function theme.at_screen_connect(s)
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- If wallpaper is a function, call it with the screen
    if type(wallpaper) == "function" then
        theme.wallpaper = theme.wallpaper(s)
    end
    gears.wallpaper.maximized(theme.wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    -- Textual layoutbox
    s.mytxtlayoutbox = wibox.widget.textbox(theme["layout_txt_" .. awful.layout.getname(awful.layout.get(s))])
    awful.tag.attached_connect_signal(s, "property::selected", function () update_txt_layoutbox(s) end)
    awful.tag.attached_connect_signal(s, "property::layout", function () update_txt_layoutbox(s) end)
    s.mytxtlayoutbox:buttons(awful.util.table.join(
                           awful.button({}, 1, function() awful.layout.inc(1) end),
                           awful.button({}, 3, function() awful.layout.inc(-1) end),
                           awful.button({}, 4, function() awful.layout.inc(1) end),
                           awful.button({}, 5, function() awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, awful.util.taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, awful.util.tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 17, bg = theme.bg_normal, fg = theme.fg_normal })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            small_spr,
            s.mytxtlayoutbox,
            bar_spr,
            s.mytaglist,
            spr,
            s.mypromptbox,
            small_spr,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            small_spr,
--            theme.mpd.widget,
            theme.volume.widget,
            bar_spr,
            mem.widget,
            bar_spr,
            cpu.widget,
            bar_spr,
            temp.widget,
            bar_spr,
            net.widget,
            bar_spr,
            mytextclock,
        },
    }
end

return theme
