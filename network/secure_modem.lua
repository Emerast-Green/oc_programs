local modem = require("component").list("modem")
local table = require("table")

local SECURE = true

if not SECURE then
  return {["send"]=modem.send,["broadcast"]=modem.broadcast,["recv"]=modem.recv,["isWireless"]=modem.isWireless,["open"]=modem.open,["address"]=modem.address}
end

for a,b in pairs(modem) do
  x = require("component").proxy(a)
  if x.isWireless() then modem = x end
end

local io = require("io")
local event = require("event")
local table = require("table")
local pro = require("programs")

local f = io.open("/etc/sec.dat","r")
local security = f:read(1024)
f:close()

local function send(ip,port,...)
  modem.send(ip,port,security,table.unpack({...}))
end

local function broadcast(port,...)
  modem.broadcast(port,security,table.unpack({...}))
end

local function recv(log)
  a,b,ip,port,c,sec,dt = pro.separgs(6,{event.pull("modem_message")})
  if sec == security then 
    return a,b,ip,port,c,dt 
  else 
    if log==true then 
      print(ip.."->msg denied on "..port.." due to wrong sec-key") 
    end
  end
end

return {["send"]=send,["broadcast"]=broadcast,["recv"]=recv,["isWireless"]=modem.isWireless,["open"]=modem.open,["address"]=modem.address}
