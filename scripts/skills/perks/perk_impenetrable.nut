this.perk_impenetrable <- this.inherit("scripts/skills/skill", {
  m = {
    BestFatigueFromArmorAndHelmet = this.Const.ImpenetrableBestFatigueFromArmorAndHelmet,
    FatigueStdDev = this.Const.ImpenetrablFatigueStdDev,
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
      this.Math.round(this.getDamageReceivedDirectMult(this.getFatigueFromArmorAndHelmet()) * 100) +
      "%[/color] of any damage that ignores armor.";
  }

  function onUpdate(_properties) {
    _properties.DamageReceivedDirectMult *= this.getDamageReceivedDirectMult(this.getFatigueFromArmorAndHelmet());
  }

  function getDamageReceivedDirectMult(fatigueFromArmorAndHelmet) {
    if (fatigueFromArmorAndHelmet <= this.m.BestFatigueFromArmorAndHelmet) {
      return this.m.BestDamageReceivedDirectMult;
    } else {
      return this.m.MinDamageReceivedDirectMult + (this.m.BestDamageReceivedDirectMult - this.m.MinDamageReceivedDirectMult) *
        ::libreuse.gaussian(fatigueFromArmorAndHelmet, this.m.BestFatigueFromArmorAndHelmet, this.m.FatigueStdDev);
    }
  }

  function getFatigueFromArmorAndHelmet() {
    local fat = 0;
    local items = this.getContainer().getActor().getItems();

    local body = items.getItemAtSlot(this.Const.ItemSlot.Body);
    if (body != null) {
      fat = fat - body.getStaminaModifier();
    }

    local head = items.getItemAtSlot(this.Const.ItemSlot.Head);
    if (head != null) {
      fat = fat - head.getStaminaModifier();
    }

    return fat;
  }
});
