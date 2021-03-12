this.bank_effect <- this.inherit("scripts/skills/skill", {
  m = {
    ActionPointsBank = 0
  }

  function create()
  {
    this.m.ID = "effects.bank";
    this.m.Name = this.Const.Strings.PerkName.Bank;
    this.m.Icon = "ui/perks/perk_bank.png";
    this.m.IconMini = "";
    this.m.Overlay = "perk_bank";
    this.m.Type = this.Const.SkillType.StatusEffect;
    this.m.IsActive = false;
    this.m.IsStacking = false;
    this.m.IsRemovedAfterBattle = true;
  }

  function setActionPointsBank(ap) {
    this.m.ActionPointsBank = ap;
  }

  function getActionPointsBank() {
    return this.m.ActionPointsBank;
  }

  function addActionPoints(ap) {
    this.m.ActionPointsBank += ap;
  }

  function onAdded() {
    local actor = this.getContainer().add("scripts/skills/actives/cash_in_skill");
  }

  function getDescription() {
    return "This character has [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getActionPointsBank() +
      "[/color] action points in the bank.";
  }

  function onTurnEnd() {
    this.setActionPointsBank(this.getActionPointsBank() * this.Const.BankInterestRatePerTurn);
  }
});
