this.quirks_plunge_effect <- this.inherit("scripts/skills/skill", {
  m = {
    DamageMultPerStack = this.Const.Quirks.PlungeDamageMultPerStack,
    KnockBackChancePerStack = this.Const.Quirks.PlungeKnockBackChancePerStack,
    StartTile = null,
    IsSpent = false,
    Skill = null,
    TargetEntity = null,
    TargetEntityTile = null
  }

  function create() {
    this.m.ID = "effects.quirks.plunge";
    this.m.Name = this.Const.Strings.PerkName.QuirksPlunge;
    this.m.Icon = "ui/perks/perk_quirks_plunge.png";
    this.m.IconMini = "";
    this.m.Overlay = "perk_quirks_plunge";
    this.m.Type = this.Const.SkillType.StatusEffect;
    this.m.IsActive = false;
    this.m.IsStacking = false;
    this.m.IsRemovedAfterBattle = true;
  }

  function getDescription() {
    return this.getroottable().Quirks.getPlungeEffectDescription(
      this.m.DamageMultPerStack, this.m.KnockBackChancePerStack);
  }

  function onAdded() {
    this.m.StartTile = this.getContainer().getActor().getTile();
  }

  function onWaitTurn() {
    this.removeSelf();
  }

  function findTileToKnockBackTo(_userTile, _targetTile) {
    local dir = _userTile.getDirectionTo(_targetTile);

    if (_targetTile.hasNextTile(dir)) {
      local knockToTile = _targetTile.getNextTile(dir);

      if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1) {
        return knockToTile;
      }
    }

    local altdir = dir - 1 >= 0 ? dir - 1 : 5;

    if (_targetTile.hasNextTile(altdir)) {
      local knockToTile = _targetTile.getNextTile(altdir);

      if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1) {
        return knockToTile;
      }
    }

    altdir = dir + 1 <= 5 ? dir + 1 : 0;

    if (_targetTile.hasNextTile(altdir)) {
      local knockToTile = _targetTile.getNextTile(altdir);

      if (knockToTile.IsEmpty && knockToTile.Level - _targetTile.Level <= 1) {
        return knockToTile;
      }
    }

    return null;
  }

  function getStacks() {
    local tile = this.getContainer().getActor().getTile();
    local distance = tile.getDistanceTo(this.m.StartTile);
    local levelDiff = this.m.StartTile.Level - tile.Level;
    local stacks = this.Math.max(0, distance + levelDiff);
    return stacks;
  }

  function getKnockBackChance() {
    local stack = this.getStacks();
    return 1 - ::libreuse.binomialCdf(stack, 0, this.m.KnockBackChancePerStack);
  }

  function onAnySkillUsed(_skill, _targetEntity, _properties) {
    if (_skill != null && _skill.isAttack() && !_skill.isRanged()) {
      _properties.DamageTotalMult *= this.Math.pow(this.m.DamageMultPerStack, this.getStacks());
      this.m.IsSpent = true;
      this.m.Skill = _skill;
      this.m.TargetEntity = _targetEntity;
      #this.logInfo("_targetEntity = " + ::libreuse.toStr(_targetEntity, 1));
      this.m.TargetEntityTile = _targetEntity.getTile();
    }
  }

  function onAfterUpdate(_properties) {
    changeMovementFatigueCost();
  }

  function changeMovementFatigueCost() {
    if (this.getContainer().getSkillByID("perk.pathfinder") == null) {
      this.changeMovementFatigueCostWithoutPathfinder();
    } else {
      this.changeMovementFatigueCostWithPathfinder();
    }
  }

  function changeMovementFatigueCostWithPathfinder() {
    local actor = this.getContainer().getActor();
    local movementFatigueCosts = clone actor.m.FatigueCosts;
    for (local i = 0; i < movementFatigueCosts.len(); i += 1) {
      movementFatigueCosts[i] += this.Const.DefaultMovementFatigueCost[i];
    }
    actor.m.FatigueCosts = movementFatigueCosts;

    actor.m.LevelFatigueCost += this.Const.Movement.LevelDifferenceFatigueCost;
  }

  function changeMovementFatigueCostWithoutPathfinder() {
    local actor = this.getContainer().getActor();
    actor.m.FatigueCosts = clone this.Const.DefaultMovementFatigueCost;
    actor.m.LevelFatigueCost = this.Const.Movement.LevelDifferenceFatigueCost;
    this.changeMovementFatigueCostWithPathfinder();
  }

  function onTurnEnd() {
    this.removeSelf();
  }

  function onAfterAnySkillUsed(_skill, _targetTile) {
    this.logInfo("plunge.onAfterAnySkillUsed");
    if (this.m.IsSpent) {
      this.logInfo("removing.");
      this.getContainer().getActor().setDirty(true);
      this.getContainer().remove(this);
    }
  }

  function onPlunge(_entity, _tag) {
    this.logInfo("Plunge callback called.");
    local actorTile = _tag.User.getTile();
    local plungeToTile = actorTile.hasNextTile(_tag.Direction) ? actorTile.getNextTile(_tag.Direction) : null;
    #this.logInfo(::libreuse.toStr(this.getstackinfos(1), 2));
    if (plungeToTile != null && plungeToTile.IsEmpty && plungeToTile.Level - actorTile.Level <= 1) {
      this.logInfo("Teleporting.");
      this.Tactical.getNavigator().teleport(_tag.User, plungeToTile, null, null, false);
    }
  }

  function onTargetHit(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor) {
    this.logInfo("plunge.onTargetHit");
    if (_skill != this.m.Skill ||
      _targetEntity.getCurrentProperties().IsImmuneToKnockBackAndGrab ||
      _targetEntity.getCurrentProperties().IsRooted) {
      return;
    }

    local knockBackChance = this.getKnockBackChance();
    this.logInfo("knockBackChance = " + knockBackChance);
    if (knockBackChance * 1000 <= this.Math.rand(1, 1000)) {
      return;
    }

    local actor = this.getContainer().getActor();
    local actorTile = actor.getTile();
    if (_targetEntity.isAlive()) {
      local knockBackTile = this.findTileToKnockBackTo(this.getContainer().getActor().getTile(), _targetEntity.getTile());
      if (knockBackTile != null) {
        _targetEntity.setCurrentMovementType(this.Const.Tactical.MovementType.Involuntary);
        local callback = null;
        local tag = null;
        if (_targetEntity == this.m.TargetEntity) {
          this.logInfo("Scheduling plunge.");
          tag = {
            User = actor,
            Direction = actorTile.getDirectionTo(this.m.TargetEntityTile)
          };
          callback = this.onPlunge.bindenv(this);
        }
        this.Tactical.getNavigator().teleport(_targetEntity, knockBackTile, callback, tag, true);
      }
    } else {
      if (_targetEntity == this.m.TargetEntity) {
        local tag = {
          User = actor,
          Direction = actorTile.getDirectionTo(this.m.TargetEntityTile)
        };
        this.onPlunge(null, tag);
      }
    }
  }
});
