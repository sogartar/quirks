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
    if (this.getContainer().m.IsCalculatingExpectedDamge || !_skill.isAttack()) {
      return;
    }

    if (this.Math.rand(1, 2) == 1) {
      _properties.DamageTotalMult *= 2;
    } else {
      _properties.DamageTotalMult = 0.0;
    }
  }

  function onBeforeDamageReceived(_attacker, _skill, _hitInfo, _properties) {
    if (this.getContainer().m.IsCalculatingExpectedDamge) {
      return;
    }

    if (this.Math.rand(1, 2) == 1) {
      _properties.DamageReceivedTotalMult *= 2;
    } else {
      _properties.DamageReceivedTotalMult = 0.0;
    }
  }
  
  function onUpdated(_properties) {
    _properties.TargetAttractionMult *= 1.2;
  }
});
