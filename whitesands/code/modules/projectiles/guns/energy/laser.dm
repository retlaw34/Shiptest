/obj/item/gun/energy/laser/terra
	name = "TerraGov laser rifle"
	desc = "A old laser rifle that was used by SolGov. Has a self-recharging cell but only 6 shots before needing to recharge. This should be in a musuem instead."
	icon_state = "terralaser"
	item_state = "laser"
	w_class = WEIGHT_CLASS_NORMAL
	flags_1 =  CONDUCT_1
	selfcharge = 1
	cell_type = /obj/item/stock_parts/cell/gun/mini
	internal_cell = TRUE
	charge_delay = 1 //50 seconds to recharge the clip

/obj/item/gun/energy/laser/iot
	name = "\improper E-SG 255 Ultimate"
	desc = "An energy shotgun with an integrated computer system for surveillance and statistics tracking."
	lefthand_file = 'icons/mob/inhands/weapons/64x_guns_left.dmi'
	righthand_file = 'icons/mob/inhands/weapons/64x_guns_right.dmi'
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	icon_state = "iotshotgun"
	item_state = "shotgun_combat"
	w_class = WEIGHT_CLASS_BULKY
	ammo_type = list(/obj/item/ammo_casing/energy/disabler/scatter/ultima)
	var/obj/item/modular_computer/integratedNTOS
	var/NTOS_type = /obj/item/modular_computer/internal

/obj/item/gun/energy/laser/iot/lethal
	desc = "An energy shotgun with an integrated computer system for surveillance and statistics tracking. This one appears to be modified to fire lethal beams."
	icon_state = "iotshotgun_lethal"
	ammo_type = list(/obj/item/ammo_casing/energy/laser/ultima)

/obj/item/gun/energy/laser/hitscanpistol
	name = "experimental laser gun"
	desc = "A highly experimental laser gun, with unknown inner workings. It has no markings besides a \"GROUP A\" inscription on the barrel."
	icon_state = "hitscangun"
	item_state = "gun"
	ammo_x_offset = 2
	charge_sections = 4
	small_gun = TRUE
	w_class = WEIGHT_CLASS_NORMAL
	cell_type = /obj/item/stock_parts/cell/gun/mini
	ammo_type = list(/obj/item/ammo_casing/energy/lasergun/hitscan)

/obj/item/gun/energy/laser/hitscanpistol/examine_more(mob/user)
	if(in_range(src, user) || isobserver(user))
		. = list("<span class='notice'>You examine [src] closer. Under the grip is a small inscription: \"NT CN SVALINN 2502\".</span>")
	else
		. = list("<span class='warning'>You try to examine [src] closer, but you're too far away.</span>")
