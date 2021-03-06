::mods_registerMod("quirks", 0.3.0, "quirks");

local gt = this.getroottable();

if (!("quirks" in gt)) {
  ::quirks <- {};
}

local setupRootTableStructure = function() {
  gt.Quirks <- {};
  gt.Const.Quirks <- {};
};

::quirks.setPerk <- function(perk, row, col = null) {
  gt.Const.Perks.Perks.resize(this.Math.max(row + 1, gt.Const.Perks.Perks.len()), []);
  if (col == null) {
    col = gt.Const.Perks.Perks[row].len();
  }
  gt.Const.Perks.Perks[row].resize(this.Math.max(col + 1, gt.Const.Perks.Perks[row].len()));
  gt.Const.Perks.Perks[row][col] = perk;
  gt.Const.Perks.LookupMap[perk.ID] <- perk;
  perk.Row <- row;
  perk.Unlocks <- row;
};

local addPerkBank = function() {
  gt.Const.Quirks.BankFatigueCost <- 50;
  gt.Const.Quirks.BankApCost <- 9;
  gt.Const.Quirks.BankApIncreaseOnUse <- 1;
  gt.Const.Quirks.CashInFatigueCost <- 50;
  gt.Const.Quirks.CashInApCost <- 9;
  gt.Const.Strings.PerkName.QuirksBank <- "Bank";
  gt.Const.Strings.CashInName <- "Cash In";
  gt.Const.Strings.CashedInEffectName <- "Cashed In";
  gt.Const.Quirks.BankInterestRatePerTurn <- 0.3;
  gt.Const.Strings.PerkDescription.QuirksBank <- "Unlocks the \'Bank\' ability to bank action points to be used later. " +
    "When used, banks [color=" + this.Const.UI.Color.PositiveValue + "]" + gt.Const.Quirks.BankApIncreaseOnUse + "[/color] action point. " +
    "Breaking (cashing in) makes the action points available next turn. " +
    "Each turn the bank is not spent it is increased by [color=" + gt.Const.UI.Color.PositiveValue + "]" + (gt.Const.Quirks.BankInterestRatePerTurn * 100) + "%[/color]. " +
    "\'" + gt.Const.Strings.PerkName.QuirksBank + "\' costs " + this.Const.Quirks.BankFatigueCost + " fatigue and " + gt.Const.Quirks.BankApCost + " action points. " +
    "\'" + gt.Const.Strings.CashInName + "\' costs " + this.Const.Quirks.CashInFatigueCost + " fatigue and " + gt.Const.Quirks.CashInApCost + " action points.";
  gt.Const.Strings.BankSkillDescription <- "Adds [color=" + gt.Const.UI.Color.PositiveValue + "]" +
    gt.Const.Quirks.BankApIncreaseOnUse + "[/color] action point to the bank.";

  local bankPerkConsts = {
    ID = "perk.quirks.bank",
    Script = "scripts/skills/perks/perk_quirks_bank",
    Name = this.Const.Strings.PerkName.QuirksBank,
    Tooltip = this.Const.Strings.PerkDescription.QuirksBank,
    Icon = "ui/perks/perk_quirks_bank.png",
    IconDisabled = "ui/perks/perk_quirks_bank_sw.png"
  };
  ::quirks.setPerk(bankPerkConsts, 6);

  ::quirks.stopAiDefendingOnEnemyBank();
};

local addPerkPrecision = function() {
  gt.Const.Quirks.PrecisionFatigueCost <- 11;
  gt.Const.Quirks.PrecisionApCost <- 3;
  gt.Const.Strings.PerkName.QuirksPrecision <- "Precision";
  gt.Const.Quirks.PrecisionHitChanceBonus <- 25;
  this.Const.Quirks.PrecisionHitChanceBonusDecreasePerTurn <- 12.5;
  gt.Const.Strings.PerkDescription.QuirksPrecision <- "Unlocks the \'" + gt.Const.Strings.PerkName.QuirksPrecision + "\' ability to increase next attack's hit chance with [color=" +
  this.Const.UI.Color.PositiveValue + "]" + gt.Const.Quirks.PrecisionHitChanceBonus + "%[/color]." +
    "If unused, each turn this bonus is decreased with [color=" + this.Const.UI.Color.NegativeValue + "]" + gt.Const.Quirks.PrecisionHitChanceBonusDecreasePerTurn + "%[/color]. Costs " + 
    this.Const.Quirks.PrecisionFatigueCost + " fatigue and " + gt.Const.Quirks.PrecisionApCost + " action points. The bonus is halfed for area of effect attacks.";
  gt.Const.Strings.PrecisionSkillDescription <- "Increase next attack's hit chance by [color=" + this.Const.UI.Color.PositiveValue + "]" + gt.Const.Quirks.PrecisionHitChanceBonus + "%[/color]. " +
    "If unused, each turn this bonus is decreased by [color=" + this.Const.UI.Color.NegativeValue + "]" + gt.Const.Quirks.PrecisionHitChanceBonusDecreasePerTurn + "%[/color]. " +
    "The bonus is halved for area of effect attacks.";

  local precisionPerkConsts = {
    ID = "perk.quirks.precision",
    Script = "scripts/skills/perks/perk_quirks_precision",
    Name = this.Const.Strings.PerkName.QuirksPrecision,
    Tooltip = this.Const.Strings.PerkDescription.QuirksPrecision,
    Icon = "ui/perks/perk_quirks_precision.png",
    IconDisabled = "ui/perks/perk_quirks_precision_sw.png"
  };
  ::quirks.setPerk(precisionPerkConsts, 4);
};

