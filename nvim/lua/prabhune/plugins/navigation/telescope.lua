return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = { "nvim-lua/plenary.nvim" },
	module = "telescope",
	winblend = 0,

	config = function()
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")

		-- custom function to delete files from the system
		local delete_file_from_system = function(prompt_bufnr)
			local current_picker = action_state.get_current_picker(prompt_bufnr)
			local selections = current_picker:get_multi_selection()

			if vim.tbl_isempty(selections) then
				table.insert(selections, action_state.get_selected_entry())
			end

			local files_to_delete = {}
			for _, selection in ipairs(selections) do
				-- use the correct entry property depending on the picker
				local path = selection.path or selection.value or selection[1]
				if path then
					table.insert(files_to_delete, path)
				end
			end

			if vim.tbl_isempty(files_to_delete) then
				return
			end

			local confirm = vim.fn.input("Delete " .. #files_to_delete .. " file(s) from system? (y/n): ")
			if confirm:lower() == "y" then
				for _, filepath in ipairs(files_to_delete) do
					os.remove(filepath)
					print("\nDeleted: " .. filepath)
				end
				actions.close(prompt_bufnr)
			else
				print("\nDeletion cancelled.")
			end
		end

		require("telescope").setup({
			defaults = {
				mappings = {
					i = {
						-- map file deletion shortcut globally for file searchers
						["<C-x>"] = delete_file_from_system,
					},
					n = {
						["<C-x>"] = delete_file_from_system,
					},
				},
			},
			-- ISOLATE BUFFER DELETION HERE SO IT DOES NOT CRASH FILE SEARCHES
			pickers = {
				buffers = {
					mappings = {
						i = {
							["<C-d>"] = actions.delete_buffer,
						},
						n = {
							["<C-d>"] = actions.delete_buffer,
						},
					},
				},
			},
		})

		local builtin = require("telescope.builtin")

		vim.keymap.set("n", "<leader>ff", ":Telescope find_files hidden=true <CR>", { desc = "File search" })
		vim.keymap.set("n", "<space>fb", ":Telescope file_browser<CR>", { desc = "File browser" })
		vim.keymap.set("n", "<leader>ft", ":Telescope live_grep hidden=true <CR>", { desc = "Word search" })
		vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Git search" })
		vim.keymap.set("n", "<leader>ww", builtin.current_buffer_fuzzy_find, { desc = "Word search in current buffer" })
		vim.keymap.set("n", "<leader>bb", ":Telescope buffers <CR>", { desc = "See buffers" })
		vim.keymap.set("n", "<leader>ps", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end, { desc = "Project search" })

		-- search for either a word under cursor or entire phrase under cursor
		vim.keymap.set("n", "<leader>fw", function()
			local word = vim.fn.expand("<cword>")
			builtin.grep_string({ search = word })
		end, { desc = "Word search (under cursor)" })
		vim.keymap.set("n", "<leader>fW", function()
			local word = vim.fn.expand("<cWORD>")
			builtin.grep_string({ search = word })
		end, { desc = "Phrase search (under cursor)" })
	end,
}
