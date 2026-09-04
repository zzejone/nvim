# renvim

个人 Neovim 配置，纯 Lua 编写。

## 结构

```
lua/
├── core/          # 核心配置（选项、键位、插件管理、命令）
├── base/          # 基础插件与 LSP 配置
│   ├── plugins/   # 主题、Telescope、Treesitter、帮助文档
│   └── lsp/       # gopls / lua_ls / ts_ls
├── custom/        # 自定义插件配置（32 个模块）
├── utils/         # 工具函数（模块自动加载器）
└── trash/         # 废弃配置
```

## 特性

- **模块自动加载** — 通过 `utils.loader` 按文件名排序自动 require 目录下所有模块，无需手动维护加载顺序
- **统一插件管理** — `pack_add()` 封装 `vim.pack.add`，支持简写 GitHub 地址
- **快捷键注册系统** — `key.lua` 提供 group/map/get_spec 三件套，自动生成 which-key 格式的 spec
- **Leader 键** — 空格
- **主题** — Catppuccin Mocha
- **状态栏** — Lualine（everforest 风格）
- **补全** — blink.cmp + LuaSnip + friendly-snippets
- **Git** — gitsigns

## 核心插件

| 功能 | 插件 |
|------|------|
| 主题 | catppuccin/nvim |
| 状态栏 | lualine.nvim |
| 补全 | blink.cmp, LuaSnip |
| 模糊搜索 | telescope.nvim |
| 语法高亮 | treesitter |
| 文件树 | nvim-tree |
| Git 标记 | gitsigns.nvim |
| 代码导航 | aerial.nvim |
| 光标跳转 | flash.nvim |
| 注释 | comment.nvim |
| 错误列表 | trouble.nvim |
| 待办 | todo-comments |
| Lint | nvim-lint |
| 格式化 | conform.nvim |

## 安装

```bash
# 备份现有配置
mv ~/.config/nvim ~/.config/nvim.bak

# 克隆
git clone <repo-url> ~/.config/nvim
```

需要 Neovim 内置包管理器支持（`vim.pack`）。

## 要求

- Neovim（最新稳定版，需支持 `vim.pack`）
- Nerd Font
- Node.js（Treesitter / LSP 需要）
- Go（gopls）
