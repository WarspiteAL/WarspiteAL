--Grand Wizard - Grand Fusion

--scripted by Warspite
if not grand then Duel.LoadScript("Grand Wizard.lua") end
local s,id=GetID()
function s.initial_effect(c)
	--grand fusion proc
	c:RegisterEffect(Grand.CreateWizardFusion(c,stage1))
	--activate in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
end
s.listed_series={0x600f}
s.counter_place_list={0x301}
function stage1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.FilterFaceupFunction(Card.IsSetCard,0x600f),tp,LOCATION_MZONE,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		g:ForEach(Card.AddCounter,0x301,1)
	end
end
function s.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x600f)
end
function s.handcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.cfilter,0,LOCATION_MZONE,0,1,nil)
end