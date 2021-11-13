this.perk_quirks_slack <- this.inherit("scripts/skills/skill", {
  m = {
    FatigueRecoveryPerUnspentActionPoint = this.Const.Quirks.SlackFatigueRecoveryPerUnspentActionPoint,
    UspentActionPoints = 0
  },
  function create() {
    this.m.ID = "perk.quirks.slack";
    this.m.Name = this.Const.Strings.PerkName.QuirksSlack;
    this.m.Icon = "ui/perks/perk_quirks_slack.png";
    this.m.IconMini = "perk_quirks_slack_mini";
    this.m.Type = this.Const.SkillType.Perk;
    this.m.Order = this.Const.SkillOrder.Perk;
    this.m.IsActive = false;
    this.m.IsHidden = true;
  }

  function getDescription() {
    return this.getroottable().Quirks.getSlackDescription(this.m.FatigueRecoveryPerUnspentActionPoint);
  }

  function onUpdate(_properties) {
    _properties.FatigueRecoveryRate += ::libreuse.roundRandomWeighted(this.m.UspentActionPoints * this.m.FatigueRecoveryPerUnspentActionPoint);
  }

  function onTurnEnd() {
    this.m.UspentActionPoints = this.getContainer().getActor().getActionPoints();
  }
});
