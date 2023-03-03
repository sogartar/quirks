this.perk_quirks_hyperactive <- this.inherit("scripts/skills/skill", {
  m = {
    RefundApProbabilityPromile = this.Const.Quirks.HyperactiveRefundApProbabilityPromile,
    FatigueRecoveryRateModifierPerSpentActionPoint = this.Const.Quirks.HyperactiveFatigueRecoveryRateModifierPerSpentActionPoint,
    SpentActionPointsThisTurn = 0,
    SpentActionPointsLastTurn = 0,
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

  function getSkillApCost(skill, actor) {
    if (actor.getCurrentProperties().IsSkillUseFree)
    {
      return 0;
    }
    else if (actor.getCurrentProperties().IsSkillUseHalfCost)
    {
      return this.Math.max(1, this.Math.floor(skill.m.ActionPointCost / 2));
    }
    else
    {
      return skill.m.ActionPointCost;
    }
  }

  function onAfterAnySkillUsed(_skill, _actor, _targetTile) {
    local ap = this.getSkillApCost(_skill, _actor);
    if (ap == 0) {
      return;
    }
    this.m.SpentActionPointsThisTurn += ap;
    if (this.Math.rand(1, 1000) <= this.m.RefundApProbabilityPromile) {
      _actor.setActionPoints(this.Math.min(_actor.getActionPointsMax(),
      _actor.getActionPoints() + ap));
      local spwanIconArg = {
        actor = _actor
      };
      local spwanIcon = function(_arg) {
        this.spawnIcon("perk_quirks_hyperactive", _arg.actor.getTile());
      }
      this.Time.scheduleEvent(this.TimeUnit.Virtual, 200, spwanIcon.bindenv(this), spwanIconArg);
      _actor.setDirty(true);
    }
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
