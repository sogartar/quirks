this.quirks_slow_down_skill <- this.inherit("scripts/skills/skill", {
  m = {
    MaxTargetsSlowedPerRound = 0,
    TargetsSlowedThisRound = 0,
    IsActivated = true
  },
  function create()
  {
    this.m.ID = "actives.quirks.slow_down";
    this.m.Name = this.Const.Strings.PerkName.QuirksSlowDown;
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
    this.m.ActionPointCost = 0;
    this.m.FatigueCost = 0;
    this.m.MaxTargetsSlowedPerRound = this.Const.Quirks.SlowDownMaxTargetsSlowedPerRound;
  }

  function getDescription() {
    return this.Const.Strings.PerkDescription.QuirksSlowDown + "\n" +
      this.m.TargetsSlowedThisRound + " targets slowed tihs round.\n" + (this.m.IsActivated ? "Activated." : "Deactivated.");
  }

  function onNewRound() {
    this.m.TargetsSlowedThisRound = 0;
  }

  function activate() {
    this.m.IsActivated = true;
  }

  function getIcon() {
    if (this.m.IsActivated) {
      return this.m.Icon;
    } else {
      return this.m.IconDisabled;
    }
  }

  function isUsable() {
    return true;
  }

  function onUse(_user, _targetTile) {
    if (this.m.IsActivated) {
      this.m.IsActivated = false;
    } else {
      this.m.IsActivated = true;
    }
    return true;
  }

  function onTargetHit(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor) {
    if (!_targetEntity.isAlive() || _targetEntity.isDying()) {
      return;
    }

    if (this.m.IsActivated && this.m.TargetsSlowedThisRound < this.m.MaxTargetsSlowedPerRound) {
      _targetEntity.getSkills().add(this.new("scripts/skills/effects/quirks_slowed_down_effect"));
      ++this.m.TargetsSlowedThisRound;
    }
  }

  function onNewRound() {
    this.m.TargetsSlowedThisRound = 0;
  }
});
