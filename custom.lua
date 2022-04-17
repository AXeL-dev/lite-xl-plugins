-- mod-version:2 -- lite-xl 2.0
local core = require "core"
-- local command = require "core.command"
local keymap = require "core.keymap"
local menu = require "plugins.contextmenu"


-- command.add("core.docview", {
--   ["custom:command"] = function()
--     -- write your command code here
--   end
-- })


keymap.add { ["ctrl+shift+:"] = "doc:toggle-line-comments" }


menu:register("core.docview", {
  { text = "Toggle line comments", command = "doc:toggle-line-comments" },
})