local addPerkExertion = function() {
  gt.Const.Quirks.ExertionMinFatigueCost <- 15;
  gt.Const.Quirks.ExertionFatigueCostBase <- 33;
  gt.Const.Quirks.ExertionFatiguePoolCostMult <- 0.1;
  gt.Const.Quirks.ExertionResolveCostMult <- 0.1;
  gt.Const.Quirks.ExertionCurrentInitiativeCostMult <- 0.1;
  gt.Const.Quirks.ExertionApBonus <- 3;
  gt.Const.Quirks.ExertionFatigueCostMultOnSameTurn <- 2;
  gt.Const.Strings.PerkName.QuirksExertion <- "Exertion";
  gt.Const.Strings.PerkDescription.QuirksExertion <- "Unlocks the \'" + gt.Const.Strings.PerkName.QuirksExertion +
    "\' ability to increase action points by " + gt.Const.Quirks.ExertionApBonus + " this turn. Fatigue cost is based on the current fatigue pool left, current initiative and resolve. " +
    "The cost starts from [color=" + this.Const.UI.Color.NegativeValue + "]" + gt.Const.Quirks.ExertionFatigueCostBase +
    "[/color] fatigue and is reduced to a minimum of  [color=" + this.Const.UI.Color.NegativeValue + "]" + gt.Const.Quirks.ExertionMinFatigueCost +
    "[/color] by subtracting [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.round(gt.Const.Quirks.ExertionFatiguePoolCostMult * 100) +
    "%[/color] of current fatigue left, [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.round(gt.Const.Quirks.ExertionResolveCostMult * 100) +
    "%[/color] of resolve and [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.round(gt.Const.Quirks.ExertionCurrentInitiativeCostMult * 100) +
    "%[/color] of current initiative. The fatigue cost is increased by [color=" +
    this.Const.UI.Color.NegativeValue + "]" + this.Math.round(gt.Const.Quirks.ExertionFatigueCostMultOnSameTurn * 100) + "%[/color] after each use in the same turn.";

  local exertionPerkConsts = {
    ID = "perk.quirks.exertion",
    Script = "scripts/skills/perks/perk_quirks_exertion",
    Name = this.Const.Strings.PerkName.QuirksExertion,
    Tooltip = this.Const.Strings.PerkDescription.QuirksExertion,
    Icon = "ui/perks/perk_quirks_exertion.png",
    IconDisabled = "ui/perks/perk_quirks_exertion_sw.png"
  };
  ::quirks.setPerk(exertionPerkConsts, 4);
};

local addPerkHyperactive = function() {
  gt.Const.Quirks.HyperactiveApBonus <- 3;
  gt.Const.Quirks.HyperactiveFatigueRecoveryRateModifierPerSpentActionPoint <- -1.25;
  gt.Const.Strings.PerkName.QuirksHyperactive <- "Hyperactive";
  gt.Quirks.getHyperactiveDescription <- function(apBonus, fatigueRecoveryRateModifierPerSpentActionPoint) {
    return "Permanently increases action points by [color=" + this.Const.UI.Color.PositiveValue + "]" + apBonus +
      "[/color] and reduces fatigue recovery rate by [color=" + this.Const.UI.Color.NegativeValue + "]" +
      (-fatigueRecoveryRateModifierPerSpentActionPoint) + "[/color] per action point spent on skills and attacks in the previous turn." +
      "\nRounding to the whole number is randomized with probability of rounding away from zero equal to the fraction part.";
  };
  gt.Const.Strings.PerkDescription.QuirksHyperactive <- gt.Quirks.getHyperactiveDescription(
    gt.Const.Quirks.HyperactiveApBonus, gt.Const.Quirks.HyperactiveFatigueRecoveryRateModifierPerSpentActionPoint);

  local hyperactivePerkConsts = {
    ID = "perk.quirks.hyperactive",
    Script = "scripts/skills/perks/perk_quirks_hyperactive",
    Name = this.Const.Strings.PerkName.QuirksHyperactive,
    Tooltip = this.Const.Strings.PerkDescription.QuirksHyperactive,
    Icon = "ui/perks/perk_quirks_hyperactive.png",
    IconDisabled = "ui/perks/perk_quirks_hyperactive_sw.png"
  };
  ::quirks.setPerk(hyperactivePerkConsts, 5);
};

