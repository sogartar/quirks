this.perk_quirks_refund_fatigue <- this.inherit("scripts/skills/skill", {
  m = {
    RefundMult = this.Const.Quirks.RefundFatigueMult,
    IsTargetHit = false
    IsTargetMissed = false
  }

  function create() {
    this.m.ID = "perk.quirks.refund_fatigue";
    this.m.Name = this.Const.Strings.PerkName.QuirksRefundFatigue;
    this.m.Description = this.Const.Strings.PerkDescription.QuirksRefundFatigue;
    this.m.Icon = "ui/perks/perk_quirks_refund_fatigue.png";
    this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
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

  function onAfterAnySkillUsed(_skill, _targetTile) {
    if (_skill == null || !_skill.isAttack() || (!this.m.IsTargetHit && !this.m.IsTargetMissed)) {
      return; #Not an attack skill
    }

    if (_skill.isUsedForFree()) {
      return;
    }

    if (!this.m.IsTargetHit) {
      local actor = _skill.getContainer().getActor();
      local fat = _skill.getFatigueCost();
      actor.setFatigue(this.Math.max(0, actor.getFatigue() - ::libreuse.roundRandomWeighted(fat * this.m.RefundMult)));
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
});
