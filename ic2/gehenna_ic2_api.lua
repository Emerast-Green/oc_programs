local function get_status()
    now = 0
    top = 0
    for x,y in pairs(require("component").list("ic2_te_mfsu")) do
        now = now + require("component").proxy(x).getEnergy()
        top = top + require("component").proxy(x).getCapacity()
    end
    return now, top, (now/top)*100
end

return {["get_status"]=get_status}
