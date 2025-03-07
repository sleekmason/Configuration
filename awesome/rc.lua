-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")
-- widgets
local battery = require("obvious.battery")
local vicious = require("vicious")
local logout_menu_widget = require("awewidgets.logout-menu-widget.logout-menu")
local apt_widget = require("awewidgets.apt-widget.apt-widget")
local brightness_widget = require("awewidgets.brightness-widget.brightness")
local lilidog_widget = require("awewidgets.lilidog-widget.lilidog")

-- Load Debian menu entries
local debian = require("debian.menu")
local has_fdo, freedesktop = pcall(require, "freedesktop")

-- call to enable autostart file --
--local gfs = require "gears".filesystem.get_configuration_dir()
awful.spawn.with_shell("~/.config/awesome/autostart.sh")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}
-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- change between default, gtk, sky, xresources, skinburn
--beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
beautiful.init(awful.util.getdir("config") .. "/themes/default/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "x-terminal-emulator"
editor = "geany"
editor_cmd = editor
-- editor = os.getenv("EDITOR") or "editor"
-- editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "toggles", "bash -c ~/.config/awesome/scripts/awesome-toggles" },
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

local menu_awesome = { "awesome", myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { "open terminal", terminal }

if has_fdo then
    mymainmenu = freedesktop.menu.build({
        before = { menu_awesome },
        after =  { menu_terminal }
    })
else
    mymainmenu = awful.menu({
        items = {
                  menu_awesome,
                  { "Debian", debian.menu.Debian_menu.Debian },
                  menu_terminal,
                }
    })
end


mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )
local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))
local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
	-- Change size of layoutbox through margins
	s.mylayoutbox = wibox.container.margin(s.mylayoutbox, 3, 3, 3, 3)
	
    -- Create a taglist widget (ORIGINAL)
--    s.mytaglist = awful.widget.taglist {
--        screen  = s,
--        filter  = awful.widget.taglist.filter.all,
--        buttons = taglist_buttons
--    }

s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    style   = {
        shape = function(cr, w, h)
    -- Change the number below to adjust the rounded corners
			gears.shape.rounded_rect(cr, w, h, 10)
    end
    },
    buttons = taglist_buttons
}

    -- Create a tasklist widget (ORIGINAL)
--    s.mytasklist = awful.widget.tasklist {
--        screen  = s,
--        filter  = awful.widget.tasklist.filter.currenttags,
--        buttons = tasklist_buttons
--    }

s.mytasklist = awful.widget.tasklist {
    screen   = s,
    filter   = awful.widget.tasklist.filter.currenttags,
    buttons  = tasklist_buttons,
    style    = {
        border_width = 1,
        border_color = "#777777",
        shape        = gears.shape.rounded_bar,
    },
    layout   = {
        spacing = 10,
        spacing_widget = {
-- Separator for tasklist--        
--            {
--                forced_width = 5,
--                shape        = gears.shape.circle,
--                widget       = wibox.widget.separator
--            },
            valign = "center",
            halign = "center",
            widget = wibox.container.place,
        },
        layout  = wibox.layout.flex.horizontal
    },
    -- Notice that there is *NO* wibox.wibox prefix, it is a template,
    -- not a widget instance.
    widget_template = {
        {
            {
                {
                    {
                        id     = "icon_role",
                        widget = wibox.widget.imagebox,
                    },
                    margins = 4,
                    widget  = wibox.container.margin,
                },
                {
                    id     = "text_role",
                    widget = wibox.widget.textbox,
                },
                layout = wibox.layout.fixed.horizontal,
            },
            left  = 10,
            right = 10,
            widget = wibox.container.margin
        },
        id     = "background_role",
        widget = wibox.container.background,
    },
}
    
