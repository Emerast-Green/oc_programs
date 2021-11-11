local modem = require("component").modem
local event = require("event")

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

return {["request"]=request,["translate"]=translate}