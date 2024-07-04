vim.g.mapleader = " "
-- options
vim.opt.number = true
vim.opt.clipboard = "unnamed"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

-- colorscheme
{ "morhetz/gruvbox", name = "gruvbox", priority = 1000 },

-- syntax highlight
{ "nvim-treesitter/nvim-treesitter" },

-- lsp
{
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
},

{
    "hrsh7th/nvim-cmp",
    dependencies = { 
      "hrsh7th/cmp-emoji", 
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/vim-vsnip",
      -- "hrsh7th/cmp-cmdline",
    },
    config = function()
      local cmp = require 'cmp'
      cmp.setup {
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        preselect = cmp.PreselectMode.Item,
        sources = {
          { name = 'emoji' },
          { name = 'buffer' },
          { name = 'nvim_lsp' },
          { name = 'path' },
          { name = 'nvim_lua' },
          { name = 'cmdline' },
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ['<C-l>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ["<CR>"] = cmp.mapping.confirm { select = true },
        }),
      }
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          {
            name = 'cmdline',
          }
        })
      })
    end
},

-- telescope
{
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
},

})

-- treesitter
require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"go",
	},
	auto_install = true,
	highlight = {
		enable = true,
	},
})

-- mason
require("mason").setup ({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})
require("mason-lspconfig").setup ({
  ensure_installed = {
    "gopls",
    "terraformls",
    "gradle_ls",
    "jqls",
    "jsonls",
    -- "java_language_server",
    "kotlin_language_server",
    "lua_ls",
    "yamlls",
  },
  automatic_installation = true,
})

-- lsp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("lspconfig").gopls.setup{
  capabilities = capabilities,
  settings = {
    gopls =  {
      buildFlags =  {"-tags=integration,wireinject"}
    }
  }
}

require("lspconfig").terraformls.setup{
  capabilities = capabilities,
}

require("lspconfig").kotlin_language_server.setup{
  capabilities = capabilities,
}

require("lspconfig").jqls.setup{
  capabilities = capabilities,
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- colorscheme
vim.cmd.colorscheme "gruvbox"
