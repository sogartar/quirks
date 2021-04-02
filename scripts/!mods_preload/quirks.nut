::mods_registerMod("quirks", 0.1, "quirks");

local gt = this.getroottable();

if (!("quirks" in gt)) {
  ::quirks <- {};
}

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
  gt.Const.BankFatigueCost <- 50;
  gt.Const.BankApCost <- 9;
  gt.Const.BankApIncreaseOnUse <- 1;
  gt.Const.CashInFatigueCost <- 50;
  gt.Const.CashInApCost <- 9;
  gt.Const.Strings.PerkName.Bank <- "Bank";
  gt.Const.Strings.CashInName <- "Cash In";
  gt.Const.Strings.CashedInEffectName <- "Cashed In";
  gt.Const.BankInterestRatePerTurn <- 0.3;
  gt.Const.Strings.PerkDescription.Bank <- "Unlocks the \'Bank\' ability to bank action points to be used later. " +
    "When used, banks [color=" + this.Const.UI.Color.PositiveValue + "]" + gt.Const.BankApIncreaseOnUse + "[/color] action point. " +
    "Breaking (cashing in) makes the action points available next turn. " +
    "Each turn the bank is not spent it is increased by [color=" + gt.Const.UI.Color.PositiveValue + "]" + (gt.Const.BankInterestRatePerTurn * 100) + "%[/color]. " +
    "\'" + gt.Const.Strings.PerkName.Bank + "\' costs " + this.Const.BankFatigueCost + " fatigue and " + gt.Const.BankApCost + " action points. " +
    "\'" + gt.Const.Strings.CashInName + "\' costs " + this.Const.CashInFatigueCost + " fatigue and " + gt.Const.CashInApCost + " action points.";
  gt.Const.Strings.BankSkillDescription <- "Adds [color=" + gt.Const.UI.Color.PositiveValue + "]" +
    gt.Const.BankApIncreaseOnUse + "[/color] action point to the bank.";

  local bankPerkConsts = {
    ID = "perk.bank",
    Script = "scripts/skills/perks/perk_bank",
    Name = this.Const.Strings.PerkName.Bank,
    Tooltip = this.Const.Strings.PerkDescription.Bank,
    Icon = "ui/perks/perk_bank.png",
    IconDisabled = "ui/perks/perk_bank_sw.png"
  };
  ::quirks.setPerk(bankPerkConsts, 6);

  ::quirks.stopAiDefendingOnEnemyBank();
};

local addPerkPrecision = function() {
  gt.Const.PrecisionFatigueCost <- 15;
  gt.Const.PrecisionApCost <- 3;
  gt.Const.Strings.PerkName.Precision <- "Precision";
  gt.Const.PrecisionHitChanceBonus <- 25;
  this.Const.PrecisionHitChanceBonusDecreasePerTurn <- 12.5;
  gt.Const.Strings.PerkDescription.Precision <- "Unlocks the \'" + gt.Const.Strings.PerkName.Precision + "\' ability to increase next attack's hit chance with [color=" +
  this.Const.UI.Color.PositiveValue + "]" + gt.Const.PrecisionHitChanceBonus + "%[/color]." +
    "If unused, each turn this bonus is decreased with [color=" + this.Const.UI.Color.NegativeValue + "]" + gt.Const.PrecisionHitChanceBonusDecreasePerTurn + "%[/color]. Costs " + 
    this.Const.PrecisionFatigueCost + " fatigue and " + gt.Const.PrecisionApCost + " action points. The bonus is halfed for area of effect attacks.";
  gt.Const.Strings.PrecisionSkillDescription <- "Increase next attack's hit chance by [color=" + this.Const.UI.Color.PositiveValue + "]" + gt.Const.PrecisionHitChanceBonus + "%[/color]. " +
    "If unused, each turn this bonus is decreased by [color=" + this.Const.UI.Color.NegativeValue + "]" + gt.Const.PrecisionHitChanceBonusDecreasePerTurn + "%[/color]. " +
    "The bonus is halfed for area of effect attacks.";

  local precisionPerkConsts = {
    ID = "perk.precision",
    Script = "scripts/skills/perks/perk_precision",
    Name = this.Const.Strings.PerkName.Precision,
    Tooltip = this.Const.Strings.PerkDescription.Precision,
    Icon = "ui/perks/perk_precision.png",
    IconDisabled = "ui/perks/perk_precision_sw.png"
  };
  ::quirks.setPerk(precisionPerkConsts, 4);
};

