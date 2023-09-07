/obj/item/forging/forged_weapon
	icon = 'icons/obj/forge_items.dmi'
	lefthand_file = 'icons/mob/forge_weapon_l.dmi'
	righthand_file = 'icons/mob/forge_weapon_r.dmi'

/obj/item/forging/forged_weapon/Initialize()
	. = ..()
	AddComponent(/datum/component/reagent_weapon)

/obj/item/forging/forged_weapon/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Using a hammer on [src] will repair its damage!</span>"

/obj/item/forging/forged_weapon/attackby(obj/item/attacking_item, mob/user, params)
	if(obj_integrity >= max_integrity)
		return ..()
	if(istype(attacking_item, /obj/item/forging/hammer))
		var/obj/item/forging/hammer/attacking_hammer = attacking_item
		var/skill_modifier = user.mind.get_skill_modifier(/datum/skill/smithing, SKILL_SPEED_MODIFIER) * attacking_hammer.work_time
		while(obj_integrity < max_integrity)
			if(!do_after(user, skill_modifier, src))
				return
			var/fixing_amount = min(max_integrity - obj_integrity, 5)
			obj_integrity += fixing_amount
			user.mind.adjust_experience(/datum/skill/smithing, 5) //useful heating means you get some experience
		return
	return ..()

/obj/item/forging/forged_weapon/sword
	name = "forged sword"
	desc = "A sword that can be imbued with a reagent. Useful for blocking."
	force = 15
	armour_penetration = 10
	icon_state = "sword"
	item_state = "sword"
	hitsound = 'sound/weapons/bladeslice.ogg'
	throwforce = 10
	block_chance = 25 //either we make it melee block only or we don't give it too much. It's bulkly so the buckler is superior
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = FIRE_PROOF
	sharpness = IS_SHARP
	max_integrity = 150

/obj/item/forging/forged_weapon/katana
	name = "forged katana"
	desc = "A katana that can be imbued with a reagent. It's very sharp, but not quite million-times-folded sharp."
	force = 15
	armour_penetration = 25 //Slices through armour like butter, but can't quite bisect a knight like the real thing.
	icon_state = "katana"
	item_state = "katana"
	hitsound = 'sound/weapons/bladeslice.ogg'
	throwforce = 10
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = FIRE_PROOF
	sharpness = IS_SHARP

/obj/item/forging/forged_weapon/dagger
	name = "forged dagger"
	desc = "A dagger that can be imbued with a reagent. It can attack very fast!"
	force = 8
	icon_state = "dagger"
	item_state = "dagger"
	hitsound = 'sound/weapons/bladeslice.ogg'
	throwforce = 10
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FIRE_PROOF
	sharpness = IS_SHARP

/obj/item/forging/forged_weapon/dagger/attack(mob/living/M, mob/living/user, params)
	. = ..()
	user.changeNext_move(CLICK_CD_RANGE)

/obj/item/forging/forged_weapon/staff //doesn't do damage. Useful for healing reagents.
	name = "forged staff"
	desc = "A staff that can be imbued with a reagent. It has a very soft swing."
	force = 0
	icon_state = "staff"
	item_state = "staff"
	throwforce = 0
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = FIRE_PROOF

/obj/item/forging/forged_weapon/staff/attack(mob/living/M, mob/living/user, params)
	. = ..()
	user.changeNext_move(CLICK_CD_RANGE)

/obj/item/forging/forged_weapon/spear
	name = "forged spear"
	desc = "A spear that can be imbued with a reagent. It can be dual-wielded to increase its damage!"
	force = 10
	armour_penetration = 10
	icon_state = "spear"
	item_state = "spear"
	throwforce = 15 //not a javelin, throwing specialty is for the axe.
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = FIRE_PROOF
	hitsound = 'sound/weapons/bladeslice.ogg'
	reach = 2
	sharpness = IS_SHARP

/obj/item/forging/forged_weapon/spear/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, force_unwielded=10, force_wielded=17) //better than the bone spear

