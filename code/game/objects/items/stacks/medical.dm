/obj/item/stack/medical
	name = "medical pack"
	singular_name = "medical pack"
	icon = 'icons/obj/stack_objects.dmi'
	amount = 6
	max_amount = 6
	w_class = WEIGHT_CLASS_TINY
	full_w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	resistance_flags = FLAMMABLE
	max_integrity = 40
	novariants = FALSE
	item_flags = NOBLUDGEON
	var/failure_chance //WS Edit - Failure chance
	merge_type = /obj/item/stack/medical
	/// How long it takes to apply it to yourself
	var/self_delay = 5 SECONDS
	/// How long it takes to apply it to someone else
	var/other_delay = 0
	/// If we've still got more and the patient is still hurt, should we keep going automatically?
	var/repeating = FALSE
	/// How much medical XP is given per use?
	var/experience_given = 1
	///Sound/Sounds to play when this is applied
	var/apply_sounds
	/// How much brute we heal per application. This is the only number that matters for simplemobs
	var/heal_brute
	/// How much burn we heal per application
	var/heal_burn
	/// How much we reduce bleeding per application on cut wounds
	var/stop_bleeding
	/// How much sanitization to apply to burn wounds on application
	var/sanitization
	/// How much we add to flesh_healing for burn wounds on application
	var/flesh_regeneration
	/// This is a multiplier used to speed up burn recoveries
	var/burn_cleanliness_bonus

/obj/item/stack/medical/attack(mob/living/target, mob/user)
	. = ..()
	try_heal(target, user)

/// In which we print the message that we're starting to heal someone, then we try healing them. Does the do_after whether or not it can actually succeed on a targeted mob
/obj/item/stack/medical/proc/try_heal(mob/living/patient, mob/user, silent = FALSE)
	if(patient.stat == DEAD)
		to_chat(user, "<span class='warning'>[patient] is dead! You can not help [patient.p_them()].</span>")
		return
	if(isanimal(patient) && heal_brute) // only brute can heal
		var/mob/living/simple_animal/critter = patient
		if (!critter.healable)
			to_chat(user, "<span class='warning'>You cannot use [src] on [patient]!</span>")
			return FALSE
		else if (critter.health == critter.maxHealth)
			to_chat(user, "<span class='notice'>[patient] is at full health.</span>")
			return FALSE
		user.visible_message("<span class='green'>[user] applies [src] on [patient].</span>", "<span class='green'>You apply [src] on [patient].</span>")
		patient.heal_bodypart_damage((heal_brute * 0.5))
		return TRUE
	if(iscarbon(patient))
		return heal_carbon(patient, user, heal_brute, heal_burn)
	to_chat(user, "<span class='warning'>You can't heal [patient] with [src]!</span>")

/// The healing effects on a carbon patient. Since we have extra details for dealing with bodyparts, we get our own fancy proc. Still returns TRUE on success and FALSE on fail
/obj/item/stack/medical/proc/heal_carbon(mob/living/carbon/C, mob/user, brute, burn)
	var/obj/item/bodypart/affecting = C.get_bodypart(check_zone(user.zone_selected))
	if(!affecting) //Missing limb?
		to_chat(user, "<span class='warning'>[C] doesn't have \a [parse_zone(user.zone_selected)]!</span>")
		return FALSE
	if(!IS_ORGANIC_LIMB(affecting)) //Limb must be organic to be healed - RR
		to_chat(user, "<span class='warning'>[src] won't work on a robotic limb!</span>")
		return FALSE
	if(affecting.brute_dam && brute || affecting.burn_dam && burn)
		user.visible_message("<span class='green'>[user] applies [src] on [C]'s [affecting.name].</span>", "<span class='green'>You apply [src] on [C]'s [affecting.name].</span>")
		var/previous_damage = affecting.get_damage()
		if(affecting.heal_damage(brute, burn))
			C.update_damage_overlays()
		post_heal_effects(max(previous_damage - affecting.get_damage(), 0), C, user)
		return TRUE
	to_chat(user, "<span class='warning'>[C]'s [affecting.name] can not be healed with [src]!</span>")
	return FALSE

///Override this proc for special post heal effects.
/obj/item/stack/medical/proc/post_heal_effects(amount_healed, mob/living/carbon/healed_mob, mob/user)
	return

