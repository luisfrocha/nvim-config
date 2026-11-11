---
description: Ensures vue-language-server is installed from the official npm
  registry while keeping other packages using Apple's registry
alwaysApply: false
---

When installing vue-language-server via Mason, set NPM_CONFIG_USERCONFIG environment variable to point to ~/.config/nvim/mason-vue-npmrc before installation to use the official npm registry