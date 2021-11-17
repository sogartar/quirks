this.quirks_precision_effect <- this.inherit("scripts/skills/skill", {
  m = {
    HitChanceBonus = this.Const.Quirks.PrecisionHitChanceBonus,
    HitChanceBonusDecreasePerTurn = this.Const.Quirks.PrecisionHitChanceBonusDecreasePerTurn
  }

  function create() {
    this.m.ID = "effects.quirks.precision";
    this.m.Name = this.Const.Strings.PerkName.QuirksPrecision;
    this.m.Icon = "ui/perks/perk_quirks_precision.png";
    this.m.IconMini = "quirks_precision_effect_mini";
    this.m.Overlay = "perk_quirks_precision";
    this.m.Type = this.Const.SkillType.StatusEffect;
    this.m.IsActive = false;
    this.m.IsStacking = true;
    this.m.IsRemovedAfterBattle = true;
  }

  function getName() {
    return this.skill.getName() + " (+" + this.m.HitChanceBonus + ")";
  }

  function getDescription() {
    return "This character has [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.HitChanceBonus +
      "%[/color] additional hit chance next attack.";
  }

  function onAnySkillUsed(_skill, _targetEntity, _properties) {
    if (_skill.isAttack()) {
      local bonus = this.m.HitChanceBonus;
      bonus *= _skill.isAOE() ? 0.5 : 1;
      _properties.MeleeSkill += bonus;
      _properties.RangedSkill += bonus;
    }
  }

  function onTargetHit(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor) {
    this.getContainer().remove(this);
  }

  function onTargetMissed(_skill, _targetEntity) {
    this.getContainer().remove(this);
  }
  
  function onTurnStart() {
    this.m.HitChanceBonus = this.Math.maxf(0, this.m.HitChanceBonus - this.m.HitChanceBonusDecreasePerTurn);
    if (this.m.HitChanceBonus == 0) {
      this.removeSelf();
    }
  }
});
