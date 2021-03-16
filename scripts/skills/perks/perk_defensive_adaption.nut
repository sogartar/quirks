this.perk_defensive_adaption <- this.inherit("scripts/skills/skill", {
  m = {
    BonusPerStack = this.Const.DefensiveAdaptionBonusPerStack
    Stacks = 0
  },
  function create() {
    this.m.ID = "perk.defensive_adaption";
    this.m.Name = this.Const.Strings.PerkName.DefensiveAdaption;
    this.m.Icon = "ui/perks/perk_defensive_adaption.png";
    this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
    this.m.Order = this.Const.SkillOrder.Perk | this.Const.SkillType.StatusEffect;
    this.m.IsActive = false;
    this.m.IsHidden = true;
  }

  function getBonus() {
    return this.m.Stacks * this.m.BonusPerStack;
  }

  function getDescription() {
    return this.getroottable().getDefensiveAdaptionDescription(this.m.BonusPerStack) +
      "\nCurrent defense bonus [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getBonus() + "[/color].";
  }

  function onUpdate(_properties) {
    this.m.IsHidden = this.m.Stacks == 0;
    local bonus = this.getBonus();
    _properties.MeleeDefense += bonus;
    _properties.RangedDefense += bonus;
  }

  function onDamageReceived(_attacker, _damageHitpoints, _damageArmor) {
    this.m.Stacks += 1;
  }

  function onMissed(_attacker, _skill) {
    this.m.Stacks = 0;
  }
  

  function onCombatFinished() {
    this.m.Stacks = 0;
    this.skill.onCombatFinished();
  }
});
