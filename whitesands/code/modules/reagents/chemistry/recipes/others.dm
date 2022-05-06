/datum/chemical_reaction/cellulose_carbonization/ash		// Sub for cellulose
	required_reagents = list(/datum/reagent/ash_fibers)

/datum/chemical_reaction/fervor
	results = list(/datum/reagent/consumable/fervor = 10)
	required_reagents = list(/datum/reagent/consumable/vitfro = 5, /datum/reagent/consumable/tinlux = 5, /datum/reagent/consumable/pyre_elementum = 1)

/datum/chemical_reaction/herbal_brute
	required_reagents = list(/datum/reagent/ash_fibers = 10, /datum/reagent/consumable/vitfro = 10, /datum/reagent/consumable/ethanol = 10, /datum/reagent/stabilizing_agent = 5)

/datum/chemical_reaction/herbal_brute/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/stack/medical/bruise_pack/herb(location)

/datum/chemical_reaction/herbal_burn
	required_reagents = list(/datum/reagent/calcium = 10, /datum/reagent/consumable/pyre_elementum = 10, /datum/reagent/silver = 10, /datum/reagent/toxin/plasma = 5)

/datum/chemical_reaction/herbal_burn/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/stack/medical/ointment/herb(location)

/datum/chemical_reaction/titaniumsolidification
	required_reagents = list(/datum/reagent/consumable/frostoil = 5, /datum/reagent/titanium = 20, /datum/reagent/iron = 1)
	mob_react = FALSE

/datum/chemical_reaction/titaniumsolidification/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i = 1, i <= created_volume, i++)
		new /obj/item/stack/sheet/mineral/titanium(location)

/datum/chemical_reaction/mutationtoxin/kobold
	results = list(/datum/reagent/mutationtoxin/kobold = 1)
	required_reagents  = list(/datum/reagent/aslimetoxin = 1, /datum/reagent/mutationtoxin/ash = 1, /datum/reagent/consumable/tinlux = 5)