local addPerkAcurate = function() {
  gt.Const.Quirks.AcurateHitChanceBonus <- 4;
  gt.Const.Strings.PerkName.QuirksAcurate <- "Acurate";
  gt.Const.Strings.PerkDescription.QuirksAcurate <- "Increases hit chance by [color=" + this.Const.UI.Color.PositiveValue + "]" + gt.Const.Quirks.AcurateHitChanceBonus + "[/color].";

  local acuratePerkConsts = {
    ID = "perk.quirks.acurate",
    Script = "scripts/skills/perks/perk_quirks_acurate",
    Name = this.Const.Strings.PerkName.QuirksAcurate,
    Tooltip = this.Const.Strings.PerkDescription.QuirksAcurate,
    Icon = "ui/perks/perk_quirks_acurate.png",
    IconDisabled = "ui/perks/perk_quirks_acurate_sw.png"
  };
  ::quirks.setPerk(acuratePerkConsts, 2);
};

local addPerkRefundFatigue = function() {
  gt.Const.Quirks.RefundFatigueMult <- 0.6;
  gt.Const.Strings.PerkName.QuirksRefundFatigue <- "Refund Fatigue";
  gt.Const.Strings.PerkDescription.QuirksRefundFatigue <- "On a miss refund [color=" + this.Const.UI.Color.PositiveValue + "]" +
    this.Math.round(gt.Const.Quirks.RefundFatigueMult * 100) + "%[/color] of the fatigue used. " +
    " Rounding is randomized with probability to round down or up equal to the fraction.";

  local refundFatiguePerkConsts = {
    ID = "perk.quirks.refund_fatigue",
    Script = "scripts/skills/perks/perk_quirks_refund_fatigue",
    Name = this.Const.Strings.PerkName.QuirksRefundFatigue,
    Tooltip = this.Const.Strings.PerkDescription.QuirksRefundFatigue,
    Icon = "ui/perks/perk_quirks_refund_fatigue.png",
    IconDisabled = "ui/perks/perk_quirks_refund_fatigue_sw.png"
  };
  ::quirks.setPerk(refundFatiguePerkConsts, 2);
};

local addOnAfterSkillUsed = function() {
  ::mods_hookClass("skills/skill", function(c) {
    local skillClass = ::libreuse.getParentClass(c, "skill");
    if (skillClass == null) {
      skillClass = c;
    }
    skillClass.onAfterSkillUsed <- function(_targetTile) {};
    skillClass.onAfterAnySkillUsed <- function(_skill, _targetTile) {};
    skillClass.m.IsOnAfterSkillUsedScheduled <- false;
    skillClass.m.TargetTile <- null;
    skillClass.m.IsUsedForFree <- false;
    skillClass.isUsedForFree <- function() { return this.m.IsUsedForFree; };

    local useOriginal = skillClass.use;
    skillClass.use = function(_targetTile, _forFree = false) {
      this.m.IsOnAfterSkillUsedScheduled = false;
      this.m.TargetTile = _targetTile;
      this.m.IsUsedForFree = _forFree;
      local container = this.getContainer();
      local ret = useOriginal(_targetTile, _forFree);
      if (!ret || !this.isAttack()) {
        this.m.IsOnAfterSkillUsedScheduled = true;
        this.onAfterSkillUsed(_targetTile);
        container.onAfterSkillUsed(this, _targetTile);
      }
      return ret;
    };

    local onScheduledTargetHitOriginal = skillClass.onScheduledTargetHit;
    skillClass.onScheduledTargetHit = function(_info) {
      onScheduledTargetHitOriginal(_info);
      if (!this.m.IsOnAfterSkillUsedScheduled) {
        this.m.IsOnAfterSkillUsedScheduled = true;
        this.Time.scheduleEvent(this.TimeUnit.Virtual, 1, this.onAfterSkillUsed, this.m.TargetTile);
        local callbackData = {
          container = this.getContainer(),
          caller = this,
          targetTile = this.m.TargetTile
        };
        this.Time.scheduleEvent(this.TimeUnit.Virtual, 1,
          function(callbackData) {
            callbackData.container.onAfterSkillUsed(callbackData.caller, callbackData.targetTile);
          },
          callbackData);
      }
    };
  });

  ::mods_hookClass("skills/skill_container", function(c) {
    local containerClass = ::libreuse.getParentClass(c, "skill_container");
    if (containerClass == null) {
      containerClass = c;
    }
    containerClass.onAfterSkillUsed <- function(_caller, _targetTile) {
      foreach(skill in this.m.Skills) {
        skill.onAfterAnySkillUsed(_caller, _targetTile);
      }
    };
  });
}

