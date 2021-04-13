this.quirks_slow_down_skill <- this.inherit("scripts/skills/skill", {
  m = {},
  function create()
  {
    this.m.ID = "actives.quirks.slow_down";
    this.m.Name = this.Const.Strings.PerkName.QuirksSlowDown;
    this.m.Description = this.getroottable().Quirks.getSlowDownSkillDescription();
    this.m.Icon = "ui/actives/active_quirks_slow_down.png";
    this.m.IconDisabled = "ui/actives/active_quirks_slow_down_sw.png";
    this.m.Overlay = "active_quirks_slow_down";
    this.m.SoundOnUse = [
      "sounds/combat/active_quirks_slow_down.wav"
    ];
    this.m.Type = this.Const.SkillType.Active;
    this.m.Order = this.Const.SkillOrder.Any;
    this.m.IsSerialized = false;
    this.m.IsActive = true;
    this.m.IsTargeted = false;
    this.m.IsAttack = false;
    this.m.IsAudibleWhenHidden = true;
    this.m.ActionPointCost = this.Const.Quirks.SlowDownActionPointsCost;
    this.m.FatigueCost = this.Const.Quirks.SlowDownFatigueCost;
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
    local isUsedAlready = skills.getSkillByID("effects.quirks.slow_down") != null;
    return !isUsedAlready && !skills.getActor().isWaitActionSpent() && this.skill.isUsable();
  }

  function onUse(_user, _targetTile) {
    this.getContainer().add(this.new("scripts/skills/effects/quirks_slow_down_effect"));
    return true;
  }
});
