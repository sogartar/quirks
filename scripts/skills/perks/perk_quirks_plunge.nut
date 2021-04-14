this.perk_quirks_plunge <- this.inherit("scripts/skills/skill", {
  m = {},
  function create() {
    this.m.ID = "perk.quirks.plunge";
    this.m.Name = this.Const.Strings.PerkName.QuirksPlunge;
    this.m.Description = this.Const.Strings.PerkDescription.QuirksPlunge;
    this.m.Icon = "ui/perks/perk_quirks_plunge.png";
    this.m.Type = this.Const.SkillType.Perk;
    this.m.Order = this.Const.SkillOrder.Perk;
    this.m.IsActive = false;
    this.m.IsHidden = true;
  }

  function onAdded() {
    if (!this.m.Container.hasSkill("actives.quirks.plunge")) {
      this.m.Container.add(this.new("scripts/skills/actives/quirks_plunge_skill"));
    }
  }

  function onRemoved() {
    this.m.Container.removeByID("actives.quirks.plunge");
  }
});
