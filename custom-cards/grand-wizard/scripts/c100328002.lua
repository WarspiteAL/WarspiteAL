--Grand Wizard - Remi & Rami

--scripted by Warspite
if not grand then Duel.LoadScript("Grand Wizard.lua") end
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x301,LOCATION_MZONE)
	--register grand counter
	aux.RegisterGrandCounter(c,0x301,1)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(aux.countercost(1,0x301))
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
end
s.listed_series={0x600f}
s.counter_place_list={0x301}
function s.setfilter(c)
	return c:IsSetCard(0x600f) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	local c=e:GetHandler()
	if tc then
		Duel.SSet(tp,tc)
		aux.GrandSpLimit(c,tp,s.splimit)
	end
end
function s.splimit(e,c)
	return not c:IsRace(RACE_SPELLCASTER)
end