/obj/item/forging/forged_weapon/axe
	name = "forged axe"
	desc = "An axe that can be imbued with a reagent. Looks balanced for throwing."
	force = 15
	armour_penetration = 10
	icon_state = "axe"
	item_state = "axe"
	throwforce = 22 //ouch
	throw_speed = 4
	embedding = list("impact_pain_mult" = 2, "remove_pain_mult" = 4, "jostle_chance" = 2.5)
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = FIRE_PROOF
	sharpness = IS_SHARP

/obj/item/forging/forged_weapon/hammer
	name = "forged hammer"
	desc = "A hammer that can be imbued with a reagent. It packs a real wallop."
	force = 19 //strong but boring.
	armour_penetration = 10
	icon_state = "crush_hammer"
	item_state = "crush_hammer"
	throwforce = 10
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	resistance_flags = FIRE_PROOF

/obj/item/shield/riot/buckler/forged_weapon //Same as a buckler, but metal.
	name = "forged plated buckler shield"
	desc = "A small, round shield best used in tandem with a melee weapon in close-quarters combat; can be imbued with a reagent."
	icon = 'icons/obj/forge_items.dmi'
	icon_state = "buckler"
	item_state = "buckler"
	lefthand_file = 'icons/mob/forge_weapon_l.dmi'
	righthand_file = 'icons/mob/forge_weapon_r.dmi'
	custom_materials = list(/datum/material/iron=1000)
	resistance_flags = FIRE_PROOF
	block_chance = 30
	transparent = FALSE
	max_integrity = 150 //over double that of a wooden one
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/shield/riot/buckler/forged_weapon/Initialize()
	. = ..()
	AddComponent(/datum/component/reagent_weapon)

/obj/item/shield/riot/buckler/forged_weapon/shatter(mob/living/carbon/human/owner)
	playsound(owner, 'sound/effects/bang.ogg', 50)
	new /obj/item/forging/complete/plate(get_turf(src))

/obj/item/shield/riot/buckler/forged_weapon/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Using a hammer on [src] will repair its damage!</span>"

/obj/item/shield/riot/buckler/forged_weapon/attackby(obj/item/attacking_item, mob/user, params)
	if(obj_integrity >= max_integrity)
		return ..()
	if(!istype(attacking_item, /obj/item/forging/hammer))
		return ..()
	var/obj/item/forging/hammer/attacking_hammer = attacking_item
	var/skill_modifier = user.mind.get_skill_modifier(/datum/skill/smithing, SKILL_SPEED_MODIFIER) * attacking_hammer.work_time
	while(obj_integrity < max_integrity)
		if(!do_after(user, skill_modifier, src))
			return
		var/fixing_amount = min(max_integrity - obj_integrity, 5)
		obj_integrity += fixing_amount
		user.mind.adjust_experience(/datum/skill/smithing, 5) //useful heating means you get some experience
		to_chat(user, "<span class='notice'>Partially repaired!</span>") //ReplaceWithBalloonAlertLater
	return

/obj/item/shield/riot/buckler/forged_weapon/pavise //similar to the adamantine shield. Huge, slow, lets you soak damage and packs a wallop.
	name = "forged plated pavise shield"
	desc = "An oblong shield used by ancient crossbowman as cover while reloading; can be imbued with a reagent."
	icon_state = "pavise"
	item_state = "pavise"
	block_chance = 75
	item_flags = SLOWS_WHILE_IN_HAND
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = ITEM_SLOT_BACK
	max_integrity = 300 //tanky

/obj/item/shield/riot/buckler/forged_weapon/pavise/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/two_handed, require_twohands=TRUE, force_wielded=15)

/obj/item/pickaxe/forged_weapon
	name = "forged pickaxe"
	toolspeed = 0.45 //Just a tiny bit better than a regular one

/obj/item/pickaxe/forged_weapon/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/reagent_weapon)

/obj/item/shovel/forged_weapon
	name = "forged shovel"

/obj/item/shovel/forged_weapon/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/reagent_weapon)
