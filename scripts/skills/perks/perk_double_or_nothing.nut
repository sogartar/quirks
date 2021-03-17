this.perk_double_or_nothing <- this.inherit("scripts/skills/skill", {
  m = {},
  function create() {
    this.m.ID = "perk.double_or_nothing";
    this.m.Name = this.Const.Strings.PerkName.DoubleOrNothing;
    this.m.Description = this.Const.Strings.PerkDescription.DoubleOrNothing;
    this.m.Icon = "ui/perks/perk_double_or_nothing.png";
    this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
    this.m.Order = this.Const.SkillOrder.Perk | this.Const.SkillType.StatusEffect;
    this.m.IsActive = false;
    this.m.IsHidden = false;
  }

  function onAnySkillUsed(_skill, _targetEntity, _properties) {
    if (!_skill.isAttack()) {
      return;
    }

    _properties.DamageTotalMult *= 2;
    _properties.TotalAttackToHitMult *= 0.5;
  }

  function onBeingAttacked(_attacker, _skill, _properties) {
    _properties.TotalAttackToHitMult *= 0.5;
  }

  function onUpdate(_properties) {
    _properties.TargetAttractionMult *= 1.2;
    _properties.DamageReceivedTotalMult *= 2;
  }
});