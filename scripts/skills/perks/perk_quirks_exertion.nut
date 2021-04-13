this.perk_quirks_exertion <- this.inherit("scripts/skills/skill", {
  m = {},
  function create() {
    this.m.ID = "perk.quirks.exertion";
    this.m.Name = this.Const.Strings.PerkName.QuirksExertion;
    this.m.Description = this.Const.Strings.PerkDescription.QuirksExertion;
    this.m.Icon = "ui/perks/perk_quirks_exertion.png";
    this.m.Type = this.Const.SkillType.Perk;
    this.m.Order = this.Const.SkillOrder.Perk;
    this.m.IsActive = false;
    this.m.IsHidden = false;
  }

  function onAdded() {
    if (!this.m.Container.hasSkill("actives.quirks.exertion")) {
      this.m.Container.add(this.new("scripts/skills/actives/quirks_exertion_skill"));
    }
  }

  function onRemoved() {
    this.m.Container.removeByID("actives.quirks.exertion");
  }
});
