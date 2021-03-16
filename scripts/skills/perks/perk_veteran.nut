this.perk_veteran <- this.inherit("scripts/skills/skill", {
  m = {
    HitpointsCost = this.Const.VeteranHitpointsCost,
    StaminaCost = this.Const.VeteranStaminaCost,
    PerkPointsBonus = this.Const.VeteranPerkPointsBonus
  },
  function create() {
    this.m.ID = "perk.veteran";
    this.m.Name = this.Const.Strings.PerkName.Veteran;
    this.m.Description = this.Const.Strings.PerkDescription.Veteran;
    this.m.Icon = "ui/perks/perk_veteran.png";
    this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
    this.m.Order = this.Const.SkillOrder.Perk | this.Const.SkillType.StatusEffect;
    this.m.IsActive = false;
    this.m.IsHidden = true;
  }

  function getDescription() {
    return this.getroottable().getVeteranDescription(this.m.HitpointsCost, this.m.StaminaCost, this.m.PerkPointsBonus);
  }

  function onAdded() {
    local player = this.getContainer().getActor();
    player.m.MaxPerkPoints += this.m.PerkPointsBonus;
    player.updateLevel();
    player.setDirty(true);
  }
  
   function onUpdate(_properties) {
     _properties.Hitpoints = this.Math.max(1, _properties.Hitpoints - this.m.HitpointsCost);
     _properties.Stamina -= this.m.StaminaCost;
   }
});
