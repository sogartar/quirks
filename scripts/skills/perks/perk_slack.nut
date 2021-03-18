this.perk_slack <- this.inherit("scripts/skills/skill", {
  m = {
    FatigueRecoveryPerUnspentActionPoint = this.Const.SlackFatigueRecoveryPerUnspentActionPoint,
    UspentActionPoints = 0
  },
  function create() {
    this.m.ID = "perk.slack";
    this.m.Name = this.Const.Strings.PerkName.Slack;
    this.m.Icon = "ui/perks/perk_slack.png";
    this.m.Type = this.Const.SkillType.Perk;
    this.m.Order = this.Const.SkillOrder.Perk;
    this.m.IsActive = false;
    this.m.IsHidden = true;
  }

  function getDescription() {
    return this.getroottable().getSlackDescription(this.m.FatigueRecoveryPerUnspentActionPoint);
  }

  function onUpdate(_properties) {
    _properties.FatigueRecoveryRate += this.Math.floor(this.m.UspentActionPoints * this.m.FatigueRecoveryPerUnspentActionPoint);
  }

  function onTurnEnd() {
    this.m.UspentActionPoints = this.getContainer().getActor().getActionPoints();
  }
});
