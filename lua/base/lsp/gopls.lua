vim.lsp.config("gopls", {
	init_options = {
		usePlaceholders = true,
		completeUnimported = true,
	},
	filetypes = {
		"go",
		"gomod",
		"gowork",
		"gotmpl",
	},

	root_markers = {
		"go.work",
		"go.mod",
		".git",
	},
	settings = {
		gopls = {
			-- 分析器配置
			analyses = {
				fieldalignment = true,
				nilness = true,
				useany = true,
				simplifycompositelit = true,
				simplifyrange = true,
				simplifyslice = true,
				simplifystruct = true,
				unusedparams = true,
				unusedwrite = true,
				packagecomments = true, -- 确保启用包注释检查
				shadow = true,
				composites = false,
			},
			-- 代码透镜
			codelenses = {
				generate = true, -- 显示生成代码的透镜
				gc_details = true, -- 显示 GC 细节
				test = true, -- 显示测试透镜
				tidy = true, -- 显示 go mod tidy 透镜
				upgrade_dependency = true, -- 显示依赖升级透镜
				vendor = true, -- 显示 vendor 透镜
			},
			usePlaceholders = false,
			staticcheck = true, -- ❗大项目必须关
			-- 悬停信息
			hoverKind = "SynopsisDocumentation",
			-- 链接处理
			linksInHover = true,
			completeUnimported = true,
			completionDocumentation = true,
			-- 符号信息
			symbolMatcher = "fuzzy",
			-- 诊断配置
			diagnosticsDelay = "200ms", -- 降低延迟，加快诊断显示
			-- 实验性功能
			experimentalPostfixCompletions = true,
			experimentalWorkspaceModule = true,
			-- 模板支持
			templateSupport = true,
			-- 内存模式 (对于大项目可以调整)
			memoryMode = "DegradeClosed",
			-- 目录过滤
			directoryFilters = {
				"-.git",
				"-node_modules",
				"-vendor",
			},
			semanticTokens = true,
			env = {
				GO111MODULE = "on",
				GOPROXY = "https://goproxy.cn,direct", -- 国内用户推荐
				GOSUMDB = "sum.golang.google.cn",
			},
			gofumpt = true,
			hints = {
				assignVariableTypes = true,
				compositeLiteralFields = true,
				compositeLiteralTypes = true,
				constantValues = true,
				functionTypeParameters = true,
				parameterNames = true,
				rangeVariableTypes = true,
			},
		},
	},
})

