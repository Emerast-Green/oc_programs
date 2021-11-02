reactor  = require("component").reactor_chamber
redstone = require("component").redstone

timeout = 0

while true do
  os.sleep(1)
  if timeout>0 then timeout=timeout-1 end
  if reactor.getHeat()>0 then
    print("REACTOR OFF")
    redstone.setOutput(5,0)
    timeout = 20
    print("timeout "..timeout)
  else
    if timeout>0 then
      print("timeout "..timeout)
    else
      print("REACTOR ON")
      redstone.setOutput(5,1)
    end 
  end
end