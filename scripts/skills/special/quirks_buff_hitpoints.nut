this.quirks_buff_hitpoints <- this.inherit("scripts/skills/skill", {
  m = {
    HitpointsModifier = 6,
  },
  function create() {
    this.m.ID = "special.quirks.buff_hitpoints";
    this.m.Type = this.Const.SkillType.StatusEffect | this.Const.SkillType.Special;
    this.m.IsActive = false;
    this.m.IsStacking = false;
    this.m.IsHidden = true;
  }

  function onUpdate(_properties) {
    _properties.Hitpoints += this.m.HitpointsModifier;
  }
});
