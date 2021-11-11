local modem = require("component").modem
local event = require("event")
local static_addresses = require("dhcp_static")

if modem.isWireless() then
  print("Modem is wireless")
else
  print("Modem is wired")
end

local ADDRESS = modem.address
local PORT = 55
print("Address "..ADDRESS)
print("Opening port "..PORT)
modem.open(PORT)

local RANGE = {2,20}

-- CONFIG STATIC ADDRESSES IN //usr/lib/dhcp_static.lua
NETWORK = "10.0.0"
CLIENTS = {["n"]=0}

for x,y in pairs(static_addresses) do
  CLIENTS[x]=y
  CLIENTS.n=CLIENTS.n+1
end

local function in_table(table,name)
  for y,_ in pairs(table) do
    if y == name then return true end
  end
  return false
end

local function find_table(table,address)
  --print("compare "..address)
  for x,y in pairs(table) do
    --print(x.."=>"..y)
    if NETWORK.."."..y == address then
      return x
    end
  end
  return "not_found"
end

local function find_ip(table,address)
  for x,y in pairs(table) do
    if x == address then
      return NETWORK.."."..y
    end
  end
  return "not_found"
end

local function find_free(table,range,network)
  if table.n == 0 then
    return range[1]
  end
  num = range[1]
  while num<range[2]+1 do
    check = false -- either this ip is taken or not
    for mac,ip in pairs(CLIENTS) do
      if ip == num then
        if not check then
          check = true
        end 
      end
    end
    if not check then return num end
    num = num + 1 
  end
  return "not_found"
end

local function dhpc()
  print("send request_address on 55 port")
  print("send translate_address on 55 port")
  while true do
    _,_,sender,_,_,msg,par = event.pull("modem_message")
    print(msg)
    if msg == "request_address" then
      print("REQUEST")
      if not in_table(CLIENTS,sender) then
        new = find_free(CLIENTS,RANGE,NETWORK)
        print("NEW=>"..new)
        if new ~= "not_found" then
          CLIENTS[sender]= new
          CLIENTS.n=CLIENTS.n+1
          modem.send(sender,PORT,"granted",NETWORK.."."..new)
          print("granted "..NETWORK.."."..new)
        else
          print("FULL")
          modem.send(sender,PORT,"error - no free address")
        end
      else
        print("PRESENT")
        modem.send(sender,PORT,"already registered",find_ip(CLIENTS,sender))
      end 
    elseif msg == "translate_address" then
      ans = find_table(CLIENTS,par)
      if ans == "not_found" then
        modem.send(sender,PORT,"not_found")
      else
        print(msg.."=>"..ans)
        modem.send(sender,PORT,NETWORK.."."..ans)
      end      
    else
      print("?")
      modem.send(sender,PORT,"error - wrong argument")
    end 
  end
end

dhpc()