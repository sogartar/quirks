this.perk_impenetrable <- this.inherit("scripts/skills/skill", {
  m = {
    BestTotalArmorMax = this.Const.ImpenetrableBestTotalArmorMax,
    TotalArmorMaxStdDev = this.Const.ImpenetrableTotalArmorMaxStdDev,
    BestDamageReceivedDirectMult = this.Const.ImpenetrableBestDamageReceivedDirectMult,
    MinDamageReceivedDirectMult = this.Const.ImpenetrableMinDamageReceivedDirectMult
  },
  function create() {
    this.m.ID = "perk.impenetrable";
    this.m.Name = this.Const.Strings.PerkName.Impenetrable;
    this.m.Icon = "ui/perks/perk_impenetrable.png";
    this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
    this.m.Order = this.Const.SkillOrder.Perk;
    this.m.IsActive = false;
    this.m.IsHidden = false;
  }

  function getDescription() {
    return "Only take [color=" + this.Const.UI.Color.PositiveValue + "]" +
      this.Math.round(this.getDamageReceivedDirectMult(this.getTotalArmorMax()) * 100) +
      "%[/color] of any damage that ignores armor.";
  }

  function onUpdate(_properties) {
    _properties.DamageReceivedDirectMult *= this.getDamageReceivedDirectMult(this.getTotalArmorMax());
  }

  function getDamageReceivedDirectMult(totalArmorMax) {
    if (totalArmorMax <= this.m.BestTotalArmorMax) {
      return this.m.BestDamageReceivedDirectMult;
    } else {
      return this.m.MinDamageReceivedDirectMult - (this.m.MinDamageReceivedDirectMult - this.m.BestDamageReceivedDirectMult) *
        ::libreuse.gaussian(totalArmorMax, this.m.BestTotalArmorMax, this.m.TotalArmorMaxStdDev);
    }
  }

  function getTotalArmorMax() {
    local totalArmor = 0;
    local items = this.getContainer().getActor().getItems();

    local body = items.getItemAtSlot(this.Const.ItemSlot.Body);
    if (body != null) {
      totalArmor += body.getArmorMax();
    }

    local head = items.getItemAtSlot(this.Const.ItemSlot.Head);
    if (head != null) {
      totalArmor += head.getArmorMax();
    }

    return totalArmor;
  }
});
