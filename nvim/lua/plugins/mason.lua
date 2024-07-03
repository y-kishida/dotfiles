return {
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = {
      -- Golang
      "goimports",
      "gofumpt",
      "gomodifytags",
      "impl",
      "delve",
      -- Kotlin
      "ktlint",
    }},
  },
  }
