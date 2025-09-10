-- options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.wrap = false
vim.opt.smarttab = true
vim.opt.cindent = false
vim.opt.autoindent = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.winborder = 'none'
vim.opt.swapfile = false
vim.g.showmode = false
vim.g.showcmd = false
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = "yes"
vim.g.have_nerd_font = true
vim.g.ttyfast = true
vim.g.smoothscroll = true
vim.g.mapleader = " "

-- key_binds
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set('i', '<C-h>', '<Left>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-j>', '<Down>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-k>', '<Up>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-l>', '<Right>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-[>', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], { noremap = true, silent = true })
-- key_binds_end

-- plugins
vim.pack.add({
    -- твои старые плагины
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/echasnovski/mini.pick" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/rebelot/kanagawa.nvim" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/uZer/pywal16.nvim" },
    { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/numToStr/Comment.nvim" },
    { src = "https://github.com/romgrk/barbar.nvim" },
    { src = "https://github.com/nvim-tree/nvim-tree.lua" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/akinsho/toggleterm.nvim" },
    { src = "https://github.com/goolord/alpha-nvim" },
    { src = "https://github.com/ron-rs/ron.vim" },
    { src = "https://github.com/mfussenegger/nvim-lint" },
    { src = "https://github.com/folke/which-key.nvim" },
    { src = "https://github.com/norcalli/nvim-colorizer.lua" },
    { src = "https://github.com/elkowar/yuck.vim" },

    -- автодополнение и сниппеты
    { src = "https://github.com/williamboman/mason.nvim" },
    { src = "https://github.com/williamboman/mason-lspconfig.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/hrsh7th/nvim-cmp" },
    { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
    { src = "https://github.com/hrsh7th/cmp-buffer" },
    { src = "https://github.com/hrsh7th/cmp-path" },
    { src = "https://github.com/saadparwaiz1/cmp_luasnip" },
    { src = "https://github.com/L3MON4D3/LuaSnip" },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
})

-- mason + lspconfig
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "clangd", "marksman", "rust_analyzer" },
})

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local servers = { "lua_ls", "clangd", "marksman", "rust_analyzer" }
for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({ capabilities = capabilities })
end

-- luasnip
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

-- nvim-cmp
local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
    },
    mapping = {
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
    }),
    experimental = { ghost_text = true },
})

-- остальные настройки
vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking',
	group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
	callback = function() vim.highlight.on_yank() end,
})

vim.cmd("set completeopt=menuone,noinsert,noselect")

-- nvim-tree mapping
local api = require("nvim-tree.api")
vim.keymap.set("n", "<C-n>", function()
	if api.tree.is_visible() then api.tree.close() else api.tree.open() end
end, { noremap = true, silent = true, desc = "Toggle NvimTree" })

-- Enter в popup
vim.keymap.set("i", "<CR>", function()
	if vim.fn.pumvisible() == 1 then
		return vim.api.nvim_replace_termcodes("<C-y>", true, true, true)
	else
		return vim.api.nvim_replace_termcodes("<CR>", true, true, true)
	end
end, { expr = true })

-- цвета и статус
vim.cmd("colorscheme kanagawa-dragon")
vim.cmd(":hi statusline guibg=NONE")

-- setups
require "lualine".setup()
require "render-markdown".setup()
require "Comment".setup()
require "nvim-treesitter".setup {
	ensure_installed = { "yuck", "ron" },
	highlight = { enable = true },
	indent = { enable = true },
}
require "nvim-tree".setup()
require "nvim-web-devicons".setup()
require("alpha").setup(require("alpha.themes.dashboard").config)
require("toggleterm").setup({
	size = 20, open_mapping = [[<A-h>]], hide_numbers = true,
	shade_terminals = true, shading_factor = 2, start_in_insert = true,
	insert_mappings = true, terminal_mappings = true, persist_size = true,
	direction = "horizontal", close_on_exit = true, shell = vim.o.shell,
	float_opts = { border = "curved", winblend = 0, highlights = { border = "Normal", background = "Normal" } },
})

-- filetypes
vim.filetype.add({ extension = { yuck = "yuck", ron = "ron" } })

-- custom configs
require("configs.lualine-colorscheme")
require("configs.nvim-tree")
