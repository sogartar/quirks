this.buff_throwing <- this.inherit("scripts/skills/skill", {
  m = {
    DamageTotalMultPerDistance = [1.0, 1.0, 1.15, 1.075],
    
  },
  function create() {
    this.m.ID = "special.buff_throwing";
    this.m.Type = this.Const.SkillType.StatusEffect | this.Const.SkillType.Special;
    this.m.IsActive = false;
    this.m.IsStacking = false;
    this.m.IsHidden = true;
  }

  function onAnySkillUsed(_skill, _targetEntity, _properties) {
    if (_targetEntity == null) {
      return;
    }

    if (_skill.isRanged() && (_skill.getID() == "actives.throw_axe" || _skill.getID() == "actives.throw_balls" ||
      _skill.getID() == "actives.throw_javelin" || _skill.getID() == "actives.throw_spear" || _skill.getID() == "actives.sling_stone")) {
      local d = this.getContainer().getActor().getTile().getDistanceTo(_targetEntity.getTile());
      _properties.DamageTotalMult *= (d < this.m.DamageTotalMultPerDistance.len() ? this.m.DamageTotalMultPerDistance[d] : 1.0);
    }
  }

});
