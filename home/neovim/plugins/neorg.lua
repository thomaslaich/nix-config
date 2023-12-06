require("neorg").setup({
  load = {
    -- core defaults
    ["core.defaults"] = {},
    -- workspace definitions
    ["core.dirman"] = {
      config = {
        workspaces = {
          -- TODO move this to dropbox maybe?
          work = "~/notes/work",
          home = "~/notes/home",
          sabbatical = "~/notes/sabbatical",
          personal = "~/notes/personal",
        },
        default_workspace = "work",
      },
    },
    -- completion
    ["core.completion"] = {
      config = {
        engine = "nvim-cmp",
      },
    },
    -- nice icons, and folding
    ["core.concealer"] = {},
    -- automtatically summarize workspaces
    ["core.summary"] = {},
    -- activate this once we upgrade to nvim 0.10.x
    -- ['core.ui.calendar'] = {}
  },
})
