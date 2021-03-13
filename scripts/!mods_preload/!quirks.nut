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
  gt.Const.BankFatigueCost <- 1;
  gt.Const.BankApCost <- 1;
  gt.Const.BankApIncreaseOnUse <- 1;
  gt.Const.CashInFatigueCost <- 1;
  gt.Const.CashInApCost <- 1;
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

::mods_queue(null, "mod_hooks(>=20)", function() {
  addPerkBank();
  addPerkPrecision();
});
