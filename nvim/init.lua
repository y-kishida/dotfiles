vim.g.mapleader = " "
-- options
vim.opt.number = true
vim.opt.clipboard = "unnamed"
vim.opt.statusline = '%f'
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.expandtab = true

--keymap
-- tab
vim.keymap.set("n", "tl", ":<C-u>tabn<CR>")
vim.keymap.set("n", "th", ":<C-u>tabp<CR>")
vim.keymap.set("n", "<C-t>", ":<C-u>tabnew<CR>")

-- window
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "<C-q>", ":q<CR>")

-- neotree
vim.keymap.set("n", "<leader>e", ":Neotree<CR>")

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

-- copilot
{ "github/copilot.vim" },

-- goimports
{ "mattn/vim-goimports" },

-- fTerm
{ "numToStr/FTerm.nvim" },

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

-- gotest

{
  "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "fredrikaverpil/neotest-golang", -- Installation
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-golang"), -- Registration
        },
	status = { virtual_text = true },
        output = { open_on_run = true },
      })
    end,
  keys = {
    --{"<leader>t", "", desc = "+test"},
    { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File" },
    { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files" },
    { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest" },
    { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last" },
    { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary" },
    { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
    { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel" },
    { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop" },
    { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle Watch" },
  },
},

-- neotree
{
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
		config = function()
			require("neo-tree").setup({
				filesystem = {
					follow_current_file = {
						enabled = true,
					},
					filtered_items = {
						visible = true,
						hide_dotfiles = false,
					},
				},
				buffers = {
					follow_current_file = {
						enabled = true,
					},
				},
			})
		end,
},

-- telescope
{
    "nvim-telescope/telescope.nvim",
},

{
  "cohama/lexima.vim",
  event = "InsertEnter",
},

{
  "ntpeters/vim-better-whitespace",
  event = "VimEnter",
},

})

-- treesitter
require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"go", "gomod", "gosum",
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

require'FTerm'.setup({
    border = 'single',
    dimensions  = {
        height = 0.7,
        width = 0.7,
    },
})
vim.keymap.set('n', '<leader>t', '<CMD>lua require("FTerm").toggle()<CR>')
vim.keymap.set('t', '<leader>t', '<CMD>lua require("FTerm").close()<CR>')

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
vim.keymap.set('n', '<leader>lg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})


-- colorscheme
vim.cmd.colorscheme "gruvbox"
