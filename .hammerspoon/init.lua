local prefix = {"cmd", "ctrl"}

hs.hotkey.bind(prefix, "Up", function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.x
	f.y = max.y
	f.w = max.w
	f.h = max.h

	win:setFrame(f)
end)

hs.hotkey.bind(prefix, "Left", function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.x
	f.y = max.y
	f.w = max.w / 2
	f.h = max.h

	win:setFrame(f)
end)

hs.hotkey.bind(prefix, "Right", function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.x + (max.w / 2)
	f.y = max.y
	f.w = max.w / 2
	f.h = max.h

	win:setFrame(f)
end)

hs.hotkey.bind("alt", "tab", function()
	hs.window.switcher.nextWindow()
end)

hs.hotkey.bind({"alt", "shift"}, "tab", function()
	hs.window.switcher.previousWindow()
end)

