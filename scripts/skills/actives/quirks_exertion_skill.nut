this.quirks_exertion_skill <- this.inherit("scripts/skills/skill", {
  m = {
  }

  function create() {
    this.m.ID = "actives.quirks.exertion";
    this.m.Name = this.Const.Strings.PerkName.QuirksExertion;
    this.m.Description = this.Const.Strings.PerkDescription.QuirksExertion;
    this.m.Icon = "ui/actives/active_quirks_exertion.png";
    this.m.IconDisabled = "ui/actives/active_quirks_exertion_sw.png";
    this.m.Overlay = "active_quirks_exertion";
    this.m.SoundOnUse = [
      "sounds/combat/active_quirks_exertion_1.wav",
      "sounds/combat/active_quirks_exertion_2.wav",
    ];
    this.m.Type = this.Const.SkillType.Active;
    this.m.Order = this.Const.SkillOrder.Any;
    this.m.IsSerialized = false;
    this.m.IsActive = true;
    this.m.IsTargeted = false;
    this.m.ActionPointCost = 0;
    this.m.FatigueCost = 0;
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

  function isActivated() {
    return this.getContainer().getSkillByID("effects.quirks.exertion") != null;
  }

  function getDescription() {
    return this.Const.Strings.PerkDescription.QuirksExertion + "\n" + (this.isActivated() ? "Activated." : "Decativated.");
  }

  function getIcon() {
    if (this.isActivated()) {
      return this.m.Icon;
    } else {
      return this.m.IconDisabled;
    }
  }

  function onUse(_user, _targetTile) {
    local effect = this.getContainer().getSkillByID("effects.quirks.exertion");
    if (effect != null) {
      this.getContainer().remove(effect);
    } else {
      this.getContainer().add(this.new("scripts/skills/effects/quirks_exertion_effect"));
    }
    return true;
  }
});
