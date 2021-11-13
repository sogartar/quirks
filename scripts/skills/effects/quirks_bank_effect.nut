this.quirks_bank_effect <- this.inherit("scripts/skills/skill", {
  m = {
    ActionPoints = 0
  }

  function create() {
    this.m.ID = "effects.quirks.bank";
    this.m.Name = this.Const.Strings.PerkName.QuirksBank;
    this.m.Icon = "ui/perks/perk_quirks_bank.png";
    this.m.IconMini = "perk_quirks_bank_mini";
    this.m.Overlay = "perk_quirks_bank";
    this.m.Type = this.Const.SkillType.StatusEffect;
    this.m.IsActive = false;
    this.m.IsHidden = false;
    this.m.IsRemovedAfterBattle = true;
  }

  function setActionPoints(ap) {
    this.m.ActionPoints = ap;
  }

  function getActionPoints() {
    return this.m.ActionPoints;
  }

  function addActionPoints(ap) {
    this.m.ActionPoints += ap;
  }

  function onAdded() {
    local actor = this.getContainer().add(this.new("scripts/skills/actives/quirks_cash_in_skill"));
  }

  function getDescription() {
    return "This character has [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getActionPoints() +
      "[/color] action points in the bank.";
  }

  function onTurnEnd() {
    this.setActionPoints(this.getActionPoints() * (this.Const.Quirks.BankInterestRatePerTurn + 1));
  }
  
  function onUpdated(_properties) {
    _properties.TargetAttractionMult *= this.Math.pow(1.03, 1 + this.getActionPoints());
  }
});
