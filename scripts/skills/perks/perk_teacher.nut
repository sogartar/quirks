this.perk_teacher <- this.inherit("scripts/skills/skill", {
  m = {
    XpMult = this.Const.TeacherXpMult,
    LifetimeXpTaught = 0
  },
  function create() {
    this.m.ID = "perk.teacher";
    this.m.Name = this.Const.Strings.PerkName.Teacher;
    this.m.Icon = "ui/perks/perk_teacher.png";
    this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
    this.m.Order = this.Const.SkillOrder.Perk;
    this.m.IsActive = false;
    this.m.IsHidden = false;
  }

  function getDescription() {
    return this.getroottable().getTeacherDescription(this.m.XpMult) +
      "\nTotal XP taught [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.LifetimeXpTaught + "[/color].";
  }

  function onTargetKilled(_targetEntity, _skill) {
    local teacher = _skill.getContainer().getActor();
    local brothers = this.Tactical.Entities.getInstancesOfFaction(this.Const.Faction.Player);
    local xpGroup = this.Math.floor(_targetEntity.getXPValue() * this.m.XpMult * (1.0 - this.Const.XP.XPForKillerPct) / brothers.len());
    local students = [];
    local teacherLevel = teacher.getLevel();
    foreach (bro in brothers) {
      if (bro.getLevel() < teacherLevel && bro != teacher) {
        students.append(bro);
      }
    }

    foreach (student in students) {
      student.addXP(xpGroup);
      this.m.LifetimeXpTaught += xpGroup;
    }
  }

  function onSerialize(_out) {
    this.skill.onSerialize(_out);
    _out.writeU32(this.m.LifetimeXpTaught);
  }

  function onDeserialize(_in) {
    this.skill.onDeserialize(_in);
    this.m.LifetimeXpTaught = _in.readU32();
  }
});
