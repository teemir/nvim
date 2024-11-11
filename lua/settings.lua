local cmd = vim.cmd             -- выполнение команд Vim
local cmd = vim.cmd             -- выполнение команд Vim
local exec = vim.api.nvim_exec  -- выполнение Vimscript
local g = vim.g                 -- глобальные переменные
local opt = vim.opt             -- глобальные/буферные/окна опции
local o = vim.o                 -- глобальная o
local telescope = require('telescope.builtin') -- подключение модуля telescope для поиска

opt.mouse = "a"                 -- включить использование мыши
opt.encoding = 'utf-8'          -- установить кодировку UTF-8
opt.number = true               -- отображать номера строк
opt.relativenumber = true       -- включить относительные номера строк
opt.scrolloff = 7               -- минимальное количество строк вокруг курсора
opt.tabstop = 4                 -- количество столбцов для табуляции
opt.softtabstop = 4             -- видимость табуляции как нескольких пробелов
opt.shiftwidth = 4              -- ширина автоотступов
opt.expandtab = true            -- конвертировать табуляции в пробелы
opt.autoindent = true           -- автоматический отступ новой строки
opt.fileformat = 'unix'         -- формат файла UNIX
opt.smartindent = true          -- умный отступ
opt.expandtab = true            -- преобразование табуляции в пробелы
opt.ignorecase = true           -- нечувствительность к регистру при поиске
opt.showmatch = true            -- показать совпадение
opt.hlsearch = true             -- выделение совпадений при поиске
opt.incsearch = true            -- инкрементный поиск
opt.wildmode = {'longest', 'list'} -- автозавершение команд как в bash
opt.cc = '80'                   -- ограничение в 80 символов для улучшения стиля кода
opt.clipboard = 'unnamedplus'   -- использование системного буфера обмена
opt.cursorline = true           -- подсветка строки с курсором
opt.ttyfast = true              -- ускорение прокрутки в Vim
opt.termguicolors = true        -- важный параметр для bufferline

-- Включить индентацию и плагины для файлов
cmd([[
filetype indent on
filetype plugin on
syntax on
]])

-- отключить авто-комментарии для новой строки
cmd [[au BufEnter * set fo-=c fo-=r fo-=o]]

-- убрать маркер длины строки для выбранных типов файлов
cmd [[autocmd FileType text,markdown,html,xhtml,javascript setlocal cc=0]]

-- 2 пробела для отступов для выбранных типов файлов
cmd [[
autocmd FileType xml,html,xhtml,css,scss,javascript,lua,yaml,htmljinja setlocal shiftwidth=2 tabstop=2
]]

-- формат синтаксиса jinja2 в HTML файлах
cmd[[ autocmd BufNewFile,BufRead *.html set filetype=htmldjango ]]

-- установить цветовую схему gruvbox
-- cmd'colorscheme gruvbox'

-- Настройка цветовой схемы Gruvbox
require("gruvbox").setup({
  terminal_colors = true,
  undercurl = true,
  underline = true,
  bold = false,
  italic = {
    strings = false,
    emphasis = false,
    comments = false,
    operators = false,
    folds = false,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true,
  contrast = "hard", -- возможные значения: "hard", "soft", или пустая строка
  palette_overrides = {},
  overrides = {
    Delimiter = { fg = "#00ced1" },
  },
  dim_inactive = false,
  transparent_mode = false,
})



opt.termguicolors = true
o.background = "dark"
cmd[[colorscheme gruvbox]]

-- Настройки Nvim-Tree (файлового менеджера)
g.loaded_netrw = 0
g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
    sort = {
        sorter = "case_sensitive",  -- сортировка с учетом регистра
    },
    view = {
        width = 30,                 -- ширина окна
    },
    renderer = {
        group_empty = true,         -- группировать пустые директории
    },
    filters = {
        dotfiles = true,            -- фильтрация скрытых файлов
    },
})

-- Настройка Lualine (статусной линии)
require('lualine').setup {
  options = { theme  = 'gruvbox' },
}

-- Настройки Bufferline
require("bufferline").setup({
  options = {
    mode = "buffers",
    numbers = "none",
    close_command = "bdelete! %d",
    indicator = {
      style = 'icon',
    },
    buffer_close_icon = '✖',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    diagnostics = "nvim_lsp",
    offsets = {{
      filetype = "NvimTree",
      text = "File Explorer",
      text_align = "left",
      separator = true
    }},
    color_icons = true,
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = true,
    show_tab_indicators = true,
    separator_style = "thin",
    always_show_bufferline = true,
  }
})

-- Настройки Telescope (поиск файлов и текста)
vim.keymap.set('n', 'ff', telescope.find_files, {})
vim.keymap.set('n', 'fg', telescope.live_grep, {})

-- Настройка LSP (подсистема анализа кода)
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local lspconfig = require('lspconfig')
local servers = { 'pyright' }

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
  }
end

-- Настройка luasnip (сниппеты)
local luasnip = require 'luasnip'

-- Настройка nvim-cmp (автодополнение)
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

