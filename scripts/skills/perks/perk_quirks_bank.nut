this.perk_quirks_bank <- this.inherit("scripts/skills/skill", {
  m = {},
  function create() {
    this.m.ID = "perk.quirks.bank";
    this.m.Name = this.Const.Strings.PerkName.QuirksBank;
    this.m.Description = this.Const.Strings.PerkDescription.QuirksBank;
    this.m.Icon = "ui/perks/perk_quirks_bank.png";
    this.m.Type = this.Const.SkillType.Perk;
    this.m.Order = this.Const.SkillOrder.Perk;
    this.m.IsActive = false;
    this.m.IsHidden = false;
  }

  function onAdded() {
    if (!this.m.Container.hasSkill("actives.quirks.bank")) {
      this.m.Container.add(this.new("scripts/skills/actives/quirks_bank_skill"));
    }
  }

  function onRemoved() {
    this.m.Container.removeByID("actives.quirks.bank");
  }

  function onUpdated(_properties) {
    _properties.TargetAttractionMult *= 1.1;
  }
});
