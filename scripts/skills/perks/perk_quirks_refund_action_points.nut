this.perk_quirks_refund_action_points <- this.inherit("scripts/skills/skill", {
  m = {
    AttackFatigueCostMult = this.Const.Quirks.RefundActionPointsAttackFatigueCostMult,
    FatigueCostPerActionPoint = this.Const.Quirks.RefundActionPointsFatigueCostPerActionPoint,
    FatigueCostInSameTurnMult = this.Const.Quirks.FatigueCostInSameTurnMult,
    SkillCounterFatigueCostMap = {},
    SkillCounterActionPointsCostMap = {},
    EnabledSameTurnCount = 0
  }

  function create() {
    this.m.ID = "perk.quirks.refund_action_points";
    this.m.Name = this.Const.Strings.PerkName.QuirksRefundActionPoints;
    this.m.Icon = "ui/perks/perk_quirks_refund_action_points.png";
    this.m.Type = this.Const.SkillType.Perk;
    this.m.Order = this.Const.SkillOrder.Perk;
    this.m.IsActive = false;
    this.m.IsHidden = false;
  }

  function onTargetHit(_caller, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor) {
    this.m.SkillCounterFatigueCostMap[this.Const.SkillCounter] <- 0;
    this.m.SkillCounterActionPointsCostMap[this.Const.SkillCounter] <- 0;
  }

  function onTargetMissed(_skill, _targetEntity) {
    if (!(this.Const.SkillCounter in this.m.SkillCounterFatigueCostMap)) {
      this.m.SkillCounterFatigueCostMap[this.Const.SkillCounter] <-
        (_skill.isUsedForFree() ? 0 : _skill.getFatigueCost());
      this.m.SkillCounterActionPointsCostMap[this.Const.SkillCounter] <-
        (_skill.isUsedForFree() ? 0 : _skill.getActionPointCost());
      local tag = {
        Actor = this.getContainer().getActor(),
        SkillCounter = this.Const.SkillCounter,
        FatigueCostOnUse = _skill.getFatigueCost()
      };
      this.Time.scheduleEvent(this.TimeUnit.Virtual, 600, this.onTargedMissedCallback.bindenv(this), tag);
    }
  }

	function onTargedMissedCallback(_tag) {
		if ((_tag.SkillCounter in this.m.SkillCounterActionPointsCostMap) &&
    this.m.SkillCounterActionPointsCostMap[_tag.SkillCounter] > 0 && _tag.Actor.isAlive() &&
      this.Tactical.TurnSequenceBar.getActiveEntity().getID() == _tag.Actor.getID()) {
			enableRefundActionPointsSkill(
        this.m.SkillCounterFatigueCostMap[_tag.SkillCounter],
        this.m.SkillCounterActionPointsCostMap[_tag.SkillCounter],
        _tag.Actor);
		}
	}

  function enableRefundActionPointsSkill(fatigueCostOnUse, apCost, actor) {
    local active = this.new("scripts/skills/actives/quirks_refund_action_points_skill");
    active.setID("actives.quirks.refund_action_points" + this.m.EnabledSameTurnCount);
    active.setFatigueCost(this.Math.round(
      this.Math.pow(this.m.FatigueCostInSameTurnMult, this.m.EnabledSameTurnCount) *
      (fatigueCostOnUse * this.m.AttackFatigueCostMult + this.m.FatigueCostPerActionPoint * apCost)));
    active.setActionPontsRefund(apCost);
    this.getContainer().add(active);
    this.m.EnabledSameTurnCount += 1;
    this.spawnIcon("perk_quirks_refund_action_points", actor.getTile());
    actor.setDirty(true);
  }

  function onTurnStart() {
    this.m.SkillCounterFatigueCostMap = {};
    this.m.SkillCounterActionPointsCostMap = {};
    this.m.EnabledSameTurnCount = 0;
  }

  function onUpdated(_properties) {
    _properties.TargetAttractionMult *= 1.1;
  }
});
