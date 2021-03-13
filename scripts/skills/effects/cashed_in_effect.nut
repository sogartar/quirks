this.cashed_in_effect <- this.inherit("scripts/skills/skill", {
  m = {
    ActionPoints = 0,
    IsRewardThisRound = false
  }

  function create()
  {
    this.m.ID = "effects.cashed_in";
    this.m.Name = this.Const.Strings.CashedInEffectName;
    this.m.Icon = "ui/perks/cashed_in_effect.png";
    this.m.IconMini = "";
    this.m.Overlay = "cashed_in_effect";
    this.m.Type = this.Const.SkillType.StatusEffect;
    this.m.IsActive = false;
    this.m.IsRemovedAfterBattle = true;
  }

  function setActionPoints(ap) {
    this.m.ActionPoints = ap;
  }

  function getActionPoints() {
    return this.m.ActionPoints;
  }

  function getDescription() {
    return "This character will have [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getActionPoints() +
      "[/color] extra action points " + (this.m.IsRewardThisRound ? "this" : "next") + " round.";
  }

  function onUpdate(_properties) {
    if (this.m.IsRewardThisRound) {
      _properties.ActionPoints = this.Math.floor(_properties.ActionPoints + this.getActionPoints());
      #this.logInfo("cashed_in_effect AP = " + _properties.ActionPoints);
    }
  }

  function onTurnEnd() {
    if (this.m.IsRewardThisRound) {
      this.removeSelf();
    }
  }

  function onNewRound() {
    this.m.IsRewardThisRound = true;
  }
});
