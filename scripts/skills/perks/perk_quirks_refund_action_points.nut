this.perk_quirks_refund_action_points <- this.inherit("scripts/skills/skill", {
  m = {
    AttackFatigueCostMult = this.Const.Quirks.RefundActionPointsAttackFatigueCostMult,
    FatigueCostPerActionPoint = this.Const.Quirks.RefundActionPointsFatigueCostPerActionPoint,
    IsTargetHit = false,
    IsTargetMissed = false,
    LastSkillActionPonts = 0
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

  function onAnySkillUsed(_skill, _targetEntity, _properties) {
    this.m.LastSkillActionPonts = _skill.getActionPointCost();
  }

  function onTargetHit(_caller, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor) {
    this.m.IsTargetHit = true;
  }

  function onTargetMissed(_skill, _targetEntity) {
    this.m.IsTargetMissed = true;
  }

  function onAfterAnySkillUsed(_skill, _targetTile) {
    if (_skill == null || !_skill.isAttack() || (!this.m.IsTargetHit && !this.m.IsTargetMissed)) {
      return; #Not an attack skill
    }

    if (_skill.isUsedForFree()) {
      return;
    }

    if (!this.m.IsTargetHit) {
      this.enableRefundActionPointsSkill(_skill);
    }

    reset();
  }

  function enableRefundActionPointsSkill(_skill) {
    local active = this.new("scripts/skills/actives/quirks_refund_action_points_skill");
    active.setFatigueCost(this.Math.round(_skill.getFatigueCost() * this.m.AttackFatigueCostMult + this.m.FatigueCostPerActionPoint * this.m.LastSkillActionPonts));
    active.setActionPontsRefund(this.m.LastSkillActionPonts);
    this.getContainer().add(active);
  }

  function reset() {
    this.m.IsTargetHit = false;
    this.m.IsTargetMissed = false;
  }

  function onCombatStarted() {
    this.reset();
  }

  function onUpdated(_properties) {
    _properties.TargetAttractionMult *= 1.1;
  }
});
