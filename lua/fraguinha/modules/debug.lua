M = {}

function M.Debug()
  local dap = require("dap")

  local remote_config = function(filetype)
    local host_name = vim.fn.input("Debug hostname [default: 127.0.0.1]: ")
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

  local filetype = vim.bo.filetype
  local mode = vim.fn.input("Debug mode [remote|executable]: ")

  local config = {}
  if mode == "" or string.find("remote", mode) then
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

return M
