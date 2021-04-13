local gt = this.getroottable();

if (!("quirks" in gt)) {
  ::quirks <- {};
}

::quirks.stopAiDefendingOnEnemyBank <- function() {
  ::mods_hookNewObject("ai/tactical/strategy", function(o) {
    local updateDefendingOriginal = o.updateDefending;
    o.updateDefending = function() {
      local res = updateDefendingOriginal();
      if (!res) {
        return false;
      }

      local allFactions = this.Tactical.Entities.getAllInstances();

      foreach(faction in allFactions) {
        foreach(entity in faction) {
          if (!entity.isAlliedWith(this.m.Faction)) {
            local bank_skill = entity.getSkills().getSkillByID("actives.quirks.bank");
            if (bank_skill != null) {
              return false;
            }
          }
        }
      }

      return true;
    };
  });
}

