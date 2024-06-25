local curl = require("plenary.curl")
local TelescopePicker = require("ogpt.common.telescope_picker")

local M = {}

function M.select_model(provider, opts)
  opts = opts or {}

  local title = "Models"

  local res = curl.get(provider:models_url(), {
    accept = "application/json",
  })

  if res.status == 200 and res.body then
    local models = vim.tbl_map(function(model)
      return model.name
    end, vim.fn.json_decode(res.body).models)

    vim.ui.select(models, {
      prompt = title,
      telescope = TelescopePicker:new(title, "Select Ollama Model"),
    }, function(item)
      opts.cb(item, item)
    end)
  else
    vim.notify("An Error Occurred, cannot fetch list of models ...", vim.log.levels.ERROR)
  end
end

return M