-- Register all the widgets
    -- cpu widget
	cpufreqwidget = wibox.widget.textbox()
	                 
    -- cpu frequency widget
	cpuwidget = wibox.widget.textbox()

    -- mem widget
	memwidget = wibox.widget.textbox()
                                
    -- fs widget
	fswidget = wibox.widget.textbox()

	-- uptime widget
	uptimewidget = wibox.widget.textbox()
                 
     -- bat widget
	batwidget = wibox.widget.textbox()
                                 
     -- os widget
	oswidget = wibox.widget.textbox()
                 
    -- wifi widget
	wifiiwwidget = wibox.widget.textbox()
                                
    -- weather widget
	weatherwidget = wibox.widget.textbox()
	
	     -- date widget USE FOR LOWERCASE
	datewidget = wibox.widget.textbox()

     -- date widget 2  USE FOR UPPERCASE             
    mytextclock = wibox.widget.textbox()
        s.time = gears.timer({ timeout = 1 })
			s.time:connect_signal("timeout", function() mytextclock:set_text(string.upper(string.gsub(os.date(" %a %b %e, %R")," 0", " ")..os.date(" "))) end)
				s.time:start()
				
    -- systemtray
    local systray = wibox.widget.systray()
    systray:set_base_size(16)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            spacing = 4,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
        layout = wibox.layout.fixed.horizontal,
        spacing = 4,
            vicious.register(cpuwidget, vicious.widgets.cpu, "   CPU: $1%  ", 3),
			vicious.register(memwidget, vicious.widgets.mem, "MEM: $1%  ", 3),
			--vicious.register(cpufreqwidget, vicious.widgets.cpufreq, "FREQ: $1  ", 3, "cpu0"),
			vicious.register(fswidget, vicious.widgets.fs, "DISK: ${/ used_gb} / ${/ avail_gb}  ", 13),
			vicious.register(batwidget, vicious.widgets.bat, "BAT: $1 $2% $3  ", 23, "BAT0"),
			vicious.register(uptimewidget, vicious.widgets.uptime, "UPTIME: $1D $2H $3M  ", 61),
			--vicious.register(oswidget, vicious.widgets.os, "KERNEL: $2  ", 61),
			--vicious.register(wifiiwwidget, vicious.widgets.wifiiw, "NET: ${linp}%  ${rate} Mb/s  ", 6, "wlp2s0"),
            --vicious.register(weatherwidget, vicious.widgets.weather, "${tempf}F ${weather}  ", 61, "KFYV"),
            --battery(),
            --mykeyboardlayout,
            --wibox.widget.systray(),
            wibox.container.margin(
				systray,
                -1,1,6,5, '#272C33'
        ),
            mytextclock,
            --vicious.register(datewidget, vicious.widgets.date, " %a %b %e, %R "),
            --apt_widget(),
            lilidog_widget(),
            --brightness_widget(),
            logout_menu_widget{
                font = 'Dejavu 10',
                onlock = function() awful.spawn.with_shell('slock') end
        },
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
-- USER CUSTOM KEYBINDS --
    awful.key({ modkey,           }, "b",      function () awful.spawn("x-www-browser")             end),
    awful.key({ modkey,           }, "f",      function () awful.spawn("thunar")              end),
    awful.key({ modkey,           }, "e",      function () awful.spawn("geany", false)        end),
    awful.key({ modkey,           }, "x",      function () awful.spawn("ld-logout")           end),
    awful.key({ modkey,           }, "p",      function () awful.spawn("pragha")              end),
    awful.key({ modkey,           }, "F1",     function () awful.spawn("jgmenu_run", false)   end),
    awful.key({ modkey,           }, "F3",     function () awful.spawn("rofi -show drun")     end),
    awful.key({ modkey,           }, "v",      function () awful.spawn("feh-set-wallpaper")   end),
    awful.key({ modkey,           }, "z",      function () awful.spawn("toggle.ld", false)    end),
    awful.key({                   }, "Print",  function () awful.spawn("xfce4-screenshooter") end),
	awful.key({ modkey, "Shift"   }, "b",      function() awful.screen.focused().mywibox.visible = not awful.screen.focused().mywibox.visible end),