local addPerkExertion = function() {
  gt.Const.ExertionMinFatigueCost <- 12;
  gt.Const.ExertionFatigueCostBase <- 31;
  gt.Const.ExertionFatiguePoolCostMult <- 0.1;
  gt.Const.ExertionResolveCostMult <- 0.1;
  gt.Const.ExertionCurrentInitiativeCostMult <- 0.1;
  gt.Const.ExertionApBonus <- 3;
  gt.Const.ExertionFatigueCostMultOnSameTurn <- 2;
  gt.Const.Strings.PerkName.Exertion <- "Exertion";
  gt.Const.Strings.PerkDescription.Exertion <- "Unlocks the \'" + gt.Const.Strings.PerkName.Exertion +
    "\' ability to increase action points by " + gt.Const.ExertionApBonus + " this turn. Fatigue cost is based on the current fatigue pool left, current intiative and resolve. " +
    "The cost starts from [color=" + this.Const.UI.Color.NegativeValue + "]" + gt.Const.ExertionFatigueCostBase +
    "[/color] fatigue and is reduced to a minimum of  [color=" + this.Const.UI.Color.NegativeValue + "]" + gt.Const.ExertionMinFatigueCost +
    "[/color] by subtracting [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.round(gt.Const.ExertionFatiguePoolCostMult * 100) +
    "%[/color] of current fatigue left, [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.round(gt.Const.ExertionResolveCostMult * 100) +
    "%[/color] of resolve and [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.round(gt.Const.ExertionCurrentInitiativeCostMult * 100) +
    "%[/color] of current initiative. The fatigue cost is increased by [color=" +
    this.Const.UI.Color.NegativeValue + "]" + this.Math.round(gt.Const.ExertionFatigueCostMultOnSameTurn * 100) + "%[/color] afer each use in the same turn.";

  local exertionPerkConsts = {
    ID = "perk.exertion",
    Script = "scripts/skills/perks/perk_exertion",
    Name = this.Const.Strings.PerkName.Exertion,
    Tooltip = this.Const.Strings.PerkDescription.Exertion,
    Icon = "ui/perks/perk_exertion.png",
    IconDisabled = "ui/perks/perk_exertion_sw.png"
  };
  ::quirks.setPerk(exertionPerkConsts, 4);
};

local addPerkHyperactive = function() {
  gt.Const.HyperactiveApBonus <- 3;
  gt.Const.HyperactiveFatigueRecoveryRatePerTurnChange <- -3;
  gt.Const.Strings.PerkName.Hyperactive <- "Hyperactive";
  gt.getHyperactiveDescription <- function(apBonus, fatigueRecoveryRatePerTernChange) {
    return "Permanently increases action points by [color=" + this.Const.UI.Color.PositiveValue + "]" + apBonus +
      "[/color] and each turn after the first reduces fatigue recovery rate by [color=" + this.Const.UI.Color.NegativeValue + "]" +
      (-fatigueRecoveryRatePerTernChange) + "[/color].";
  };
  gt.Const.Strings.PerkDescription.Hyperactive <- gt.getHyperactiveDescription(
    gt.Const.HyperactiveApBonus, gt.Const.HyperactiveFatigueRecoveryRatePerTurnChange);

  local hyperactivePerkConsts = {
    ID = "perk.hyperactive",
    Script = "scripts/skills/perks/perk_hyperactive",
    Name = this.Const.Strings.PerkName.Hyperactive,
    Tooltip = this.Const.Strings.PerkDescription.Hyperactive,
    Icon = "ui/perks/perk_hyperactive.png",
    IconDisabled = "ui/perks/perk_hyperactive_sw.png"
  };
  ::quirks.setPerk(hyperactivePerkConsts, 5);
};

