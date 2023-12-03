local options = {
  ma = true,
  tabstop = 2,
  shiftwidth = 2,
  softtabstop = 2,
  autoindent = true,
  expandtab = true,
  autoread = true,
  nu = true,
  backup = false,
  writebackup = false,
  swapfile = false,
  clipboard = "unnamedplus",
  showmode = false,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end
