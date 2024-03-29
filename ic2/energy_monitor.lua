local drivers = require("gehenna_drivers")
local gpu = require("component").gpu
require("shell").execute("resolution 100 30")
local math = require("math")

gpu.fill(1,1,100,30," ")
gpu.set(24,20,"^")
gpu.set(49,20,"^")
gpu.set(74,20,"^")
o = 0
while true do
    n,t,p = drivers.ic2_te_mfsu.get_status()
    n = math.floor(n)
    t = math.floor(t)
    p = math.floor(p)
    gpu.fill(1,8,100,2," ")
    gpu.set(1,8,p.."%")
    gpu.set(15,8,n-o.."")
    gpu.set(1,9,n.."/"..t)
    gpu.fill(1,10,100,10,"|")
    gpu.fill(p,10,101-p,10," ")
    os.sleep(.5)
    o = n
end