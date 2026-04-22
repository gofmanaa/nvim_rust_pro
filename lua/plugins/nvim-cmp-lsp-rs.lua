return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    {
      "zjp-CN/nvim-cmp-lsp-rs",
      opts = {
        unwanted_prefix = { "color", "ratatui::style::Styled" },
        kind = function(k)
          return { k.Module, k.Function }
        end,
        combo = {
          alphabetic_label_but_underscore_last = function()
            local comparators = require("cmp_lsp_rs").comparators
            return { comparators.sort_by_label_but_underscore_last }
          end,
          recentlyUsed_sortText = function()
            local compare = require("cmp").config.compare
            local comparators = require("cmp_lsp_rs").comparators
            return {
              compare.recently_used,
              compare.sort_text,
              comparators.sort_by_label_but_underscore_last
            }
          end,
        },
      },
    },
  },

  keys = {
    {
      "<leader>bc",
      function()
        require("cmp_lsp_rs").combo()
      end,
      desc = "Switch cmp comparator",
    },
  },

  opts = function(_, opts)
    local cmp = require("cmp")
    local cmp_lsp_rs = require("cmp_lsp_rs")
    local comparators = cmp_lsp_rs.comparators
    local compare = cmp.config.compare

    opts = opts or {}

    opts.sources = opts.sources or {
      { name = "nvim_lsp" },
      { name = "buffer" },
      { name = "path" },
    }

    opts.sorting = opts.sorting or {}
    opts.sorting.comparators = {
      compare.exact,
      compare.score,
      comparators.inscope_inherent_import,
      comparators.sort_by_label_but_underscore_last,
    }

    if opts.sources then
      for _, source in ipairs(opts.sources) do
        cmp_lsp_rs.filter_out.entry_filter(source)
      end
    end

    return opts
  end,
}
