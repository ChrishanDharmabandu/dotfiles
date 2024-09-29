return {
	"mfussenegger/nvim-dap",
	dependencies = {"rcarriga/nvim-dap-ui"},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		vim.keymanp.set('n', '<Leader>dt', dap.toggle_breakpoint, {})
		vim.keymanp.set('n', '<Leader>dc', dap.continue, {})
	end,
}
