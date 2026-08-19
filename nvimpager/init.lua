vim.opt.termguicolors = true

local function use_terminal_background(group)
	local hl = vim.api.nvim_get_hl(0, {
		name = group,
		link = false,
	})

	hl.bg = nil
	vim.api.nvim_set_hl(0, group, hl)
end

for _, group in ipairs({
	"Normal",
	"NormalNC",
	"EndOfBuffer",
	"SignColumn",
	"FoldColumn",
}) do
	use_terminal_background(group)
end
