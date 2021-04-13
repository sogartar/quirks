this.perk_quirks_acurate <- this.inherit("scripts/skills/skill", {
  m = {
    HitChanceBonus = this.Const.Quirks.AcurateHitChanceBonus
  },
  function create() {
    this.m.ID = "perk.quirks.acurate";
    this.m.Name = this.Const.Strings.PerkName.QuirksAcurate;
    this.m.Description = this.Const.Strings.PerkDescription.QuirksAcurate;
    this.m.Icon = "ui/perks/perk_quirks_acurate.png";
    this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
    this.m.Order = this.Const.SkillOrder.Perk | this.Const.SkillType.StatusEffect;
    this.m.IsActive = false;
    this.m.IsHidden = true;
  }

  function onUpdate(_properties) {
    _properties.MeleeSkill += this.m.HitChanceBonus;
    _properties.RangedSkill += this.m.HitChanceBonus;
  }
});
