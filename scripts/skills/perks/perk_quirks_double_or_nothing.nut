this.perk_quirks_double_or_nothing <- this.inherit("scripts/skills/skill", {
  m = {},
  function create() {
    this.m.ID = "perk.quirks.double_or_nothing";
    this.m.Name = this.Const.Strings.PerkName.QuirksDoubleOrNothing;
    this.m.Description = this.Const.Strings.PerkDescription.QuirksDoubleOrNothing;
    this.m.Icon = "ui/perks/perk_quirks_double_or_nothing.png";
    this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
    this.m.Order = this.Const.SkillOrder.Perk | this.Const.SkillType.StatusEffect;
    this.m.IsActive = false;
    this.m.IsHidden = false;
  }

  function onUpdate(_properties) {
    _properties.TargetAttractionMult *= 1.1;
    _properties.DamageTotalMult *= 2;
    _properties.TotalAttackToHitMult *= 0.5;
  }
});
