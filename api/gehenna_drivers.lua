-- ic2_te_mfsu
local function get_status()
    now = 0
    top = 0
    for x,y in pairs(require("component").list("ic2_te_mfsu")) do
        now = now + require("component").proxy(x).getEnergy()
        top = top + require("component").proxy(x).getCapacity()
    end
    return now, top, (now/top)*100
end

-- modem
local function send(ip,port,...)
    require("component").modem.open(55)
    require("component").modem.send(require("arp").translate(55,ip),port,...)
end

return {["ic2_te_mfsu"]={["get_status"]=get_status},["modem"]={["send"]=send}}
