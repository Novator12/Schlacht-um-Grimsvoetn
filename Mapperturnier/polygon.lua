

function CreatePolygon()
	local xpoly1, ypoly1 = Logic.GetEntityPosition(GetID("Poly1"))
	local xpoly2, ypoly2 = Logic.GetEntityPosition(GetID("Poly2"))
	local xpoly3, ypoly3 = Logic.GetEntityPosition(GetID("Poly3"))
	local xpoly4, ypoly4 = Logic.GetEntityPosition(GetID("Poly4"))
	local xpoly5, ypoly5 = Logic.GetEntityPosition(GetID("Poly5"))
	local xpoly6, ypoly6 = Logic.GetEntityPosition(GetID("Poly6"))
	local xpoly7, ypoly7 = Logic.GetEntityPosition(GetID("Poly7"))
	Polygon1 = Polygon.New(
		{X=xpoly1,Y=ypoly1},
		{X=xpoly2,Y=ypoly2}, 
		{X=xpoly3,Y=ypoly3}, 
		{X=xpoly4,Y=ypoly4}, 
		{X=xpoly5,Y=ypoly5},
		{X=xpoly6,Y=ypoly6},
		{X=xpoly7,Y=ypoly7})
	if EnableLavaDamage == true then
	LavaTrigger = Trigger.RequestTrigger(Events.LOGIC_EVENT_ENTITY_CREATED,nil,"CheckForEntityInPolygon",1)
	elseif EnableLavaDamage == false and LavaTrigger ~= nil then
		Trigger.UnrequestTrigger(LavaTrigger)
	end
end

function CheckForEntityInPolygon()
	if EnableLavaDamage == true then
		local entityID = Event.GetEntityID()
		local playerID = Logic.EntityGetPlayer(entityID)
		if playerID == 1 then
			local xPos, yPos = Logic.GetEntityPosition(entityID)
			local entityTable = {X= xPos,Y=yPos}
			local entityName = Logic.GetEntityTypeName(Logic.GetEntityType(entityID))
			if Polygon1:IsPointInside(entityTable) == 1 and Logic.IsBuilding(entityID) == 1 and (string.find(entityName,"PB") ~= nil or string.find(entityName,"CB") ~= nil ) then
				Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,nil,"EntityHurtHandler",1,nil,{entityID})
				Message("Achtung: Es wurde ein Gebäude innerhalb der Lava gebaut!")
			elseif Polygon1:IsPointInside(entityTable) == 1 and Logic.IsSettler(entityID) == 1 and (string.find(entityName,"PU") ~= nil or string.find(entityName,"CU") ~= nil or string.find(entityName,"PV") ~= nil ) then
				Trigger.RequestTrigger(Events.LOGIC_EVENT_EVERY_SECOND,nil,"EntityHurtHandler",1,nil,{entityID})
			end
		end
	end
end


function EntityHurtHandler(entityID)
	local eID = entityID
	if IsAlive(eID) then
		Logic.HurtEntity(eID,30)
		return false
	elseif IsDead(eID) then
		return true
	end
end











--- author:mcb		current maintainer:mcb		v1.0
-- Einfache Lua OOP implementierung eines Polygons mit Punkttests.
-- 
-- Polygon.New(...)					Erzeugt ein neues Polygon mit aus den Vorgegebenen Punkten.
-- 											Aufeinanderfolgende Punkte sowie der erste und letzte sind verbunden.
-- 
-- Polygon:GetDistanceToPoint(p)	Gibt die absolute Entfernung eines Punktes zur Polygon Außenseite.
-- Polygon:IsPointInside(p)			Gibt zurück, ob der Punkt im Polygon liegt. (-1->außen, 1->innen, 0->auf der Kante)
-- Polygon:Reverse()				Tauscht innen/außen des Polygons.
-- Polygon:GetModifiedDistance(p)	Gibt die modifizierte Entfernung zum Polynom zurück (<0->innen, >0->außen, ==0->Kante).
-- 
-- Benötigt:
-- - CopyTable
-- - Vector
-- - GetDistance
Polygon = {}

function Polygon.New(...)
	local t = CopyTable(Polygon)
	t.points = {}
	for k,v in ipairs(arg) do
		if IsValid(v) then
			t.points[k] = GetPosition(v)
		else
			t.points[k] = v
		end
	end
	t.reversed = 1
	return t
end

function Polygon:GetDistanceToPoint(p)
	local d, ind = nil, nil
	for i=1,table.getn(self.points) do
		local a = self.points[i]
		local b = self.points[i+1] or self.points[1]
		local d2 = self:GetLinePointDistance(a, b, p)
		if (not d) or d>d2 then
			d = d2
			ind = i
		end
	end
	return d, ind
