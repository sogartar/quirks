this.perk_refund_action_points <- this.inherit("scripts/skills/skill", {
  m = {
    RefundFatigueCostMultiplier = this.Const.RefundActionPointsFatigueCostMultiplier,
    IsTargetHit = false,
    IsTargetMissed = false
  }

  function create() {
    this.m.ID = "perk.refund_action_points";
    this.m.Name = this.Const.Strings.PerkName.RefundActionPoints;
    this.m.Icon = "ui/perks/perk_refund_action_points.png";
    this.m.Type = this.Const.SkillType.Perk;
    this.m.Order = this.Const.SkillOrder.Perk;
    this.m.IsActive = false;
    this.m.IsHidden = false;
  }

  function onTargetHit(_caller, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor) {
    this.m.IsTargetHit = true;
  }

  function onTargetMissed(_skill, _targetEntity) {
    this.m.IsTargetMissed = true;
  }

  function onAfterAnySkillUsed(_skill, _targetEntity) {
    if (_skill == null || !_skill.isAttack() || (!this.m.IsTargetHit && !this.m.IsTargetMissed)) {
      return; #Not an attack skill
    }

    if (!this.m.IsTargetHit) {
      this.logInfo("Target Missed.");
      local active = this.new("scripts/skills/actives/refund_action_points_skill");
      active.setFatigueCost(_skill.getFatigueCost() * this.m.RefundFatigueCostMultiplier);
      active.setActionPontsRefund(_skill.getActionPointCost());
      this.getContainer().add(active);
    }

    reset();
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
