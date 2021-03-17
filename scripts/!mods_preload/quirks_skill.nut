local gt = this.getroottable();

if (!("quirks" in gt)) {
  ::quirks <- {};
}

::quirks.makeHitChanceMultipliersSymmetric <- function() {
  ::mods_hookClass("skills/skill", function(c) {
    local skillClass = ::libreuse.getParentClass(c, "skill");
    if (skillClass == null) {
      skillClass = c;
    }

    skillClass.scaleHitChance <- function(hitChance, attackerProperties, defenderProperties) {
      hitChance = hitChance * attackerProperties.TotalAttackToHitMult * defenderProperties.TotalAttackToHitMult;
      hitChance = hitChance + this.Math.max(0, 100 - hitChance) * (1.0 - attackerProperties.TotalDefenseToHitMult * defenderProperties.TotalDefenseToHitMult);
      return hitChance;
    }

    skillClass.getHitchance = function( _targetEntity )
    {
      if (!_targetEntity.isAttackable())
      {
        return 0;
      }

      local user = this.m.Container.getActor();
      local properties = this.m.Container.buildPropertiesForUse(this, _targetEntity);

      if (!this.isUsingHitchance())
      {
        return 100;
      }

      local allowDiversion = this.m.IsRanged && this.m.MaxRangeBonus > 1;
      local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(user, this);
      local skill = this.m.IsRanged ? properties.RangedSkill * properties.RangedSkillMult : properties.MeleeSkill * properties.MeleeSkillMult;
      local defense = _targetEntity.getDefense(user, this, defenderProperties);
      local levelDifference = _targetEntity.getTile().Level - user.getTile().Level;
      local distanceToTarget = user.getTile().getDistanceTo(_targetEntity.getTile());
      local toHit = skill - defense;

      if (this.m.IsRanged)
      {
        toHit = toHit + (distanceToTarget - this.m.MinRange) * properties.HitChanceAdditionalWithEachTile * properties.HitChanceWithEachTileMult;
      }

      if (levelDifference < 0)
      {
        toHit = toHit + this.Const.Combat.LevelDifferenceToHitBonus;
      }
      else
      {
        toHit = toHit + this.Const.Combat.LevelDifferenceToHitMalus * levelDifference;
      }

      if (!this.m.IsShieldRelevant)
      {
        local shield = _targetEntity.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

        if (shield != null && shield.isItemType(this.Const.Items.ItemType.Shield))
        {
          local shieldBonus = (this.m.IsRanged ? shield.getRangedDefense() : shield.getMeleeDefense()) * (_targetEntity.getCurrentProperties().IsSpecializedInShields ? 1.25 : 1.0);
          toHit = toHit + shieldBonus;

          if (!this.m.IsShieldwallRelevant && _targetEntity.getSkills().hasSkill("effects.shieldwall"))
          {
            toHit = toHit + shieldBonus;
          }
        }
      }

      # Original:
      # toHit = toHit * properties.TotalAttackToHitMult;
      # toHit = toHit + this.Math.max(0, 100 - toHit) * (1.0 - defenderProperties.TotalDefenseToHitMult);
      # Edit (make symmetric)
      toHit = this.scaleHitChance(toHit, properties, defenderProperties);

      local userTile = user.getTile();

      if (allowDiversion && this.m.IsRanged && userTile.getDistanceTo(_targetEntity.getTile()) > 1)
      {
        local blockedTiles = this.Const.Tactical.Common.getBlockedTiles(userTile, _targetEntity.getTile(), user.getFaction(), true);

        if (blockedTiles.len() != 0)
        {
          local blockChance = this.Const.Combat.RangedAttackBlockedChance * properties.RangedAttackBlockedChanceMult;
          toHit = this.Math.floor(toHit * (1.0 - blockChance));
        }
      }

      return this.Math.max(5, this.Math.min(95, toHit));
    };

    skillClass.attackEntity = function( _user, _targetEntity, _allowDiversion = true )
    {
      local properties = this.m.Container.buildPropertiesForUse(this, _targetEntity);
      local userTile = _user.getTile();
      local astray = false;

      if (_allowDiversion && this.m.IsRanged && userTile.getDistanceTo(_targetEntity.getTile()) > 1)
      {
        local blockedTiles = this.Const.Tactical.Common.getBlockedTiles(userTile, _targetEntity.getTile(), _user.getFaction());

        if (blockedTiles.len() != 0 && this.Math.rand(1, 100) <= this.Math.ceil(this.Const.Combat.RangedAttackBlockedChance * properties.RangedAttackBlockedChanceMult * 100))
        {
          _allowDiversion = false;
          astray = true;
          _targetEntity = blockedTiles[this.Math.rand(0, blockedTiles.len() - 1)].getEntity();
        }
      }

      if (!_targetEntity.isAttackable())
      {
        if (this.m.IsShowingProjectile && this.m.ProjectileType != 0)
        {
          local flip = !this.m.IsProjectileRotated && _targetEntity.getPos().X > _user.getPos().X;

          if (_user.getTile().getDistanceTo(_targetEntity.getTile()) >= this.Const.Combat.SpawnProjectileMinDist)
          {
            this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), _targetEntity.getTile(), 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
          }
        }

        return false;
      }

      local defenderProperties = _targetEntity.getSkills().buildPropertiesForDefense(_user, this);
      local defense = _targetEntity.getDefense(_user, this, defenderProperties);
      local levelDifference = _targetEntity.getTile().Level - _user.getTile().Level;
      local distanceToTarget = _user.getTile().getDistanceTo(_targetEntity.getTile());
      local toHit = 0;
      local skill = this.m.IsRanged ? properties.RangedSkill * properties.RangedSkillMult : properties.MeleeSkill * properties.MeleeSkillMult;
      toHit = toHit + skill;
      toHit = toHit - defense;

      if (this.m.IsRanged)
      {
        toHit = toHit + (distanceToTarget - this.m.MinRange) * properties.HitChanceAdditionalWithEachTile * properties.HitChanceWithEachTileMult;
      }

      if (levelDifference < 0)
      {
        toHit = toHit + this.Const.Combat.LevelDifferenceToHitBonus;
      }
      else
      {
        toHit = toHit + this.Const.Combat.LevelDifferenceToHitMalus * levelDifference;
      }

      local shieldBonus = 0;
      local shield = _targetEntity.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand);

      if (shield != null && shield.isItemType(this.Const.Items.ItemType.Shield))
      {
        shieldBonus = (this.m.IsRanged ? shield.getRangedDefense() : shield.getMeleeDefense()) * (_targetEntity.getCurrentProperties().IsSpecializedInShields ? 1.25 : 1.0);

        if (!this.m.IsShieldRelevant)
        {
          toHit = toHit + shieldBonus;
        }

        if (_targetEntity.getSkills().hasSkill("effects.shieldwall"))
        {
          if (!this.m.IsShieldwallRelevant)
          {
            toHit = toHit + shieldBonus;
          }

          shieldBonus = shieldBonus * 2;
        }
      }

      # Original:
      # toHit = toHit * properties.TotalAttackToHitMult;
      # toHit = toHit + this.Math.max(0, 100 - toHit) * (1.0 - defenderProperties.TotalDefenseToHitMult);
      # Edit (make symmetric)
      toHit = this.scaleHitChance(toHit, properties, defenderProperties);

      if (this.m.IsRanged && !_allowDiversion && this.m.IsShowingProjectile)
      {
        toHit = toHit - 15;
        properties.DamageTotalMult *= 0.75;
      }

      if (defense > -100 && skill > -100)
      {
        toHit = this.Math.max(5, this.Math.min(95, toHit));
      }

      _targetEntity.onAttacked(_user);

      if (this.m.IsDoingAttackMove && !_user.isHiddenToPlayer() && !_targetEntity.isHiddenToPlayer())
      {
        this.Tactical.getShaker().cancel(_user);

        if (this.m.IsDoingForwardMove)
        {
          this.Tactical.getShaker().shake(_user, _targetEntity.getTile(), 5);
        }
        else
        {
          local otherDir = _targetEntity.getTile().getDirectionTo(_user.getTile());

          if (_user.getTile().hasNextTile(otherDir))
          {
            this.Tactical.getShaker().shake(_user, _user.getTile().getNextTile(otherDir), 6);
          }
        }
      }

      if (!_targetEntity.isAbleToDie() && _targetEntity.getHitpoints() == 1)
      {
        toHit = 0;
      }

      if (!this.isUsingHitchance())
      {
        toHit = 100;
      }

      local r = this.Math.rand(1, 100);

      if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == 0)
      {
        if (_user.isPlayerControlled())
        {
          r = this.Math.max(1, r - 5);
        }
        else if (_targetEntity.isPlayerControlled())
        {
          r = this.Math.min(100, r + 5);
        }
      }

      local isHit = r <= toHit;

      if (!_user.isHiddenToPlayer() && !_targetEntity.isHiddenToPlayer())
      {
        local rolled = r;
        this.Tactical.EventLog.log_newline();

        if (astray)
        {
          if (this.isUsingHitchance())
          {
            if (isHit)
            {
              this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and the shot goes astray and hits " + this.Const.UI.getColorizedEntityName(_targetEntity) + " (Chance: " + this.Math.min(95, this.Math.max(5, toHit)) + ", Rolled: " + rolled + ")");
            }
            else
            {
              this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and the shot goes astray and misses " + this.Const.UI.getColorizedEntityName(_targetEntity) + " (Chance: " + this.Math.min(95, this.Math.max(5, toHit)) + ", Rolled: " + rolled + ")");
            }
          }
          else
          {
            this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and the shot goes astray and hits " + this.Const.UI.getColorizedEntityName(_targetEntity));
          }
        }
        else if (this.isUsingHitchance())
        {
          if (isHit)
          {
            this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and hits " + this.Const.UI.getColorizedEntityName(_targetEntity) + " (Chance: " + this.Math.min(95, this.Math.max(5, toHit)) + ", Rolled: " + rolled + ")");
          }
          else
          {
            this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and misses " + this.Const.UI.getColorizedEntityName(_targetEntity) + " (Chance: " + this.Math.min(95, this.Math.max(5, toHit)) + ", Rolled: " + rolled + ")");
          }
        }
        else
        {
          this.Tactical.EventLog.logEx(this.Const.UI.getColorizedEntityName(_user) + " uses " + this.getName() + " and hits " + this.Const.UI.getColorizedEntityName(_targetEntity));
        }
      }

      if (isHit && this.Math.rand(1, 100) <= _targetEntity.getCurrentProperties().RerollDefenseChance)
      {
        r = this.Math.rand(1, 100);
        isHit = r <= toHit;
      }

      if (isHit)
      {
        this.getContainer().setBusy(true);
        local info = {
          Skill = this,
          Container = this.getContainer(),
          User = _user,
          TargetEntity = _targetEntity,
          Properties = properties,
          DistanceToTarget = distanceToTarget
        };

        if (this.m.IsShowingProjectile && this.m.ProjectileType != 0 && _user.getTile().getDistanceTo(_targetEntity.getTile()) >= this.Const.Combat.SpawnProjectileMinDist && (!_user.isHiddenToPlayer() || !_targetEntity.isHiddenToPlayer()))
        {
          local flip = !this.m.IsProjectileRotated && _targetEntity.getPos().X > _user.getPos().X;
          local time = this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), _targetEntity.getTile(), 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
          this.Time.scheduleEvent(this.TimeUnit.Virtual, time, this.onScheduledTargetHit, info);

          if (this.m.SoundOnHit.len() != 0)
          {
            this.Time.scheduleEvent(this.TimeUnit.Virtual, time + this.m.SoundOnHitDelay, this.onPlayHitSound.bindenv(this), {
              Sound = this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)],
              Pos = _targetEntity.getPos()
            });
          }
        }
        else
        {
          if (this.m.SoundOnHit.len() != 0)
          {
            this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, _targetEntity.getPos());
          }

          if (this.Tactical.State.getStrategicProperties() != null && this.Tactical.State.getStrategicProperties().IsArenaMode && toHit <= 15)
          {
            this.Sound.play(this.Const.Sound.ArenaShock[this.Math.rand(0, this.Const.Sound.ArenaShock.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
          }

          this.onScheduledTargetHit(info);
        }

        return true;
      }
      else
      {
        local distanceToTarget = _user.getTile().getDistanceTo(_targetEntity.getTile());
        _targetEntity.onMissed(_user, this, this.m.IsShieldRelevant && shield != null && r <= toHit + shieldBonus * 2);
        this.m.Container.onTargetMissed(this, _targetEntity);
        local prohibitDiversion = false;

        if (_allowDiversion && this.m.IsRanged && !_user.isPlayerControlled() && this.Math.rand(1, 100) <= 25 && distanceToTarget > 2)
        {
          local targetTile = _targetEntity.getTile();

          for( local i = 0; i < this.Const.Direction.COUNT; i = ++i )
          {
            if (!targetTile.hasNextTile(i))
            {
            }
            else
            {
              local tile = targetTile.getNextTile(i);

              if (tile.IsEmpty)
              {
              }
              else if (tile.IsOccupiedByActor && tile.getEntity().isAlliedWith(_user))
              {
                prohibitDiversion = true;
                break;
              }
            }
          }
        }

        if (_allowDiversion && this.m.IsRanged && !(this.m.IsShieldRelevant && shield != null && r <= toHit + shieldBonus * 2) && !prohibitDiversion && distanceToTarget > 2)
        {
          this.divertAttack(_user, _targetEntity);
        }
        else if (this.m.IsShieldRelevant && shield != null && r <= toHit + shieldBonus * 2)
        {
          local info = {
            Skill = this,
            User = _user,
            TargetEntity = _targetEntity,
            Shield = shield
          };

          if (this.m.IsShowingProjectile && this.m.ProjectileType != 0)
          {
            local divertTile = _targetEntity.getTile();
            local flip = !this.m.IsProjectileRotated && _targetEntity.getPos().X > _user.getPos().X;
            local time = 0;

            if (_user.getTile().getDistanceTo(divertTile) >= this.Const.Combat.SpawnProjectileMinDist)
            {
              time = this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), divertTile, 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
            }

            this.Time.scheduleEvent(this.TimeUnit.Virtual, time, this.onShieldHit, info);
          }
          else
          {
            this.onShieldHit(info);
          }
        }
        else
        {
          if (this.m.SoundOnMiss.len() != 0)
          {
            this.Sound.play(this.m.SoundOnMiss[this.Math.rand(0, this.m.SoundOnMiss.len() - 1)], this.Const.Sound.Volume.Skill * this.m.SoundVolume, _targetEntity.getPos());
          }

          if (this.m.IsShowingProjectile && this.m.ProjectileType != 0)
          {
            local divertTile = _targetEntity.getTile();
            local flip = !this.m.IsProjectileRotated && _targetEntity.getPos().X > _user.getPos().X;

            if (_user.getTile().getDistanceTo(divertTile) >= this.Const.Combat.SpawnProjectileMinDist)
            {
              this.Tactical.spawnProjectileEffect(this.Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), divertTile, 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
            }
          }

          if (this.Tactical.State.getStrategicProperties() != null && this.Tactical.State.getStrategicProperties().IsArenaMode)
          {
            if (toHit >= 90 || _targetEntity.getHitpointsPct() <= 0.1)
            {
              this.Sound.play(this.Const.Sound.ArenaMiss[this.Math.rand(0, this.Const.Sound.ArenaBigMiss.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
            }
            else if (this.Math.rand(1, 100) <= 20)
            {
              this.Sound.play(this.Const.Sound.ArenaMiss[this.Math.rand(0, this.Const.Sound.ArenaMiss.len() - 1)], this.Const.Sound.Volume.Tactical * this.Const.Sound.Volume.Arena);
            }
          }
        }

        return false;
      }
    };
  }, true, false);
}