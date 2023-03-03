this.perk_quirks_defensive_adaptation <- this.inherit("scripts/skills/skill", {
  m = {
    BonusPerStack = this.Const.Quirks.DefensiveAdaptationBonusPerStack
    Stacks = 0
  },
  function create() {
    this.m.ID = "perk.quirks.defensive_adaptation";
    this.m.Name = this.Const.Strings.PerkName.QuirksDefensiveAdaptation;
    this.m.Icon = "ui/perks/perk_quirks_defensive_adaptation.png";
    this.m.IconMini = "perk_quirks_defensive_adaptation_mini";
    this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
    this.m.Order = this.Const.SkillOrder.Perk | this.Const.SkillType.StatusEffect;
    this.m.IsActive = false;
    this.m.IsHidden = true;
  }

  function getBonus() {
    return this.m.Stacks * this.m.BonusPerStack;
  }

  function getDescription() {
    return this.getroottable().Quirks.getDefensiveAdaptationDescription(this.m.BonusPerStack) +
      "\nCurrent defense bonus [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getBonus() + "[/color].";
  }

  function onUpdate(_properties) {
    this.m.IsHidden = this.m.Stacks == 0;
    local bonus = this.getBonus();
    _properties.MeleeDefense += bonus;
    _properties.RangedDefense += bonus;
    _properties.TargetAttractionMult *= this.Math.pow(1.008, bonus);
  }

  function onDamageReceived(_attacker, _damageHitpoints, _damageArmor) {
    this.m.Stacks += 1;
  }

  function onMissed(_attacker, _skill) {
    this.m.Stacks = this.Math.max(0, this.m.Stacks - 1);
  }

  function onCombatFinished() {
    this.m.Stacks = 0;
    this.skill.onCombatFinished();
  }
});
