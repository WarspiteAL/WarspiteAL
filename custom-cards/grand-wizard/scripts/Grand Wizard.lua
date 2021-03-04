
--adding aux.RegisterGrandCounter
--parameter guide
--c: a card to activate this function
--counter: this is not only for grand wizard, and the counter is your (setcard)
--counter: the amount of counter that will place it
function Auxiliary.RegisterGrandCounter(c,counter,count)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_SSET)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(Auxiliary.addcon)
	e1:SetOperation(Auxiliary.addop(counter,count))
	c:RegisterEffect(e1)
end
function Auxiliary.addcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function Auxiliary.addop(counter,count)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				e:GetHandler():AddCounter(counter,count)
			end
end

--handle the counter cost function for Grand Wizard
--parameter guide
--minc: it's a minimum the card itself
--minc: this is not only for grand wizard, and the counter is your (setcard)
function Auxiliary.countercost(minc,counter)
	if minc==min then minc=minc end
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
				local c=e:GetHandler()
				if chk==0 then return c:IsCanRemoveCounter(tp,counter,minc,REASON_COST) end
				c:RemoveCounter(tp,counter,minc,REASON_COST)
			end
end

--adding aux.GrandSpLimit
--parameter guide
--c: a card to activate this function
--tp: the player conduting the summon
--valid: it is your special summon limit function
function Auxiliary.GrandSpLimit(c,tp,valid)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(valid)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

--adding Grand.CreateWizardFusion
--note: that this function is not fully implementation
--parameter guide
--c: a card to activate this function
--stage1: after the fusion summoned you can apply the operation of it, and if it is not, use nil instead
Grand = {}
function Grand.CreateWizardFusion(c,stage1)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(Grand.FStarget)
	e1:SetOperation(Grand.FSactivate(stage1))
	return e1
end
function Grand.fusionfilter(c,e,tp)
	return c:IsSetCard(0x600f) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,false)
end
function Grand.FStarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Grand.fusionfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(Grand.fusionlistedfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function Grand.fusionlistedfilter(c)
	return c:IsSetCard(0x600f) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function Grand.FSactivate(stage1)
	return	function(e,tp,eg,ep,ev,re,r,rp)
				local check=Duel.GetMatchingGroup(Grand.fusionfilter,tp,LOCATION_EXTRA,0,nil,e,tp) 
				local fg=check:Select(tp,1,1,nil):GetFirst() 
				if fg and fg:IsCode(100328004) then
					local mg=Duel.SelectMatchingCard(tp,Grand.fusionlistedfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,2,2,nil)
					Duel.SendtoGrave(mg,REASON_EFFECT+REASON_MATERIAL)
				end
				Duel.SpecialSummon(fg,SUMMON_TYPE_FUSION,tp,tp,true,false,POS_FACEUP)
				if stage1 then
					stage1(e,tp,eg,ep,ev,re,r,rp)
				else
					return false
				end
			end
end