local addExpectedDamageCalculationFlag = function() {
  ::mods_hookClass("skills/skill", function(c) {
    local skillClass = ::libreuse.getParentClass(c, "skill");
    if (skillClass == null) {
      skillClass = c;
    }
    local getExpectedDamageOriginal = skillClass.getExpectedDamage;
    skillClass.getExpectedDamage = function(_target) {
      local skills = this.getContainer();
      local targetSkills = _target.getSkills();
      skills.m.IsCalculatingExpectedDamge = true;
      targetSkills.m.IsCalculatingExpectedDamge = true;

      local ret = getExpectedDamageOriginal(_target);

      skills.m.IsCalculatingExpectedDamge = false;
      targetSkills.m.IsCalculatingExpectedDamge = false;

      return ret;
    };

    local getTooltipOriginal = ::libreuse.getMember(c, "getTooltip");
    ::mods_override(c, "getTooltip", function() {
      this.getContainer().m.IsCalculatingExpectedDamge = true;
      local ret = getTooltipOriginal();
      this.getContainer().m.IsCalculatingExpectedDamge = false;
      return ret;
    });
  }, true, false);

  ::mods_hookClass("skills/skill_container", function(c) {
    local containerClass = ::libreuse.getParentClass(c, "skill_container");
    if (containerClass == null) {
      containerClass = c;
    }
    containerClass.m.IsCalculatingExpectedDamge <- false;
  });
}

local addPerkDoubleOrNothing = function() {
  gt.Const.Strings.PerkName.QuirksDoubleOrNothing <- "Double Or Nothing";
  gt.Const.Strings.PerkDescription.QuirksDoubleOrNothing <-
    "Doubles damage dealt but halves hit chance when attacking." +
    " The hit chance reduction is applied before clipping in the range [5, 95].";

  local doubleOrNothingPerkConsts = {
    ID = "perk.quirks.double_or_nothing",
    Script = "scripts/skills/perks/perk_quirks_double_or_nothing",
    Name = this.Const.Strings.PerkName.QuirksDoubleOrNothing,
    Tooltip = this.Const.Strings.PerkDescription.QuirksDoubleOrNothing,
    Icon = "ui/perks/perk_quirks_double_or_nothing.png",
    IconDisabled = "ui/perks/perk_quirks_double_or_nothing_sw.png"
  };
  ::quirks.setPerk(doubleOrNothingPerkConsts, 6);
};

local addPerkTeacher = function() {
  gt.Const.Quirks.TeacherXpMult <- 1.5;
  gt.Const.Strings.PerkName.QuirksTeacher <- "Teacher";
  gt.Quirks.getTeacherDescription <- function(xpMult) {
    return "Each kill by this character grants addition [color=" + this.Const.UI.Color.PositiveValue + "]" +
    this.Math.round((xpMult - 1) * 100) + "%[/color] XP for the kill to everybody in the battle who is a lower level."; };
  gt.Const.Strings.PerkDescription.QuirksTeacher <- gt.Quirks.getTeacherDescription(gt.Const.Quirks.TeacherXpMult);

  local teacherPerkConsts = {
    ID = "perk.quirks.teacher",
    Script = "scripts/skills/perks/perk_quirks_teacher",
    Name = this.Const.Strings.PerkName.QuirksTeacher,
    Tooltip = this.Const.Strings.PerkDescription.QuirksTeacher,
    Icon = "ui/perks/perk_quirks_teacher.png",
    IconDisabled = "ui/perks/perk_quirks_teacher_sw.png"
  };
  ::quirks.setPerk(teacherPerkConsts, 4);
};

local addPerkDefensiveAdaptation = function() {
  gt.Const.Quirks.DefensiveAdaptationBonusPerStack <- 16;
  gt.Const.Strings.PerkName.QuirksDefensiveAdaptation <- "Defensive Adaptation";
  gt.Quirks.getDefensiveAdaptationDescription <- function(bonusPerStack) {
    return "With each hit taken increase melee and ranged defense by [color=" + this.Const.UI.Color.PositiveValue + "]" +
    bonusPerStack + "[/color]. Upon being missed the counter is reset."; };
  gt.Const.Strings.PerkDescription.QuirksDefensiveAdaptation <- gt.Quirks.getDefensiveAdaptationDescription(gt.Const.Quirks.DefensiveAdaptationBonusPerStack);

  local defensiveAdaptationPerkConsts = {
    ID = "perk.quirks.defensive_adaptation",
    Script = "scripts/skills/perks/perk_quirks_defensive_adaptation",
    Name = this.Const.Strings.PerkName.QuirksDefensiveAdaptation,
    Tooltip = this.Const.Strings.PerkDescription.QuirksDefensiveAdaptation,
    Icon = "ui/perks/perk_quirks_defensive_adaptation.png",
    IconDisabled = "ui/perks/perk_quirks_defensive_adaptation_sw.png"
  };
  ::quirks.setPerk(defensiveAdaptationPerkConsts, 0);
};

local addMaxPerkPointsToPlayer = function() {
  ::mods_hookExactClass("entity/tactical/player", function(c) {
    c.m.MaxPerkPoints <- gt.Const.XP.MaxLevelWithPerkpoints - 1;
    c.m.StudentRefundPerkPointAtLevel <- gt.Const.XP.MaxLevelWithPerkpoints;
    local updateLevelOriginalQuirks = c.updateLevel;
    c.updateLevel = function() {
      updateLevelOriginalQuirks();
      local hasStudent = this.getSkills().getSkillByID("perk.student") != null;
      local perkPoints = this.Math.min(this.m.MaxPerkPoints, this.getLevel() - 1);
      if (hasStudent && this.getLevel() >= this.m.StudentRefundPerkPointAtLevel) {
        perkPoints += 1;
      }
      this.m.PerkPoints = perkPoints - this.m.PerkPointsSpent;
    };
  });

  ::mods_hookNewObject("entity/tactical/player", function(o) {
    if (this.World.Assets.getOrigin().getID() == "scenario.manhunters" && o.getBackground().getID() == "background.slave") {
      o.m.MaxPerkPoints = 6;
      o.m.StudentRefundPerkPointAtLevel = 7;
    }
  });
};

