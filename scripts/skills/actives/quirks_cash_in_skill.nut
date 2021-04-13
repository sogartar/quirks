this.quirks_cash_in_skill <- this.inherit("scripts/skills/skill", {
  m = {},
  function create() {
    this.m.ID = "actives.quirks.cash_in";
    this.m.Name = this.Const.Strings.CashInName;
    this.m.Icon = "ui/actives/active_quirks_cash_in.png";
    this.m.IconDisabled = "ui/actives/active_quirks_cash_in_sw.png";
    this.m.Overlay = "active_quirks_cash_in";
    this.m.SoundOnUse = [
      "sounds/combat/active_quirks_cash_in.wav"
    ];
    this.m.Type = this.Const.SkillType.Active;
    this.m.Order = this.Const.SkillOrder.Any;
    this.m.IsSerialized = false;
    this.m.IsActive = true;
    this.m.IsTargeted = false;
    this.m.IsAttack = false;
    this.m.IsAudibleWhenHidden = true;
    this.m.ActionPointCost = this.Const.Quirks.CashInApCost;
    this.m.FatigueCost = this.Const.Quirks.CashInFatigueCost;
    this.m.MinRange = 0;
    this.m.MaxRange = 0;
    this.m.IsRemovedAfterBattle = true;
  }

  function getDescription() {
    local skills = this.getContainer();
    local bank_effect = skills.getSkillByID("effects.quirks.bank");
    return "Cash in [color=" + this.Const.UI.Color.PositiveValue + "]" + bank_effect.getActionPoints() + "[/color] banked action points.";
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
    local skills = this.getContainer();
    return this.skill.isUsable() && skills.hasSkill("effects.quirks.bank") && !skills.hasSkill("effects.quirks.cashed_in");
  }

  function onUse(_user, _targetTile) {
    local skills = this.getContainer();
    local actor = skills.getActor();
    local bank_effect = skills.getSkillByID("effects.quirks.bank");
    local ap = bank_effect.getActionPoints();
    skills.remove(bank_effect);
    local cashed_in_effect = this.new("scripts/skills/effects/quirks_cashed_in_effect");
    cashed_in_effect.setActionPoints(ap);
    skills.add(cashed_in_effect);
    this.getContainer().remove(this);
    return true;
  }
});
