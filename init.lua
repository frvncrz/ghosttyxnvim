-- 1. Bootstrap lazy.nvim (Plugin Manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- 2. Basic IDE Settings
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Relative numbers (helpful for jumping)
vim.opt.mouse = "a" -- Enable mouse support (clicking/scrolling)
vim.opt.ignorecase = true -- Smart search
vim.opt.smartcase = true
vim.opt.termguicolors = true -- Better colors
vim.opt.guicursor = "n-v-c:block,i-ci-ve:block-blinkwait300-blinkon200-blinkoff150"

-- 3. Load Plugins
require("lazy").setup({
	-- Dark Rose Theme
	{
		"water-sucks/darkrose.nvim",
	},
	-- Spacegray Theme
	{
		"ignu/Spacegray.vim",
	},

	-- VS Code Theme
	{
		"Mofiqul/vscode.nvim",
	},

	-- Stylized dashboard
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local dashboard = require("alpha.themes.dashboard")

			-- 1. Custom ASCII Header (You can find more at 'ascii.co.uk')
			dashboard.section.header.val = {
				[[       ____      ____________________      ]],
				[[      ' |  '    '  .______________.  '     ]],
				[[      |=|  |    | |/+------------+/| |     ]],
				[[O     |=|  |    | |/|            |/| |     ]],
				[[d     |/|  |    | |/| /    |>    |/| |    |[]|\|    d]],
				[[     ;     |    | |o| \|ame|>oy  |/| |    |[]|  ;    ]],
				[[l    ;/": E|    | |/|            |/| |    |Of|  ;   p]],
				[[e    ;|:| X|    | |/|NINTENDO(R) |/| |    |f |  ;   r]],
				[[w    .\_: T|    | |/+------------+/| |    |  |  .   a]],
				[[e   ,'     |    | |/GAME/BOY/COLOR/| |    |  |  ',  w]],
				[[j   |   ||:|    | '----------------' |    |  |   |  e ]],
				[[    |   ||:|    |       (luk)        |    |  |   |  j]],
				[[|   ;   |V |    |                    |    |  |   ;   ]],
				[['>  ;   |O |]   | / ^ \          (A) |   [|  |   ;  |]],
				[[    ;   |L |]   | <(o)>      (B)     |   [|  |   ; <']],
				[[    |   ||\|]   | \ V /              |   [|  |   |   ]],
				[[    |   |'"|    |                    |    |  |   |   ]],
				[[    .   |  |)   |       == ==    .-. |   (|  |   .   ]],
				[[     ;  |  |    |               ':::'|    |  |  ;    ]],
				[[      \ |  |    '..__           '__..'    |  | /     ]],
				[[       "'--'         """"""""""""         '--'"      ]],
			}

			dashboard.section.header.opts.hl = "Special" -- This usually makes it a bright color

			-- 2. Custom Buttons (Shortcuts)
			dashboard.section.buttons.val = {
				dashboard.button("n", "📝  New File", ":ene <BAR> startinsert <CR>"),
				dashboard.button("f", "🥽  Find File", ":Telescope find_files <CR>"),
				dashboard.button("r", "👾  Recent Files", ":Telescope oldfiles <CR>"),
				dashboard.button("j", "⚡️  My Coding Root", ":cd /Users/justfrvn/Coding <BAR> NvimTreeOpen <CR>"),
				dashboard.button("s", "🛠️   Settings", ":e $MYVIMRC <CR>"),
				dashboard.button("q", "🎧  Quit", ":qa <CR>"),
			}

			-- 3. Footer (Random "Startify" style text)
			dashboard.section.footer.val = "⚡️ Lock in, and get coding! ⚡️"
			dashboard.section.footer.opts.hl = "Type"
			dashboard.section.footer.opts.position = "center"

			require("alpha").setup(dashboard.config)
		end,
	},

	-- File Explorer
	{ "nvim-tree/nvim-tree.lua", config = true },

	-- Telescope (Fuzzy Finder / VS Code "Ctrl+P")
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = true,
	},

	-- Auto-formatter
	{
		"stevearc/conform.nvim",
		opts = {},
	},

	-- Autocompletion Engine
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp", -- Integration with LSP (Java, Python, etc.)
			"L3MON4D3/LuaSnip", -- Snippet engine (required)
			"saadparwaiz1/cmp_luasnip",
		},
	},

	-- Mason (LSP/Linter/Formatter Manager)
	{
		"williamboman/mason.nvim",
		dependencies = { "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig" },
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "pyright", "jdtls" }, -- Add servers for your languages here
			})
		end,
	},

	-- Integrated Terminal
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {
			open_mapping = [[<c-\>]], -- Shortcut to toggle terminal
			direction = "float", -- Make it float instead of split
			float_opts = {
				border = "rounded", -- Match your other floating windows
				winblend = 3, -- Slight transparency
			},
		},
	},

	-- Autopairs: Auto-close brackets, quotes, etc.
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({
				check_ts = true, -- Enable Treesitter integration
				disable_filetype = { "TelescopePrompt" },
			})

			-- If you want it to work with nvim-cmp (highly recommended)
			-- This makes it so if you select a function from the menu,
			-- it automatically adds the parentheses.
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},
})

-- NEW KEYBINDINGS
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {}) -- Find Files (Ctrl+P)
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {}) -- Search text in all files
vim.keymap.set("n", "<leader>m", ":Mason<CR>") -- Open Mason UI

-- 4. IDE Keybindings
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>") -- Ctrl+n for Sidebar
-- Updated Run Command: Now handles Java, Python, and Node
vim.keymap.set("n", "<leader>r", function()
	local file_ext = vim.fn.expand("%:e")
	local file_name = vim.fn.expand("%:r") -- Gets the filename without .java
	if file_ext == "py" then
		vim.cmd('TermExec cmd="python3 %"')
	elseif file_ext == "js" then
		vim.cmd('TermExec cmd="node %"')
	elseif file_ext == "java" then
		-- 1. Get the directory of the file and the filename
		local file_dir = vim.fn.expand("%:p:h")
		local file_name = vim.fn.expand("%:t:r")
		-- 2. CD into the folder, compile, and run using the -cp (classpath) flag
		vim.cmd(
			'TermExec cmd="cd ' .. file_dir .. " && javac " .. file_name .. ".java && java -cp . " .. file_name .. '"'
		)
	end
end)

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "isort", "black" },
		java = { "google-java-format" }, -- The standard for Java
		javascript = { "prettierd", "prettier", stop_after_first = true },
	},
	-- This is the "Magic" part: Format on Save
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true,
	},
})

local cmp = require("cmp")
cmp.setup({
	window = {
		completion = { border = "rounded" },
		documentation = { border = "rounded" },
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<Tab>"] = cmp.mapping.select_next_item(), -- Tab to go down
		["<S-Tab>"] = cmp.mapping.select_prev_item(), -- Shift-Tab to go up
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Enter to select
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" }, -- Get suggestions from Java/Python/Lua
	}),
})

-- Native LSP Setup for Neovim 0.11+
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local servers = { "lua_ls", "pyright", "jdtls" }

for _, server in ipairs(servers) do
	vim.lsp.config(server, { capabilities = capabilities })
	vim.lsp.enable(server)
end

-- Ensure this is OUTSIDE the require("lazy").setup({...}) block
vim.keymap.set("n", "<leader>th", function()
	require("telescope.builtin").colorscheme({ enable_preview = true })
end)

-- Define colors for different modes
local mode_colors = {
	n = "%#DiagnosticInfo#", -- Normal: Blue-ish
	i = "%#DiagnosticOk#", -- Insert: Green
	v = "%#DiagnosticWarn#", -- Visual: Yellow/Orange
	V = "%#DiagnosticWarn#",
	["\22"] = "%#DiagnosticWarn#",
	c = "%#DiagnosticHint#", -- Command: Light Blue
}

-- Create the Winbar function
function _G.get_winbar()
	local mode = vim.api.nvim_get_mode().mode
	local color = mode_colors[mode] or "%#Normal#"
	local file_path = vim.fn.expand("%:f")

	if file_path == "" then
		return ""
	end
	return color .. "  " .. mode:upper() .. "  %* " .. file_path
end

-- Apply the winbar globally
vim.opt.winbar = "%{%v:lua.get_winbar()%}"

-- Refresh winbar on mode change
vim.api.nvim_create_autocmd("ModeChanged", {
	callback = function()
		vim.cmd("redrawstatus")
	end,
})

-- Transparent Background Fix
-- 1. Set Spacegray as the default
vim.cmd([[colorscheme spacegray]])

-- 2. Refined Transparency Function
local function make_transparent()
	-- Targeted UI groups only
	local groups = {
		"Normal",
		"NormalNC",
		"LineNr",
		"CursorLineNr",
		"SignColumn",
		"NormalFloat",
		"FloatBorder",
		"Pmenu",
		"EndOfBuffer",
		"NonText",
		"Folded",
		"WinSeparator",
	}

	for _, group in ipairs(groups) do
		vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE", force = true })
	end

	-- Custom visibility tweaks for Line Numbers
	vim.api.nvim_set_hl(0, "LineNr", { fg = "#65737e", bg = "NONE" })
	vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#bf616a", bg = "NONE", bold = true })
	vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#65737e", bg = "NONE" })
end

-- 3. Run it immediately and every time the theme changes
make_transparent()

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = make_transparent,
})

-- Function to update colors based on Mode
local function update_mode_colors()
	local mode = vim.api.nvim_get_mode().mode

	-- Define Spacegray-friendly mode colors
	local mode_colors = {
		n = "#65737e", -- Normal: Blue-Gray
		i = "#a3be8c", -- Insert: Green
		v = "#ebcb8b", -- Visual: Yellow
		V = "#ebcb8b", -- Visual Line
		c = "#bf616a", -- Command: Red
		R = "#b48ead", -- Replace: Purple
	}

	local color = mode_colors[mode] or "#65737e"

	-- Apply this color to the StatusLine or specific UI borders
	vim.api.nvim_set_hl(0, "StatusLine", { fg = color, bg = "NONE", bold = true })
	vim.api.nvim_set_hl(0, "CursorLineNr", { fg = color, bg = "NONE", bold = true })
end

-- Trigger the color update whenever the mode changes
vim.api.nvim_create_autocmd("ModeChanged", {
	callback = update_mode_colors,
})

-- Set the border style
-- --- UI BORDERS & LSP HELPERS ---
local border = "rounded"

-- 1. Correct way to handle Diagnostics (LSP errors/warnings)
vim.diagnostic.config({
	float = { border = border },
})

-- 2. The Global Override for all LSP Floating Windows (Hover, Signature, etc.)
-- This replaces the deprecated vim.lsp.with() method entirely
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or border
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
