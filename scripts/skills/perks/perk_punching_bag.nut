this.perk_punching_bag <- this.inherit("scripts/skills/skill", {
  m = {
    OnHitDamageMult = this.Const.PunchingBagOnHitDamageMult,
    ThisTurnDamageMult = 1.0,
    NextTurnDamageMult = 1.0
  },
  function create() {
    this.m.ID = "perk.punching_bag";
    this.m.Name = this.Const.Strings.PerkName.PunchingBag;
    this.m.Icon = "ui/perks/perk_punching_bag.png";
    this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
    this.m.Order = this.Const.SkillOrder.Perk;
    this.m.IsActive = false;
    this.m.IsHidden = true;
  }

  function getDescription() {
    return this.getroottable().getPunchingBagDescription(this.m.OnHitDamageMult) +
      "\nCurrent damage reduction [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.round((1 - this.m.ThisTurnDamageMult) * 100) + "%[/color]." +
      "\nNext turn damage reduction [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.round((1 - this.m.NextTurnDamageMult) * 100) + "%[/color].";
  }

  function onDamageReceived(_attacker, _damageHitpoints, _damageArmor) {
    this.m.ThisTurnDamageMult *= this.m.OnHitDamageMult;
    this.m.NextTurnDamageMult *= this.m.OnHitDamageMult;
    this.m.IsHidden = false;
  }

  function onTurnStart() {
    this.m.ThisTurnDamageMult = this.m.NextTurnDamageMult;
    this.m.NextTurnDamageMult = 1.0;
    if (this.m.ThisTurnDamageMult == 1.0) {
      this.m.IsHidden = true;
    }
  }

  function onCombatFinished() {
    this.reset();
    this.skill.onCombatFinished();
  }

  function onUpdate(_properties) {
    _properties.DamageReceivedTotalMult *= this.m.ThisTurnDamageMult;
    _properties.TargetAttractionMult *= this.m.ThisTurnDamageMult;
  }

  function reset() {
    this.m.IsHidden = true;
    this.m.ThisTurnDamageMult = 1.0;
    this.m.NextTurnDamageMult = 1.0;
  }
});
