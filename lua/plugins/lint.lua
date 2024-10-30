local M = {}

M.linting = true

function LintingStatus()
    if M.linting then
        print("linting")
    else
        print("not linting")
    end
end

function ToggleLinting()
    M.linting = not M.linting

    if M.linting then
        Lint()
    else
        vim.diagnostic.reset()
    end
end

function M.debounce(ms, fn)
    local timer = vim.uv.new_timer()
    return function(...)
        local argv = { ... }
        timer:start(ms, 0, function()
            timer:stop()
            vim.schedule_wrap(fn)(unpack(argv))
        end)
    end
end

function Lint()
    -- Use nvim-lint"s logic first:
    -- * checks if linters exist for the full filetype first
    -- * otherwise will split filetype by "." and add all those linters
    -- * this differs from conform.nvim which only uses the first filetype that has a formatter
    local lint = require("lint")
    local names = lint._resolve_linter_by_ft(vim.bo.filetype)

    -- Create a copy of the names table to avoid modifying the original.
    names = vim.list_extend({}, names)

    -- Add fallback linters.
    if #names == 0 then
        vim.list_extend(names, lint.linters_by_ft["_"] or {})
    end

    -- Add global linters.
    vim.list_extend(names, lint.linters_by_ft["*"] or {})

    -- Filter out linters that don"t exist or don"t match the condition.
    local ctx = { filename = vim.api.nvim_buf_get_name(0) }
    ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
    names = vim.tbl_filter(function(name)
        local linter = lint.linters[name]
        return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
    end, names)

    -- Run linters.
    if #names > 0 then
        lint.try_lint(names)
    end
end

function GetLinters()
    local linters = require("lint").get_running()
    if #linters == 0 then
        return "no linters"
    end
    return "󱉶 " .. table.concat(linters, ", ")
end

local function linters_config()
    local linters = require("lint").linters

    linters.shellcheck.args = {
        "--format", "json",
        "--shell", "bash",
        "-",
    }
end

local function config(_, opts)
    local lint = require("lint")
    lint.linters_by_ft = opts.linters_by_ft

    vim.api.nvim_create_autocmd(opts.events, {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = function()
            if not M.linting then
                return
            end
            M.debounce(100, Lint)()
        end,
    })

    linters_config()

    local cmd = vim.api.nvim_create_user_command
    cmd("Lint", function() Lint() end, { nargs = 0 })
    cmd("GetLinters", function() print(GetLinters()) end, { nargs = 0 })

    local keymap = vim.api.nvim_set_keymap
    keymap("n", "<leader>ls", ":lua LintingStatus()<CR>", { noremap = true, silent = true })
    keymap("n", "<leader>lt", ":lua ToggleLinting()<CR>", { noremap = true, silent = true })
end

return {
    "mfussenegger/nvim-lint",
    opts = {
        -- Event to trigger linters
        events = { "BufReadPost", "BufWritePost", "TextChanged", "TextChangedI", },
        linters_by_ft = {
            rust = { "rust-analyzer" },
            python = { "pylint" },
            lua = { "stylua" },
            bash = { "shellcheck" },
            sh = { "shellcheck" },
            -- c = { "cpplint" },
            cpp = { "cpplint" },
            make = { "checkmake" },
            ["*"] = { "codespell" },
        },
    },
    config = config,
}
