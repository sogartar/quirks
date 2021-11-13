this.perk_quirks_glass_cannon <- this.inherit("scripts/skills/skill", {
  m = {
    DamageTotalMult = 0,
    DamageReceivedTotalMult = 0
  },
  function create() {
    this.m.ID = "perk.quirks.glass_cannon";
    this.m.Name = this.Const.Strings.PerkName.QuirksGlassCannon;
    this.m.Icon = "ui/perks/perk_quirks_glass_cannon.png";
    this.m.IconMini = "perk_quirks_glass_cannon_mini";
    this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
    this.m.Order = this.Const.SkillOrder.Perk | this.Const.SkillType.StatusEffect;
    this.m.IsActive = false;
    this.m.IsHidden = false;
    this.m.DamageTotalMult = this.Const.Quirks.GlassCannonDamageTotalMult;
    this.m.DamageReceivedTotalMult = this.Const.Quirks.GlassCannonDamageReceivedTotalMult;
  }

  function getDescription() {
    return this.getroottable().Quirks.getGlassCannonDescription(
      this.m.DamageTotalMult, this.m.DamageReceivedTotalMult);
  }

  function onUpdate(_properties) {
    _properties.TargetAttractionMult *= 1.2;
    _properties.DamageTotalMult *= this.m.DamageTotalMult;
    _properties.DamageReceivedTotalMult *= this.m.DamageReceivedTotalMult;
  }
});
