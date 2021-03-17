this.perk_punching_bag <- this.inherit("scripts/skills/skill", {
  m = {
    OnHitDamageMult = this.Const.PunchingBagOnHitDamageMult,
    DamageMult = 1.0
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
      "\nCurrent damage reduction [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.round((1 - this.m.DamageMult) * 100) + "%[/color].";
  }

  function onDamageReceived(_attacker, _damageHitpoints, _damageArmor) {
    this.m.DamageMult *= this.m.OnHitDamageMult;
    this.m.IsHidden = false;
  }

  function onTurnStart() {
    this.reset();
  }

  function onCombatFinished() {
    this.reset();
    this.skill.onCombatFinished();
  }

  function onUpdate(_properties) {
    _properties.DamageReceivedTotalMult *= this.m.DamageMult;
  }
  
  function reset() {
    this.m.IsHidden = true;
    this.m.DamageMult = 1.0;
  }
});
