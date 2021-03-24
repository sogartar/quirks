this.bank_skill <- this.inherit("scripts/skills/skill", {
  m = {},
  function create()
  {
    this.m.ID = "actives.bank";
    this.m.Name = this.Const.Strings.PerkName.Bank;
    this.m.Description = this.Const.Strings.BankSkillDescription;
    this.m.Icon = "ui/perks/active_bank.png";
    this.m.IconDisabled = "ui/perks/active_bank_sw.png";
    this.m.Overlay = "active_bank";
    this.m.SoundOnUse = [
      "sounds/combat/bank_skill.wav"
    ];
    this.m.Type = this.Const.SkillType.Active;
    this.m.Order = this.Const.SkillOrder.Any;
    this.m.IsSerialized = false;
    this.m.IsActive = true;
    this.m.IsTargeted = false;
    this.m.IsAttack = false;
    this.m.IsAudibleWhenHidden = true;
    this.m.ActionPointCost = this.Const.BankApCost;
    this.m.FatigueCost = this.Const.BankFatigueCost;
    this.m.MinRange = 0;
    this.m.MaxRange = 0;
  }

  function getTooltip() {
    local ret = [
      {
        id = 1,
        type = "title",
        text = this.getName()
      },
      {
        id = 2,
        type = "description",
        text = this.getDescription()
      },
      {
        id = 3,
        type = "text",
        text = this.getCostString()
      }
    ];
    return ret;
  }

  function isUsable() {
    return this.skill.isUsable();
  }

  function onUse(_user, _targetTile) {
    local bank_effect = this.getContainer().getSkillByID("effects.bank");
    if (bank_effect == null) {
      bank_effect = this.new("scripts/skills/effects/bank_effect");
      this.getContainer().add(bank_effect);
    }
    bank_effect.addActionPoints(this.Const.BankApIncreaseOnUse);
    return true;
  }

});