local addPerkAcurate = function() {
  gt.Const.AcurateHitChanceBonus <- 4.5;
  gt.Const.Strings.PerkName.Acurate <- "Acurate";
  gt.Const.Strings.PerkDescription.Acurate <- "Increases hit chance by [color=" + this.Const.UI.Color.PositiveValue + "]" + gt.Const.AcurateHitChanceBonus + "[/color].";

  local acuratePerkConsts = {
    ID = "perk.acurate",
    Script = "scripts/skills/perks/perk_acurate",
    Name = this.Const.Strings.PerkName.Acurate,
    Tooltip = this.Const.Strings.PerkDescription.Acurate,
    Icon = "ui/perks/perk_acurate.png",
    IconDisabled = "ui/perks/perk_acurate_sw.png"
  };
  ::quirks.setPerk(acuratePerkConsts, 2);
};

local addPerkRefundFatigue = function() {
  gt.Const.RefundFatigueMult <- 0.5;
  gt.Const.Strings.PerkName.RefundFatigue <- "Refund Fatigue";
  gt.Const.Strings.PerkDescription.RefundFatigue <- "On a miss refund [color=" + this.Const.UI.Color.PositiveValue + "]" +
    this.Math.floor(gt.Const.RefundFatigueMult * 100) + "%[/color] of the fatigue used. " +
    " Rounding is randomized with probability to round down or up equal to the fraction.";

  local refundFatiguePerkConsts = {
    ID = "perk.refund_fatigue",
    Script = "scripts/skills/perks/perk_refund_fatigue",
    Name = this.Const.Strings.PerkName.RefundFatigue,
    Tooltip = this.Const.Strings.PerkDescription.RefundFatigue,
    Icon = "ui/perks/perk_refund_fatigue.png",
    IconDisabled = "ui/perks/perk_refund_fatigue_sw.png"
  };
  ::quirks.setPerk(refundFatiguePerkConsts, 4);
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

    local useOriginal = skillClass.use;
    skillClass.use = function(_targetTile, _forFree = false) {
      this.m.IsOnAfterSkillUsedScheduled = false;
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
        this.Time.scheduleEvent(this.TimeUnit.Virtual, 1, this.onAfterSkillUsed, _info.TargetEntity.getTile());
        local callbackData = {
          container = this.getContainer(),
          caller = this,
          targetTile = _info.TargetEntity.getTile()
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
  gt.Const.Strings.PerkName.DoubleOrNothing <- "Double Or Nothing";
  gt.Const.Strings.PerkDescription.DoubleOrNothing <-
    "Halfs the hit chance when attacking or being attacked but doubles damage dealt and received." +
    " The hit chance reduction is applied before clipping in the range [5, 95].";

  local doubleOrNothingPerkConsts = {
    ID = "perk.double_or_nothing",
    Script = "scripts/skills/perks/perk_double_or_nothing",
    Name = this.Const.Strings.PerkName.DoubleOrNothing,
    Tooltip = this.Const.Strings.PerkDescription.DoubleOrNothing,
    Icon = "ui/perks/perk_double_or_nothing.png",
    IconDisabled = "ui/perks/perk_double_or_nothing_sw.png"
  };
  ::quirks.setPerk(doubleOrNothingPerkConsts, 6);
};

local addPerkTeacher = function() {
  gt.Const.TeacherXpMult <- 1.4;
  gt.Const.Strings.PerkName.Teacher <- "Teacher";
  gt.getTeacherDescription <- function(xpMult) {
    return "Each kill by this character grants addition [color=" + this.Const.UI.Color.PositiveValue + "]" +
    this.Math.round((xpMult - 1) * 100) + "%[/color] XP for the kill to everybody in the battle who is a lower level."; };
  gt.Const.Strings.PerkDescription.Teacher <- gt.getTeacherDescription(gt.Const.TeacherXpMult);

  local teacherPerkConsts = {
    ID = "perk.teacher",
    Script = "scripts/skills/perks/perk_teacher",
    Name = this.Const.Strings.PerkName.Teacher,
    Tooltip = this.Const.Strings.PerkDescription.Teacher,
    Icon = "ui/perks/perk_teacher.png",
    IconDisabled = "ui/perks/perk_teacher_sw.png"
  };
  ::quirks.setPerk(teacherPerkConsts, 4);
};

local addPerkDefensiveAdaptation = function() {
  gt.Const.DefensiveAdaptationBonusPerStack <- 13;
  gt.Const.Strings.PerkName.DefensiveAdaptation <- "Defensive Adaptation";
  gt.getDefensiveAdaptationDescription <- function(bonusPerStack) {
    return "With each hit taken increase defense by [color=" + this.Const.UI.Color.PositiveValue + "]" +
    bonusPerStack + "[/color]. Upon being missed the counter is reset."; };
  gt.Const.Strings.PerkDescription.DefensiveAdaptation <- gt.getDefensiveAdaptationDescription(gt.Const.DefensiveAdaptationBonusPerStack);

  local defensiveAdaptationPerkConsts = {
    ID = "perk.defensive_adaptation",
    Script = "scripts/skills/perks/perk_defensive_adaptation",
    Name = this.Const.Strings.PerkName.DefensiveAdaptation,
    Tooltip = this.Const.Strings.PerkDescription.DefensiveAdaptation,
    Icon = "ui/perks/perk_defensive_adaptation.png",
    IconDisabled = "ui/perks/perk_defensive_adaptation_sw.png"
  };
  ::quirks.setPerk(defensiveAdaptationPerkConsts, 0);
};

local addMaxPerkPointsToPlayer = function() {
  ::mods_hookExactClass("entity/tactical/player", function(c) {
    c.m.MaxPerkPoints <- gt.Const.XP.MaxLevelWithPerkpoints - 1;
    local updateLevelOriginal = c.updateLevel;
    c.updateLevel = function() {
      updateLevelOriginal();
      local hasStudent = this.getSkills().getSkillByID("perk.student") != null;
      local spentAndUnspentPerkPoints = this.m.PerkPoints + this.m.PerkPointsSpent;
      local perkPointsToAdd = this.Math.min(this.m.MaxPerkPoints + (hasStudent ? 1 : 0), this.getLevel() - 1) - spentAndUnspentPerkPoints;
      this.m.PerkPoints += perkPointsToAdd;
    };
  });
}

local addPerkVeteran = function() {
  gt.Const.VeteranHitpointsCost <- 9;
  gt.Const.VeteranStaminaCost <- 9;
  gt.Const.VeteranPerkPointsBonus <- 2;
  gt.Const.Strings.PerkName.Veteran <- "Veteran";
  gt.getVeteranDescription <- function(hitpointsCost, staminaCost, perkPointsBonus) {
    return "Increase maximum perk points by [color=" + this.Const.UI.Color.PositiveValue + "]" +
    perkPointsBonus + "[/color], but lose [color=" + this.Const.UI.Color.NegativeValue + "]" +
    hitpointsCost + "[/color] hitpoints and [color=" + this.Const.UI.Color.NegativeValue + "]" +
    staminaCost + "[/color] maximum fatigue.";
  };
  gt.Const.Strings.PerkDescription.Veteran <- gt.getVeteranDescription(
    gt.Const.VeteranHitpointsCost, gt.Const.VeteranStaminaCost, gt.Const.VeteranPerkPointsBonus);

  local veteranPerkConsts = {
    ID = "perk.veteran",
    Script = "scripts/skills/perks/perk_veteran",
    Name = this.Const.Strings.PerkName.Veteran,
    Tooltip = this.Const.Strings.PerkDescription.Veteran,
    Icon = "ui/perks/perk_veteran.png",
    IconDisabled = "ui/perks/perk_veteran_sw.png"
  };
  ::quirks.setPerk(veteranPerkConsts, 6);
};

local addPerkLastStand = function() {
  gt.Const.LastStandResolveBonusPerNeighbourEnemy <- 3;
  gt.Const.LastStandResolveBonusMax <- 36;
  gt.Const.Strings.PerkName.LastStand <- "Last Stand";
  gt.getLastStandDescription <- function(resolveBonusPerNeighbourEnemy, resolveBonusMax) {
    return "Upon taking damage to hitpoints add a stack of Last Stand until the end of the battle. " +
      "Each stack increases resolve by [color=" + this.Const.UI.Color.PositiveValue + "]" +
      resolveBonusPerNeighbourEnemy + "[/color] per enemy around you to a maximum of " +
      "[color=" + this.Const.UI.Color.PositiveValue + "]" + resolveBonusMax + "[/color].";
  };
  gt.Const.Strings.PerkDescription.LastStand <- gt.getLastStandDescription(
    gt.Const.LastStandResolveBonusPerNeighbourEnemy, gt.Const.LastStandResolveBonusMax);

  local lastStandPerkConsts = {
    ID = "perk.last_stand",
    Script = "scripts/skills/perks/perk_last_stand",
    Name = this.Const.Strings.PerkName.LastStand,
    Tooltip = this.Const.Strings.PerkDescription.LastStand,
    Icon = "ui/perks/perk_last_stand.png",
    IconDisabled = "ui/perks/perk_last_stand_sw.png"
  };
  ::quirks.setPerk(lastStandPerkConsts, 2);
};

local addPerkPunchingBag = function() {
  gt.Const.PunchingBagOnHitDamageMult <- 0.85;
  gt.Const.PunchingBagOnTurnStartBonusMult <- 0.4;
  gt.Const.Strings.PerkName.PunchingBag <- "Punching Bag";
  gt.getPunchingBagDescription <- function(onHitDamageMult, onTurnStartBonusMult) {
    return "Each time being hit decrease future incomming damage by [color=" + this.Const.UI.Color.PositiveValue + "]" +
      this.Math.round((1 - onHitDamageMult) * 100) + "%[/color] from attacks. At the start of each turn this bonus is reduced by [color=" + this.Const.UI.Color.NegativeValue + "]" +
      this.Math.round(onTurnStartBonusMult * 100) + "%[/color].";
  };
  gt.Const.Strings.PerkDescription.PunchingBag <- gt.getPunchingBagDescription(gt.Const.PunchingBagOnHitDamageMult, gt.Const.PunchingBagOnTurnStartBonusMult);

  local punchingBagPerkConsts = {
    ID = "perk.punching_bag",
    Script = "scripts/skills/perks/perk_punching_bag",
    Name = this.Const.Strings.PerkName.PunchingBag,
    Tooltip = this.Const.Strings.PerkDescription.PunchingBag,
    Icon = "ui/perks/perk_punching_bag.png",
    IconDisabled = "ui/perks/perk_punching_bag_sw.png"
  };
  ::quirks.setPerk(punchingBagPerkConsts, 1);
};

local addPerkSurprise = function() {
  gt.Const.Strings.SurprisedEffectName <- "Surprised";
  gt.Const.SurpriseOnMissedInitiativeStolen <- 10;
  gt.Const.Strings.PerkName.Surprise <- "Surprise";
  gt.getSurpriseDescription <- function(onMissedInitiativeStolen) {
    return "With each time, being missed, steal [color=" + this.Const.UI.Color.PositiveValue + "]" +
      onMissedInitiativeStolen + "[/color] initiative form the attacker for 2 round.";
  };
  gt.Const.Strings.PerkDescription.Surprise <- gt.getSurpriseDescription(gt.Const.SurpriseOnMissedInitiativeStolen);

  local surprisePerkConsts = {
    ID = "perk.surprise",
    Script = "scripts/skills/perks/perk_surprise",
    Name = this.Const.Strings.PerkName.Surprise,
    Tooltip = this.Const.Strings.PerkDescription.Surprise,
    Icon = "ui/perks/perk_surprise.png",
    IconDisabled = "ui/perks/perk_surprise_sw.png"
  };
  ::quirks.setPerk(surprisePerkConsts, 4);
};

local addPerkRefundActionPoints = function() {
  gt.Const.RefundActionPointsAttackFatigueCostMult <- 0.5;
  gt.Const.RefundActionPointsFatigueCostPerActionPoint <- 2;
  this.Const.Strings.PerkName.RefundActionPoints <- "Refund Action Points"
  gt.getRefundActionPointsDescription <- function(attackFatigueCostMult, fatigueCostPerActionPoint) {
    return "Unlocks the ability to refund all action points on a missed attack. " +
      "The cost is [color=" + this.Const.UI.Color.NegativeValue + "]" + this.Math.round(attackFatigueCostMult * 100) + "%[/color] of the fatigue of the attack + " +
      "[color=" + this.Const.UI.Color.NegativeValue + "]" + fatigueCostPerActionPoint + "[/color] per action point.";
  };
  gt.Const.Strings.PerkDescription.RefundActionPoints <- gt.getRefundActionPointsDescription(
    gt.Const.RefundActionPointsAttackFatigueCostMult, gt.Const.RefundActionPointsFatigueCostPerActionPoint);

  local refundActionPointsPerkConsts = {
    ID = "perk.refund_action_points",
    Script = "scripts/skills/perks/perk_refund_action_points",
    Name = this.Const.Strings.PerkName.RefundActionPoints,
    Tooltip = this.Const.Strings.PerkDescription.RefundActionPoints,
    Icon = "ui/perks/perk_refund_action_points.png",
    IconDisabled = "ui/perks/perk_refund_action_points_sw.png"
  };
  ::quirks.setPerk(refundActionPointsPerkConsts, 5);
};

local addPerkSlack = function() {
  gt.Const.SlackFatigueRecoveryPerUnspentActionPoint <- 1.5;
  this.Const.Strings.PerkName.Slack <- "Slack";
  gt.getSlackDescription <- function(fatigueRecoveryPerUnspentActionPoint) {
    return "Each turn recover an aditional [color=" + this.Const.UI.Color.PositiveValue + "]" +
      fatigueRecoveryPerUnspentActionPoint + "[/color] fatigue per unspent action point previos turn. " +
      " Rounding is randomized with probability to round down or up equal to the fraction.";
  };
  gt.Const.Strings.PerkDescription.Slack <- gt.getSlackDescription(gt.Const.SlackFatigueRecoveryPerUnspentActionPoint);

  local slackPerkConsts = {
    ID = "perk.slack",
    Script = "scripts/skills/perks/perk_slack",
    Name = this.Const.Strings.PerkName.Slack,
    Tooltip = this.Const.Strings.PerkDescription.Slack,
    Icon = "ui/perks/perk_slack.png",
    IconDisabled = "ui/perks/perk_slack_sw.png"
  };
  ::quirks.setPerk(slackPerkConsts, 1);
};

local addPerkImpenetrable = function() {
  gt.Const.ImpenetrableBestTotalArmorMax <- 400;
  gt.Const.ImpenetrableTotalArmorMaxStdDev <- 100;
  gt.Const.ImpenetrableBestDamageReceivedDirectMult <- 0.33;
  gt.Const.ImpenetrableMinDamageReceivedDirectMult <- 0.85;
  this.Const.Strings.PerkName.Impenetrable <- "Impenetrable"
  gt.getImpenetrableDescription <- function(bestTotalArmorMax, bestDamageReceivedDirectMult, minDamageReceivedDirectMult) {
    return "Reduces armor penetration damage based on total max body and helmet armor with best results at " +
      bestTotalArmorMax + " armor when damage is reduced by [color=" + this.Const.UI.Color.PositiveValue + "]" +
      this.Math.round((1 - bestDamageReceivedDirectMult) * 100) +
      "%[/color]. If total max armor is more than that the effect is gradually weakend to a minimum of [color=" + this.Const.UI.Color.PositiveValue + "]" +
      this.Math.round((1 - minDamageReceivedDirectMult) * 100) +
      "%[/color].";
  };
  gt.Const.Strings.PerkDescription.Impenetrable <- gt.getImpenetrableDescription(
    gt.Const.ImpenetrableBestTotalArmorMax, gt.Const.ImpenetrableBestDamageReceivedDirectMult, gt.Const.ImpenetrableMinDamageReceivedDirectMult);

  local impenetrablePerkConsts = {
    ID = "perk.impenetrable",
    Script = "scripts/skills/perks/perk_impenetrable",
    Name = this.Const.Strings.PerkName.Impenetrable,
    Tooltip = this.Const.Strings.PerkDescription.Impenetrable,
    Icon = "ui/perks/perk_impenetrable.png",
    IconDisabled = "ui/perks/perk_impenetrable_sw.png"
  };
  ::quirks.setPerk(impenetrablePerkConsts, 5);
};

local findPerkConsts = function(perkId, perks=gt.Const.Perks.Perks) {
  foreach (perksRow in perks) {
    foreach (perk in perksRow) {
      if (perk.ID == perkId) {
        return perk;
      }
    }
  }

  return null;
}

local buffBullseye = function() {
  gt.Const.BullseyeRangedAttackBlockedChanceMult <- 0.533;
  local total = this.Const.Combat.RangedAttackBlockedChance * gt.Const.BullseyeRangedAttackBlockedChanceMult;
  gt.Const.Strings.PerkDescription.Bullseye <- "Nailed it! The penalty to hitchance when shooting at a target you have no clear line of fire to is reduced from [color=" +
    this.Const.UI.Color.NegativeValue + "]" + this.Math.round(this.Const.Combat.RangedAttackBlockedChance * 100) +
    "%[/color] to [color=" + this.Const.UI.Color.NegativeValue + "]" + this.Math.round(total * 100) + "%[/color] for ranged weapons.";
  
  ::mods_hookExactClass("skills/perks/perk_bullseye", function(c) {
    c.m.RangedAttackBlockedChanceMult <- this.Const.BullseyeRangedAttackBlockedChanceMult;
    c.onUpdate = function(_properties) {
      _properties.RangedAttackBlockedChanceMult *= this.m.RangedAttackBlockedChanceMult;
    };
  });

  local perkConsts = findPerkConsts("perk.bullseye");
  perkConsts.Tooltip = gt.Const.Strings.PerkDescription.Bullseye;
}

local nerfThrowingMastery = function() {
  gt.Const.ThrowingMasteryDamageMultAtDistance2 <- 1.2;
  gt.Const.ThrowingMasteryDamageMultAtDistance3 <- 1.1;
  gt.Const.Strings.PerkDescription.SpecThrowing <- "Master throwing weapons to wound or kill the enemy before they even get close. " +
    "Skills build up [color=" + this.Const.UI.Color.NegativeValue + "]25%[/color] less Fatigue." +
    "\n\nDamage is increased by [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.round((gt.Const.ThrowingMasteryDamageMultAtDistance2 - 1) * 100) + "%[/color] when attacking at 2 tiles of distance." +
    "\n\nDamage is increased by [color=" + this.Const.UI.Color.PositiveValue + "]" + this.Math.round((gt.Const.ThrowingMasteryDamageMultAtDistance3 - 1) * 100) + "%[/color] when attacking at 3 tiles of distance.",

  ::mods_hookExactClass("skills/perks/perk_mastery_throwing", function(c) {
    c.onAnySkillUsed = function(_skill, _targetEntity, _properties) {
      if (_targetEntity == null)
      {
        return;
      }

      if (_skill.isRanged() && (_skill.getID() == "actives.throw_axe" || _skill.getID() == "actives.throw_balls" || _skill.getID() == "actives.throw_javelin" || _skill.getID() == "actives.throw_spear" || _skill.getID() == "actives.sling_stone"))
      {
        local d = this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile());

        if (d <= 2)
        {
          _properties.DamageTotalMult *= this.Const.ThrowingMasteryDamageMultAtDistance2;
        }
        else if (d <= 3)
        {
          _properties.DamageTotalMult *= gt.Const.ThrowingMasteryDamageMultAtDistance3;
        }
      }
    };
  });

  local perkConsts = findPerkConsts("perk.mastery.throwing");
  perkConsts.Tooltip = gt.Const.Strings.PerkDescription.SpecThrowing;
};

local buffThrowingWithoutMastery = function() {
  ::mods_hookDescendants("entity/tactical/actor", function(c) {
    local actorClass = ::mods_getClassForOverride(c, "actor");
    if (!("onInitOriginalQuirks" in actorClass)) {
      actorClass.onInitOriginalQuirks <- actorClass.onInit;
      actorClass.onInit = function() {
        this.onInitOriginalQuirks();
        this.m.Skills.add(this.new("scripts/skills/special/buff_throwing"));
      };
    }
  });

  nerfThrowingMastery();
}

::mods_queue(null, "mod_hooks(>=20),libreuse(>=0.1)", function() {
  addOnAfterSkillUsed();
  #addExpectedDamageCalculationFlag();
  addMaxPerkPointsToPlayer();
  ::quirks.makeHitChanceMultipliersSymmetric();

  addPerkAcurate();
  addPerkBank();
  addPerkDefensiveAdaptation();
  addPerkDoubleOrNothing();
  addPerkExertion();
  addPerkHyperactive();
  addPerkImpenetrable();
  addPerkLastStand();
  addPerkPrecision();
  addPerkPunchingBag();
  addPerkRefundActionPoints();
  addPerkRefundFatigue();
  addPerkSlack();
  addPerkSurprise();
  addPerkTeacher();
  addPerkVeteran();

  buffBullseye();
  buffThrowingWithoutMastery();
});
