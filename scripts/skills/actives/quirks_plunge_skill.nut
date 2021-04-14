this.quirks_plunge_skill <- this.inherit("scripts/skills/skill", {
  m = {},
  function create() {
    this.m.ID = "actives.quirks.plunge";
    this.m.Name = this.Const.Strings.PerkName.QuirksPlunge;
    this.m.Description = this.getroottable().Quirks.getPlungeSkillDescription(
      this.Const.Quirks.PlungeDamageMultPerStack, this.Const.Quirks.PlungeKnockBackChancePerStack);
    this.m.Icon = "ui/actives/active_quirks_plunge.png";
    this.m.IconDisabled = "ui/actives/active_quirks_plunge_sw.png";
    this.m.Overlay = "active_quirks_plunge";
    this.m.SoundOnUse = [
      "sounds/combat/active_quirks_plunge_1.wav",
      "sounds/combat/active_quirks_plunge_2.wav",
      "sounds/combat/active_quirks_plunge_3.wav"
    ];
    this.m.Type = this.Const.SkillType.Active;
    this.m.Order = this.Const.SkillOrder.Any;
    this.m.IsSerialized = false;
    this.m.IsActive = true;
    this.m.IsTargeted = false;
    this.m.IsAttack = false;
    this.m.IsAudibleWhenHidden = true;
    this.m.ActionPointCost = this.Const.Quirks.PlungeActionPointsCost;
    this.m.FatigueCost = this.Const.Quirks.PlungeFatigueCost;
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
    local skills = this.getContainer();
    local isUsedAlready = skills.getSkillByID("effects.quirks.plunge") != null;
    return !isUsedAlready && this.skill.isUsable();
  }

  function onUse(_user, _targetTile) {
    this.getContainer().add(this.new("scripts/skills/effects/quirks_plunge_effect"));
    return true;
  }
});
