this.perk_precision <- this.inherit("scripts/skills/skill", {
  m = {},
  function create() {
    this.m.ID = "perk.precision";
    this.m.Name = this.Const.Strings.PerkName.Precision;
    this.m.Description = this.Const.Strings.PerkDescription.Precision;
    this.m.Icon = "ui/perks/perk_precision.png";
    this.m.Type = this.Const.SkillType.Perk;
    this.m.Order = this.Const.SkillOrder.Perk;
    this.m.IsActive = false;
    this.m.IsHidden = false;
  }

  function onAdded() {
    if (!this.m.Container.hasSkill("actives.precision")) {
      this.m.Container.add(this.new("scripts/skills/actives/precision_skill"));
    }
  }

  function onRemoved() {
    this.m.Container.removeByID("actives.precision");
  }
});
