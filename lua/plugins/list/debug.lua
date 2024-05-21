return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"theHamsta/nvim-dap-virtual-text",
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local dap_virtual_text = require("nvim-dap-virtual-text")

		require("mason-nvim-dap").setup({
			automatic_setup = true,
			handlers = {},
			ensure_installed = { "codelldb", "java-debug-adapter", "java-test", "js-debug-adapter" },
		})

		local remote_config = function(filetype)
			local host_name = vim.fn.input("Debug hostname: ")
			local port = vim.fn.input("Debug port: ")

			if host_name == "" then
				host_name = "127.0.0.1"
			end

			local config = {
				name = "Debug (Attach) - Remote " .. port,
				type = filetype,
				request = "attach",
				hostName = host_name,
				port = port,
			}

			return config
		end

		local executable_config = function(filetype)
			local executable = vim.fn.input({ "Debug executable: ", vim.fn.getcwd() .. "/", "file" })

			local config = {
				type = "codelldb",
				request = "launch",
				program = executable,
				cwd = "${workspaceFolder}",
				terminal = "integrated",
				sourceLanguages = { filetype },
			}

			return config
		end

		local debug = function()
			local filetype = vim.bo.filetype
			local mode = vim.fn.input("Debug mode [remote|executable]: ")

			local config = {}
			if string.find("remote", mode) or mode == "" then
				config = remote_config(filetype)
			elseif string.find("executable", mode) then
				config = executable_config(filetype)
			end

			if not dap.configurations[filetype] then
				dap.configurations[filetype] = {}
				table.insert(dap.configurations[filetype], config)
			end

			dap.run(config)
		end

		vim.keymap.set("n", "<F1>", dap.step_into)
		vim.keymap.set("n", "<F2>", dap.step_over)
		vim.keymap.set("n", "<F3>", dap.step_out)
		vim.keymap.set("n", "<F4>", dap.continue)
		vim.keymap.set("n", "<F5>", debug)
		vim.keymap.set("n", "<F8>", dapui.toggle)
		vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
		vim.keymap.set("n", "<leader>B", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end)

		dapui.setup()
		dap_virtual_text.setup({})

		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close
	end,
}
