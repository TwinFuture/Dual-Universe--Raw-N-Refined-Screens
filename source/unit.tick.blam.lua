local ores = {
    {
        {'Quartz',2.65,'rgba(0,255,255','Silicon',2.33,'rgba(0,255,255'},
        {'Bauxite',1.28095,'rgba(191,166,166','Aluminium',2.70,'rgba(191,166,166'},
        {'Coal',1.346,'rgba(54,69,79','Carbon',2.27,'rgba(54,69,79'},
        {'Hematite',5.04,'rgba(255,255,0','Iron',7.85,'rgba(255,255,0'}
    },
    {
        {'Malachite',4.0,'rgba(200,128,51','Copper',8.96,'rgba(200,128,51'},
        {'Limestone',2.7108,'rgba(61,255,0','Calcium',1.55,'rgba(61,255,0'},
        {'Natron',1.55,'rgba(171,92,242','Sodium',0.97,'rgba(171,92,242'},
        {'Chromite',4.54,'rgba(138,153,199','Chromium',7.19,'rgba(138,153,199'}
    },
    {
        {'Acanthite',7.2,'rgba(192,192,192','Silver',10.49,'rgba(192,192,192'},
        {'Garnierite',2.6,'rgba(80,208,80','Nickel',8.91,'rgba(80,208,80'},
        {'Pyrite',5.01,'rgba(255,255,48','Sulfur',1.82,'rgba(255,255,48'},
        {'Petalite',2.41,'rgba(204,128,255','Lithium',0.53,'rgba(204,128,255'}
    },
    {
        {'Cobaltite',6.33,'rgba(240,144,160','Cobalt',8.90,'rgba(240,144,160'},
        {'Cryolite',2.95,'rgba(144,224,80','Fluorine',1.70,'rgba(144,224,80'},
        {'Kolbeckite',2.37,'rgba(230,230,230','Scandium',2.98,'rgba(230,230,230'},
        {'Gold Nuggets',19.3,'rgba(255,209,35','Gold',19.30,'rgba(255,209,35'}
    },
    {
        {'Columbite',5.38,'rgba(155,194,201','Niobium',8.57,'rgba(155,194,201'},
        {'Illmenite',4.55,'rgba(191,194,199','Titanium',4.51,'rgba(191,194,199'},
        {'Vanadinite',6.95,'rgba(166,166,171','Vanadium',6.0,'rgba(166,166,171'},
        {'Rhodonite',3.76,'rgba(156,122,199','Manganese',7.21,'rgba(156,122,199'},
        {'Thoramine',21.30,'rgba(255,0,0','?????????'}
    }
}
-- Simple rounding function needed later.
local round = function(number, decimals)
    local power = 10^decimals
    return math.floor(number * power) / power
end

local calc = function (maxHP, weight, mass)
    local containerProficiency = 30 --export
    local hubVol = 114400 --export
    local sizes = {
        -- Mining and Inventory, Inventory Manager, Container Proficiency.
        -- Containers, min - max Hitpoints, Base Volume, Base Weight
        -- TODO: Determing what size containers the Hub is connected to.
        -- for now its hardcoded, containers connected to hub x base volume.
        -- eg: medium, 64000 * 10 containers connected to hub
        {49.00,122.00,hubVol,55.80}, --Hub
        {123.00,998.00,1000,229.09}, --xs
        {998.00,7996.00,8000,1280}, --s
        {7996.00,17316.00,64000,7421.34}, --m
        {17316.00,50316.00,128000,14842.7} --l
    }
    for i = 1, #sizes do
        if (maxHP >= sizes[i][1] and maxHP <= sizes[i][2]) then
            local amount = (weight - sizes[i][4]) / mass
            -- we need to times the base volume by the proficiency modifier.
            local volume = sizes[i][3] + (sizes[i][3] * containerProficiency / 100)
            local percent = amount / volume
            -- Convert L to KL
            if amount > 999999 then
                amount = round(amount / 1000000, 2) .. 'ML'
            elseif amount > 999 then
                amount = round(amount / 1000, 2) .. 'KL'
            else
                amount = round(amount, 2) .. 'L'
            end
            if percent < 0.5 then
                -- I like red to blue....Empty -> half full.
                r = math.floor(255 *(1 - (percent) / 0.5) +0 * (percent) / 0.5)
                g = math.floor(0 *(1 - (percent) / 0.5) +0 * (percent) / 0.5)
                b = math.floor(0 *(1 - (percent) / 0.5) +255 * (percent) / 0.5)
            else
                -- then, blue to green, half full -> full.
                r = math.floor(0 *(1 - (percent - 0.5) / 0.5) +0 * (percent - 0.5) / 0.5)
                g = math.floor(0 *(1 - (percent - 0.5) / 0.5) +255 * (percent - 0.5) / 0.5)
                b = math.floor(255 *(1 - (percent - 0.5) / 0.5) +0 * (percent - 0.5) / 0.5)
            end
            percent = round(percent * 100, 1)
            return amount, percent, 'rgba('..r..','..g..','..b..',0.7)'
        end
    end
