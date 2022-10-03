this.perk_quirks_double_or_nothing <- this.inherit("scripts/skills/skill", {
  m = {},
  function create() {
    this.m.ID = "perk.quirks.double_or_nothing";
    this.m.Name = this.Const.Strings.PerkName.QuirksDoubleOrNothing;
    this.m.Description = this.Const.Strings.PerkDescription.QuirksDoubleOrNothing;
    this.m.Icon = "ui/perks/perk_quirks_double_or_nothing.png";
    this.m.Type = this.Const.SkillType.Perk;
    this.m.Order = this.Const.SkillOrder.Perk;
    this.m.IsActive = false;
    this.m.IsHidden = true;
  }

  function onAdded() {
    if (!this.m.Container.hasSkill("actives.quirks.double_or_nothing")) {
      this.m.Container.add(this.new("scripts/skills/actives/quirks_double_or_nothing_skill"));
    }
  }

  function onRemoved() {
    this.m.Container.removeByID("actives.quirks.double_or_nothing");
    this.m.Container.removeByID("actives.effects.double_or_nothing");
  }
});
