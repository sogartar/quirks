this.surprised_effect <- this.inherit("scripts/skills/skill", {
  m = {
    InitiativeModifierForThisRound = 0
    InitiativeModifierForNextRound = 0
  }

  function create() {
    this.m.ID = "effects.surprised";
    this.m.Name = this.Const.Strings.SurprisedEffectName;
    this.m.Icon = "ui/perks/surprised_effect.png";
    this.m.IconMini = "";
    this.m.Overlay = "surprised_effect";
    this.m.Type = this.Const.SkillType.StatusEffect;
    this.m.IsActive = false;
    this.m.IsRemovedAfterBattle = true;
    this.m.IsStacking = true;
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

  function decreaseInitiativeForNextRound(value) {
    this.m.InitiativeModifierForNextRound -= value;
  }
});