end
local outHTML = function(name, color, amount, percent, barColor)
    return [[<tr>
    <td class="name" style="border: 1px solid ]]..color..',1); background-color:'..color..', 0.6)">'..name..[[</td>
    <td class="amount" style="border: 1px solid ]]..color..',1); background-color:'..color..', 0.6)">'..amount..[[</td>
    <td class="percent" style="border: 1px solid ]]..color..[[,1);">
    <div class="bar" style="width: ]]..percent..'%; background-color: '.. barColor ..'">'..percent..[[%</div>
    </td>
    </tr>
    <tr class="blank"><td></td></tr>]]
end
local htmlHead, htmlFoot, eleIds, containers = [[<html><head><style>
    body {
        text-align:center
    }
    table {
        font-size:20px;
        float:left;
        width: calc(50% - 10px);
        margin:0 5px 10px 5px
    }
    .head {
        margin-top: -6px;
        font-size:50px;
        font-variant: small-caps;
        font-weight:bold
    }
    th, .head {
        background: -webkit-linear-gradient(white, #38495a);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        -webkit-text-stroke-width: 2px;
        -webkit-text-stroke-color: #fff
    }
    th {
        font-size:28px
    }
    td, .bar {
        text-shadow: 1px 1px #000, 2px 2px #000;
        background-image: linear-gradient(to bottom, rgba(255, 255, 255, 0.3), rgba(255, 255, 255, 0.05));
        box-shadow: 0 0 1px 1px rgba(0, 0, 0, 0.25), inset 0 1px rgba(255, 255, 255, 0.1);
        color:#fff
    }
    .name, .amount {
        width:26%
    }
    .percent {
        width:48%;
        font-family:bank;
        letter-spacing:-1px
    }
    .blank td {
        padding:2px
    }
</style></head><body>]], '</body></html>', core.getElementIdList(), {}
local htmlBody, htmlBody2 = '', ''
-- Grab and store all the containers into a table.
for i = 1, #eleIds do
    if core.getElementTypeById(eleIds[i]) == 'container'
    or core.getElementTypeById(eleIds[i]) == 'Hub Container' then
        local name = core.getElementNameById(eleIds[i])
        -- If not default container name, store.
        if not string.match(name, '%[') then
            -- Container name eg: Coal, Bauxite
            -- Name of containers, Max Hitpoints and Total Weight of container.
            table.insert(containers, {name, core.getElementMaxHitPointsById(eleIds[i]), core.getElementMassById(eleIds[i])})
        end
    end
end
htmlBody = htmlBody .. '<div class="head">Raw Ores</div>'
htmlBody2 = htmlBody2 .. '<div class="head">Refined Ores</div>'
-- Iterate through the list of ores so they display in order.
for i = 1, #ores do
    local style = ''
    if i == 5 then
        style = 'style="float:none;margin:0 auto"'
    end
    local head = '<table '.. style ..'><tbody><tr><th colspan=3>TIER '..i..'</th></tr>'
    htmlBody = htmlBody .. head
    htmlBody2 = htmlBody2 .. head
    local tiers = ores[i]
    for x = 1, #tiers do
        local oreName = tiers[x][1]
        local refinedName = tiers[x][4]
        for y = 1, #containers do
            local containerName = containers[y][1]
            -- Ores
            if containerName == oreName then
                local amount, percent, barColor = calc(containers[y][2], containers[y][3], tiers[x][2])
                htmlBody = htmlBody .. outHTML(oreName, tiers[x][3], amount, percent, barColor)
            end
            -- refined
            if containerName == refinedName then
                local amount, percent, barColor = calc(containers[y][2], containers[y][3], tiers[x][5])
                htmlBody2 = htmlBody2 .. outHTML(refinedName, tiers[x][6], amount, percent, barColor)
            end
        end
    end
    local foot = '</tbody></table>'
    htmlBody = htmlBody .. foot
    htmlBody2 = htmlBody2 .. foot
end
screen1.setHTML(htmlHead .. htmlBody .. htmlFoot)
screen2.setHTML(htmlHead .. htmlBody2 .. htmlFoot)