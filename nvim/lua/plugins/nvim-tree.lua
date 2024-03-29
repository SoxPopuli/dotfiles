return {
  'nvim-tree/nvim-tree.lua',
  enabled = false,

  cmd = {
    'NvimTreeOpen',
    'NvimTreeClose',
    'NvimTreeFocus',
    'NvimTreeResize',
    'NvimTreeToggle',
    'NvimTreeRefresh',
    'NvimTreeCollapse',
    'NvimTreeFindFile',
    'NvimTreeClipboard',
    'NvimTreeFindFileToggle',
    'NvimTreeCollapseKeepBuffers',
  },

  keys = {
    {
      '<leader>z',
      function()
        local api = require('nvim-tree.api')
        --Open tree if not focused, close if focused
        if vim.bo.filetype == 'NvimTree' then
          api.tree.close()
        else
          api.tree.open()
        end
      end,
      desc = 'Toggle Tree View',
    },
    {
      '<leader>x',
      function()
        require('nvim-tree.api').tree.close()
      end,
      desc = 'Close Tree View',
    },
  },

  opts = {
    sort_by = 'case_sensitive',
    disable_netrw = false,
    hijack_netrw = true,
    hijack_unnamed_buffer_when_opening = true,
    hijack_directories = {
      enable = true,
      auto_open = false,
    },
    diagnostics = {
      enable = true,
    },
    renderer = {
      group_empty = true,
      icons = {
        webdev_colors = true,
        git_placement = 'before',
        modified_placement = 'after',
        padding = ' ',
        symlink_arrow = ' ➛ ',
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
          modified = true,
        },
        glyphs = {
          default = '',
          symlink = '',
          bookmark = '󰆤',
          modified = '●',
          folder = {
            arrow_closed = '',
            arrow_open = '',
            default = '',
            open = '',
            empty = '',
            empty_open = '',
            symlink = '',
            symlink_open = '',
          },
          git = {
            unstaged = '✗',
            staged = '✓',
            unmerged = '',
            renamed = '➜',
            untracked = '★',
            deleted = '',
            ignored = '◌',
          },
        },
        --glyphs = {
        --    default = "◆",
        --    symlink = "◇",
        --    bookmark = "▣",
        --    modified = "●",
        --    folder = {
        --        arrow_closed = " ",
        --        arrow_open = " ",
        --        default = "▶",
        --        open = "▼",
        --        empty = "▷",
        --        empty_open = "▽",
        --        symlink = "▶",
        --        symlink_open = "▼",
        --    },
        --    git = {
        --        unstaged = "✗",
        --        staged = "✓",
        --        unmerged = "",
        --        renamed = "➜",
        --        untracked = "★",
        --        deleted = "␣",
        --        ignored = "◌",
        --    },
        --},
      },
    },
  },
}
