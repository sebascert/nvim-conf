return {
    "apyra/nvim-unity-sync",
    enabled = true,
    config = function()
        require("unity.plugin").setup({
            -- unity_path = "path/to/unity/Unity.exe",
            unity_cs_template = true,
        })
    end,
    ft = "cs",
}
