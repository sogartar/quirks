this.quirks_surprised_effect <- this.inherit("scripts/skills/skill", {
  m = {
    InitiativeModifierForThisRound = 0
    InitiativeModifierForNextRound = 0
  }

  function create() {
    this.m.ID = "effects.quirks.surprised";
    this.m.Name = this.Const.Strings.SurprisedEffectName;
    this.m.Icon = "ui/effects/quirks_surprised_effect.png";
    this.m.IconMini = "";
    this.m.Overlay = "quirks_surprised_effect";
    this.m.Type = this.Const.SkillType.StatusEffect;
    this.m.IsActive = false;
    this.m.IsRemovedAfterBattle = true;
    this.m.IsStacking = true;
  }

  function getName() {
    return this.skill.getName() + (this.m.InitiativeModifierForNextRound == 0 ? " (1 turn)" : " (2 turns)");
  }

  function getDescription() {
    return "[color=" + this.Const.UI.Color.NegativeValue + "]" + this.m.InitiativeModifierForThisRound + "[/color] initiative stolen from this character and active currently." +
      "\n[color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.InitiativeModifierForNextRound + "[/color] initiative stolen from this character for next round.";
  }

  function onRoundEnd() {
    if (this.m.InitiativeModifierForNextRound == 0) {
      this.removeSelf();
      return;
    }

    this.m.InitiativeModifierForThisRound = this.m.InitiativeModifierForNextRound;
    this.m.InitiativeModifierForNextRound = 0;
  }

  function onUpdate(_properties) {
    _properties.Initiative += this.m.InitiativeModifierForThisRound;
  }

  function decreaseInitiativeForThisRound(value) {
    this.m.InitiativeModifierForThisRound -= value;
  }

  function decreaseInitiativeForNextRound(value) {
    this.m.InitiativeModifierForNextRound -= value;
  }
});
