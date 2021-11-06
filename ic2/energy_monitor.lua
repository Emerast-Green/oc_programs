local drivers = require("gehenna_drivers")
local gpu = require("gpu")
require("shell").execute("resolution 100 30")
local math = require("math")

while true do
    n,t,p = drivers.ic2_te_mfsu.get_status()
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