this.perk_bank <- this.inherit("scripts/skills/skill", {
  m = {},
  function create() {
    this.m.ID = "perk.bank";
    this.m.Name = this.Const.Strings.PerkName.Bank;
    this.m.Description = this.Const.Strings.PerkDescription.Bank;
    this.m.Icon = "ui/perks/perk_bank.png";
    this.m.Type = this.Const.SkillType.Perk;
    this.m.Order = this.Const.SkillOrder.Perk;
    this.m.IsActive = false;
    this.m.IsStacking = false;
    this.m.IsHidden = false;
  }

  function onAdded() {
    if (!this.m.Container.hasSkill("actives.bank")) {
      this.m.Container.add(this.new("scripts/skills/actives/bank_skill"));
    }
  }

  function onRemoved() {
    this.m.Container.removeByID("actives.bank");
  }

  function onUpdated(_properties) {
    _properties.TargetAttractionMult *= 1.1;
  }
});
