-- main module file
local module = require("ogpt.module")
local config = require("ogpt.config")
local signs = require("ogpt.signs")
local TelescopePicker = require("ogpt.common.telescope_picker")

local M = {}

M.setup = function(options)
  -- set custom highlights
  vim.api.nvim_set_hl(0, "OGPTQuestion", { fg = "#b4befe", italic = true, bold = false, default = true })

  vim.api.nvim_set_hl(0, "OGPTWelcome", { fg = "#9399b2", italic = true, bold = false, default = true })

  vim.api.nvim_set_hl(0, "OGPTTotalTokens", { fg = "#ffffff", bg = "#444444", default = true })
  vim.api.nvim_set_hl(0, "OGPTTotalTokensBorder", { fg = "#444444", default = true })

  vim.api.nvim_set_hl(0, "OGPTMessageAction", { fg = "#ffffff", bg = "#1d4c61", italic = true, default = true })

  vim.api.nvim_set_hl(0, "OGPTCompletion", { fg = "#9399b2", italic = true, bold = false, default = true })

  vim.cmd("highlight default link OGPTSelectedMessage ColorColumn")

  config.setup(options)
  signs.setup()
end

function M.select_action(opts)
  opts = opts or {}

  local ActionFlow = require("ogpt.flows.actions")
  local action_definitions = ActionFlow.read_actions()
  local title = "Actions"

  vim.ui.select(
    vim.tbl_keys(action_definitions),
    { prompt = title, telescope = TelescopePicker:new(title, "Select Ollama action") },
    function(item)
      opts.cb(item, item)
    end
  )
end

--
-- public methods for the plugin
--

M.openChat = function(opts)
  module.open_chat(opts)
end

M.focusChat = function(opts)
  module.focus_chat(opts)
end

M.selectAwesomePrompt = function()
  module.open_chat_with_awesome_prompt()
end

M.edit_with_instructions = function(opts)
  module.edit_with_instructions(nil, nil, nil, opts)
end

M.run_action = function(opts)
  if opts.args == "" then
    M.select_action({
      cb = function(key, _)
        local _opts = vim.tbl_extend("force", opts, {
          args = key,
          fargs = {
            key,
          },
        })
        module.run_action(_opts)
      end,
    })
  else
    module.run_action(opts)
  end
end

M.complete_code = module.complete_code

return M
