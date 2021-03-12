this.bank_effect <- this.inherit("scripts/skills/skill", {
  m = {
    ActionPoints = 0,
    IsCashInThisRound = false
  }

  function create()
  {
    this.m.ID = "effects.cashed_in";
    this.m.Name = this.Const.Strings.PerkName.Bank;
    this.m.Icon = "ui/perks/cashed_in_effect.png";
    this.m.IconMini = "";
    this.m.Overlay = "cashed_in_effect";
    this.m.Type = this.Const.SkillType.StatusEffect;
    this.m.IsActive = false;
    this.m.IsStacking = false;
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
      "[/color] extra action points " + (this.m.IsCashInThisRound ? "this" : "next") + " round.";
  }

  function onTurnStart() {
    local actor = this.getContainer().getActor();
    actor.setActionPoints(this.Math.floor(actor.getActionPoints() + this.getActionPoints()));
    this.removeSelf();
  }

  function onRoundEnd() {
    this.m.IsCashInThisRound = true;
  }
});