local addPerkVeteran = function() {
  gt.Const.Quirks.VeteranHitpointsCost <- 7;
  gt.Const.Quirks.VeteranStaminaCost <- 7;
  gt.Const.Quirks.VeteranPerkPointsBonus <- 2;
  gt.Const.Strings.PerkName.QuirksVeteran <- "Veteran";
  gt.Quirks.getVeteranDescription <- function(hitpointsCost, staminaCost, perkPointsBonus) {
    return "Increase maximum perk points by [color=" + this.Const.UI.Color.PositiveValue + "]" +
    perkPointsBonus + "[/color], but lose [color=" + this.Const.UI.Color.NegativeValue + "]" +
    hitpointsCost + "[/color] hitpoints and [color=" + this.Const.UI.Color.NegativeValue + "]" +
    staminaCost + "[/color] maximum fatigue.";
  };
  gt.Const.Strings.PerkDescription.QuirksVeteran <- gt.Quirks.getVeteranDescription(
    gt.Const.Quirks.VeteranHitpointsCost, gt.Const.Quirks.VeteranStaminaCost, gt.Const.Quirks.VeteranPerkPointsBonus);

  local veteranPerkConsts = {
    ID = "perk.quirks.veteran",
    Script = "scripts/skills/perks/perk_quirks_veteran",
    Name = this.Const.Strings.PerkName.QuirksVeteran,
    Tooltip = this.Const.Strings.PerkDescription.QuirksVeteran,
    Icon = "ui/perks/perk_quirks_veteran.png",
    IconDisabled = "ui/perks/perk_quirks_veteran_sw.png"
  };
  ::quirks.setPerk(veteranPerkConsts, 6);
};

local addPerkLastStand = function() {
  gt.Const.Quirks.LastStandResolveBonusPerNeighbourEnemy <- 5;
  gt.Const.Quirks.LastStandResolveBonusMax <- 40;
  gt.Const.Strings.PerkName.QuirksLastStand <- "Last Stand";
  gt.Quirks.getLastStandDescription <- function(resolveBonusPerNeighbourEnemy, resolveBonusMax) {
    return "Upon taking damage to hitpoints add a stack of Last Stand until the end of the battle. " +
      "Each stack increases resolve by [color=" + this.Const.UI.Color.PositiveValue + "]" +
      resolveBonusPerNeighbourEnemy + "[/color] per enemy around you to a maximum of " +
      "[color=" + this.Const.UI.Color.PositiveValue + "]" + resolveBonusMax + "[/color].";
  };
  gt.Const.Strings.PerkDescription.QuirksLastStand <- gt.Quirks.getLastStandDescription(
    gt.Const.Quirks.LastStandResolveBonusPerNeighbourEnemy, gt.Const.Quirks.LastStandResolveBonusMax);

  local lastStandPerkConsts = {
    ID = "perk.quirks.last_stand",
    Script = "scripts/skills/perks/perk_quirks_last_stand",
    Name = this.Const.Strings.PerkName.QuirksLastStand,
    Tooltip = this.Const.Strings.PerkDescription.QuirksLastStand,
    Icon = "ui/perks/perk_quirks_last_stand.png",
    IconDisabled = "ui/perks/perk_quirks_last_stand_sw.png"
  };
  ::quirks.setPerk(lastStandPerkConsts, 2);
};

local addPerkPunchingBag = function() {
  gt.Const.Quirks.PunchingBagOnHitDamageMult <- 0.85;
  gt.Const.Quirks.PunchingBagOnTurnStartBonusMult <- 0.6666;
  gt.Const.Strings.PerkName.QuirksPunchingBag <- "Punching Bag";
  gt.Quirks.getPunchingBagDescription <- function(onHitDamageMult, onTurnStartBonusMult) {
    return "Each time being hit decrease future incoming damage by [color=" + this.Const.UI.Color.PositiveValue + "]" +
      this.Math.round((1 - onHitDamageMult) * 100) + "%[/color] from attacks. At the start of each turn this bonus is reduced by [color=" + this.Const.UI.Color.NegativeValue + "]" +
      this.Math.round((1 - onTurnStartBonusMult) * 100) + "%[/color].";
  };
  gt.Const.Strings.PerkDescription.QuirksPunchingBag <- gt.Quirks.getPunchingBagDescription(gt.Const.Quirks.PunchingBagOnHitDamageMult, gt.Const.Quirks.PunchingBagOnTurnStartBonusMult);

  local punchingBagPerkConsts = {
    ID = "perk.quirks.punching_bag",
    Script = "scripts/skills/perks/perk_quirks_punching_bag",
    Name = this.Const.Strings.PerkName.QuirksPunchingBag,
    Tooltip = this.Const.Strings.PerkDescription.QuirksPunchingBag,
    Icon = "ui/perks/perk_quirks_punching_bag.png",
    IconDisabled = "ui/perks/perk_quirks_punching_bag_sw.png"
  };
  ::quirks.setPerk(punchingBagPerkConsts, 0);
};

