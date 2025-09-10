-- options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.cindent = true
vim.opt.winborder = 'none'
vim.opt.swapfile = false
vim.g.showmode = false --not needed due to lualine
vim.g.showcmd = false
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = "yes"
vim.g.have_nerd_font = true
vim.g.ttyfast = true --faster scrolling
vim.g.smoothscroll = true
-- vim.g.title = true
vim.g.mapleader = " " -- ставим leader на пробел
-- options_end

-- key_binds
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format)
vim.keymap.set('i', '<C-h>', '<Left>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-j>', '<Down>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-k>', '<Up>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-l>', '<Right>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-[>', '<Esc>', { noremap = true, silent = true })
-- Нормальный режим
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })
-- Терминальный режим
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], { noremap = true, silent = true })

-- key_binds_end

vim.pack.add({
	{ src = "https://github.com/chomosuke/typst-preview.nvim",             version = "1.1" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter",          version = "main" },
	{ src = "https://github.com/rebelot/kanagawa.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
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
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/Civitasv/cmake-tools.nvim" },
	--{ src = "https://github.com/cdelledonne/vim-cmake" }
})

vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- CMAKE PLUGIN
-- Полная конфигурация cmake-tools
local osys = require("cmake-tools.osys")
require("cmake-tools").setup {
	cmake_command = "cmake",                                    -- this is used to specify cmake command path
	ctest_command = "ctest",                                    -- this is used to specify ctest command path
	cmake_use_preset = true,
	cmake_regenerate_on_save = true,                            -- auto generate when save CMakeLists.txt
	cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" }, -- this will be passed when invoke `CMakeGenerate`
	cmake_build_options = {},                                   -- this will be passed when invoke `CMakeBuild`
	-- support macro expansion:
	--       ${kit}
	--       ${kitGenerator}
	--       ${variant:xx}
	cmake_build_directory = function()
		if osys.iswin32 then
			return "build\\${variant:buildType}"
		end
		return "build/${variant:buildType}"
	end,              -- this is used to specify generate directory for cmake, allows macro expansion, can be a string or a function returning the string, relative to cwd.
	cmake_compile_commands_options = {
		action = "soft_link", -- available options: soft_link, copy, lsp, none
		-- soft_link: this will automatically make a soft link from compile commands file to target
		-- copy:      this will automatically copy compile commands file to target
		-- lsp:       this will automatically set compile commands file location using lsp
		-- none:      this will make this option ignored
		target = vim.loop.cwd()      -- path to directory, this is used only if action == "soft_link" or action == "copy"
	},
	cmake_kits_path = nil,               -- this is used to specify global cmake kits path, see CMakeKits for detailed usage
	cmake_variants_message = {
		short = { show = true },     -- whether to show short message
		long = { show = true, max_length = 40 }, -- whether to show long message
	},
	cmake_dap_configuration = {          -- debug settings for cmake
		name = "cpp",
		type = "codelldb",
		request = "launch",
		stopOnEntry = false,
		runInTerminal = true,
		console = "integratedTerminal",
	},
	cmake_executor = {              -- executor to use
		name = "quickfix",      -- name of the executor
		opts = {},              -- the options the executor will get, possible values depend on the executor type. See `default_opts` for possible values.
		default_opts = {        -- a list of default and possible values for executors
			quickfix = {
				show = "always", -- "always", "only_on_error"
				position = "belowright", -- "vertical", "horizontal", "leftabove", "aboveleft", "rightbelow", "belowright", "topleft", "botright", use `:h vertical` for example to see help on them
				size = 10,
				encoding = "utf-8", -- if encoding is not "utf-8", it will be converted to "utf-8" using `vim.fn.iconv`
				auto_close_when_success = true, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
			},
			toggleterm = {
				direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
				close_on_exit = false, -- whether close the terminal when exit
				auto_scroll = true, -- whether auto scroll to the bottom
				singleton = true, -- single instance, autocloses the opened one, if present
			},
			overseer = {
				new_task_opts = {
					strategy = {
						"toggleterm",
						direction = "horizontal",
						auto_scroll = true,
						quit_on_exit = "success"
					}
				}, -- options to pass into the `overseer.new_task` command
				on_new_task = function(task)
					require("overseer").open(
						{ enter = false, direction = "right" }
					)
				end, -- a function that gets overseer.Task when it is created, before calling `task:start`
			},
			terminal = {
				name = "Main Terminal",
				prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
				split_direction = "horizontal", -- "horizontal", "vertical"
				split_size = 11,

				-- Window handling
				single_terminal_per_instance = true, -- Single viewport, multiple windows
				single_terminal_per_tab = true, -- Single viewport per tab
				keep_terminal_static_location = true, -- Static location of the viewport if avialable
				auto_resize = true, -- Resize the terminal if it already exists

				-- Running Tasks
				start_insert = false, -- If you want to enter terminal with :startinsert upon using :CMakeRun
				focus = false, -- Focus on terminal when cmake task is launched.
				do_not_add_newline = false, -- Do not hit enter on the command inserted when using :CMakeRun, allowing a chance to review or modify the command before hitting enter.
			},          -- terminal executor uses the values in cmake_terminal
		},
	},
	cmake_runner = {         -- runner to use
		name = "terminal", -- name of the runner
		opts = {},       -- the options the runner will get, possible values depend on the runner type. See `default_opts` for possible values.
		default_opts = { -- a list of default and possible values for runners
			quickfix = {
				show = "always", -- "always", "only_on_error"
				position = "belowright", -- "bottom", "top"
				size = 10,
				encoding = "utf-8",
				auto_close_when_success = true, -- typically, you can use it with the "always" option; it will auto-close the quickfix buffer if the execution is successful.
			},
			toggleterm = {
				direction = "float", -- 'vertical' | 'horizontal' | 'tab' | 'float'
				close_on_exit = false, -- whether close the terminal when exit
				auto_scroll = true, -- whether auto scroll to the bottom
				singleton = true, -- single instance, autocloses the opened one, if present
			},
			overseer = {
				new_task_opts = {
					strategy = {
						"toggleterm",
						direction = "horizontal",
						auto_scroll = true, -- исправлена опечатка из "autos_croll"
						quit_on_exit = "success"
					}
				}, -- options to pass into the `overseer.new_task` command
				on_new_task = function(task)
				end, -- a function that gets overseer.Task when it is created, before calling `task:start`
			},
			terminal = {
				name = "Main Terminal",
				prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
				split_direction = "horizontal", -- "horizontal", "vertical"
				split_size = 11,

				-- Window handling
				single_terminal_per_instance = true, -- Single viewport, multiple windows
				single_terminal_per_tab = true, -- Single viewport per tab
				keep_terminal_static_location = true, -- Static location of the viewport if avialable
				auto_resize = true, -- Resize the terminal if it already exists

				-- Running Tasks
				start_insert = false, -- If you want to enter terminal with :startinsert upon using :CMakeRun
				focus = false, -- Focus on terminal when cmake task is launched.
				do_not_add_newline = false, -- Do not hit enter on the command inserted when using :CMakeRun, allowing a chance to review or modify the command before hitting enter.
			},
		},
	},
	cmake_notifications = {
		runner = { enabled = true },
		executor = { enabled = true },
		spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }, -- icons used for progress display
		refresh_rate_ms = 100, -- how often to iterate icons
	},
	cmake_virtual_text_support = true, -- Show the target related to current file using virtual text (at right corner)
	cmake_use_scratch_buffer = false, -- A buffer that shows what cmake-tools has done
}

-- Полезные keybindings
vim.keymap.set('n', '<leader>cg', ':CMakeGenerate<CR>', { desc = 'CMake Generate' })
vim.keymap.set('n', '<leader>cb', ':CMakeBuild<CR>', { desc = 'CMake Build' })
vim.keymap.set('n', '<leader>cr', ':CMakeRun<CR>', { desc = 'CMake Run' })
vim.keymap.set('n', '<leader>cc', ':CMakeClean<CR>', { desc = 'CMake Clean' })
vim.keymap.set('n', '<leader>ct', ':CMakeSelectBuildTarget<CR>', { desc = 'CMake Select Target' })
vim.keymap.set('n', '<leader>cv', ':CMakeSelectBuildType<CR>', { desc = 'CMake Select Build Type' })

-- vim.g.cmake_default_config = ''  -- вообще без конфигурации

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		if client:supports_method('textDocument/completion') then
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})
vim.cmd("set completeopt=menuone,noinsert,noselect")

