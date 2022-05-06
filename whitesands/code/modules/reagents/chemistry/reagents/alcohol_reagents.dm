/datum/reagent/consumable/ethanol/spriters_bane
	name = "Spriter's Bane"
	description = "A drink to fill your very SOUL."
	color = "#800080"
	boozepwr = 30
	quality = DRINK_GOOD
	taste_description = "microsoft paints"
	glass_icon_state = "uglydrink"
	glass_name = "Spriter's Bane"
	glass_desc = "Tastes better than it looks."

/datum/reagent/consumable/ethanol/spriters_bane/on_mob_life(mob/living/carbon/C)
	switch(current_cycle)
		if(5 to 40)
			C.jitteriness += 3
			if(prob(10) && !C.eye_blurry)
				C.blur_eyes(6)
				to_chat(C, "<span class='warning'>That outline is so distracting, it's hard to look at anything else!</span>")
		if(40 to 100)
			C.Dizzy(10)
			if(prob(15))
				new /datum/hallucination/hudscrew(C)
		if(100 to INFINITY)
			if(prob(10) && !C.eye_blind)
				C.blind_eyes(6)
				to_chat(C, "<span class='userdanger'>Your vision fades as your eyes are outlined in black!</span>")
			else
				C.Dizzy(20)
	..()

/datum/reagent/consumable/ethanol/spriters_bane/expose_atom(atom/A, volume)
	A.AddComponent(/datum/component/outline)
	..()

/datum/reagent/consumable/ethanol/freezer_burn
	name = "Freezer Burn"
	description = "Fire and ice combine in your mouth! Drinking slowly recommended."
	boozepwr = 40
	color = "#ba3100"
	quality = DRINK_FANTASTIC
	taste_description = "fire and ice"
	glass_icon_state = "freezer_burn"
	glass_name = "Freezer Burn"
	glass_desc = "Fire and ice combine in your mouth! Drinking slowly recommended."

/datum/reagent/consumable/ethanol/freezer_burn/on_mob_life(mob/living/carbon/M)
	M.adjustFireLoss(-0.2, 0)
	..()
	return TRUE

/datum/reagent/consumable/ethanol/out_of_touch
	name = "Out of Touch"
	description = "Perfect for when you're out of time."
	boozepwr = 40
	color = "#ff9200"
	quality = DRINK_FANTASTIC
	taste_description = "dry, salty oranges"
	glass_icon_state = "out_of_touch"
	glass_name = "Out of Touch"
	glass_desc = "Perfect for when you're out of time."
	shot_glass_icon_state = "shotglassoot"

/datum/reagent/consumable/ethanol/out_of_touch/expose_obj(obj/O, reac_volume)
	if(istype(O, /obj/item/stack/sheet/metal))
		var/obj/item/stack/sheet/metal/M = O
		reac_volume = min(reac_volume, M.amount)
		new/obj/item/stack/tile/bronze(get_turf(M), reac_volume)
		M.use(reac_volume)

/datum/reagent/consumable/ethanol/darkest_chocolate
	name = "Darkest Chocolate"
	description = "Darkness within darkness awaits you, spaceman!"
	boozepwr = 40
	color = "#240c0c"
	quality = DRINK_FANTASTIC
	taste_description = "bitter, chocolatey darkness with a note of cream"
	glass_icon_state = "darkest_chocolate"
	glass_name = "Darkest Chocolate"
	glass_desc = "Darkness within darkness awaits you, spaceman!"
	var/obj/effect/light_holder

/datum/reagent/consumable/ethanol/darkest_chocolate/on_mob_metabolize(mob/living/M)
	to_chat(M, "<span class='notice'>You feel endless night enveloping you!</span>")
	light_holder = new(M)
	light_holder.set_light(3, 0.7, "#8000ff")

/datum/reagent/consumable/ethanol/darkest_chocolate/on_mob_life(mob/living/carbon/M)
	if(QDELETED(light_holder))
		M.reagents.del_reagent(/datum/reagent/consumable/ethanol/darkest_chocolate)
	else if(light_holder.loc != M)
		light_holder.forceMove(M)
	return ..()

/datum/reagent/consumable/ethanol/darkest_chocolate/on_mob_end_metabolize(mob/living/M)
	to_chat(M, "<span class='notice'>The darkness subsides.</span>")
	QDEL_NULL(light_holder)

/datum/reagent/consumable/ethanol/archmagus_brew
	name = "Archmagus' Brew"
	description = "Said to have been requested by a great Archmagus, hence the name. Tastes like tough love."
	boozepwr = 40
	color = "#c75295"
	quality = DRINK_FANTASTIC
	taste_description = "tough love"
	glass_icon_state = "archmagus_brew"
	glass_name = "Archmagus' Brew"
	glass_desc = "Said to have been requested by a great Archmagus, hence the name. Tastes like tough love."

/datum/reagent/consumable/ethanol/archmagus_brew/on_mob_life(mob/living/carbon/human/M)
	if(M.mind && M.mind.spell_list.len != 0)
		var/spell_improved = FALSE
		for(var/obj/effect/proc_holder/spell/S in M.mind.spell_list)
			if(S.clothes_req)
				S.clothes_req = 0
				spell_improved = TRUE
		if(spell_improved)
			to_chat(M, "<span class='notice'>You suddenly feel like you never needed those garish robes in the first place...</span>")
	return ..()

/datum/reagent/consumable/ethanol/out_of_lime
	name = "Out of Lime"
	description = "A spin on the classic. Artists and street fighters swear by this stuff."
	boozepwr = 40
	color = "#c75295"
	quality = DRINK_VERYGOOD
	taste_description = "alternate palettes, copycats, and fierce plus short."
	glass_icon_state = "out_of_lime"
	glass_name = "Out of Lime"
	glass_desc = "A spin on the classic. Artists and street fighters swear by this stuff."

/datum/reagent/consumable/ethanol/out_of_lime/expose_mob(mob/living/carbon/human/consumer, method=INGEST, reac_volume)
	if(method == INGEST || method == TOUCH)
		if(istype(consumer))
			consumer.hair_color = pick("0ad","a0f","f73","d14","0b5","fc2","084","05e","d22","fa0")
			consumer.facial_hair_color = pick("0ad","a0f","f73","d14","0b5","fc2","084","05e","d22","fa0")
			consumer.update_hair()

/datum/reagent/consumable/ethanol/cogchamp
	name = "CogChamp"
	description = "Now you can fill yourself with the power of Ratvar!"
	color = rgb(255, 201, 49)
	boozepwr = 10
	quality = DRINK_FANTASTIC
	taste_description = "a brass taste with a hint of oil"
	glass_icon_state = "cogchamp"
	glass_name = "CogChamp"
	glass_desc = "Not one of Ratvar's Four Generals could withstand this!  Qevax Jryy!"

/datum/reagent/consumable/ethanol/cogchamp/on_mob_life(mob/living/carbon/M)
	M.clockcultslurring = min(M.clockcultslurring + 3, 3)
	M.stuttering = min(M.stuttering + 3, 3)
	..()
