local modem = require("component").modem
local event = require("event")
local table = require("table")

local function request(port)
  modem.open(port)
  modem.broadcast(port,"request_address")  
  _,_,sender,_,_,msg,ip = event.pull("modem_message")
  modem.close(port)
  return msg,ip
end

local function translate(port,ip)
  modem.open(port)
  modem.broadcast(port,"translate_address",ip)
  _,_,sender,_,_,msg = event.pull("modem_message")
  modem.close(port)
  return msg
end

local function send(ip,port,...)
  require("component").modem.open(port)
  require("component").modem.send(translate(port,ip),port,...)
end

local function get_index(port)
  require("component").modem.open(port)
  require("component").modem.broadcast(port,"get_index")
  data = table.pack(event.pull("modem_message"))
  result = table.pack()
  result["ips"] = table.pack()
  for x,y in pairs(data) do
    if x ~="n" then
      if x==6 then
        result["network"]=y
      elseif x>6 then
        table.insert(result["ips"],y)
      end
    end
  end
  return result
end

return {["request"]=request,["translate"]=translate,["send"]=send,["get_index"]=get_index}