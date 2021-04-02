this.exertion_skill <- this.inherit("scripts/skills/skill", {
  m = {
    ApBonusPerUse = this.Const.ExertionApBonus,
    MinFatigueCost = this.Const.ExertionMinFatigueCost,
    FatigueCostBase = this.Const.ExertionFatigueCostBase,
    FatiguePoolCostMult = this.Const.ExertionFatiguePoolCostMult,
    ResolveCostMult = this.Const.ExertionResolveCostMult,
    CurrentInitiativeCostMult = this.Const.ExertionCurrentInitiativeCostMult,
    FatigueCostMultOnSameTurn = this.Const.ExertionFatigueCostMultOnSameTurn,
    UsesCountThisTurn = 0,
    ApBonus = 0
  }

  function create() {
    this.m.ID = "actives.exertion";
    this.m.Name = this.Const.Strings.PerkName.Exertion;
    this.m.Icon = "ui/perks/active_exertion.png";
    this.m.IconDisabled = "ui/perks/active_exertion_sw.png";
    this.m.Overlay = "active_exertion";
    this.m.SoundOnUse = [
      "sounds/combat/active_exertion_1.wav",
      "sounds/combat/active_exertion_2.wav",
    ];
    this.m.Type = this.Const.SkillType.Active;
    this.m.Order = this.Const.SkillOrder.Any;
    this.m.IsSerialized = false;
    this.m.IsActive = true;
    this.m.IsTargeted = false;
    this.m.MinRange = 0;
    this.m.MaxRange = 0;
  }

  function getTooltip() {
    local ret = [
      {
        id = 1,
        type = "title",
        text = this.getName()
      },
      {
        id = 2,
        type = "description",
        text = this.getDescription()
      },
      {
        id = 3,
        type = "text",
        text = this.getCostString()
      }
    ];
    return ret;
  }

  function isUsable() {
    return this.skill.isUsable();
  }

  function getFatigueCost() {
    local actor = this.getContainer().getActor();
    local res = this.m.FatigueCostBase -
      this.m.FatiguePoolCostMult * (actor.getFatigueMax() - actor.getFatigue()) -
      this.m.ResolveCostMult * actor.getBravery() -
      this.m.CurrentInitiativeCostMult * actor.getInitiative();
    res = this.Math.max(this.m.MinFatigueCost, res);
    if (this.m.UsesCountThisTurn > 0) {
      res *= this.m.FatigueCostMultOnSameTurn * this.m.UsesCountThisTurn;
    }
    return this.Math.round(res);
  }

  function onUpdate(_properties) {
    _properties.ActionPoints = this.Math.floor(_properties.ActionPoints + this.m.ApBonus);
  }

  function onUse(_user, _targetTile) {
    this.m.ApBonus += this.m.ApBonusPerUse;
    local actor = this.getContainer().getActor();
    actor.setActionPoints(actor.getActionPoints() + this.m.ApBonusPerUse);
    actor.getCurrentProperties().ActionPoints += this.m.ApBonusPerUse;
    actor.setDirty(true);
    this.m.UsesCountThisTurn += 1;
    return true;
  }

  function getDescription() {
    return "Increase current turn action points by [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.ApBonusPerUse + "[/color].";
  }

  function onTurnStart() {
    this.m.ApBonus = 0;
    this.m.UsesCountThisTurn = 0;
  }
});
