this.quirks_exertion_effect <- this.inherit("scripts/skills/skill", {
  m = {
    DamageMult = this.Const.Quirks.ExertionDamageMult,
    FatigueCostBaseMult = this.Const.Quirks.ExertionFatigueCostBaseMult,
    FatiguePoolCostMult = this.Const.Quirks.ExertionFatiguePoolCostMult,
    ResolveCostMult = this.Const.Quirks.ExertionResolveCostMult,
    MinFatigueCostMult = this.Const.Quirks.ExertionMinFatigueCostMult,
  },
  function create() {
    this.m.ID = "effects.quirks.exertion";
    this.m.Name = this.Const.Strings.PerkName.QuirksExertion;
    this.m.Icon = "ui/perks/perk_quirks_exertion.png";
    this.m.IconMini = "perk_quirks_exertion_mini";
    this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
    this.m.Order = this.Const.SkillOrder.Perk | this.Const.SkillType.StatusEffect;
    this.m.IsHidden = false;
    this.m.IsStacking = false;
  }

  function getDescription() {
    return "Total Damage [color=" + this.Const.UI.Color.PositiveValue + "]+" +
      this.Math.round((this.m.DamageMult - 1) * 100)
      + "%[/color]\n" +
      "Fatigue Cost [color=" + this.Const.UI.Color.NegativeValue + "]+" +
      this.Math.round((this.getFatigueCostMult() - 1) * 100)
      + "%[/color]\n";
  }

  function getFatigueCostMult() {
    local actor = this.getContainer().getActor();
    local res = this.m.FatigueCostBaseMult -
      this.m.FatiguePoolCostMult * (actor.getFatigueMax() - actor.getFatigue()) -
      this.m.ResolveCostMult * actor.getBravery();
    res = this.Math.maxf(this.m.MinFatigueCostMult, res);
    return res;
  }

  function onUpdate(_properties) {
    local container = this.getContainer();
    if (container.getSkillByID("actives.shoot_bolt") != null ||
      container.getSkillByID("actives.shoot_stake") != null ||
      container.getSkillByID("actives.fire_handgonne") != null ||
      container.getSkillByID("effects.spearwall") != null) {
      this.logInfo("exertion.onUpdate: not a valid weapon.");
      return;
    }
    this.logInfo("exertion.onUpdate: applying effect.");
    _properties.FatigueEffectMult *= this.getFatigueCostMult();
    _properties.DamageTotalMult *= this.m.DamageMult;
  }

  function onAfterAnySkillUsed(_skill, _targetTile) {
    this.logInfo("quirks_exertion_effect.onAfterAnySkillUsed");
    if (_skill.getID() != "actives.quirks.exertion") {
      this.removeSelf();
    }
  }
});
