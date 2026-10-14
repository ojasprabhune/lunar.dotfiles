return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {},
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    config = function()
      -- specific configuration for Pyright.
      --
      -- NOTE: this has to live in `config`, not in `handlers` below. The
      -- handlers entry never runs for pyright under nvim-lspconfig v2, so the
      -- settings it registered were silently discarded and nvim fell back to
      -- the packaged lsp/pyright.lua defaults.
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      local analysis = {
        autoImportCompletions = true,
        typeCheckingMode = "basic",
        -- per-file diagnostics: "workspace" mode withholds results until the
        -- entire (possibly huge) repo has been analyzed
        diagnosticMode = "openFilesOnly",
        -- this helps Pyright find libraries in research envs
        autoSearchPaths = true,
        -- OFF. nvim-lspconfig ships this as true, which makes pyright parse the
        -- source of every installed library -- tens of thousands of files in a
        -- research .venv, tens of seconds of analysis that stalls hover and
        -- completion. Type stubs are still used, so hover stays accurate.
        useLibraryCodeForTypes = false,
      }

      -- Pyright needs to be told which interpreter to use, otherwise every
      -- third-party import fails to resolve (no hover, no library completion).
      -- Its venv settings are only honoured as absolute paths, so this waits
      -- for a python buffer to locate the project root and is a no-op in
      -- projects without a .venv.
      local configured_for

      local function setup_pyright(bufnr)
        local python
        local root = vim.fs.root(bufnr, { "pyproject.toml", "setup.py", "requirements.txt", ".venv" })
        if root then
          local candidate = vim.fs.joinpath(root, ".venv", "bin", "python")
          if vim.uv.fs_stat(candidate) then
            python = candidate
          end
        end

        if python == configured_for then
          vim.lsp.enable("pyright")
          return
        end
        configured_for = python

        vim.lsp.config["pyright"] = {
          capabilities = capabilities,
          settings = {
            python = {
              pythonPath = python or vim.NIL,
              analysis = analysis,
            },
          },
        }
        vim.lsp.enable("pyright")
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("pyright.config", { clear = true }),
        pattern = "python",
        callback = function(args)
          setup_pyright(args.buf)
        end,
      })

      setup_pyright(0)
    end,
    handlers = {
      -- this function runs for every installed server
      function(server_name)
        local capabilities = require("blink.cmp").get_lsp_capabilities()

        -- pyright is configured in `config` above
        if server_name ~= "pyright" then
          -- default configuration for everything else (clangd, jdtls, etc.)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end
      end,
    },
  },
}
