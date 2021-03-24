this.perk_last_stand <- this.inherit("scripts/skills/skill", {
  m = {
    OnHitResolveBonusPerNeighbourEnemy = this.Const.LastStandOnHitResolveBonusPerNeighbourEnemy,
    ResolveBonusMax = this.Const.LastStandResolveBonusMax,
    ResolveBonus = 0
  }

  function create() {
    this.m.ID = "perk.last_stand";
    this.m.Name = this.Const.Strings.PerkName.LastStand;
    this.m.Icon = "ui/perks/perk_last_stand.png";
    this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
    this.m.Order = this.Const.SkillOrder.Perk;
    this.m.IsActive = false;
    this.m.IsHidden = true;
  }

  function getDescription() {
    return this.getroottable().getLastStandDescription(this.m.OnHitResolveBonusPerNeighbourEnemy, this.m.ResolveBonusMax) +
      "\nCurrent resolve bonus is [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.ResolveBonus + "[/color].";
  }

  function getOnHitBonus() {
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

    return surroundCount * this.m.OnHitResolveBonusPerNeighbourEnemy;
  }

  function onDamageReceived(_attacker, _damageHitpoints, _damageArmor) {
    if (_damageHitpoints > 0) {
      this.m.IsHidden = false;
      this.m.ResolveBonus = this.Math.min(this.m.ResolveBonusMax, this.m.ResolveBonus + this.getOnHitBonus());
    }
  }

  function onCombatFinished() {
    this.reset();
    this.skill.onCombatFinished();
  }

  function onUpdate(_properties) {
    _properties.Bravery += this.m.ResolveBonus;
  }

  function reset() {
    this.m.IsHidden = true;
    this.m.ResolveBonus = 0;
  }
});
