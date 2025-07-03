require("neorg").setup({
  load = {
    -- core defaults
    ["core.defaults"] = {},
    -- workspace definitions
    ["core.dirman"] = {
      config = {
        workspaces = {
          -- TODO move this to dropbox maybe?
          work = "~/Dropbox/notes/neorg/work",
          home = "~/Dropbox/notes/neorg/home",
          sabbatical = "~/Dropbox/notes/neorg/sabbatical",
          personal = "~/Dropbox/notes/neorg/personal",
        },
        default_workspace = "work",
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
