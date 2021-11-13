this.perk_quirks_punching_bag <- this.inherit("scripts/skills/skill", {
  m = {
    OnHitDamageMult = this.Const.Quirks.PunchingBagOnHitDamageMult,
    OnTurnStartBonusMult = this.Const.Quirks.PunchingBagOnTurnStartBonusMult,
    DamageMult = 1.0
  },
  function create() {
    this.m.ID = "perk.quirks.punching_bag";
    this.m.Name = this.Const.Strings.PerkName.QuirksPunchingBag;
    this.m.Icon = "ui/perks/perk_quirks_punching_bag.png";
    this.m.IconMini = "perk_quirks_punching_bag_mini";
    this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
    this.m.Order = this.Const.SkillOrder.Perk;
    this.m.IsActive = false;
    this.m.IsHidden = true;
  }

  function getDescription() {
    return this.getroottable().Quirks.getPunchingBagDescription(this.m.OnHitDamageMult, this.m.OnTurnStartBonusMult) +
      "\nCurrent damage reduction [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.round((1 - this.m.DamageMult) * 100) + "%[/color].";
  }

  function onBeforeDamageReceived(_attacker, _skill, _hitInfo, _properties) {
    if (_skill != null && _skill.isAttack()) {
      _properties.DamageReceivedTotalMult *= this.m.DamageMult;
      this.m.DamageMult *= this.m.OnHitDamageMult;
      this.m.IsHidden = false;
    }
  }

  function onTurnStart() {
    this.m.DamageMult = 1 - (1 - this.m.DamageMult) * this.m.OnTurnStartBonusMult;
    if (this.m.DamageMult == 1.0) {
      this.m.IsHidden = true;
    }
  }

  function onCombatFinished() {
    this.reset();
    this.skill.onCombatFinished();
  }

  function onUpdate(_properties) {
    _properties.TargetAttractionMult *= this.m.DamageMult;
  }

  function reset() {
    this.m.IsHidden = true;
    this.m.DamageMult = 1.0;
  }
});
