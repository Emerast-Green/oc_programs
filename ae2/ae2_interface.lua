gpu = require("component").gpu
pro = require("programs")
mec = require("component").me_controller
event = require("event")
keyboard = require("keyboard")
computer = require("computer")
cursor = 1
local run = true
craft_data = pro.organizetable(mec.getCraftables())

local function update()
  print(cursor)
end

local function gpu_cupdate()
  gpu.fill(1,2,1,50," ")
  gpu.set(1,cursor+1,">")
end

local function move() 
  update = false
  _,_,_,key = event.pull("key_down")
  if key == 208 then cursor = cursor + 1 update = true end -- arrow down moves cursor +1
  if key == 200 then cursor = cursor - 1 update = true  end -- arrow up   moves cursor -1
  if key ==  28 then craft_data[cursor].request() computer.beep() end
  if key == 16 then run = false end
  if cursor<1 then cursor = 1 end
  if cursor>craft_data.n then cursor=craft_data.n end
  if update then gpu_cupdate() end
end
-- READY SCREEN
gpu.fill(0,0,120,60," ")
local tmp = 1
while tmp<craft_data.n+1 do
  gpu.set(3,tmp+1,tmp.." "..craft_data[tmp].getItemStack()["label"])
  tmp=tmp+1
end
gpu_cupdate()
gpu.set(1,25,"q-quit up/down-move enter-request")
-- MAIN LOOP
while run do
  move()
end
gpu.fill(0,0,120,60," ")
require("shell").execute("clear")
return 0