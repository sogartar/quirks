this.quirks_precision_skill <- this.inherit("scripts/skills/skill", {
  m = {},
  function create()
  {
    this.m.ID = "actives.quirks.precision";
    this.m.Name = this.Const.Strings.PerkName.QuirksPrecision;
    this.m.Description = this.Const.Strings.PrecisionSkillDescription;
    this.m.Icon = "ui/actives/active_quirks_precision.png";
    this.m.IconDisabled = "ui/actives/active_quirks_precision_sw.png";
    this.m.Overlay = "active_quirks_precision";
    this.m.SoundOnUse = [
      "sounds/combat/active_quirks_precision_1.wav",
      "sounds/combat/active_quirks_precision_2.wav",
      "sounds/combat/active_quirks_precision_3.wav"
    ];
    this.m.Type = this.Const.SkillType.Active;
    this.m.Order = this.Const.SkillOrder.Any;
    this.m.IsSerialized = false;
    this.m.IsActive = true;
    this.m.IsTargeted = false;
    this.m.ActionPointCost = this.Const.Quirks.PrecisionApCost;
    this.m.FatigueCost = this.Const.Quirks.PrecisionFatigueCost;
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

  function onUse(_user, _targetTile) {
    this.getContainer().add(this.new("scripts/skills/effects/quirks_precision_effect"));
    return true;
  }

});
