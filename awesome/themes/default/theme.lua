---------------------------
-- Default awesome theme --
---------------------------

-- See: 
-- https://awesomewm.org/doc/api/documentation/06-appearance.md.html
-- For settings and more info on appearance in awesome.

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local theme = {}

--------------
-- Directory usedfor titlebar icons.
local icondir = os.getenv("HOME") .. "/.config/awesome/themes/default/titlebar/"

-- Folder to use from "/default/titlebar". Choose your selection.
-- current possibilities are "default", "lilidog", "lilidog2", and "clone".

icondir = icondir .. "default/"

--icondir = icondir .. "default/"
--icondir = icondir .. "lilidog/"
--icondir = icondir .. "lilidog2/"
--icondir = icondir .. "papirus/"
--icondir = icondir .. "clone/"
-------------

-- Define the image to load
theme.titlebar_close_button_normal              = icondir .. "close_normal.png"
theme.titlebar_close_button_focus               = icondir .. "close_focus.png"

theme.titlebar_minimize_button_normal           = icondir .. "minimize_normal.png"
theme.titlebar_minimize_button_focus            = icondir .. "minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive     = icondir .. "ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = icondir .. "ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = icondir .. "ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = icondir .. "ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive    = icondir .. "sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = icondir .. "sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = icondir .. "sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = icondir .. "sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive  = icondir .. "floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = icondir .. "floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = icondir .. "floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = icondir .. "floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = icondir .. "maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = icondir .. "maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = icondir .. "maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = icondir .. "maximized_focus_active.png"

-- theme colors
theme.font          = "JetBrains Mono 10"

theme.bg_normal     = "#1A262E"
theme.bg_focus      = "#2A656D"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"

theme.fg_normal     = "#D1DCE0"
theme.fg_focus      = "#E8F2F7"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#FAFAFA"

-- {{{ Theme Borders
-- Look in the tasklist and taglist section for their border settings.

theme.useless_gap   = dpi(3)
theme.border_width  = dpi(1)

theme.border_normal = "#000000"
theme.border_focus  = "#32718F"
theme.border_marked = "#AD504A"

theme.border_color_normal = "#000000"
theme.border_color_active = "#007D99"
theme.border_color_marked = "#AD504A"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_normal = "#1D2A33"
theme.titlebar_fg_normal = "#AFB9BD"
theme.titlebar_bg_focus  = "#2D4552"
theme.titlebar_fg_focus  = "#D8E3E8"

-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua

--theme.widgetbar_fg     = "#E0E0E0"
--theme.fg_widget        = "#E0E0E0"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"

-- }}}
-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]

-- Generate taglist squares:
local taglist_square_size = dpi(6)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
    taglist_square_size, theme.fg_normal
)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
    taglist_square_size, theme.fg_normal
)

-- Notifications--
theme.notification_font         = "Dejavu 11"
theme.notification_opacity      = 0.84
theme.notification_bg           = "#1F2D36"
theme.notification_fg           = "#D1DDE3"
theme.notification_border_width = 1
theme.notification_border_color = "#2A656D"

-- feh is handling the wallpapers through the ~/.config/awesome/autostart file
-- when the below is commented.
-- theme.wallpaper = themes_path.."default/background.png"
-- theme.wallpaper = "/home/wallpaper/*"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

--menu--
theme.menu_font         = "Dejavu 10"
theme.menu_height       = dpi(22)
theme.menu_width        = dpi(165)
theme.menu_fg_focus     = "#F5F5F5"
theme.menu_bg_focus     = "#2A656D"
theme.menu_fg_normal    = "#C2CDD1"
theme.menu_bg_normal    = "#1F2D36"
--theme.menu_border_color = "#7B939E"
--theme.menu_border_width = 1

--menu icons--
theme.awesome_icon = "~/.config/awesome/icons/menu-light.svg"
--theme.menu_submenu_icon = "~/.config/awesome/icons/menu-light-small.svg"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
--theme.icon_theme = Papirus

--wibar--
--theme.wibar_bg           = "#272C33"
theme.wibar_fg           = "#D1DBE0"
--theme.wibar_border_width = 1
--theme.wibar_border_color = "#ffffff"
--theme.wibar_height       = 24
theme.wibar_opacity = .94

--tasklist --
theme.tasklist_fg_normal          = "#C5D1D6"
--theme.tasklist_bg_normal          = "#272C33"
theme.tasklist_fg_focus           = "#FFFFFF"
theme.tasklist_bg_focus           = "#2A656D"
theme.tasklist_fg_urgent          = "#ffffff"
theme.tasklist_bg_urgent          = "#BA3F4E"
--theme.tasklist_disable_task_name  = "true"
--theme.tasklist_plain_task_name    = "true"
theme.tasklist_font               = "Dejavu 9.5"
--theme.tasklist_font               = "JetBrains Mono 9"
--theme.tasklist_font_focus         = "JetBrains Mono 9"
--theme.tasklist_font_minimized     = "JetBrains Mono 9"
--theme.tasklist_font_urgent        = "JetBrains Mono 9"
--theme.tasklist_align              = "right"
--theme.tasklist_disable_icon       = "true"
--theme.tasklist_spacing            = 20
--tasklist border--
--theme.tasklist_shape_border_width_focus = 1
--theme.tasklist_shape_border_color_focus = "#1B1F24"

--taglist --
--theme.taglist_bg        = "#272C33"
--theme.taglist_fg        = "#ffffff"
theme.taglist_fg_focus  = "#F5F5F5"
theme.taglist_bg_focus  = "#2A656D"
theme.taglist_fg_urgent = "#ffffff"
theme.taglist_bg_urgent = "#BA3F4E"
theme.taglist_shape_border_color_urgent = 1
theme.taglist_shape_border_color_urgent = "#0D0F12"
--theme.taglist_font      = "JetBrains Mono 9"
theme.taglist_spacing   = 5

-- systray
theme.bg_systray           = theme.bg_normal
--theme.systray_icon_spacing = 4
theme.systray_icon_spacing = dpi(12)

-- Generate Awesome icon:
--theme.awesome_icon = theme_assets.awesome_icon(
--    theme.menu_height, theme.bg_focus, theme.fg_focus
--)

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
