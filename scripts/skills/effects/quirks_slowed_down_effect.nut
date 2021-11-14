this.quirks_slowed_down_effect <- this.inherit("scripts/skills/skill", {
  m = {
    ActionPointsMovementConstPerStack = 0
  }

  function create() {
    this.m.ID = "effects.quirks.slowed_down";
    this.m.Name = this.Const.Strings.PerkName.QuirksSlowDown;
    this.m.Icon = "ui/perks/perk_quirks_slow_down.png";
    this.m.IconMini = "quirks_slowed_down_effect_mini";
    this.m.Overlay = "perk_quirks_slow_down";
    this.m.Type = this.Const.SkillType.StatusEffect;
    this.m.IsActive = false;
    this.m.IsRemovedAfterBattle = true;
    this.m.IsStacking = false;
    this.m.ActionPointsMovementConstPerStack = this.Const.Quirks.SlowDownActionPointsMovementConstPerStack;
  }

  function getName() {
    return this.skill.getName();
  }

  function getDescription() {
    return "Each tile movement costs an additional [color=" + this.Const.UI.Color.NegativeValue + "]"
      + (this.m.Count * this.m.ActionPointsMovementConstPerStack) + "[/color] action points.";
  }

  function onUpdate(_properties) {
    _properties.MovementAPCostAdditional += this.m.ActionPointsMovementConstPerStack;
  }

  function onTurnEnd() {
    this.removeSelf();
  }

  function onNewRound() {
    this.removeSelf();
  }
});
