// eyespider marking skill, to give them a target to harass
/datum/targetable/critter/mark
  name = "Mark"
  desc = "Focus your unyielding gaze on some poor soul."
  cooldown = 600
  targeted = 1
  target_anything = 1
  icon_state = "mark"


  cast(atom/target)
    if (..())
      return 1
    if (isobj(target))
      target = get_turf(target)
    if (isturf(target))
      target = locate(/mob/living) in target
      if (!target)
        boutput(holder.owner, SPAN_ALERT("No one to mark there."))
        return 1
    if (target == holder.owner)
      return 1
    if (BOUNDS_DIST(holder.owner, target) > 0)
      boutput(holder.owner, SPAN_ALERT("That is too far away to mark."))
      return 1
    var/mob/M = target

    holder.owner.visible_message(SPAN_ALERT("<b>[holder.owner] stares unyielding at [M]!</b>"), SPAN_ALERT("We have marked [M]! We now follow every movement."))
    if (istype(holder.owner, /mob/living/critter/changeling/eyespider))
      var/mob/living/critter/changeling/eyespider/E = holder.owner
      if(E.marked_target)
        boutput(E, SPAN_ALERT("We have ceased following [E.marked_target] as a result."))
        // no need to null the target, we're about to overwrite it
      logTheThing(LOG_COMBAT, E, "marks [constructTarget(M,"combat")] for constant watching as an eyespider [log_loc(E)].")
      E.marked_target = M

      // TODO: NOT THIS, THERE MUST BE A BETTER WAY
      SPAWN(1 MINUTE) // 60 second timeout for marks
        if(E.marked_target && E.marked_target == M)
          boutput(E, SPAN_ALERT("Our mark on [E.marked_target] has faded."))
          E.marked_target = null
