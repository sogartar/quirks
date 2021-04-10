this.perk_hyperactive <- this.inherit("scripts/skills/skill", {
  m = {
    ApBonus = this.Const.HyperactiveApBonus,
    FatigueRecoveryRateModifierPerSpentActionPoint = this.Const.HyperactiveFatigueRecoveryRateModifierPerSpentActionPoint,
    SpentActionPointsThisTurn = 0,
    SpentActionPointsLastTurn = 0
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
    return this.getroottable().getHyperactiveDescription(this.m.ApBonus, this.m.FatigueRecoveryRateModifierPerSpentActionPoint) +
      "\n[color=" + this.Const.UI.Color.NegativeValue + "]" + (-this.getCurrentFatigueRecoveryRateModifier()) +
      "[/color] fatigue recory rate reduction for next turn.";
  }

  function getCurrentFatigueRecoveryRateModifier() {
    return this.m.SpentActionPointsLastTurn * this.m.FatigueRecoveryRateModifierPerSpentActionPoint;
  }

  function onUpdate(_properties) {
    _properties.ActionPoints += this.m.ApBonus;
    _properties.FatigueRecoveryRate += ::libreuse.roundRandomWeighted(this.getCurrentFatigueRecoveryRateModifier());
  }

  function onAfterAnySkillUsed(_skill, _targetTile) {
    if (_skill == null || _skill.isUsedForFree()) {
      return;
    }

    this.m.SpentActionPointsThisTurn += _skill.getActionPointCost();
  }

  function onTurnEnd() {
    this.m.SpentActionPointsLastTurn = this.m.SpentActionPointsThisTurn;
    this.m.SpentActionPointsThisTurn = 0;
  }

  function onCombatFinished() {
    this.skill.onCombatFinished();
    this.m.SpentActionPointsThisTurn = 0;
    this.m.SpentActionPointsLastTurn = 0;
  }
});
