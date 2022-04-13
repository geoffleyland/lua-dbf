package = "dbf"
version = "scm-4"
source =
{
  url = "git+https://git@github.com:geoffleyland/lua-dbf.git"
}
description =
{
  summary = "Read DBF files",
  homepage = "https://github.com/geoffleyland/lua-dbf",
  license = "MIT/X11",
  maintainer = "Geoff Leyland <geoff.leyland@incremental.co.nz>",
}
dependencies =
{
  "lua >= 5.1",
  "struct",
}
build =
{
  type = "builtin",
  modules =
  {
    ["dbf"] = "src-lua/dbf.lua",
  },
}