-- mapping для nvim-tree
local api = require("nvim-tree.api")
-- глобальный mapping для Ctrl+n
vim.keymap.set("n", "<C-n>", function()
	-- если дерево открыто — закрыть, иначе — открыть
	if api.tree.is_visible() then
		api.tree.close()
	else
		api.tree.open()
	end
end, { noremap = true, silent = true, desc = "Toggle NvimTree" })

-- Только Enter выбирает текущий элемент в popup меню
vim.keymap.set("i", "<CR>", function()
	if vim.fn.pumvisible() == 1 then
		return vim.api.nvim_replace_termcodes("<C-y>", true, true, true) -- подтвердить выбор
	else
		return vim.api.nvim_replace_termcodes("<CR>", true, true, true) -- обычный Enter
	end
end, { expr = true })

vim.cmd("colorscheme kanagawa-dragon")
vim.cmd(":hi statusline guibg=NONE") -- делаем статус-лайн прозрачным

vim.lsp.enable({ "lua_ls", "clangd", "marksman", "rust-analyzer", "qmls" })

vim.filetype.add({
	extension = {
		yuck = "yuck",
		ron  = "ron",
		qmk  = "qml",
	},
})

-- setups
require "mason".setup()
require "lualine".setup()
require "render-markdown".setup()
require "Comment".setup()
require "Comment".setup()
require("nvim-tree").setup()
require "nvim-web-devicons".setup()

-- -- В конфиге neovim на хосте
-- require'lspconfig'.clangd.setup{
--   cmd = {"clangd-astra"},  -- wrapper script
--   -- остальные настройки как обычно
-- }
--
local alpha = require("alpha")
alpha.setup(require("alpha.themes.dashboard").config)

require("toggleterm").setup({
	size = 20,         -- Размер терминала
	open_mapping = [[<A-h>]], -- Клавиша для открытия/закрытия терминала
	hide_numbers = true, -- Скрыть номера терминалов
	shade_terminals = true, -- Применить затемнение к терминалам
	shading_factor = 2, -- Степень затемнения
	start_in_insert = true, -- Начинать с режима вставки
	insert_mappings = true, -- Включить мэппинги в режиме вставки
	terminal_mappings = true, -- Включить мэппинги в терминале
	persist_size = true, -- Сохранять размер терминала
	direction = "horizontal", -- Направление терминала: "horizontal", "vertical" или "float"
	close_on_exit = true, -- Закрывать терминал при завершении процесса
	shell = vim.o.shell, -- Использовать оболочку по умолчанию
	float_opts = {
		border = "curved", -- Граница окна
		winblend = 0, -- Прозрачность окна
		highlights = { border = "Normal", background = "Normal" },
	},
})

-- custom configs
require("configs.lualine-colorscheme")
require("configs.nvim-tree")
require("autocmds")
