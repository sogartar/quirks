this.quirks_double_or_nothing_effect <- this.inherit("scripts/skills/skill", {
  m = {},
  function create() {
    this.m.ID = "effects.quirks.double_or_nothing";
    this.m.Name = this.Const.Strings.PerkName.QuirksDoubleOrNothing;
    this.m.Description = this.Const.Strings.PerkName.QuirksDoubleOrNothing;
    this.m.Icon = "ui/perks/perk_quirks_double_or_nothing.png";
    this.m.IconMini = "perk_quirks_double_or_nothing_mini";
    this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
    this.m.Order = this.Const.SkillOrder.Perk | this.Const.SkillType.StatusEffect;
    this.m.IsActive = false;
    this.m.IsHidden = false;
  }

  function onUpdate(_properties) {
    _properties.DamageTotalMult *= 2;
    _properties.TotalAttackToHitMult *= 0.5;
  }
});
