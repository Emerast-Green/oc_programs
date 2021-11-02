local modem = require("secure_modem")
local com   = require("component")
local filesystem = com.filesystem
local thread = require("thread")
local pro = require("programs")
local os = require("os")

PORT = 340
modem.open(PORT)

local CLIENTS = table.pack()
--print(CLIENTS.n)
local function recver()
  while true do
    _,_,ip,port,_,dt = modem.recv()
    os.sleep(0.1)
    if dt[1] == "download" then
      print("checking /files/"..dt[2])
      if filesystem.exists("/files/"..dt[2]) then
        local lines = table.pack(table.unpack(({pro.getlines("/files/"..dt[2])})[1]))
        print("found",lines.n)
        modem.send(ip,port,"true",lines.n)
        table.insert(lines,">end<")
        table.insert(CLIENTS,{[1]=ip,[2]=lines})
        CLIENTS = table.pack(table.unpack(CLIENTS))
--        print("CLIENTS.n ",CLIENTS.n)
      else
        modem.send(ip,port,"false","no file")
      end
    end
  end
end

rec = thread.create(recver)

while true do
  os.sleep(0.1)
  if CLIENTS.n > 0 then
    for nr,dt_ in pairs(CLIENTS) do
      if nr ~= "n" then
    --  print("nr",nr)
  --    print("dt",dt_)
--      print("dt",table.concat(dt_[2],","))
      modem.send(dt_[1],PORT,"packet",dt_[2][1])
      --print("send",dt_[2][1])
      table.remove(CLIENTS[nr][2],1)
      if dt_[2][1] == ">end<" then
        modem.send(dt_[1],PORT,">end<","file send")
        table.remove(CLIENTS,nr)
      end
      end
    end
  else
  --  print(CLIENTS.n)
  end
end