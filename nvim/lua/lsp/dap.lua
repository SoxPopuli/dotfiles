local M = {}
local has_dap, dap = pcall(require, 'dap')
local has_misc, misc = pcall(require, 'misc')
local has_dapui, dapui = pcall(require, 'dapui')

function M.bind_keys()
  if not (has_dap and has_misc and has_dapui) then
    return
  end
  dapui.setup()

  --  F5 => Continue
  --  F8 => Stop
  --  F9 => Restart
  -- F10 => Step Over
  -- F11 => Step Into
  -- F12 => Step Out

  local function dap_hover()
    require('dap.ui.widgets').hover()

    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', '<Cmd>:q<CR>', { desc = 'Close' })
  end

  vim.keymap.set('n', '<leader>do', function()
    dapui.open()
  end, { desc = 'Open dap ui' })
  vim.keymap.set('n', '<leader>dc', function()
    dapui.close()
  end, { desc = 'Close dap ui' })
  vim.keymap.set('n', '<leader>dt', function()
    dapui.toggle()
  end, { desc = 'Toggle dap ui' })

  vim.keymap.set('n', '<F5>', function()
    dap.continue()
  end, { desc = 'Continue debug' })
  vim.keymap.set('n', '<F8>', function()
    dap.close()
  end, { desc = 'Stop debugging' })
  vim.keymap.set('n', '<F9>', function()
    dap.restart()
  end, { desc = 'Restart debug' })
  vim.keymap.set('n', '<F10>', function()
    dap.step_over()
  end, { desc = 'Step over' })
  vim.keymap.set('n', '<F11>', function()
    dap.step_into()
  end, { desc = 'Step into' })
  vim.keymap.set('n', '<F12>', function()
    dap.step_out()
  end, { desc = 'Step out' })
  vim.keymap.set('n', '<leader>b', function()
    dap.toggle_breakpoint()
  end, { desc = 'Toggle breakpoint' })
  vim.keymap.set('n', '<leader>B', function()
    dap.set_breakpoint()
  end, { desc = 'Set breakpoint' })
  --vim.keymap.set('n', '<leader>lp', function()
  --  dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
  --end, { desc = 'Set logpoint' })
  vim.keymap.set('n', '<leader>cb', function()
    dap.clear_breakpoints()
  end, { desc = 'Clear breakpoints' })
  vim.keymap.set('n', '<leader>dr', function()
    dap.repl.open()
  end, { desc = 'Open dap repl' })
  vim.keymap.set('n', '<leader>dl', function()
    dap.run_last()
  end, { desc = 'Run last debug' })
  vim.keymap.set({ 'n', 'v' }, '<space>k', function()
    dap_hover()
  end, { desc = 'dap hover' })
  vim.keymap.set({ 'n', 'v' }, '<leader>dh', function()
    require('dap.ui.widgets').hover()
  end, { desc = 'dap hover' })
  vim.keymap.set({ 'n', 'v' }, '<leader>dp', function()
    require('dap.ui.widgets').preview()
  end, { desc = 'dap preview' })
  vim.keymap.set('n', '<leader>df', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.frames)
  end, { desc = 'Show debug frames' })
  vim.keymap.set('n', '<leader>ds', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.scopes)
  end, { desc = 'Show debug scopes' })
end

function M.config()
  local data_path = vim.fn.stdpath('data')
  local mason_bin = misc.build_path({
    data_path,
    'mason',
    'bin',
  })

  local lldb = {
    type = 'server',
    port = '${port}',
    executable = {
      command = misc.build_path({ mason_bin, 'codelldb' }),
      args = { '--port', '${port}' },
    },
  }

  dap.adapters = {
    coreclr = {
      type = 'executable',
      command = 'netcoredbg',
      args = { '--interpreter=vscode' },
    },

    lldb = lldb,
    codelldb = lldb,

    ocaml = {
      type = 'executable',
      command = './_opam/bin/ocamlearlybird',
      args = { 'debug' },
      cwd = '${workspaceFolder}',
    },
  }

  dap.configurations.scala = {
    {
      type = 'scala',
      request = 'launch',
      name = 'RunOrTest',
      metals = {
        runType = 'runOrTestFile',
        --args = { "firstArg", "secondArg", "thirdArg" }, -- here just as an example
      },
    },
    {
      type = 'scala',
      request = 'launch',
      name = 'Test Target',
      metals = {
        runType = 'testTarget',
      },
    },
  }
end

vim.api.nvim_create_user_command('DapLoadLaunchJSON', function(args)
  local mappings = {
    lldb = { 'c', 'cpp', 'rust' },
    codelldb = { 'c', 'cpp', 'rust' },
    coreclr = { 'cs', 'fsharp', 'vb' },
    ['pwa-node'] = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    ocaml = { 'ocaml', 'reason' },
  }

  local path = (function()
    if args.args:len() == 0 then
      return nil
    else
      return args.args
    end
  end)()

  require('dap.ext.vscode').load_launchjs(path, mappings)
end, { force = true, desc = 'Load debug config from .vscode/launch.json', nargs = '?' })

return M