/obj/item/stack/medical/bruise_pack
	name = "bruise pack"
	singular_name = "bruise pack"
	desc = "A therapeutic gel pack and bandages designed to treat blunt-force trauma."
	icon_state = "brutepack"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	apply_sounds = list('sound/effects/rip1.ogg', 'sound/effects/rip2.ogg')
	self_delay = 4 SECONDS
	other_delay = 2 SECONDS
	grind_results = list(/datum/reagent/medicine/c2/libital = 10)
	merge_type = /obj/item/stack/medical/bruise_pack

/obj/item/stack/medical/gauze
	name = "medical gauze"
	desc = "A roll of elastic cloth, perfect for stabilizing all kinds of slashes, punctures and burns. "
	gender = PLURAL
	singular_name = "medical gauze"
	icon_state = "gauze"
	apply_sounds = list('sound/effects/rip1.ogg', 'sound/effects/rip2.ogg')
	self_delay = 5 SECONDS
	other_delay = 2 SECONDS
	max_amount = 12
	amount = 6
	grind_results = list(/datum/reagent/cellulose = 2)
	custom_price = 100
	burn_cleanliness_bonus = 0.35
	merge_type = /obj/item/stack/medical/gauze
	var/gauze_type = /datum/bodypart_aid/gauze

// gauze is only relevant for wounds, which are handled in the wounds themselves
/obj/item/stack/medical/gauze/try_heal(mob/living/M, mob/user, silent)
	var/obj/item/bodypart/limb = M.get_bodypart(check_zone(user.zone_selected))
	if(!limb)
		to_chat(user, "<span class='notice'>There's nothing there to bandage!</span>")
		return
	if(!LAZYLEN(limb.wounds))
		to_chat(user, "<span class='notice'>There's no wounds that require bandaging on [user==M ? "your" : "[M]'s"] [limb.name]!</span>") // good problem to have imo
		return

	var/gauzeable_wound = FALSE
	for(var/i in limb.wounds)
		var/datum/wound/woundies = i
		if(woundies.wound_flags & ACCEPTS_GAUZE)
			gauzeable_wound = TRUE
			break
	if(!gauzeable_wound)
		to_chat(user, "<span class='notice'>There's no wounds that require bandaging on [user==M ? "your" : "[M]'s"] [limb.name]!</span>") // good problem to have imo
		return

	if(limb.current_gauze)
		to_chat(user, "<span class='warning'>[user==M ? "Your" : "[M]'s"] [limb.name] is already bandaged!</span>")

	user.visible_message("<span class='warning'>[user] begins wrapping the wounds on [M]'s [limb.name] with [src]...</span>", "<span class='warning'>You begin wrapping the wounds on [user == M ? "your" : "[M]'s"] [limb.name] with [src]...</span>")
	if(!do_after(user, (user == M ? self_delay : other_delay), target=M))
		return

	user.visible_message("<span class='green'>[user] applies [src] to [M]'s [limb.name].</span>", "<span class='green'>You bandage the wounds on [user == M ? "your" : "[M]'s"] [limb.name].</span>")
	limb.apply_gauze(src)

/obj/item/stack/medical/gauze/twelve
	amount = 12

/obj/item/stack/medical/gauze/attackby(obj/item/I, mob/user, params)
	if(I.tool_behaviour == TOOL_WIRECUTTER || I.get_sharpness())
		if(get_amount() < 2)
			to_chat(user, "<span class='warning'>You need at least two gauzes to do this!</span>")
			return
		new /obj/item/stack/sheet/cotton/cloth(user.drop_location())
		user.visible_message("<span class='notice'>[user] cuts [src] into pieces of cloth with [I].</span>", \
			"<span class='notice'>You cut [src] into pieces of cloth with [I].</span>", \
			"<span class='hear'>You hear cutting.</span>")
		use(2)
	else
		return ..()

/obj/item/stack/medical/gauze/improvised
	name = "improvised gauze"
	singular_name = "improvised gauze"
	desc = "A roll of cloth roughly cut from something that does a decent job of stabilizing wounds, but less efficiently so than real medical gauze."
	self_delay = 6 SECONDS
	other_delay = 3 SECONDS
	burn_cleanliness_bonus = 0.7
	merge_type = /obj/item/stack/medical/gauze/improvised
	gauze_type = /datum/bodypart_aid/gauze/improvised

	/*
	The idea is for the following medical devices to work like a hybrid of the old brute packs and tend wounds,
	they heal a little at a time, have reduced healing density and does not allow for rapid healing while in combat.
	However they provice graunular control of where the healing is directed, this makes them better for curing work-related cuts and scrapes.

	The interesting limb targeting mechanic is retained and i still believe they will be a viable choice, especially when healing others in the field.
	*/

/obj/item/stack/medical/suture
	name = "suture"
	desc = "Basic sterile sutures used to seal up cuts and lacerations and stop bleeding."
	gender = PLURAL
	singular_name = "suture"
	icon_state = "suture"
	self_delay = 3 SECONDS
	other_delay = 1 SECONDS
	amount = 10
	max_amount = 10
	repeating = TRUE
	heal_brute = 10
	stop_bleeding = 0.6
	grind_results = list(/datum/reagent/medicine/spaceacillin = 2)
	merge_type = /obj/item/stack/medical/suture

/obj/item/stack/medical/suture/try_heal(mob/living/target, mob/user)
	. = ..()
	if(target.stat == DEAD)
		to_chat(user, "<span class='warning'>[target] is dead! You can not help [target.p_them()].</span>")
		return
	if(iscarbon(target))
		return heal_carbon(target, user, heal_brute, 0)
	if(isanimal(target))
		var/mob/living/simple_animal/critter = target
		if (!(critter.healable))
			to_chat(user, "<span class='warning'>You cannot use \the [src] on [target]!</span>")
			return FALSE
		else if (critter.health == critter.maxHealth)
			to_chat(user, "<span class='notice'>[target] is at full health.</span>")
			return FALSE
		user.visible_message("<span class='green'>[user] applies \the [src] on [target].</span>", "<span class='green'>You apply \the [src] on [target].</span>")
		target.heal_bodypart_damage(heal_brute)
		return TRUE

	to_chat(user, "<span class='warning'>You can't heal [target] with the \the [src]!</span>")

/obj/item/stack/medical/suture/emergency
	name = "emergency suture"
	desc = "A value pack of cheap sutures, not very good at repairing damage, but still decent at stopping bleeding."
	heal_brute = 5
	amount = 5
	max_amount = 5
	merge_type = /obj/item/stack/medical/suture/emergency

/obj/item/stack/medical/suture/medicated
	name = "medicated suture"
	icon_state = "suture_purp"
	desc = "A suture infused with drugs that speed up wound healing of the treated laceration."
	heal_brute = 15
	stop_bleeding = 0.75
	grind_results = list(/datum/reagent/medicine/polypyr = 1)
	merge_type = /obj/item/stack/medical/suture/medicated

/obj/item/stack/medical/ointment
	name = "ointment"
	desc = "Basic burn ointment, rated effective for second degree burns with proper bandaging, though it's still an effective stabilizer for worse burns. Not terribly good at outright healing burns though."
	gender = PLURAL
	singular_name = "ointment"
	icon_state = "ointment"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	amount = 8
	max_amount = 8
	self_delay = 4 SECONDS
	other_delay = 2 SECONDS

	heal_burn = 5
	flesh_regeneration = 2.5
	sanitization = 0.25
	grind_results = list(/datum/reagent/medicine/c2/lenturi = 10)
	merge_type = /obj/item/stack/medical/ointment

/obj/item/stack/medical/mesh
	name = "regenerative mesh"
	desc = "A bacteriostatic mesh used to dress burns."
	gender = PLURAL
	singular_name = "mesh piece"
	icon_state = "regen_mesh"
	self_delay = 3 SECONDS
	other_delay = 1 SECONDS
	amount = 15
	heal_burn = 10
	max_amount = 15
	repeating = TRUE
	sanitization = 0.75
	flesh_regeneration = 3

	var/is_open = TRUE ///This var determines if the sterile packaging of the mesh has been opened.
	grind_results = list(/datum/reagent/medicine/spaceacillin = 2)
	merge_type = /obj/item/stack/medical/mesh

/obj/item/stack/medical/mesh/Initialize(mapload, new_amount, merge = TRUE, list/mat_override=null, mat_amt=1)
	. = ..()
	if(amount == max_amount)	 //only seal full mesh packs
		is_open = FALSE
		update_appearance()

/obj/item/stack/medical/mesh/update_icon_state()
	if(is_open)
		return ..()
	icon_state = "regen_mesh_closed"

/obj/item/stack/medical/mesh/try_heal(mob/living/target, mob/user)
	. = ..()
	if(target.stat == DEAD)
		to_chat(user, "<span class='warning'>[target] is dead! You can not help [target.p_them()].</span>")
		return
	if(iscarbon(target))
		return heal_carbon(target, user, 0, heal_burn)
	to_chat(user, "<span class='warning'>You can't heal [target] with the \the [src]!</span>")


/obj/item/stack/medical/mesh/try_heal(mob/living/target, mob/user, silent = FALSE)
	if(!is_open)
		to_chat(user, "<span class='warning'>You need to open [src] first.</span>")
		return
	return ..()

/obj/item/stack/medical/mesh/AltClick(mob/living/user)
	if(!is_open)
		to_chat(user, "<span class='warning'>You need to open [src] first.</span>")
		return
	return ..()

/obj/item/stack/medical/mesh/attack_hand(mob/user)
	if(!is_open && user.get_inactive_held_item() == src)
		to_chat(user, "<span class='warning'>You need to open [src] first.</span>")
		return
	return ..()

/obj/item/stack/medical/mesh/attack_self(mob/user)
	if(!is_open)
		is_open = TRUE
		to_chat(user, "<span class='notice'>You open the sterile mesh package.</span>")
		update_appearance()
		playsound(src, 'sound/items/poster_ripped.ogg', 20, TRUE)
		return
	return ..()

/obj/item/stack/medical/mesh/advanced
	name = "advanced regenerative mesh"
	desc = "An advanced mesh made with aloe extracts and sterilizing chemicals, used to treat burns."

	gender = PLURAL
	icon_state = "aloe_mesh"
	heal_burn = 15
	sanitization = 1.25
	flesh_regeneration = 3.5
	grind_results = list(/datum/reagent/consumable/aloejuice = 1)
	merge_type = /obj/item/stack/medical/mesh/advanced

/obj/item/stack/medical/mesh/advanced/update_icon_state()
	if(is_open)
		return ..()
	icon_state = "aloe_mesh_closed"

/obj/item/stack/medical/aloe
	name = "aloe cream"
	desc = "A healing paste for minor cuts and burns."

	gender = PLURAL
	singular_name = "aloe cream"
	icon_state = "aloe_paste"
	apply_sounds = 'sound/effects/ointment.ogg'
	self_delay = 2 SECONDS
	other_delay = 1 SECONDS
	novariants = TRUE
	amount = 20
	max_amount = 20
	repeating = TRUE
	heal_brute = 3
	heal_burn = 3
	grind_results = list(/datum/reagent/consumable/aloejuice = 1)
	merge_type = /obj/item/stack/medical/aloe

/obj/item/stack/medical/aloe/try_heal(mob/living/target, mob/user)
	. = ..()
	if(target.stat == DEAD)
		to_chat(user, "<span class='warning'>[target] is dead! You can not help [target.p_them()].</span>")
		return FALSE
	if(iscarbon(target))
		return heal_carbon(target, user, heal_brute, heal_burn)
	if(isanimal(target))
		var/mob/living/simple_animal/critter = target
		if (!(critter.healable))
			to_chat(user, "<span class='warning'>You cannot use \the [src] on [target]!</span>")
			return FALSE
		else if (critter.health == critter.maxHealth)
			to_chat(user, "<span class='notice'>[target] is at full health.</span>")
			return FALSE
		user.visible_message("<span class='green'>[user] applies \the [src] on [target].</span>", "<span class='green'>You apply \the [src] on [target].</span>")
		target.heal_bodypart_damage(heal_brute, heal_burn)
		return TRUE

	to_chat(user, "<span class='warning'>You can't heal [target] with the \the [src]!</span>")

/obj/item/stack/medical/bone_gel
	name = "bone gel"
	singular_name = "bone gel"
	desc = "A potent medical gel that, when applied to a damaged bone in a proper surgical setting, triggers an intense melding reaction to repair the wound. Can be directly applied alongside surgical sticky tape to a broken bone in dire circumstances, though this is very harmful to the patient and not recommended."

	icon = 'icons/obj/surgery.dmi'
	icon_state = "bone-gel"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	amount = 1
	self_delay = 20
	grind_results = list(/datum/reagent/calcium = 10, /datum/reagent/carbon = 10)
	novariants = TRUE
	merge_type = /obj/item/stack/medical/bone_gel

/obj/item/stack/medical/bone_gel/attack(mob/living/M, mob/user)
	to_chat(user, "<span class='warning'>Bone gel can only be used on fractured limbs!</span>")
	return

/obj/item/stack/medical/bone_gel/four
	amount = 4

/obj/item/stack/medical/bone_gel/cyborg
	custom_materials = null
	is_cyborg = 1
	cost = 250

// SPLINTS
/obj/item/stack/medical/splint
	name = "splints"
	desc = "Used to secure limbs following a fracture."
	gender = PLURAL
	singular_name = "splint"
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "splint"
	apply_sounds = list('sound/effects/rip1.ogg', 'sound/effects/rip2.ogg')
	self_delay = 5 SECONDS
	other_delay = 2 SECONDS
	max_amount = 12
	amount = 6
	grind_results = list(/datum/reagent/carbon = 2)
	merge_type = /obj/item/stack/medical/splint
	var/splint_type = /datum/bodypart_aid/splint


/obj/item/stack/medical/splint/try_heal(mob/living/M, mob/user, silent)
	var/obj/item/bodypart/limb = M.get_bodypart(check_zone(user.zone_selected))
	if(!limb)
		to_chat(user, "<span class='notice'>There's nothing there to bandage!</span>")
		return
	if(!LAZYLEN(limb.wounds))
		to_chat(user, "<span class='notice'>There's no wounds that require bandaging on [user==M ? "your" : "[M]'s"] [limb.name]!</span>") // good problem to have imo
		return

	var/splintable_wound = FALSE
	for(var/i in limb.wounds)
		var/datum/wound/woundies = i
		if(woundies.wound_flags & ACCEPTS_SPLINT)
			splintable_wound = TRUE
			break
	if(!splintable_wound)
		to_chat(user, "<span class='notice'>There's no wounds that require splinting on [user==M ? "your" : "[M]'s"] [limb.name]!</span>") // good problem to have imo
		return

	if(limb.current_splint)
		to_chat(user, "<span class='warning'>[user==M ? "Your" : "[M]'s"] [limb.name] is already fastened in a splint!</span>")
		return

	user.visible_message("<span class='warning'>[user] begins fastening [M]'s [limb.name] with [src]...</span>", "<span class='warning'>You begin to fasten [user == M ? "your" : "[M]'s"] [limb.name] with [src]...</span>")
	if(!do_after(user, (user == M ? self_delay : other_delay), target=M))
		return

	user.visible_message("<span class='green'>[user] applies [src] to [M]'s [limb.name].</span>", "<span class='green'>You splint [user == M ? "your" : "[M]'s"] [limb.name].</span>")
	limb.apply_splint(src)

/obj/item/stack/medical/splint/twelve
	amount = 12

/obj/item/stack/medical/splint/tribal
	name = "tribal splint"
	desc = "Bone fastened with sinew, used to keep injured limbs rigid, surprisingly effective."
	singular_name = "tribal splint"
	icon_state = "splint_tribal"
	amount = 1
	splint_type = /datum/bodypart_aid/splint/tribal
	merge_type = /obj/item/stack/medical/splint/tribal

/obj/item/stack/medical/splint/improvised
	name = "improvised splint"
	desc = "Crudely made out splints with wood and some cotton sling, you doubt this will be any good."
	singular_name = "improvised splint"
	icon_state = "splint_improv"
	amount = 1
	splint_type = /datum/bodypart_aid/splint/improvised
	merge_type = /obj/item/stack/medical/splint/improvised

/obj/item/stack/medical/bruise_pack/herb
	name = "ashen herbal pack"
	singular_name = "ashen herbal pack"
	icon_state = "hbrutepack"
	desc = "Thereputic herbs designed to treat bruises."
	heal_brute = 15

/obj/item/stack/medical/ointment/herb
	name = "burn ointment slurry"
	singular_name = "burn ointment slurry"
	icon_state = "hointment"
	desc = "Herb slurry meant to treat burns."
	heal_burn = 15
