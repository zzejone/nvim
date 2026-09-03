pack_add({
    "nvim-lua/plenary.nvim",
    "kdheepak/lazygit.nvim",
})


nvim.key.group("<leader>g","git")
nvim.key.map("n","<leader>gg","<cmd>LazyGit<cr>", {desc = "LazyGit" })