end

function Polygon:IsPointInside(p)
	local t = -1
	for i=1,table.getn(self.points) do
		local a = self.points[i]
		local b = self.points[i+1] or self.points[1]
		t = t * self:IsPointInsideDotTest(p, a, b)
		if t==0 then
			return 0
		end
	end
	return t * self.reversed
end

function Polygon:Reverse()
	self.reversed = self.reversed * -1
end

function Polygon:GetModifiedDistance(p)
	local d, ind = self:GetDistanceToPoint(p)
	return d * self:IsPointInside(p) * -1, ind
end

function Polygon:GetLinePointDistance(p1, p2, p)
	local v = Vector.New({p2.X-p1.X, p2.Y-p1.Y})
	local w = Vector.New({p.X-p1.X, p.Y-p1.Y})
	
	local c1 = w:Dot(v)
	if c1 <= 0 then
		return GetDistance(p, p1)
	end
	
	local c2 = v:Dot(v)
	if c2 <= c1 then
		return GetDistance(p, p2)
	end
	
	local b = c1 / c2
	local pb = Vector.New({p1.X, p1.Y}) + b * v
	return GetDistance(p, pb)
end

function Polygon:IsPointInsideDotTest(a, b, c)
	if a.Y == b.Y and a.Y == c.Y then
		if (b.X <= a.X and a.X <= c.X) or (c.X <= a.X and a.X <= b.X) then
			return 0
		else
			return 1
		end
	end
	if a.X==b.X and a.Y==b.Y then
		return 0
	end
	if b.Y > c.Y then
		b, c = c, b
	end
	if a.Y <= b.Y or a.Y > c.Y then
		return 1
	end
	local d = (b.X-a.X) * (c.Y-a.Y) - (b.Y-a.Y) * (c.X-a.X)
	if d > 0 then
		return -1
	elseif d < 0 then
		return 1
	else
		return 0
	end
end



--- author:???		current maintainer:mcb		v1.0
-- Berechnet die Entfernung zwischen 2 Punkten/Positionen.
function GetDistance(_pos1,_pos2)
    if (type(_pos1) == "string") or (type(_pos1) == "number") then
        _pos1 = GetPosition(_pos1);
    end
    assert(type(_pos1) == "table");
    if (type(_pos2) == "string") or (type(_pos2) == "number") then
        _pos2 = GetPosition(_pos2);
    end
    assert(type(_pos2) == "table");
    local xDistance = (_pos1.X - _pos2.X);
    local yDistance = (_pos1.Y - _pos2.Y);
    return math.sqrt((xDistance^2) + (yDistance^2));
end


--- author:mcb		current maintainer:mcb		v1.2
-- 
-- metatable.set(table, metatable) anstatt setmetatable verwenden.
-- Automatische Speicherung und Wiederherstellung nach dem Laden.
-- metatable == nil löscht aus der Wiederherstellung und entfernt metatable.
-- Ist ein table nur noch im Speicher für die Wiederherstellung, wird es trotzdem vom gc gelöscht (weak table).
-- Achtung, im Gegensatz zu setmetatable, wird das metatable kopiert, nicht referenziert!
-- 
---@diagnostic disable-next-line: lowercase-global
metatable = {weak = {}, metas = {}, key = 0}
function metatable.set(tab, meta)
	assert(type(tab)=="table", "metatables koennen nur fuer tables gesetzt werden! "..tostring(tab))
	assert(type(meta)=="table" or meta==nil, "metatable muss table oder nil sein! "..tostring(meta))
	if not metatable.Mission_OnSaveGameLoaded then -- erster Aufruf: init Loaded-Callback & weak table
		metatable.Mission_OnSaveGameLoaded = Mission_OnSaveGameLoaded
		Mission_OnSaveGameLoaded = function()
			metatable.Mission_OnSaveGameLoaded()
			metatable.recreate()
		end
		metatable.recreate()
	end
	local oldmeta = meta -- nötig für keySave bei verschiedenen tables mit demselben metatable
	meta = {}
	for k,v in pairs(oldmeta) do
		meta[k] = v
	end
	oldmeta = getmetatable(tab)
	setmetatable(tab, meta) -- setze metatable
	--metatable.weak[tab] = CopyTable(meta)   fehler!!! key = table => absturz!!!
	local k = 0
	if oldmeta and oldmeta.keySave and tab == metatable.weak[oldmeta.keySave] then -- hatte vorher schon metatable => alter key
		k = oldmeta.keySave
		if meta == nil then -- löschen!
			metatable.weak[k] = nil
			metatable.metas[k] = nil
			return
		end
	else -- neuer key
		k = metatable.key + 1
		metatable.key = k
	end
	metatable.weak[k] = tab
	metatable.metas[k] = meta
	meta.keySave = k
