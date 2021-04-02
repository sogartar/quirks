this.refund_action_points_skill <- this.inherit("scripts/skills/skill", {
  m = {
    ActionPontsRefund = 0,
  },
  function create()
  {
    this.m.ID = "actives.refund_action_points";
    this.m.Name = this.Const.Strings.PerkName.RefundActionPoints;
    this.m.Icon = "ui/perks/active_refund_action_points.png";
    this.m.IconDisabled = "ui/perks/active_refund_action_points_sw.png";
    this.m.Overlay = "active_refund_action_points";
    this.m.SoundOnUse = [
      "sounds/combat/active_refund_action_points.wav"
    ];
    this.m.Type = this.Const.SkillType.Active;
    this.m.Order = this.Const.SkillOrder.Any;
    this.m.IsSerialized = false;
    this.m.IsActive = true;
    this.m.IsTargeted = false;
    this.m.IsAttack = false;
    this.m.IsStacking = true;
    this.m.ActionPointCost = 0;
    this.m.MinRange = 0;
    this.m.MaxRange = 0;
  }

  function setActionPontsRefund(value) {
    this.m.ActionPontsRefund = value;
  }

  function getDescription() {
    return "Refund [color=" + this.Const.UI.Color.PositiveValue + "]" + this.m.ActionPontsRefund + "[/color] action points.";
  }

  function getTooltip() {
    local ret = [
      {
        id = 1,
        type = "title",
        text = this.getName()
      },
      {
        id = 2,
        type = "description",
        text = this.getDescription()
      },
      {
        id = 3,
        type = "text",
        text = this.getCostString()
      }
    ];
    return ret;
  }

  function isUsable() {
    return this.skill.isUsable();
  }

  function onUse(_user, _targetTile) {
    local actor = this.getContainer().getActor();
    actor.setActionPoints(actor.getActionPoints() + this.m.ActionPontsRefund);
    this.getContainer().remove(this);
    return true;
  }

  function onTurnEnd() {
    this.removeSelf();
  }
});
