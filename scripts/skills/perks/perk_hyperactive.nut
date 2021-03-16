this.perk_hyperactive <- this.inherit("scripts/skills/skill", {
  m = {
    ApBonus = this.Const.HyperactiveApBonus,
    FatigueRecoveryRateModifier = this.Const.HyperactiveFatigueRecoveryRateModifier,
    IsFirstTurn = true
  },
  function create() {
    this.m.ID = "perk.hyperactive";
    this.m.Name = this.Const.Strings.PerkName.Hyperactive;
    this.m.Description = this.Const.Strings.PerkDescription.Hyperactive;
    this.m.Icon = "ui/perks/perk_hyperactive.png";
    this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
    this.m.Order = this.Const.SkillOrder.Perk | this.Const.SkillType.StatusEffect;
    this.m.IsActive = false;
    this.m.IsHidden = false;
  }

  function onUpdate(_properties) {
    _properties.ActionPoints += this.m.ApBonus;
  }
  
  function onTurnStart() {
    if (this.m.IsFirstTurn) {
      this.m.IsFirstTurn = false;
    } else {
      local actor = this.getContainer().getActor();
      local fatigue = this.Math.max(0, this.Math.min(actor.getFatigueMax() - 15, actor.getFatigue() - this.m.FatigueRecoveryRateModifier));
      actor.setFatigue(fatigue);
    }
  }
});
