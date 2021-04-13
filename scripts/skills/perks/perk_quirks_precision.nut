this.perk_quirks_precision <- this.inherit("scripts/skills/skill", {
  m = {},
  function create() {
    this.m.ID = "perk.quirks.precision";
    this.m.Name = this.Const.Strings.PerkName.QuirksPrecision;
    this.m.Description = this.Const.Strings.PerkDescription.QuirksPrecision;
    this.m.Icon = "ui/perks/perk_quirks_precision.png";
    this.m.Type = this.Const.SkillType.Perk;
    this.m.Order = this.Const.SkillOrder.Perk;
    this.m.IsActive = false;
    this.m.IsHidden = false;
  }

  function onAdded() {
    if (!this.m.Container.hasSkill("actives.quirks.precision")) {
      this.m.Container.add(this.new("scripts/skills/actives/quirks_precision_skill"));
    }
  }

  function onRemoved() {
    this.m.Container.removeByID("actives.quirks.precision");
  }
});