local addPerkSurprise = function() {
  gt.Const.Strings.SurprisedEffectName <- "Surprised";
  gt.Const.Quirks.SurpriseOnMissedInitiativeStolen <- 15;
  gt.Const.Strings.PerkName.QuirksSurprise <- "Surprise";
  gt.Quirks.getSurpriseDescription <- function(onMissedInitiativeStolen) {
    return "With each time, being missed, steal [color=" + this.Const.UI.Color.PositiveValue + "]" +
      onMissedInitiativeStolen + "[/color] initiative form the attacker for 2 rounds.";
  };
  gt.Const.Strings.PerkDescription.QuirksSurprise <- gt.Quirks.getSurpriseDescription(gt.Const.Quirks.SurpriseOnMissedInitiativeStolen);

  local surprisePerkConsts = {
    ID = "perk.quirks.surprise",
    Script = "scripts/skills/perks/perk_quirks_surprise",
    Name = this.Const.Strings.PerkName.QuirksSurprise,
    Tooltip = this.Const.Strings.PerkDescription.QuirksSurprise,
    Icon = "ui/perks/perk_quirks_surprise.png",
    IconDisabled = "ui/perks/perk_quirks_surprise_sw.png"
  };
  ::quirks.setPerk(surprisePerkConsts, 2);
};

local addPerkRefundActionPoints = function() {
  gt.Const.Quirks.RefundActionPointsAttackFatigueCostMult <- 0.5;
  gt.Const.Quirks.RefundActionPointsFatigueCostPerActionPoint <- 2.0;
  this.Const.Strings.PerkName.QuirksRefundActionPoints <- "Refund Action Points"
  gt.Quirks.getRefundActionPointsDescription <- function(attackFatigueCostMult, fatigueCostPerActionPoint) {
    return "Unlocks the ability to refund all action points on a missed attack. The skill can be used until the end of the turn. " +
      "The cost is [color=" + this.Const.UI.Color.NegativeValue + "]" + this.Math.round(attackFatigueCostMult * 100) + "%[/color] of the attack's fatigue + " +
      "[color=" + this.Const.UI.Color.NegativeValue + "]" + fatigueCostPerActionPoint + "[/color] per action point.";
  };
  gt.Const.Strings.PerkDescription.QuirksRefundActionPoints <- gt.Quirks.getRefundActionPointsDescription(
    gt.Const.Quirks.RefundActionPointsAttackFatigueCostMult, gt.Const.Quirks.RefundActionPointsFatigueCostPerActionPoint);

  local refundActionPointsPerkConsts = {
    ID = "perk.quirks.refund_action_points",
    Script = "scripts/skills/perks/perk_quirks_refund_action_points",
    Name = this.Const.Strings.PerkName.QuirksRefundActionPoints,
    Tooltip = this.Const.Strings.PerkDescription.QuirksRefundActionPoints,
    Icon = "ui/perks/perk_quirks_refund_action_points.png",
    IconDisabled = "ui/perks/perk_quirks_refund_action_points_sw.png"
  };
  ::quirks.setPerk(refundActionPointsPerkConsts, 5);
};

local addPerkSlack = function() {
  gt.Const.Quirks.SlackFatigueRecoveryPerUnspentActionPoint <- 1.66;
  this.Const.Strings.PerkName.QuirksSlack <- "Slack";
  gt.Quirks.getSlackDescription <- function(fatigueRecoveryPerUnspentActionPoint) {
    return "Each turn recover an additional [color=" + this.Const.UI.Color.PositiveValue + "]" +
      fatigueRecoveryPerUnspentActionPoint + "[/color] fatigue per unspent action point in the previous turn. " +
      " Rounding is randomized with probability to round down or up equal to the fraction part.";
  };
  gt.Const.Strings.PerkDescription.QuirksSlack <- gt.Quirks.getSlackDescription(gt.Const.Quirks.SlackFatigueRecoveryPerUnspentActionPoint);

  local slackPerkConsts = {
    ID = "perk.quirks.slack",
    Script = "scripts/skills/perks/perk_quirks_slack",
    Name = this.Const.Strings.PerkName.QuirksSlack,
    Tooltip = this.Const.Strings.PerkDescription.QuirksSlack,
    Icon = "ui/perks/perk_quirks_slack.png",
    IconDisabled = "ui/perks/perk_quirks_slack_sw.png"
  };
  ::quirks.setPerk(slackPerkConsts, 1);
};

