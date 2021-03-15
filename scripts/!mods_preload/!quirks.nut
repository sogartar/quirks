::mods_registerMod("quirks", 0.1, "quirks");

local gt = this.getroottable();

::quirks <- {};

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
  ::quirks.setPerk(bankPerkConsts, 0);
};

local addPerkPrecision = function() {
  gt.Const.PrecisionFatigueCost <- 25;
  gt.Const.PrecisionApCost <- 5;
  gt.Const.Strings.PerkName.Precision <- "Precision";
  gt.Const.PrecisionHitChanceBonus <- 30;
  gt.Const.Strings.PerkDescription.Precision <- "Unlocks the \'" + gt.Const.Strings.PerkName.Precision + "\' ability to increase next attack's hit chance by [color=" +
  this.Const.UI.Color.PositiveValue + "]" + gt.Const.PrecisionHitChanceBonus + "%[/color]. Costs " + this.Const.PrecisionFatigueCost + " fatigue and " + gt.Const.PrecisionApCost + " action points.";
  gt.Const.Strings.PrecisionSkillDescription <- "Increase next attack's hit chance by [color=" + this.Const.UI.Color.PositiveValue + "]" + gt.Const.PrecisionHitChanceBonus + "%[/color].";

  local precisionPerkConsts = {
    ID = "perk.precision",
    Script = "scripts/skills/perks/perk_precision",
    Name = this.Const.Strings.PerkName.Precision,
    Tooltip = this.Const.Strings.PerkDescription.Precision,
    Icon = "ui/perks/perk_precision.png",
    IconDisabled = "ui/perks/perk_precision_sw.png"
  };
  ::quirks.setPerk(precisionPerkConsts, 0);
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
  ::quirks.setPerk(exertionPerkConsts, 0);
};

local addPerkHyperactive = function() {
  gt.Const.HyperactiveApBonus <- 3;
  gt.Const.HyperactiveFatigueRecoveryRateModifier <- -30;
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
  ::quirks.setPerk(hyperactivePerkConsts, 0);
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
  ::quirks.setPerk(acuratePerkConsts, 0);
};

::mods_queue(null, "mod_hooks(>=20)", function() {
  addPerkBank();
  addPerkPrecision();
  addPerkExertion();
  addPerkHyperactive();
  addPerkAcurate();
});
