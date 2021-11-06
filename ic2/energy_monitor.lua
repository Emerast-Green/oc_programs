local power_api = require("gehenna_ic2_api")
local gpu = require("gpu")
require("shell").execute("resolution 100 30")
local math = require("math")

while true do
    n,t,p = power_api.get_status()
    n = math.floor(n)
    t = math.floor(t)
    p = math.floor(p)
    gpu.set(1,8,100,2," ")
    gpu.set(1,8,p.."%")
    gpu.set(1,9,n.."/"..t)
    gpu.set(1,10,100,10,"|")
    gpu.set(p,10,100-p,10," ")
    os.sleep(.5)
end