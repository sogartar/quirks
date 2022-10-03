this.perk_quirks_hyperactive <- this.inherit("scripts/skills/skill", {
  m = {
    RefundApProbabilityPromile = this.Const.Quirks.HyperactiveRefundApProbabilityPromile,
    FatigueRecoveryRateModifierPerSpentActionPoint = this.Const.Quirks.HyperactiveFatigueRecoveryRateModifierPerSpentActionPoint,
    SpentActionPointsThisTurn = 0,
    SpentActionPointsLastTurn = 0
  },
  function create() {
    this.m.ID = "perk.quirks.hyperactive";
    this.m.Name = this.Const.Strings.PerkName.QuirksHyperactive;
    this.m.Icon = "ui/perks/perk_quirks_hyperactive.png";
    this.m.IconMini = "perk_quirks_hyperactive_mini";
    this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
    this.m.Order = this.Const.SkillOrder.Perk | this.Const.SkillType.StatusEffect;
    this.m.IsActive = false;
    this.m.IsHidden = false;
  }

  function getDescription() {
    return this.getroottable().Quirks.getHyperactiveDescription(this.m.RefundApProbabilityPromile, this.m.FatigueRecoveryRateModifierPerSpentActionPoint) +
      "\n[color=" + this.Const.UI.Color.NegativeValue + "]" + (this.m.SpentActionPointsThisTurn * this.m.FatigueRecoveryRateModifierPerSpentActionPoint) +
      "[/color] fatigue recory rate reduction for next turn.";
  }

  function onUpdate(_properties) {
    _properties.FatigueRecoveryRate += ::libreuse.roundRandomWeighted(
      this.m.SpentActionPointsLastTurn * this.m.FatigueRecoveryRateModifierPerSpentActionPoint);
  }

  function onAfterAnySkillUsed(_skill, _targetTile) {
    if (_skill == null || _skill.isUsedForFree()) {
      return;
    }

    this.m.SpentActionPointsThisTurn += _skill.getActionPointCost();
    this.logInfo("perk_quirks_hyperactive.onAfterAnySkillUsed this.m.SpentActionPointsThisTurn = " + this.m.SpentActionPointsThisTurn);

    if (this.Math.rand(1, 1000) <= this.m.RefundApProbabilityPromile) {
      local actor = this.getContainer().getActor();
      actor.setActionPoints(this.Math.min(actor.getActionPointsMax(),
      actor.getActionPoints() + _skill.getActionPointCost()));
      actor.setDirty(true);
      this.spawnIcon("perk_quirks_hyperactive", actor.getTile());
    }
  }

  function onTurnEnd() {
    this.logInfo("perk_quirks_hyperactive.onTurnEnd this.m.SpentActionPointsThisTurn = " + this.m.SpentActionPointsThisTurn);
    this.m.SpentActionPointsLastTurn = this.m.SpentActionPointsThisTurn;
    this.m.SpentActionPointsThisTurn = 0;
  }

  function onCombatFinished() {
    this.skill.onCombatFinished();
    this.m.SpentActionPointsThisTurn = 0;
    this.m.SpentActionPointsLastTurn = 0;
  }
});
