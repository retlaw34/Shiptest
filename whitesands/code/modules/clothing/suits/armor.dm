/obj/item/clothing/suit/armor/vest/lieutenant
	name = "lieutenant's armor"
	desc = "An armored vest with the lieutenant's insignia imprinted on it."
	icon_state = "blueshield"
	item_state = "blueshield"

/obj/item/clothing/suit/armor/vest/solgov
	name = "\improper SolGov armor vest"
	desc = "A standard armor vest fielded for SolGov's infantry."
	icon_state = "armor_solgov"
	item_state = "armor_solgov"

/obj/item/clothing/suit/armor/vest/solgov/Initialize()
	. = ..()
	allowed |= list(/obj/item/gun/energy/laser/terra, /obj/item/gun/energy/pulse/terra, /obj/item/tank)

/obj/item/clothing/suit/armor/vest/solgov/rep
	name = "\improper SolGov Inspector armor vest"
	desc = "A type I armor vest emblazoned with the SolGov logo."
	icon_state = "armor_alt_solgov"
	item_state = "armor_alt_solgov"

/obj/item/clothing/suit/armor/vest/hop
	name = "head of personnel's parade jacket"
	desc = "For when an armoured vest isn't fashionable enough."
	icon_state = "hopformal"
	item_state = "capspacesuit"

/obj/item/clothing/suit/armor/vest/syndie
	name = "\improper Syndicate plate carrier"
	desc = "A plate carrier vest commonly used by Syndicate forces, regardless of affiliation. Has a few attached pouches."
	icon_state = "syndiearmor"
	item_state = "syndiearmor"

/obj/item/clothing/suit/armor/vest/scrap_armor
	name = "\improper Scrap Armor"
	desc = "Who thought this is a good idea for armor?"
	icon_state = "scraparmor"
	item_state = "scraparmor"
	armor = list(melee = 5)
