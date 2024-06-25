local conf = require("telescope.config").values

local Config = require("ogpt.config")

local TelescopePicker = {}

function TelescopePicker:new(prompt_title, results_title)
  self.sorting_strategy = "ascending"
  self.layout_config = {
    height = 0.5,
  }
  self.results_title = results_title or ""
  self.prompt_prefix = Config.options.input_window.prompt
  self.selection_caret = Config.options.chat.answer_sign .. " "
  self.prompt_title = prompt_title
  self.sorter = conf.generic_sorter()

  return self
end

return TelescopePicker
