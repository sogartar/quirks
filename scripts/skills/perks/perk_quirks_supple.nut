this.perk_quirks_supple <- this.inherit("scripts/skills/skill", {
  m = {
    RerollChanceBase = this.Const.Quirks.SuppleRerollChanceBase,
    RerollChanceHitpointsMaxMult = this.Const.Quirks.SuppleRerollChanceHitpointsMaxMult,
    RerollChanceFatigueMaxPenaltyMult = this.Const.Quirks.SuppleRerollChanceFatigueMaxPenaltyMult,
    CurrentRerollChance = 0
  }

  function create() {
    this.m.ID = "perk.quirks.supple";
    this.m.Name = this.Const.Strings.PerkName.QuirksSupple;
    this.m.Description = this.Const.Strings.PerkDescription.QuirksSupple;
    this.m.Icon = "ui/perks/perk_quirks_supple.png";
    this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
    this.m.Order = this.Const.SkillOrder.Perk | this.Const.SkillType.StatusEffect;
    this.m.IsActive = false;
    this.m.IsStacking = false;
    this.m.IsHidden = false;
  }

  function getTooltip() {
    local tooltip = this.skill.getTooltip();
    tooltip.push({
      id = 6,
      type = "text",
      icon = "ui/icons/special.png",
      text = "[color=" + this.Const.UI.Color.PositiveValue + "]+" + this.m.CurrentRerollChance + "%[/color] reroll chance when being hit."
    });
    return tooltip;
  }

  function getRerollChance(_properties) {
    local actor = this.getContainer().getActor();
    local itemsFatigue = this.Math.max(0, actor.getBaseProperties().Stamina - _properties.Stamina);
    local hitpointsMax = this.Math.floor(_properties.Hitpoints *
      (_properties.HitpointsMult >= 0 ? _properties.HitpointsMult : 1.0 / _properties.HitpointsMult));
    return this.Math.round(this.m.RerollChanceBase +
      this.m.RerollChanceHitpointsMaxMult * hitpointsMax +
      this.m.RerollChanceFatigueMaxPenaltyMult * itemsFatigue);
  }

  function onAfterUpdate(_properties) {
    this.m.CurrentRerollChance = this.getRerollChance(_properties);
    _properties.RerollDefenseChance += this.m.CurrentRerollChance;
  }
});
