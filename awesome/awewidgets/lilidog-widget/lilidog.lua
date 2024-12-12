 -------------------------------------------------
-- Lilidog widget - based on the 
-- Logout Menu Widget for Awesome Window Manager by
-- @author Pavel Makhov
-- @copyright 2020 Pavel Makhov
-- More details can be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/logout-menu-widget
-------------------------------------------------

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local HOME = os.getenv('HOME')
local ICON_DIR = HOME .. '/.config/awesome/awewidgets/lilidog-widget/icons/'

local lilidog_widget = wibox.widget {
    {
        {
            image = ICON_DIR .. 'gear.svg',
            resize = true,
            widget = wibox.widget.imagebox,
        },
        margins = 4,
        layout = wibox.container.margin
    },
    shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 6)
    end,
    widget = wibox.container.background,
}

local popup = awful.popup {
    ontop = true,
    visible = false,
    shape = function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, 8)
    end,
    border_width = 1,
    border_color = beautiful.bg_focus,
    maximum_width = 400,
    offset = { y = 26 },
    widget = {}
}

local function worker(user_args)
	local rows = { layout = wibox.layout.fixed.vertical }

	local args = user_args or {}

	local font = args.font or beautiful.font

	local jgmenu = args.jgmenu or function() awful.spawn.with_shell("sleep .2; bash -c jgmenu_run") end
	local toggles = args.toggles or function () awful.spawn.with_shell("bash -c ~/.config/awesome/scripts/awesome-toggles") end
	local screenshot = args.screenshot or function() awful.spawn.with_shell("bash -c xfce4-screenshooter") end
	local conky = args.conky or function() awful.spawn.with_shell("bash -c ~/.config/awesome/conky-awesome/scripts/conky-chooser || x-terminal-emulator -T 'Awesome Conky Installer' -e 'bash -c awesome-conky-installer'") end
	local upgrade = args.upgrade or function() awful.spawn.with_shell("bash -c update-options") end

    local menu_items = {
		{ name = 'Jgmenu', icon_name = 'menu.svg', command = jgmenu },
		{ name = 'Toggles', icon_name = 'options.svg', command = toggles },
		{ name = 'Screenshot', icon_name = 'display.svg', command = screenshot },
		{ name = 'Conky', icon_name = 'star.svg', command = conky },
		{ name = 'Packages', icon_name = 'toolbox.svg', command = upgrade },
    }

    for _, item in ipairs(menu_items) do

        local row = wibox.widget {
            {
                {
                    {
                        image = ICON_DIR .. item.icon_name,
                        resize = false,
                        widget = wibox.widget.imagebox
                    },
                    {
                        text = item.name,
                        font = "Dejavu 9.5",
                        widget = wibox.widget.textbox
                    },
                    spacing = 12,
                    layout = wibox.layout.fixed.horizontal
                },
                margins = 8,
                layout = wibox.container.margin
            },
            bg = beautiful.bg_normal,
            widget = wibox.container.background
        }

        row:connect_signal("mouse::enter", function(c) c:set_bg(beautiful.bg_focus) end)
        row:connect_signal("mouse::leave", function(c) c:set_bg(beautiful.bg_normal) end)

        local old_cursor, old_wibox
        row:connect_signal("mouse::enter", function()
            local wb = mouse.current_wibox
            old_cursor, old_wibox = wb.cursor, wb
            wb.cursor = "hand2"
        end)
        row:connect_signal("mouse::leave", function()
            if old_wibox then
                old_wibox.cursor = old_cursor
                old_wibox = nil
            end
        end)

        row:buttons(awful.util.table.join(awful.button({}, 1, function()
            popup.visible = not popup.visible
            item.command()
        end)))

        table.insert(rows, row)
    end
    popup:setup(rows)

    lilidog_widget:buttons(
            awful.util.table.join(
                    awful.button({}, 1, function()
                        if popup.visible then
                            popup.visible = not popup.visible
                            lilidog_widget:set_bg('#00000000')
                        else
                            popup:move_next_to(mouse.current_widget_geometry)
                            lilidog_widget:set_bg(beautiful.bg_focus)
                        end
                    end)
            )
    )

    return lilidog_widget

end

return worker
