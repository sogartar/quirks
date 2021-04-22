this.perk_quirks_last_stand <- this.inherit("scripts/skills/skill", {
  m = {
    ResolveBonusPerNeighbourEnemy = this.Const.Quirks.LastStandResolveBonusPerNeighbourEnemy,
    ResolveBonusMax = this.Const.Quirks.LastStandResolveBonusMax,
    Stacks = 0
  }

  function create() {
    this.m.ID = "perk.quirks.last_stand";
    this.m.Name = this.Const.Strings.PerkName.QuirksLastStand;
    this.m.Icon = "ui/perks/perk_quirks_last_stand.png";
    this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
    this.m.Order = this.Const.SkillOrder.Perk;
    this.m.IsActive = false;
    this.m.IsHidden = true;
  }

  function getDescription() {
    local res = this.getroottable().Quirks.getLastStandDescription(this.m.ResolveBonusPerNeighbourEnemy, this.m.ResolveBonusMax);
    if (this.m.Stacks != 0) {
      res += "\nCurrent resolve bonus is [color=" + this.Const.UI.Color.PositiveValue + "]" + this.getBonus()+ "[/color].";
    }
    return res;
  }

  function getBonus() {
    if (this.m.Stacks == 0) {
      return 0;
    }

    local actor = this.getContainer().getActor();

    if (!actor.isPlacedOnMap()) {
      return 0;
    }

    local myTile = actor.getTile();
    local surroundCount = 0;

    for(local i = 0; i != 6; i += 1) {
      if (myTile.hasNextTile(i)) {
        local tile = myTile.getNextTile(i);

        if (!tile.IsEmpty && tile.IsOccupiedByActor && this.Math.abs(myTile.Level - tile.Level) <= 1 &&
          !actor.isAlliedWith(tile.getEntity().getFaction())) {
          surroundCount += 1;
        }
      }
    }

    return this.Math.minf(this.m.ResolveBonusMax, surroundCount * this.m.ResolveBonusPerNeighbourEnemy * this.m.Stacks);
  }

  function onDamageReceived(_attacker, _damageHitpoints, _damageArmor) {
    if (_damageHitpoints > 0) {
      this.m.Stacks += 1;
      this.m.IsHidden = false;
    }
  }

  function onCombatFinished() {
    this.reset();
    this.skill.onCombatFinished();
  }

  function onUpdate(_properties) {
    _properties.Bravery += this.getBonus();
  }

  function reset() {
    this.m.IsHidden = true;
    this.m.Stacks = 0;
  }
});
