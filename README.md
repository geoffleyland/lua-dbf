# lua-dbf - Read DBF files in Lua

## 1. What?

dbf format is documented [here](http://www.dbf2002.com/dbf-file-format.html)


## 2. Why?

Shapefiles use dbf.


## 3. How?

``luarocks install dbf``

then

    dbf = require"dbf"
    local f = dbf.open("dbf-file.dbf")
    for l in f:lines() do
      for k, v in pairs(l) do print(k, v) end
    end

If you don't install with luarocks, then you need to make sure that
Roberto's [struct library](http://www.inf.puc-rio.br/~roberto/struct/) is
installed.


## 4. Requirements

Lua >= 5.1 or LuaJIT >= 2.0.0.


## 5. Issues

+ Incomplete


## 6. Wishlist

+ Tests?
+ Documentation?

## 6. Alternatives

+ Moteus's [gist](https://gist.github.com/moteus/33a68673cfa52eeccc6e132e55e960eb) reads and writes dbf