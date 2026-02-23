local M = {}

local function read_header(relpath)
  local path = vim.fn.stdpath("config") .. "/" .. relpath
  local ok, lines = pcall(vim.fn.readfile, path)
  if ok and type(lines) == "table" and #lines > 0 then
    return lines
  end
  return { "header file not found:", path }
end

local function pad(lines, top, bottom)
  local out = {}
  for _ = 1, (top or 0) do table.insert(out, "") end
  vim.list_extend(out, lines)
  for _ = 1, (bottom or 0) do table.insert(out, "") end
  return out
end

function M.setup()
  local ok, dashboard = pcall(require, "dashboard")
  if not ok then return end

  dashboard.setup({
    theme = "doom",
    config = {
      header = pad(read_header("headers/monkey.txt"), 1, 1),
      center = {
        { desc = "New file", key = "n", action = "enew" },
        { desc = "Quit", key = "q", action = "qa" },
      },
      footer = pad({ "mhh monkey" }, 2, 0),
      vertical_center = true,
    },
  })
end

return M
