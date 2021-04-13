this.quirks_bank_skill <- this.inherit("scripts/skills/skill", {
  m = {},
  function create()
  {
    this.m.ID = "actives.quirks.bank";
    this.m.Name = this.Const.Strings.PerkName.QuirksBank;
    this.m.Description = this.Const.Strings.BankSkillDescription;
    this.m.Icon = "ui/actives/active_quirks_bank.png";
    this.m.IconDisabled = "ui/actives/active_quirks_bank_sw.png";
    this.m.Overlay = "active_quirks_bank";
    this.m.SoundOnUse = [
      "sounds/combat/active_quirks_bank.wav"
    ];
    this.m.Type = this.Const.SkillType.Active;
    this.m.Order = this.Const.SkillOrder.Any;
    this.m.IsSerialized = false;
    this.m.IsActive = true;
    this.m.IsTargeted = false;
    this.m.IsAttack = false;
    this.m.IsAudibleWhenHidden = true;
    this.m.ActionPointCost = this.Const.Quirks.BankApCost;
    this.m.FatigueCost = this.Const.Quirks.BankFatigueCost;
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
    local bank_effect = this.getContainer().getSkillByID("effects.quirks.bank");
    if (bank_effect == null) {
      bank_effect = this.new("scripts/skills/effects/quirks_bank_effect");
      this.getContainer().add(bank_effect);
    }
    bank_effect.addActionPoints(this.Const.Quirks.BankApIncreaseOnUse);
    return true;
  }

});