local addPerkImpenetrable = function() {
  gt.Const.Quirks.ImpenetrableBestTotalArmorMax <- 400;
  gt.Const.Quirks.ImpenetrableTotalArmorMaxStdDev <- 100;
  gt.Const.Quirks.ImpenetrableBestDamageReceivedDirectMult <- 0.33;
  gt.Const.Quirks.ImpenetrableMinDamageReceivedDirectMult <- 0.85;
  this.Const.Strings.PerkName.QuirksImpenetrable <- "Impenetrable"
  gt.Quirks.getImpenetrableDescription <- function(bestTotalArmorMax, bestDamageReceivedDirectMult, minDamageReceivedDirectMult) {
    return "Reduces armor penetration damage based on total max body and helmet armor with best results at " +
      bestTotalArmorMax + " armor when damage is reduced by [color=" + this.Const.UI.Color.PositiveValue + "]" +
      this.Math.round((1 - bestDamageReceivedDirectMult) * 100) +
      "%[/color]. If total max armor is more than that the effect is gradually weakened to a minimum of [color=" + this.Const.UI.Color.PositiveValue + "]" +
      this.Math.round((1 - minDamageReceivedDirectMult) * 100) +
      "%[/color].";
  };
  gt.Const.Strings.PerkDescription.QuirksImpenetrable <- gt.Quirks.getImpenetrableDescription(
    gt.Const.Quirks.ImpenetrableBestTotalArmorMax, gt.Const.Quirks.ImpenetrableBestDamageReceivedDirectMult, gt.Const.Quirks.ImpenetrableMinDamageReceivedDirectMult);

  local impenetrablePerkConsts = {
    ID = "perk.quirks.impenetrable",
    Script = "scripts/skills/perks/perk_quirks_impenetrable",
    Name = this.Const.Strings.PerkName.QuirksImpenetrable,
    Tooltip = this.Const.Strings.PerkDescription.QuirksImpenetrable,
    Icon = "ui/perks/perk_quirks_impenetrable.png",
    IconDisabled = "ui/perks/perk_quirks_impenetrable_sw.png"
  };
  ::quirks.setPerk(impenetrablePerkConsts, 5);
};

local addEffectKnackered = function() {
  gt.Const.Quirks.KnackeredDefenseModifier <- -10;
  gt.Quirks.getKnackeredDescription <- function(defenseModifier) {
    return "This character has reached the limit of his endurance. Melee and ranged defense is reduced by [color=" + this.Const.UI.Color.NegativeValue + "]" + (-defenseModifier) + "[/color].";
  };

  ::mods_hookDescendants("entity/tactical/actor", function(c) {
    local actorClass = ::mods_getClassForOverride(c, "actor");
    if (!("onInitOriginalAddEffectKnackered" in actorClass)) {
      actorClass.onInitOriginalAddEffectKnackered <- actorClass.onInit;
      actorClass.onInit = function() {
        this.onInitOriginalAddEffectKnackered();
        this.m.Skills.add(this.new("scripts/skills/effects/quirks_knackered_effect"));
      };
    }
  });
};

local addPerkSlowDown = function() {
  gt.Const.Quirks.SlowDownInitiativeForTurnOrderModifier <- -1000;
  gt.Const.Quirks.SlowDownActionPointsCost <- 0;
  gt.Const.Quirks.SlowDownFatigueCost <- 0;
  this.Const.Strings.PerkName.QuirksSlowDown <- "Slow Down";
  gt.Quirks.getSlowDownSkillDescription <- function() {
    return "Lower turn order initiative this turn to act last after waiting.";
  };
  gt.Quirks.getSlowDownEffectDescription <- function() {
    return "This character will act last after waiting.";
  };
  gt.Quirks.getSlowDownPerkDescription <- function(actionPointsCost, fatigueCost) {
    return "Unlocks the ability to lower turn order initiative this turn to act last after waiting." +
      " If two characters use this skill, the one with lower initiative will act second. " +
      " The cost is [color=" + this.Const.UI.Color.NegativeValue + "]" + actionPointsCost + "%[/color] action points and " +
      "[color=" + this.Const.UI.Color.NegativeValue + "]" + fatigueCost + "[/color] fatigue.";;
  };
  gt.Const.Strings.PerkDescription.QuirksSlowDown <- gt.Quirks.getSlowDownPerkDescription(
    gt.Const.Quirks.SlowDownActionPointsCost, gt.Const.Quirks.SlowDownFatigueCost);

  local slowDownPerkConsts = {
    ID = "perk.quirks.slow_down",
    Script = "scripts/skills/perks/perk_quirks_slow_down",
    Name = this.Const.Strings.PerkName.QuirksSlowDown,
    Tooltip = this.Const.Strings.PerkDescription.QuirksSlowDown,
    Icon = "ui/perks/perk_quirks_slow_down.png",
    IconDisabled = "ui/perks/perk_quirks_slow_down_sw.png"
  };
  ::quirks.setPerk(slowDownPerkConsts, 0);
}

