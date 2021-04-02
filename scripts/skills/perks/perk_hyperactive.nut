this.perk_hyperactive <- this.inherit("scripts/skills/skill", {
  m = {
    ApBonus = this.Const.HyperactiveApBonus,
    FatigueRecoveryRatePerTurnChange = this.Const.HyperactiveFatigueRecoveryRatePerTurnChange,
    TurnsCount = 0
  },
  function create() {
    this.m.ID = "perk.hyperactive";
    this.m.Name = this.Const.Strings.PerkName.Hyperactive;
    this.m.Icon = "ui/perks/perk_hyperactive.png";
    this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
    this.m.Order = this.Const.SkillOrder.Perk | this.Const.SkillType.StatusEffect;
    this.m.IsActive = false;
    this.m.IsHidden = false;
  }

  function getDescription() {
    return this.getroottable().getHyperactiveDescription(this.m.ApBonus, this.m.FatigueRecoveryRatePerTurnChange) +
      "\nCurrent fatigue recory rate reduction of [color=" + this.Const.UI.Color.NegativeValue + "]" +
      (-this.getCurrentFatigueRecoveryRateModifier()) + "[/color].";
  }

  function getCurrentFatigueRecoveryRateModifier() {
    return this.Math.min(0, (this.m.TurnsCount - 1) * this.m.FatigueRecoveryRatePerTurnChange);
  }

  function onUpdate(_properties) {
    _properties.ActionPoints += this.m.ApBonus;
    _properties.FatigueRecoveryRate += this.getCurrentFatigueRecoveryRateModifier();
  }

  function onTurnStart() {
    this.m.TurnsCount += 1;
  }

  function onCombatStarted() {
    this.m.TurnsCount = 0;
  }
});
