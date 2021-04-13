this.quirks_slow_down_effect <- this.inherit("scripts/skills/skill", {
  m = {
    InitiativeForTurnOrderModifier = this.Const.Quirks.SlowDownInitiativeForTurnOrderModifier
  }

  function create()
  {
    this.m.ID = "effects.quirks.slow_down";
    this.m.Name = this.Const.Strings.PerkName.QuirksSlowDown;
    this.m.Description = this.getroottable().Quirks.getSlowDownEffectDescription();
    this.m.Icon = "ui/perks/perk_quirks_slow_down.png";
    this.m.IconMini = "";
    this.m.Overlay = "perk_quirks_slow_down";
    this.m.Type = this.Const.SkillType.StatusEffect;
    this.m.IsActive = false;
    this.m.IsRemovedAfterBattle = true;
  }

  function findEntityTurnOrderIdx(id) {
    foreach(i, e in this.Tactical.TurnSequenceBar.getCurrentEntities()) {
      if (e.getID() == id) {
          return i;
      }
    }
    return null;
  }

  function onWaitTurn() {
    local turnOrder = this.findEntityTurnOrderIdx(this.getContainer().getActor().getID());
    this.logInfo("Before push back turnOrder = " + turnOrder);
    this.Tactical.TurnSequenceBar.pushEntityBack(this.getContainer().getActor().getID());
    turnOrder = this.findEntityTurnOrderIdx(this.getContainer().getActor().getID());
    this.logInfo("After push back turnOrder = " + turnOrder);
  }

  function onUpdated(_properties) {
    _properties.InitiativeForTurnOrderAdditional += this.m.InitiativeForTurnOrderModifier;
  }

  function onTurnEnd() {
    this.removeSelf();
  }
});