local addPerkPlunge = function() {
  gt.Const.Quirks.PlungeActionPointsCost <- 0;
  gt.Const.Quirks.PlungeFatigueCost <- 0;
  gt.Const.Quirks.PlungeDamageMultPerStack <- 1.15;
  gt.Const.Quirks.PlungeKnockBackChancePerStack <- 0.2;
  this.Const.Strings.PerkName.QuirksPlunge <- "Plunge";
  gt.Quirks.getPlungeSkillDescription <- function(dmageMultPerStack, knockBackChancePerStack) {
    return "With Each tile of distance since activating Plunge, the next melee attack will do [color=" + this.Const.UI.Color.PositiveValue + "]" +
      this.Math.round((dmageMultPerStack - 1) * 100) + "%[/color] more damage." +
      " Moving up/down an elevation level will also remove/add a plunge stack." +
      " Hitting your target will also have a chance to knock it back and you to follow it." +
      " The chance is [color=" + this.Const.UI.Color.PositiveValue + "]" +
      this.Math.round(knockBackChancePerStack * 100) + "%[/color] per stack." +
      " If the target is knocked back your character will plunge one tile of distance in the direction of the target." +
      " When Plunge is active movement fatigue cost is increased with the default cost." +
      " Waiting without attacking will remove the Plunge effect.";
  };
  gt.Quirks.getPlungeEffectDescription <- function(dmageMultPerStack, knockBackChancePerStack) {
    return "This character is plunging. " +
      gt.Quirks.getPlungeSkillDescription(dmageMultPerStack, knockBackChancePerStack);
  };
  gt.Quirks.getPlungePerkDescription <- function(dmageMultPerStack, knockBackChancePerStack) {
    return "Unlocks the Plunge skill. " +
      gt.Quirks.getPlungeSkillDescription(dmageMultPerStack, knockBackChancePerStack);
  };
  gt.Const.Strings.PerkDescription.QuirksPlunge <- gt.Quirks.getPlungePerkDescription(
    gt.Const.Quirks.PlungeDamageMultPerStack, gt.Const.Quirks.PlungeKnockBackChancePerStack);

  local plungePerkConsts = {
    ID = "perk.quirks.plunge",
    Script = "scripts/skills/perks/perk_quirks_plunge",
    Name = this.Const.Strings.PerkName.QuirksPlunge,
    Tooltip = this.Const.Strings.PerkDescription.QuirksPlunge,
    Icon = "ui/perks/perk_quirks_plunge.png",
    IconDisabled = "ui/perks/perk_quirks_plunge_sw.png"
  };
  ::quirks.setPerk(plungePerkConsts, 6);
}

local addPerkSupple = function() {
  gt.Const.Quirks.SuppleRerollChanceBase <- 150;
  gt.Const.Quirks.SuppleRerollChanceHitpointsMaxMult <- -1;
  gt.Const.Quirks.SuppleRerollChanceFatigueMaxPenaltyMult <- -1.5;
  this.Const.Strings.PerkName.QuirksSupple <- "Supple";
  gt.Quirks.getSuppleDescription <- function(rerollChanceBase, rerollChanceHitpointsMaxMult, rerollChanceFatigueMaxPenaltyMult) {
    return "Gain a chance to have any attacker require two successful attack rolls in order to hit." +
      " The chance starts from [color=" + this.Const.UI.Color.PositiveValue + "]" + rerollChanceBase +
      "[/color] and is reduced by [color=" + this.Const.UI.Color.NegativeValue + "]" +
      this.Math.round(-rerollChanceHitpointsMaxMult * 100) +
      "%[/color] of maximum hitpoints and [color=" + this.Const.UI.Color.NegativeValue + "]" +
      this.Math.round(-rerollChanceFatigueMaxPenaltyMult * 100) + "%[/color] of penalty to maximum fatigue.";
  };
  gt.Const.Strings.PerkDescription.QuirksSupple <-
    gt.Quirks.getSuppleDescription(gt.Const.Quirks.SuppleRerollChanceBase,
    gt.Const.Quirks.SuppleRerollChanceHitpointsMaxMult, gt.Const.Quirks.SuppleRerollChanceFatigueMaxPenaltyMult);

  local supplePerkConsts = {
    ID = "perk.quirks.supple",
    Script = "scripts/skills/perks/perk_quirks_supple",
    Name = this.Const.Strings.PerkName.QuirksSupple,
    Tooltip = this.Const.Strings.PerkDescription.QuirksSupple,
    Icon = "ui/perks/perk_quirks_supple.png",
    IconDisabled = "ui/perks/perk_quirks_supple_sw.png"
  };
  ::quirks.setPerk(supplePerkConsts, 5);
};

::mods_queue(null, "mod_hooks(>=20),libreuse(>=0.1)", function() {
  setupRootTableStructure();

  addOnAfterSkillUsed();
  addMaxPerkPointsToPlayer();

  addPerkAcurate();
  addPerkBank();
  addPerkDefensiveAdaptation();
  addPerkDoubleOrNothing();
  addPerkExertion();
  addPerkHyperactive();
  addPerkImpenetrable();
  addPerkLastStand();
  addPerkPlunge();
  addPerkPrecision();
  addPerkPunchingBag();
  addPerkRefundActionPoints();
  addPerkRefundFatigue();
  #addPerkSlowDown();
  addPerkSlack();
  addPerkSupple();
  addPerkSurprise();
  addPerkTeacher();
  addPerkVeteran();

  addEffectKnackered();
});
