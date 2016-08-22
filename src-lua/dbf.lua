-- (c) Copyright 2010-2016 Geoff Leyland.
-- See LICENSE for license information

-- dbf format is documented at
-- http://www.dbf2002.com/dbf-file-format.html


local unpack

if not string.unpack then
  require("struct")
  unpack = function(file, length, format)
    return struct.unpack(format, file:read(length))
  end
else
  unpack = function(file, length, format)
    return file:read(length):unpack(format)
  end
end


------------------------------------------------------------------------------

local ok_field_types = { C=true, D=true, F=true, N=true }
local number_field_types = { F=true, N=true }
local ok_record_types = { [" "]=true, ["*"]=true }


------------------------------------------------------------------------------

local function read_header(f)
  f:read(4)  -- version and date
  local record_count, header_length, field_length = unpack(f, 8, "<ihh")
  f:read(20) -- Reserved, Incomplete transaction flag, Encryption flag,
             -- Free record thread, Reserved for multi-user dBASE, MDX flag
             -- Language driver, Reserved
  local field_count = (header_length - 1) / 32 - 1

  local fields = {}
  local total_length = 1  -- for skipping
  for i = 1, field_count do
    local name = f:read(11):match("%Z*")
    local type = f:read(1)
    assert(ok_field_types[type], "Don't understand dbase field type: '"..type.."'")
    f:read(4)  -- Field data address
    local length = unpack(f, 1, "<B")
    f:read(15) -- Decimal count, Reserved for multi-user dBase, Work area ID
               -- Reserved for multi-user dBase, Flag for SET FIELDS, Reserved
               -- Index field flag
    fields[i] = { name=name, type=type, length=length }
    total_length = total_length + length
  end
  f:read(1)
  fields.total_length = total_length

  return fields
end


local function read_record(f, fields)
  if not ok_record_types[f:read(1)] then return end
  local r = {}
  for _, field in ipairs(fields) do
    local d = f:read(field.length)
    if number_field_types[field.type] then
      d = tonumber(d)
    else
      d = d:match("^%s*(.-)%s*$")
    end
    r[field.name] = d
  end
  return r
end


local function skip_record(f, fields)
  f:read(fields.total_length)
end


-- file objects --------------------------------------------------------------

local file_mt =
{
  read = function(t)
      return read_record(t.file, t.fields)
    end,
  skip = function(t)
      skip_record(t.file, t.fields)
    end,
  lines = function(t)
      return function() return t:read() end
    end,
  close = function(t)
      t.file:close()
    end,
}
file_mt.__index = file_mt


local function use(file)
  return setmetatable({ file=file, fields=read_header(file)}, file_mt)
end


local function open(filename)
  return use(assert(io.open(filename, "r")))
end


------------------------------------------------------------------------------

return { use=use, open=open }

------------------------------------------------------------------------------
