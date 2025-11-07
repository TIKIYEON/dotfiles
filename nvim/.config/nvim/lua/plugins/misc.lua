return {
	-- Autopairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {}, -- this is equalent to setup({}) function
	},
	-- Commenter
	{
		"echasnovski/mini.comment",
		version = false,
		config = function()
			require("mini.comment").setup()
		end,
	},
	-- Colorscheme
	{
		"EdenEast/nightfox.nvim",
		config = function()
			vim.cmd("colorscheme dayfox")
		end,
	},
	-- {
	--     "nyoom-engineering/oxocarbon.nvim",
	--     config = function()
	--         vim.cmd("colorscheme oxocarbon")
	--     end,
	--     -- {
	--     -- 	"EdenEast/nightfox.nvim",
	--     -- 	config = function()
	--     -- 		vim.cmd("colorscheme carbonfox")
	--     -- 	end,
	-- },
	-- {
	--     "miikanissi/modus-themes.nvim",
	--     priority = 1000,
	--     config = function()
	--         vim.cmd([[colorscheme modus_vivendi]])
	--     end,
	-- },
	-- {
	--     "Mofiqul/adwaita.nvim",
	--     lazy = false,
	--     priority = 1000,
	--
	--     -- configure and set on startup
	--     config = function()
	--         vim.g.adwaita_darker = true    -- for darker version
	--         vim.g.adwaita_disable_cursorline = true -- to disable cursorline
	--         vim.g.adwaita_transparent = true -- makes the background transparent
	--         vim.cmd("colorscheme adwaita")
	--     end,
	-- },
}
