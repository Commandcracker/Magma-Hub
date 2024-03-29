-- Those Who Remain
local Page = MagmaHub:addPage("Those Who Remain")

Page:addButton("Disable Zombie Damage", function()
    return (function(n, a, l, F, e, o)
        local o = o;
        local k = getfenv or function()
            return _ENV
        end;
        local o = setmetatable;
        local h = e.byte;
        local N = unpack or table.unpack;
        local b = select;
        local d = e.sub;
        local s = n;
        local i = e.char;
        local f = a;
        local r = {}
        for l = 0, 255 do
            r[l] = i(l)
        end
        local function u(t)
            local n, o, a = "", "", {}
            local c = 256;
            local e = l;
            local function h()
                local n = f(d(t, e, e), 36)
                e = e + l;
                local l = f(d(t, e, e + n - l), 36)
                e = e + n;
                return l
            end
            n = i(h())
            a[l] = n;
            while e < #t do
                local e = h()
                if r[e] then
                    o = r[e]
                else
                    o = n .. d(n, l, 1)
                end
                r[c] = n .. d(o, l, 1)
                a[#a + l], n, c = o, o, c + l
            end
            return s(a)
        end
        local u = u(
            '22M22M22N27622L22I27622N21B21O21Q21F21F22N22J27A22522H22N22R23D27627527722D27M23D27Q27A27A27N27722N27Q22K27T27P27A27V27H22N22L27I27621K21Q21E21M22L22G27A1F21F21Q21221M21921822L22C27A1J21C27D21F28J28L28N22L22E27A1S21J21Q21921Q21O21728Z2792761U21921E21C21927829221F21C21D28F27L2761F29521M21D21728G27A1R21M21821721921C21222N22B27J22728328027A23J27627Y27A22L22N2AB2A82762822AH2AD27627I2AL27O27A2792AP27V29O2AC27U2882AY2AP2AF27628H2A727T27528H2AF2B027A22F27W27N2AF2AF2862AD28627A2A527Z2BL2AY2BM2B122N2822AJ27A28A28727629B22N2BX2AV2BU2AU28527A2AV');
        local c = (bit or bit32) and (bit or bit32).bxor or function(e, n)
            local l, o = l, 0
            while e > 0 and n > 0 do
                local c, a = e % 2, n % 2
                if c ~= a then
                    o = o + l
                end
                e, n, l = (e - c) / 2, (n - a) / 2, l * 2
            end
            if e < n then
                e = n
            end
            while e > 0 do
                local n = e % 2
                if n > 0 then
                    o = o + l
                end
                e, l = (e - n) / 2, l * 2
            end
            return o
        end
        local function a(n, e, o)
            if o then
                local e = (n / 2 ^ (e - l)) % 2 ^ ((o - l) - (e - l) + l);
                return e - e % l;
            else
                local e = 2 ^ (e - l);
                return (n % (e + e) >= e) and l or 0;
            end
        end
        local e = l;
        local function n()
            local a, n, l, o = h(u, e, e + 3);
            a = c(a, 95)
            n = c(n, 95)
            l = c(l, 95)
            o = c(o, 95)
            e = e + 4;
            return (o * F) + (l * 65536) + (n * 256) + a;
        end
        local function t()
            local n, l = h(u, e, e + 2);
            n = c(n, 95)
            l = c(l, 95)
            e = e + 2;
            return (l * 256) + n;
        end
        local function i()
            local n = c(h(u, e, e), 95);
            e = e + l;
            return n;
        end
        local function F(...)
            return {...}, b('#', ...)
        end
        local function L()
            local N = {};
            local s = {};
            local b = {};
            local A = {
                [7] = b,
                [l] = nil,
                [3] = s,
                [4] = nil,
                [5] = N
            };
            local f = {}
            for A = l, i() == 0 and t() * 2 or n() do
                local o = i();
                while true do
                    if (o == 2) then
                        local n, t, a = '', n();
                        if (t == 0) then
                            o = n;
                            break
                        end
                        a = d(u, e, e + t - l);
                        e = e + t;
                        for l = l, #a do
                            n = n .. r[c(h(d(a, l, l)), 95)]
                        end
                        o = n
                        break
                    end
                    if (o == l) then
                        local n, e = n(), n();
                        local c, a, e, n = l, (a(e, l, 20) * (2 ^ 32)) + n, a(e, 21, 31), ((-l) ^ a(e, 32));
                        if e == 0 then
                            if a == 0 then
                                o = n * 0
                                break
                            else
                                e = l;
                                c = 0;
                            end
                        elseif (e == 2047) then
                            o = (n * ((a == 0 and l or 0) / 0))
                            break
                        end
                        o = (n * (2 ^ (e - 1023))) * (c + (a / (2 ^ 52)));
                        break
                    end
                    if (o == 0) then
                        o = (i() ~= 0);
                        break
                    end
                    o = nil
                    break
                end
                f[A] = o;
            end
            A[4] = i();
            for d = l, n() do
                local e = i();
                if (a(e, l, l) == 0) then
                    local r, h, i = t(), t(), t();
                    local o = a(e, 2, 3);
                    local c = a(e, 4, 6);
                    local e = {
                        [4] = h,
                        [7] = i,
                        [2] = nil,
                        [l] = r
                    };
                    if (o == 2) then
                        e[4] = n() - 65536
                    end
                    if (o == 0) then
                        e[4], e[2] = t(), t()
                    end
                    if (o == l) then
                        e[4] = n()
                    end
                    if (o == 3) then
                        e[4], e[2] = n() - 65536, t()
                    end
                    if (a(c, 2, 2) == l) then
                        e[4] = f[e[4]]
                    end
                    if (a(c, l, l) == l) then
                        e[7] = f[e[7]]
                    end
                    if (a(c, 3, 3) == l) then
                        e[2] = f[e[2]]
                    end
                    s[d] = e;
                end
            end
            for e = l, n() do
                N[e - l] = L();
            end
            for l = l, n() do
                b[l] = n();
            end
            return A;
        end
        local s = pcall
        local function i(d, e, r)
            local a = d[3];
            local t = d[l];
            local n = d[5];
            local e = d[4];
            return function(...)
                local o = l;
                local c = -l;
                local h = {...};
                local f = b('#', ...) - l;
                local function u()
                    local c = a;
                    local a = t;
                    local t = n;
                    local a = e;
                    local e = F
                    local d = {};
                    local e = {};
                    local n = {};
                    for e = 0, f do
                        if (e >= a) then
                            d[e - a] = h[e + l];
                        else
                            n[e] = h[e + l];
                        end
                    end
                    local e = f - a + l
                    local e;
                    local a;
                    while true do
                        e = c[o];
                        a = e[l];
                        if a <= 7 then
                            if a <= 3 then
                                if a <= l then
                                    if a > 0 then
                                        n[e[7]] = n[e[4]][e[2]];
                                    else
                                        local e = e[7]
                                        n[e](n[e + l])
                                    end
                                elseif a == 2 then
                                    n[e[7]] = r[e[4]];
                                else
                                    do
                                        return
                                    end
                                end
                            elseif a <= 5 then
                                if a == 4 then
                                    n[e[7]][e[4]] = n[e[2]];
                                else
                                    do
                                        return
                                    end
                                end
                            elseif a > 6 then
                                n[e[7]] = n[e[4]][e[2]];
                            else
                                n[e[7]] = r[e[4]];
                            end
                        elseif a <= 11 then
                            if a <= 9 then
                                if a == 8 then
                                    local e = e[7]
                                    n[e] = n[e](n[e + l])
                                else
                                    local o = e[7];
                                    local a = n[e[4]];
                                    n[o + l] = a;
                                    n[o] = a[e[2]];
                                end
                            elseif a > 10 then
                                n[e[7]] = i(t[e[4]], nil, r);
                            else
                                n[e[7]] = i(t[e[4]], nil, r);
                            end
                        elseif a <= 13 then
                            if a == 12 then
                                local e = e[7]
                                n[e](n[e + l])
                            else
                                local e = e[7]
                                n[e] = n[e](n[e + l])
                            end
                        elseif a <= 14 then
                            local a = e[7];
                            local o = n[e[4]];
                            n[a + l] = o;
                            n[a] = o[e[2]];
                        elseif a == 15 then
                            n[e[7]][e[4]] = n[e[2]];
                        else
                            local t;
                            local a;
                            n[e[7]] = r[e[4]];
                            o = o + l;
                            e = c[o];
                            n[e[7]] = n[e[4]][e[2]];
                            o = o + l;
                            e = c[o];
                            n[e[7]] = n[e[4]][e[2]];
                            o = o + l;
                            e = c[o];
                            n[e[7]] = n[e[4]][e[2]];
                            o = o + l;
                            e = c[o];
                            n[e[7]] = n[e[4]][e[2]];
                            o = o + l;
                            e = c[o];
                            a = e[7];
                            t = n[e[4]];
                            n[a + l] = t;
                            n[a] = t[e[2]];
                            o = o + l;
                            e = c[o];
                            a = e[7]
                            n[a] = n[a](n[a + l])
                            o = o + l;
                            e = c[o];
                            n[e[7]] = n[e[4]][e[2]];
                            o = o + l;
                            e = c[o];
                            n[e[7]][e[4]] = n[e[2]];
                            o = o + l;
                            e = c[o];
                            a = e[7];
                            t = n[e[4]];
                            n[a + l] = t;
                            n[a] = t[e[2]];
                            o = o + l;
                            e = c[o];
                            a = e[7]
                            n[a](n[a + l])
                            o = o + l;
                            e = c[o];
                            do
                                return
                            end
                        end
                        o = o + l;
                    end
                end
                A, B = F(s(u))
                if not A[l] then
                    local l = d[7][o] or '?'
                    error('ERROR IN IRONBREW SCRIPT [LINE ' .. l .. ']:\n' .. A[2])
                else
                    return N(A, 2, B)
                end
            end;
        end
        return N({i(L(), {}, k())()}) or nil;
    end)(table.concat, tonumber, 1, 16777216, string, table.insert)
end)
