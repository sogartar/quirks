this.quirks_knackered_effect <- this.inherit("scripts/skills/skill", {
  m = {
    DefenseModifier = this.Const.Quirks.KnackeredDefenseModifier,
    IsKnackered = false
  }

  function create() {
    this.m.ID = "effects.quirks.knackered";
    this.m.Name = "Knackered";
    this.m.Icon = "ui/effects/quirks_knackered_effect.png";
    this.m.IconMini = "";
    this.m.Overlay = "quirks_knackered_effect";
    this.m.Type = this.Const.SkillType.StatusEffect;
    this.m.IsActive = false;
    this.m.IsStacking = false;
    this.m.IsHidden = true;
  }

  function getDescription() {
    return this.getroottable().Quirks.getKnackeredDescription(this.m.DefenseModifier);
  }

  function isInCombat() {
    try {
      return ("Entities" in this.Tactical) && !this.Tactical.Entities.isCombatFinished();
    } catch (exception) {
      return false;
    }
  }

  function onUpdate(_properties) {
    local actor = this.getContainer().getActor();
    local staminaLeft = actor.getFatigueMax() - actor.getFatigue();
    local isKnackered = staminaLeft <= 0;
    this.m.IsHidden = !isKnackered;
    if (isKnackered) {
      _properties.MeleeDefense += this.m.DefenseModifier;
      _properties.RangedDefense += this.m.DefenseModifier;
      if (this.isInCombat() && !this.m.IsKnackered) {
        this.spawnIcon("quirks_knackered_effect", actor.getTile());
      }
    }
    this.m.IsKnackered = isKnackered;
  }
});
