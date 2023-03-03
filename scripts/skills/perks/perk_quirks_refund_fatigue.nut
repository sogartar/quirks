this.perk_quirks_refund_fatigue <- this.inherit("scripts/skills/skill", {
  m = {
    RefundMult = this.Const.Quirks.RefundFatigueMult,
    SkillCounterFatigueCostMap = {}
  }

  function create() {
    this.m.ID = "perk.quirks.refund_fatigue";
    this.m.Name = this.Const.Strings.PerkName.QuirksRefundFatigue;
    this.m.Description = this.Const.Strings.PerkDescription.QuirksRefundFatigue;
    this.m.Icon = "ui/perks/perk_quirks_refund_fatigue.png";
    this.m.IconMini = "perk_quirks_refund_fatigue_mini";
    this.m.Type = this.Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
    this.m.Order = this.Const.SkillOrder.Perk;
    this.m.IsActive = false;
    this.m.IsHidden = false;
  }

  function onTargetHit(_caller, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor) {
    this.m.SkillCounterFatigueCostMap[this.Const.SkillCounter] <- 0;
  }

  function onTargetMissed(_skill, _targetEntity) {
    if (!(this.Const.SkillCounter in this.m.SkillCounterFatigueCostMap)) {
      this.m.SkillCounterFatigueCostMap[this.Const.SkillCounter] <-
        (_skill.isUsedForFree() ? 0 : _skill.getFatigueCost());
      local tag = {
        Actor = this.getContainer().getActor(),
        SkillCounter = this.Const.SkillCounter,
      };
      this.Time.scheduleEvent(this.TimeUnit.Virtual, 400, this.onTargedMissedCallback.bindenv(this), tag);
    }
  }

	function onTargedMissedCallback(_tag) {
		if ((_tag.SkillCounter in this.m.SkillCounterFatigueCostMap) && _tag.Actor.isAlive() &&
      this.Tactical.TurnSequenceBar.getActiveEntity().getID() == _tag.Actor.getID()) {
      _tag.Actor.setFatigue(
        this.Math.max(0, _tag.Actor.getFatigue()
        - ::libreuse.roundRandomWeighted(this.m.SkillCounterFatigueCostMap[_tag.SkillCounter] * this.m.RefundMult)));
      _tag.Actor.setDirty(true);
		}
	}

  function onTurnStarted() {
    this.m.SkillCounterFatigueCostMap = {};
  }
});
