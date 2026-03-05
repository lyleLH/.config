return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
	build = "cd app && npm install",
	keys = {
		{ "<leader>md", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
	},
}
