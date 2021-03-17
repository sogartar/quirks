this.precision_effect <- this.inherit("scripts/skills/skill", {
  m = {
    HitChanceBonus = this.Const.PrecisionHitChanceBonus,
    HitChanceBonusDecreasePerTurn = this.Const.PrecisionHitChanceBonusDecreasePerTurn
  }

  function create() {
    this.m.ID = "effects.precision";
    this.m.Name = this.Const.Strings.PerkName.Precision;
    this.m.Icon = "ui/perks/perk_precision.png";
    this.m.IconMini = "";
    this.m.Overlay = "perk_precision";
    this.m.Type = this.Const.SkillType.StatusEffect;
    this.m.IsActive = false;
    this.m.IsStacking = true;
    this.m.IsRemovedAfterBattle = true;
  }

  function getDescription() {
    return "This character has [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.HitChanceBonus +
      "%[/color] additional hit chance next attack.";
  }

  function onAnySkillUsed(_skill, _targetEntity, _properties) {
    if (_skill.isAttack()) {
      _properties.MeleeSkill += this.m.HitChanceBonus;
      _properties.RangedSkill += this.m.HitChanceBonus;
    }
  }

  function onTargetHit(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor) {
    this.getContainer().remove(this);
  }

  function onTargetMissed(_skill, _targetEntity) {
    this.getContainer().remove(this);
  }
  
  function onTurnStart() {
    this.m.HitChanceBonus -= this.m.HitChanceBonusDecreasePerTurn;
    if (this.m.HitChanceBonus == 0) {
      this.removeSelf();
    }
  }
});
