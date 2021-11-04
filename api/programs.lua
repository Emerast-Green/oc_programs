local io = require("io")

local function mysplit (inputstr, sep)
-- splits strings with separator
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

local function getlines (path)
  fs = io.open(path,"r")
  con = true
  total = ""
  while con do
--    print("getting")
    cur = fs:read(1024)
    if cur == nil then con = false else total=total..cur end
  end
  return mysplit(total,"\n"),total
end

local function separgs(nr,tab)
  unp = {}
  pck = {}
  nr1 = 0
  for x,y in pairs(tab) do
    if nr1 ~=nr then
      table.insert(unp,y)
      nr1 = nr1 + 1
    else
      table.insert(pck,y)
    end
  end
  table.insert(unp,pck)
  return table.unpack(unp)
end

local function organizetable(tab)
  new_tab = {}
  for x,y in pairs(tab) do new_tab[x]=y end
  return new_tab
end

return { ["mysplit"]=mysplit, ["getlines"]=getlines, ["separgs"]=separgs, ["organizetable"]=organizetable }