--Volume and Brightness keys--
    awful.key({                   }, "XF86AudioRaiseVolume",  function () awful.spawn("pamixer -i 5", false) end),
    awful.key({                   }, "XF86AudioLowerVolume",  function () awful.spawn("pamixer -d 5", false) end),
    awful.key({                   }, "XF86AudioMute",         function () awful.spawn("pamixer -t", false)   end),
    awful.key({                   }, "XF86MonBrightnessUp",   function () awful.spawn("brightnessctl set +10%", false) end),
    awful.key({                   }, "XF86MonBrightnessDown", function () awful.spawn("brightnessctl set 10%-", false) end),
-- If installed - use awesome-conky-installer in a terminal to install conky for awesome --
	awful.key({ modkey,           }, "c",      function () awful.spawn("bash -c ~/.config/awesome/conky-awesome/scripts/conky-chooser", false)          end),
-- Activate toggles menu
    awful.key({ modkey,           }, "F6",     function () awful.spawn("bash -c ~/.config/awesome/scripts/awesome-toggles")     end),
-- USER CUSTOM KEYBINDS END --

    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    -- select next/previous screen          
    awful.key({ "Control",           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ "Control",           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
              
    --show main menu
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),
                      
    -- Focus next/previous
    awful.key({ modkey,           }, "j", function () awful.client.focus.byidx( 1)        end,
              {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k", function () awful.client.focus.byidx(-1)        end,
        {description = "focus previous by index", group = "client"}
    ),
        awful.key({ modkey,           }, "Left", function () awful.client.focus.byidx( 1) end,
              {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "Right", function () awful.client.focus.byidx(-1)    end,
        {description = "focus previous by index", group = "client"}
    ),
    
    -- Move focused
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)        end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)        end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "Left", function () awful.client.swap.byidx(  1)     end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "Right", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
              
    -- screen focus                  
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1)     end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1)     end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),
              
	-- Resize
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.01)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.01)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Control" }, "Right",     function () awful.tag.incmwfact( 0.01)      end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey, "Control" }, "Left",     function () awful.tag.incmwfact(-0.01)       end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Control" }, "Up",     function () awful.client.incwfact( 0.02)       end,
              {description = "increase master height factor", group = "layout"}),
    awful.key({ modkey, "Control" }, "Down",     function () awful.client.incwfact(-0.02)     end,
              {description = "decrease master height factor", group = "layout"}),
                                 
	-- Change placement - general
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
              
    -- Columns
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey, "Shift"   }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "F5", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey, "Shift"   }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     size_hints_honor = false,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },
    
       -- Set conky as dock.
    { rule = { class = "Conky" },
       properties = { border_width = 0, skip_taskbar = true } },
       
    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "live-usb-maker-gui-antix",
          "Gpick",
          "Yad",
          "Gammy",
          "Pragha",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "brightness_003",
          "feh",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- SET rules for windows opening on specific tags
    -- Set Firefox to always map on the tag named "9" on screen 1.
--     { rule = { class = "Firefox" },
--       properties = { screen = 1, tag = "9" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

awful.titlebar(c, { size = 24, position = "top" }) : setup {
        { -- Left
		  {
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout   = wibox.layout.fixed.horizontal
        },
            top = 0,
            bottom = 0,
            left = 0,
            right = 0,
            widget = wibox.container.margin,
        },  
        { -- Middle
        { -- Rotate title text
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c),
                font = "Jetbrains mono 9.5"
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
                   widget = wibox.container.rotate,
           direction   = "north",
        },
     { -- Right
		{
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout   = wibox.layout.fixed.horizontal
        },
            top = 0,
            bottom = 0,
            left = 0,
            right = 0,
            widget = wibox.container.margin,
        },    
        layout   = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
client.connect_signal("manage", function(c)
    c.shape = function(cr, w, h)
    -- Change the number below from 0 in order to have rounded corners
        gears.shape.rounded_rect(cr, w, h, 10)
    end
end)
-- }}}
