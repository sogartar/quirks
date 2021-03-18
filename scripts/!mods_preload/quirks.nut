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
  gt.Const.BankInterestRatePerTurn <- 0.25;
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
};

local addPerkPrecision = function() {
  gt.Const.PrecisionFatigueCost <- 25;
  gt.Const.PrecisionApCost <- 5;
  gt.Const.Strings.PerkName.Precision <- "Precision";
  gt.Const.PrecisionHitChanceBonus <- 30;
  this.Const.PrecisionHitChanceBonusDecreasePerTurn <- 10;
  gt.Const.Strings.PerkDescription.Precision <- "Unlocks the \'" + gt.Const.Strings.PerkName.Precision + "\' ability to increase next attack's hit chance by [color=" +
  this.Const.UI.Color.PositiveValue + "]" + gt.Const.PrecisionHitChanceBonus + "%[/color]." +
    "If unused, each turn this bonus is decreased by [color=" + this.Const.UI.Color.NegativeValue + "]" + gt.Const.PrecisionHitChanceBonusDecreasePerTurn + "%[/color]. Costs " + 
    this.Const.PrecisionFatigueCost + " fatigue and " + gt.Const.PrecisionApCost + " action points.";
  gt.Const.Strings.PrecisionSkillDescription <- "Increase next attack's hit chance by [color=" + this.Const.UI.Color.PositiveValue + "]" + gt.Const.PrecisionHitChanceBonus + "%[/color]. " +
    "If unused, each turn this bonus is decreased by [color=" + this.Const.UI.Color.NegativeValue + "]" + gt.Const.PrecisionHitChanceBonusDecreasePerTurn + "%[/color].";

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
  gt.Const.ExertionFatigueCostMult <- 0.166;
  gt.Const.ExertionMinFatigueCost <- 15;
  gt.Const.ExertionInitiativeBase <- 210;
  gt.Const.ExertionApBonus <- 1;
  gt.Const.Strings.PerkName.Exertion <- "Exertion";
  gt.Const.Strings.PerkDescription.Exertion <- "Unlocks the \'" + gt.Const.Strings.PerkName.Exertion +
    "\' ability to increase action points this turn. Fatigue cost is based on current initiative.";

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
  gt.Const.HyperactiveFatigueRecoveryRateModifier <- -20;
  gt.Const.Strings.PerkName.Hyperactive <- "Hyperactive";
  gt.Const.Strings.PerkDescription.Hyperactive <- "Permanently increases action points by [color=" + this.Const.UI.Color.PositiveValue + "]" + gt.Const.HyperactiveApBonus +
    "[/color] and reduces fatigue recovery rate by [color=" + this.Const.UI.Color.NegativeValue + "]" + (-gt.Const.HyperactiveFatigueRecoveryRateModifier) + "[/color].";

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
  gt.Const.AcurateHitChanceBonus <- 5;
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
    this.Math.floor(gt.Const.RefundFatigueMult * 100) + "%[/color] of the fatigue used.";

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
    skillClass.onAfterSkillUsed <- function(_user, _targetTile) {};
    skillClass.onAfterAnySkillUsed <- function(_skill, _targetTile) {};
    local useOriginal = skillClass.use;
    skillClass.use = function(_targetTile, _forFree = false) {
      local container = this.getContainer();
      local ret = useOriginal(_targetTile, _forFree);
      this.onAfterSkillUsed(container.getActor(), _targetTile);
      container.onAfterSkillUsed(this, _targetTile);
      return ret;
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
  gt.Const.Strings.PerkDescription.DoubleOrNothing <- "On each attack there is an equal chance to do double damage or no damage at all." +
    " When attacked there is an equal chance to take double damage or no damage at all.";

  local doubleOrNothingPerkConsts = {
    ID = "perk.double_or_nothing",
    Script = "scripts/skills/perks/perk_double_or_nothing",
    Name = this.Const.Strings.PerkName.DoubleOrNothing,
    Tooltip = this.Const.Strings.PerkDescription.DoubleOrNothing,
    Icon = "ui/perks/perk_double_or_nothing.png",
    IconDisabled = "ui/perks/perk_double_or_nothing_sw.png"
  };
  ::quirks.setPerk(doubleOrNothingPerkConsts, 5);
};

local addPerkTeacher = function() {
  gt.Const.TeacherXpMult <- 1.30;
  gt.Const.Strings.PerkName.Teacher <- "Teacher";
  gt.getTeacherDescription <- function(xpMult) {
    return "Each kill by this character grants addition [color=" + this.Const.UI.Color.PositiveValue + "]" +
    this.Math.round((xpMult - 1) * 100) + "%[/color] XP for the kill to everybody in the company who is a lower level."; };
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
  gt.Const.DefensiveAdaptationBonusPerStack <- 10;
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
  gt.Const.VeteranHitpointsCost <- 10;
  gt.Const.VeteranStaminaCost <- 10;
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

local addPerkPunchingBag = function() {
  gt.Const.PunchingBagOnHitDamageMult <- 0.65;
  gt.Const.Strings.PerkName.PunchingBag <- "Punching Bag";
  gt.getPunchingBagDescription <- function(onHitDamageMult) {
    return "Upon taking damage decrease future incomming damage by [color=" + this.Const.UI.Color.PositiveValue + "]" +
      this.Math.round((1 - onHitDamageMult) * 100) + "%[/color] until next turn.";
  };
  gt.Const.Strings.PerkDescription.PunchingBag <- gt.getPunchingBagDescription(gt.Const.PunchingBagOnHitDamageMult);

  local punchingBagPerkConsts = {
    ID = "perk.punching_bag",
    Script = "scripts/skills/perks/perk_punching_bag",
    Name = this.Const.Strings.PerkName.PunchingBag,
    Tooltip = this.Const.Strings.PerkDescription.PunchingBag,
    Icon = "ui/perks/perk_punching_bag.png",
    IconDisabled = "ui/perks/perk_punching_bag_sw.png"
  };
  ::quirks.setPerk(punchingBagPerkConsts, 2);
};

local addPerkSurprise = function() {
  gt.Const.Strings.SurprisedEffectName <- "Surprised";
  gt.Const.SurpriseOnMissedInitiativeStolen <- 10;
  gt.Const.Strings.PerkName.Surprise <- "Surprise";
  gt.getSurpriseDescription <- function(onMissedInitiativeStolen) {
    return "With each time, being missed, steal [color=" + this.Const.UI.Color.PositiveValue + "]" +
      onMissedInitiativeStolen + "[/color] initiative form the attacker next round.";
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
  ::quirks.setPerk(surprisePerkConsts, 5);
};

local addPerkRefundActionPoints = function() {
  gt.Const.RefundActionPointsFatigueCostMultiplier <- 2;
  this.Const.Strings.PerkName.RefundActionPoints <- "Refund Action Points"
  gt.getRefundActionPointsDescription <- function(fatigueCostMultiplier) {
    return "Unlocks the ability to refund all action points on a missed attack. The cost is [color=" + this.Const.UI.Color.PositiveValue + "]" +
      this.Math.round(fatigueCostMultiplier * 100) + "%[/color] of the fatigue of the attack.";
  };
  gt.Const.Strings.PerkDescription.RefundActionPoints <- gt.getRefundActionPointsDescription(gt.Const.RefundActionPointsFatigueCostMultiplier);

  local refundActionPointsPerkConsts = {
    ID = "perk.refund_action_points",
    Script = "scripts/skills/perks/perk_refund_action_points",
    Name = this.Const.Strings.PerkName.RefundActionPoints,
    Tooltip = this.Const.Strings.PerkDescription.RefundActionPoints,
    Icon = "ui/perks/perk_refund_action_points.png",
    IconDisabled = "ui/perks/perk_refund_action_points_sw.png"
  };
  ::quirks.setPerk(refundActionPointsPerkConsts, 4);
};

local addPerkSlack = function() {
  gt.Const.SlackFatigueRecoveryPerUnspentActionPoint <- 1.5;
  this.Const.Strings.PerkName.Slack <- "Slack"
  gt.getSlackDescription <- function(fatigueRecoveryPerUnspentActionPoint) {
    return "At the start of each turn Recovers an aditional [color=" + this.Const.UI.Color.PositiveValue + "]" +
      fatigueRecoveryPerUnspentActionPoint + "[/color] fatigue per unspent action point.";
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
  ::quirks.setPerk(slackPerkConsts, 4);
};

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
  addPerkPrecision();
  addPerkPunchingBag();
  addPerkRefundActionPoints();
  addPerkRefundFatigue();
  addPerkSlack();
  addPerkSurprise();
  addPerkTeacher();
  addPerkVeteran();
});
