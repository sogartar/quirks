this.quirks_double_or_nothing_skill <- this.inherit("scripts/skills/skill", {
  m = {},
  function create() {
    this.m.ID = "actives.quirks.double_or_nothing";
    this.m.Name = this.Const.Strings.PerkName.QuirksDoubleOrNothing;
    this.m.Icon = "ui/actives/active_quirks_double_or_nothing.png";
    this.m.IconDisabled = "ui/actives/active_quirks_double_or_nothing_sw.png";
    this.m.Overlay = "active_quirks_double_or_nothing";
    this.m.SoundOnUse = [
      "sounds/combat/active_quirks_double_or_nothing.wav"
    ];
    this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.Active;
    this.m.Order = this.Const.SkillOrder.Any;
    this.m.IsActive = true;
    this.m.IsHidden = false;
    this.m.IsTargeted = false;
    this.m.IsAttack = false;
  }

  function isActivated() {
    return this.getContainer().getSkillByID("effects.quirks.double_or_nothing") != null;
  }

  function getDescription() {
    return this.Const.Quirks.DoubleOrNothingDescription + "\n" + (this.isActivated() ? "Activated." : "Decativated.");
  }

  function getIcon() {
    if (this.isActivated()) {
      return this.m.Icon;
    } else {
      return this.m.IconDisabled;
    }
  }

  function onUse(_user, _targetTile) {
    local effect = this.getContainer().getSkillByID("effects.quirks.double_or_nothing");
    if (effect != null) {
      this.getContainer().remove(effect);
    } else {
      this.getContainer().add(this.new("scripts/skills/effects/quirks_double_or_nothing_effect"));
    }
    return true;
  }
});
