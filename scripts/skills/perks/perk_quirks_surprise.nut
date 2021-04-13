this.perk_quirks_surprise <- this.inherit("scripts/skills/skill", {
  m = {
    OnMissedInitiativeStolen = this.Const.Quirks.SurpriseOnMissedInitiativeStolen,
    StacksForThisRound = 0,
    StacksForNextRound = 0
  },
  function create() {
    this.m.ID = "perk.quirks.surprise";
    this.m.Name = this.Const.Strings.PerkName.QuirksSurprise;
    this.m.Icon = "ui/perks/perk_quirks_surprise.png";
    this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
    this.m.Order = this.Const.SkillOrder.Perk;
    this.m.IsActive = false;
    this.m.IsHidden = true;
  }

  function getName() {
    return this.skill.getName() + " (" + this.m.StacksForThisRound + "x this round, " + this.m.StacksForNextRound + "x next)";
  }

  function getDescription() {
    return this.getroottable().Quirks.getSurpriseDescription(this.m.OnMissedInitiativeStolen) +
      "\n[color=" + this.Const.UI.Color.PositiveValue + "]" + (this.m.OnMissedInitiativeStolen * this.m.StacksForThisRound) + "[/color] initiative stolen and active currently." +
      "\n[color=" + this.Const.UI.Color.PositiveValue + "]" + (this.m.OnMissedInitiativeStolen * this.m.StacksForNextRound) + "[/color] initiative stolen for next round.";
  }

  function onMissed(_attacker, _skill) {
    local surprisedEffect = this.new("scripts/skills/effects/quirks_surprised_effect");
    _attacker.getSkills().add(surprisedEffect);

    surprisedEffect.decreaseInitiativeForThisRound(this.m.OnMissedInitiativeStolen);
    surprisedEffect.decreaseInitiativeForNextRound(this.m.OnMissedInitiativeStolen);
    this.m.StacksForThisRound += 1;
    this.m.StacksForNextRound += 1;
  }

  function onCombatFinished() {
    this.reset();
    this.skill.onCombatFinished();
  }

  function onUpdate(_properties) {
    this.m.IsHidden = (this.m.StacksForThisRound == 0 && this.m.StacksForNextRound == 0);
    _properties.Initiative += this.m.OnMissedInitiativeStolen * this.m.StacksForThisRound;
    _properties.TargetAttractionMult *= 0.9;
  }

  function reset() {
    this.m.IsHidden = true;
    this.m.StacksForThisRound = 0;
    this.m.StacksForNextRound = 0;
  }
  
  function onRoundEnd() {
    this.m.StacksForThisRound = this.m.StacksForNextRound;
    this.m.StacksForNextRound = 0;
  }
});
