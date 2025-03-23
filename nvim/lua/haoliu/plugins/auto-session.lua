return {
	"rmagatti/auto-session",
	config = function()
		local auto_session = require("auto-session")

		auto_session.setup({
			auto_restore_enabled = false,
			auto_session_suppress_dirs = { "~/", "~/dev/", "~/downloads", "~/documents", "~/desktop/" },
		})

		local keymap = vim.keymap

		keymap.set("n", "<leader>wr", "<cmd>sessionrestore<cr>", { desc = "restore session for cwd" }) -- restore last workspace session for current directory
		keymap.set("n", "<leader>ws", "<cmd>sessionsave<cr>", { desc = "save session for auto session root dir" }) -- save workspace session for current working directory
	end,
}
