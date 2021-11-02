local modem = require("secure_modem")
local shell = require("shell")
local table = require("table")
local term  = require("term")
local string = require("string")
local filesystem = require("component").filesystem
-- GETTING ARGUMENTS  
local arg,_ = shell.parse(...)
local arg = table.pack(table.unpack(arg))
if arg.n < 2 then print("Not enough arguments") goto cancel end
-- NAMING REQUIRED ARGUMENTS
local FILE = arg[1]
local PATH = arg[2]
local IP,PORT   = "5dc15f86-9884-49ef-b6cc-4d8498b88a7b",340
-- CHECKING IF SAID FILE IS ALREADY DOWNLOADED
local PRESENT = filesystem.exists(PATH..FILE)
local OVERWRITE = false
if PRESENT then 
  print("overwrite (Y/n)") 
  OVERWRITE = term.read()
  if string.match(OVERWRITE,"Y") ~= "Y" then 
    print("canceling...") 
    goto cancel 
  end
end 
-- SENDING FIRST REQUEST
require("component").modem.open(PORT)
modem.send(IP,PORT,"download",FILE)
_,_,ip,port,_,dt = modem.recv()
if dt[1] == "false" then print(dt[2]) goto cancel end
if dt[1] == "true" then print(dt[2]) end
t=""
amount = tonumber(dt[2])
for x=1,amount do
  _,_,ip,port,_,dt = modem.recv()
  if dt[1] == "packet" then
    t=t..dt[2].."\n"
  end
  if dt[1] == "end" then
    print("PACKET LOST")
    goto cancel
  end
end
--print(t)
-- SAVING
local f = io.open(PATH..FILE,"w")
f:write(t)
f:flush()
f:close()
::cancel::