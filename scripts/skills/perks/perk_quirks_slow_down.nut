this.perk_quirks_slow_down <- this.inherit("scripts/skills/skill", {
  m = {},
  function create() {
    this.m.ID = "perk.quirks.slow_down";
    this.m.Name = this.Const.Strings.PerkName.QuirksSlowDown;
    this.m.Description = this.Const.Strings.PerkDescription.QuirksSlowDown;
    this.m.Icon = "ui/perks/perk_quirks_slow_down.png";
    this.m.Type = this.Const.SkillType.Perk;
    this.m.Order = this.Const.SkillOrder.Perk;
    this.m.IsActive = false;
    this.m.IsHidden = true;
  }

  function onAdded() {
    if (!this.m.Container.hasSkill("actives.quirks.slow_down")) {
      this.m.Container.add(this.new("scripts/skills/actives/quirks_slow_down_skill"));
    }
  }

  function onRemoved() {
    this.m.Container.removeByID("actives.quirks.slow_down");
  }
});
