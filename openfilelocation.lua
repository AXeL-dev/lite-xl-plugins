-- mod-version:2 -- lite-xl 2.0
local core = require "core"
local command = require "core.command"
local config = require "core.config"
local view = require "plugins.treeview"
local menu = view.contextmenu


config.plugins.openfilelocation = {}
if PLATFORM == "Windows" then
  config.plugins.openfilelocation.filemanager = "explorer"
elseif PLATFORM == "Mac OS X" then
  config.plugins.openfilelocation.filemanager = "open"
else
  config.plugins.openfilelocation.filemanager = "xdg-open"
end


-- checks whether the provided path is a file
local function is_file(path)
  local file_info = system.get_file_info(path)
  return file_info.type == "file"
end


-- opens file location
local function open_file_location(filename)
  local folder = filename:match("^(.*)[/\\].*$") or "."
  core.log("Opening \"%s\"", folder)
  if PLATFORM == "Windows" then
    system.exec(string.format("%s %s", config.plugins.openfilelocation.filemanager, folder))
  else
    system.exec(string.format("%s %q", config.plugins.openfilelocation.filemanager, folder))
  end
end


-- adds the command
command.add(nil, {
  ["open-file-location:open-file-location"] = function()
    if view.hovered_item ~= nil and view.hovered_item.abs_filename ~= core.project_dir then
      open_file_location(view.hovered_item.abs_filename)
    else
      local doc = core.active_view.doc
      if not doc.filename then
        core.error "Cannot open location of unsaved doc"
        return
      end
      open_file_location(doc.filename)
    end
  end
})


-- registers the menu
menu:register(
  function()
    return view.hovered_item
      and is_file(view.hovered_item.abs_filename) == true
  end,
  {
    menu.DIVIDER,
    { text = "Open file location", command = "open-file-location:open-file-location" },
  }
)