end
metatable.recreate = function()
	for k, tab in pairs(metatable.weak) do
		setmetatable(tab, metatable.metas[k])
	end
	setmetatable(metatable.weak, {__mode = "v"}) -- weak table => wird gelöscht, wenn value nur noch dort referenziert ist
	setmetatable(metatable.metas, {__mode = "v"})
end


--- author: Noigi?		current maintainer: mcb		v2.0
--  kopiert ein table.
-- referenzerhaltend/metatablekopierend
function CopyTable(_t, ref)
	ref = ref or {}
	if type(_t) == "table" then
		if ref[_t] then
			return ref[_t]
		end
		local r = {}
		ref[_t] = r
		for k,v in pairs(_t) do
			r[k] = CopyTable(v, ref)
		end
		local mt = getmetatable(_t)
		if mt then
			if metatable then
				mt = CopyTable(mt, ref)
				mt.keySave = nil
				metatable.set(r, mt)
			else
				setmetatable(r, CopyTable(mt, ref))
			end
		end
		return r
	else
		return _t
	end
end


--- author:mcb		current maintainer:mcb		v1.0
-- Einfache lua Vektorimplementierung mittels OOP.
-- 
-- Vector.New(d)					Erzeugt einen neuen Vektor mit dem table d als Elemente.
-- Vector:Size()					Gibt zurück, wie lang der Vektor ist.
-- Vector:Add(v)					Addiert 2 Vektoren.
-- Vector:SkalarMultiplication(s)	Skalarmultiplikation.
-- Vector:Dot(v)					Skalarprodukt.
-- Vector:MakeSavegameCompatible()	Macht diesen Vektor über den metatable fix Savegamesicher.
-- 
-- Über metatable definiert:		*, -, +, .x, .y, .z
-- 
-- Benötigt:
-- - CopyTable
-- - metatable-fix (nur wenn vektoren gespeichert werden sollen)
Vector = {}

function Vector.New(d)
	local t = CopyTable(Vector)
	t.data = d
	setmetatable(t, Vector.mt)
	return t
end

function Vector:Size()
	return table.getn(self.data)
end

function Vector:Add(v)
	assert(self:Size()==v:Size())
	local newd = {}
	for i,d in ipairs(self.data) do
		newd[i] = d + v.data[i]
	end
	return Vector.New(newd)
end

function Vector:SkalarMultiplication(s)
	local newd = {}
	for i,d in ipairs(self.data) do
		newd[i] = d * s
	end
	return Vector.New(newd)
end

function Vector:Dot(v)
	assert(self:Size()==v:Size())
	local newd = 0
	for i,d in ipairs(self.data) do
		newd = newd + d * v.data[i]
	end
	return newd
end

function Vector:MakeSavegameCompatible()
	setmetatable(self, nil)
	metatable.set(self, Vector.mt)
end

Vector.mt = {
	__add = function(a, b)
		return a:Add(b)
	end,
	__mul = function(a, b)
		if type(a)=="table" and type(b)=="number" then
			return a:SkalarMultiplication(b)
		elseif type(b)=="table" and type(a)=="number" then
			return b:SkalarMultiplication(a)
		else
			assert(false, "Vector-Vector multiplocation not implemented!")
		end
	end,
	__sub = function(a, b)
		return a + (-b)	-- forward to unm and add
	end,
	__unm = function(a)
		return -1 * a	-- forward to scalar mult
	end,
	__index = function(s, i)		-- allow numeric index acces to members
		if type(i)=="number" then
			return rawget(s, "data")[i]
		elseif i=="x" or i=="X" then
			return rawget(s, "data")[1]
		elseif i=="y" or i=="Y" then
			return rawget(s, "data")[2]
		elseif i=="z" or i=="Z" then
			return rawget(s, "data")[3]
		else
			return rawget(s, i)
		end
	end,
	__newindex = function(s, i, d)		-- allow numeric index acces to members
		if type(i)=="number" then
			rawget(s, "data")[i] = d
		elseif i=="x" or i=="X" then
			rawget(s, "data")[1] = d
		elseif i=="y" or i=="Y" then
			rawget(s, "data")[2] = d
		elseif i=="z" or i=="Z" then
			rawget(s, "data")[3] = d
		else
			return rawset(s, i, d)
		end
	end,
}
