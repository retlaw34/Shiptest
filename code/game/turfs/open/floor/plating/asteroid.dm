
/**********************Asteroid**************************/

/turf/open/floor/plating/asteroid //floor piece
	gender = PLURAL
	name = "asteroid sand"
	baseturfs = /turf/open/floor/plating/asteroid
	icon = 'icons/turf/floors.dmi'
	icon_state = "asteroid"
	icon_plating = "asteroid"
	postdig_icon_change = TRUE
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	/// the icon name to be used: for example, asteroid1 - asteroid12 in the icon file
	var/environment_type = "asteroid"
	/// Base turf type to be created by the tunnel
	var/turf_type = /turf/open/floor/plating/asteroid
	/// Probability floor has a different icon state
	var/floor_variance = 20
	attachment_holes = FALSE
	/// Itemstack to drop when dug by a shovel
	var/obj/item/stack/digResult = /obj/item/stack/ore/glass/basalt
	/// Whether the turf has been dug or not
	var/dug

/turf/open/floor/plating/asteroid/Initialize(mapload, inherited_virtual_z)
	var/proper_name = name
	. = ..()
	name = proper_name
	if(prob(floor_variance))
		icon_state = "[environment_type][rand(0,12)]"

/// Drops itemstack when dug and changes icon
/turf/open/floor/plating/asteroid/proc/getDug()
	new digResult(src, 5)
	if(postdig_icon_change)
		if(!postdig_icon)
			icon_plating = "[environment_type]_dug"
			icon_state = "[environment_type]_dug"
	dug = TRUE

/// If the user can dig the turf
/turf/open/floor/plating/asteroid/proc/can_dig(mob/user)
	if(!dug)
		return TRUE
	if(user)
		to_chat(user, "<span class='warning'>Looks like someone has dug here already!</span>")

/turf/open/floor/plating/asteroid/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	return

/turf/open/floor/plating/asteroid/burn_tile()
	return

/turf/open/floor/plating/asteroid/MakeSlippery(wet_setting, min_wet_time, wet_time_to_add, max_wet_time, permanent)
	return

/turf/open/floor/plating/asteroid/MakeDry()
	return

/turf/open/floor/plating/asteroid/crush()
	return

/turf/open/floor/plating/asteroid/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(!.)
		if(W.tool_behaviour == TOOL_SHOVEL || W.tool_behaviour == TOOL_MINING)
			if(!can_dig(user))
				return TRUE

			if(!isturf(user.loc))
				return

			to_chat(user, "<span class='notice'>You start digging...</span>")

			if(W.use_tool(src, user, 40, volume=50))
				if(!can_dig(user))
					return TRUE
				to_chat(user, "<span class='notice'>You dig a hole.</span>")
				getDug()
				SSblackbox.record_feedback("tally", "pick_used_mining", 1, W.type)
				return TRUE
		else if(istype(W, /obj/item/storage/bag/ore))
			for(var/obj/item/stack/ore/O in src)
				SEND_SIGNAL(W, COMSIG_PARENT_ATTACKBY, O)

/turf/open/floor/plating/asteroid/ex_act(severity, target)
	. = SEND_SIGNAL(src, COMSIG_ATOM_EX_ACT, severity, target)
	contents_explosion(severity, target)

/turf/open/floor/plating/lavaland_baseturf
	baseturfs = /turf/open/floor/plating/asteroid/basalt/lava_land_surface

/turf/open/floor/plating/asteroid/basalt
	name = "volcanic floor"
	baseturfs = /turf/open/floor/plating/asteroid/basalt
	icon = 'icons/turf/floors.dmi'
	icon_state = "basalt"
	icon_plating = "basalt"
	environment_type = "basalt"
	floor_variance = 15
	digResult = /obj/item/stack/ore/glass/basalt

/turf/open/floor/plating/asteroid/basalt/lava //lava underneath
	baseturfs = /turf/open/lava/smooth

/turf/open/floor/plating/asteroid/basalt/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/plating/asteroid/basalt/Initialize(mapload, inherited_virtual_z)
	. = ..()
	set_basalt_light(src)

/turf/open/floor/plating/asteroid/getDug()
	set_light(0)
	return ..()

/proc/set_basalt_light(turf/open/floor/B)
	switch(B.icon_state)
		if("basalt1", "basalt2", "basalt3")
			B.set_light(2, 0.6, LIGHT_COLOR_LAVA) //more light
		if("basalt5", "basalt9")
			B.set_light(1.4, 0.6, LIGHT_COLOR_LAVA) //barely anything!

///////Surface. The surface is warm, but survivable without a suit. Internals are required. The floors break to chasms, which drop you into the underground.

/turf/open/floor/plating/asteroid/basalt/lava_land_surface
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	planetary_atmos = TRUE
	baseturfs = /turf/open/lava/smooth/lava_land_surface

/turf/open/floor/plating/asteroid/basalt/lava_land_surface/icecropolis
	initial_gas_mix = ICEMOON_DEFAULT_ATMOS
	baseturfs = /turf/open/indestructible/necropolis/icecropolis

/turf/open/floor/plating/asteroid/basalt/lava_land_surface/icecropolis/inside
	initial_gas_mix = "o2=22;n2=82;TEMP=293.15"
	planetary_atmos = FALSE
	baseturfs = /turf/open/indestructible/necropolis/air

/turf/open/floor/plating/asteroid/lowpressure
	initial_gas_mix = OPENTURF_LOW_PRESSURE
	baseturfs = /turf/open/floor/plating/asteroid/lowpressure
	turf_type = /turf/open/floor/plating/asteroid/lowpressure

/turf/open/floor/plating/asteroid/airless
	initial_gas_mix = AIRLESS_ATMOS
	baseturfs = /turf/open/floor/plating/asteroid/airless
	turf_type = /turf/open/floor/plating/asteroid/airless

/turf/open/floor/plating/asteroid/snow
	gender = PLURAL
	name = "snow"
	desc = "Looks cold."
	icon = 'icons/turf/snow.dmi'
	baseturfs = /turf/open/floor/plating/asteroid/icerock
	icon_state = "snow"
	icon_plating = "snow"
	initial_gas_mix = FROZEN_ATMOS
	slowdown = 2.5
	environment_type = "snow"
	flags_1 = NONE
	planetary_atmos = TRUE
	footstep = FOOTSTEP_SNOW
	barefootstep = FOOTSTEP_SNOW
	clawfootstep = FOOTSTEP_SNOW
	broken_states = list("snow")
	burnt_states = list("snow")
	bullet_sizzle = TRUE
	bullet_bounce_sound = null
	digResult = /obj/item/stack/sheet/mineral/snow
	// footprint vars
	var/entered_dirs
	var/exited_dirs

/turf/open/floor/plating/asteroid/snow/Entered(atom/movable/AM)
	. = ..()
	if(!iscarbon(AM) || (AM.movement_type & (FLYING|VENTCRAWLING|FLOATING|PHASING)))
		return
	if(!(entered_dirs & AM.dir))
		entered_dirs |= AM.dir
		update_icon()

/turf/open/floor/plating/asteroid/snow/Exited(atom/movable/AM)
	. = ..()
	if(!iscarbon(AM) || (AM.movement_type & (FLYING|VENTCRAWLING|FLOATING|PHASING)))
		return
	if(!(exited_dirs & AM.dir))
		exited_dirs |= AM.dir
		update_icon()

// adapted version of footprints' update_icon code
/turf/open/floor/plating/asteroid/snow/update_overlays()
	. = ..()
	for(var/Ddir in GLOB.cardinals)
		if(entered_dirs & Ddir)
			var/image/print = GLOB.bloody_footprints_cache["entered-conc-[Ddir]"]
			if(!print)
				print = image('icons/effects/footprints.dmi', "ice1", layer = TURF_DECAL_LAYER, dir = Ddir)
				GLOB.bloody_footprints_cache["entered-conc-[Ddir]"] = print
			. += print
		if(exited_dirs & Ddir)
			var/image/print = GLOB.bloody_footprints_cache["exited-conc-[Ddir]"]
			if(!print)
				print = image('icons/effects/footprints.dmi', "ice2", layer = TURF_DECAL_LAYER, dir = Ddir)
				GLOB.bloody_footprints_cache["exited-conc-[Ddir]"] = print
			. += print

// pretty much ripped wholesale from footprints' version of this proc
/turf/open/floor/plating/asteroid/snow/setDir(newdir)
	if(dir == newdir)
		return ..()

	var/ang_change = dir2angle(newdir) - dir2angle(dir)
	var/old_entered_dirs = entered_dirs
	var/old_exited_dirs = exited_dirs
	entered_dirs = 0
	exited_dirs = 0

	for(var/Ddir in GLOB.cardinals)
		var/NDir = angle2dir_cardinal(dir2angle(Ddir) + ang_change)
		if(old_entered_dirs & Ddir)
			entered_dirs |= NDir
		if(old_exited_dirs & Ddir)
			exited_dirs |= NDir

	update_icon()
	return ..()

/turf/open/floor/plating/asteroid/snow/getDug()
	. = ..()
	ScrapeAway()

/turf/open/floor/plating/asteroid/snow/burn_tile()
	ScrapeAway()
	return TRUE

/turf/open/floor/plating/asteroid/snow/lit
	light_range = 2
	light_power = 1

/turf/open/floor/plating/asteroid/icerock
	gender = PLURAL
	name = "icy rock"
	desc = "The coarse rock that covers the surface."
	icon = 'icons/turf/snow.dmi'
	baseturfs = /turf/open/floor/plating/asteroid/icerock
	icon_state = "icemoon_ground_coarse1"
	icon_plating = "icemoon_ground_coarse1"
	initial_gas_mix = FROZEN_ATMOS
	environment_type = "icemoon_ground_coarse"
	flags_1 = NONE
	footstep = FOOTSTEP_ICE
	barefootstep = FOOTSTEP_ICE
	clawfootstep = FOOTSTEP_ICE
	planetary_atmos = TRUE
	broken_states = list("icemoon_ground_cracked")
	burnt_states = list("icemoon_ground_smooth")
	bullet_sizzle = TRUE
	bullet_bounce_sound = null
	digResult = /obj/item/stack/sheet/mineral/snow
	floor_variance = 100
	dug = TRUE

/turf/open/floor/plating/asteroid/icerock/lit
	light_range = 2
	light_power = 1

/turf/open/floor/plating/asteroid/icerock/Initialize(mapload, inherited_virtual_z)
	. = ..()
	if(prob(floor_variance))
		icon_state = "[environment_type][rand(1,8)]"
	else
		icon_state = initial(icon_state) //ughhhhhhhhhhhhhhhhhhh

/turf/open/floor/plating/asteroid/icerock/cracked
	floor_variance = 0
	icon_state = "icemoon_ground_cracked"
	environment_type = "icemoon_ground_cracked"

/turf/open/floor/plating/asteroid/icerock/smooth
	floor_variance = 0
	icon_state = "icemoon_ground_smooth"
	environment_type = "icemoon_ground_smooth"

/turf/open/floor/plating/asteroid/iceberg
	gender = PLURAL
	name = "cracked ice floor"
	desc = "A sheet of solid ice. It seems like it is so cracked, it can no longer slip."
	icon = 'icons/turf/snow.dmi'
	baseturfs = /turf/open/floor/plating/asteroid/iceberg
	icon_state = "iceberg"
	icon_plating = "iceberg"
	initial_gas_mix = FROZEN_ATMOS
	environment_type = "iceberg"
	flags_1 = NONE
	footstep = FOOTSTEP_ICE
	barefootstep = FOOTSTEP_ICE
	clawfootstep = FOOTSTEP_ICE
	planetary_atmos = TRUE
	broken_states = list("iceberg")
	burnt_states = list("iceberg")
	bullet_sizzle = TRUE
	bullet_bounce_sound = null
	digResult = /obj/item/stack/sheet/mineral/snow
	floor_variance = 100
	dug = TRUE

/turf/open/floor/plating/asteroid/iceberg/Initialize(mapload, inherited_virtual_z)
	. = ..()
	if(prob(floor_variance))
		icon_state = "[environment_type][rand(1,8)]"

/turf/open/floor/plating/asteroid/iceberg/lit
	light_range = 2
	light_power = 1


/turf/open/floor/plating/asteroid/snow/icemoon
	baseturfs = /turf/open/openspace/icemoon
	initial_gas_mix = ICEMOON_DEFAULT_ATMOS
	slowdown = 0

/turf/open/lava/plasma/ice_moon
	initial_gas_mix = ICEMOON_DEFAULT_ATMOS
	baseturfs = /turf/open/lava/plasma/ice_moon
	planetary_atmos = TRUE

/turf/open/floor/plating/asteroid/snow/ice
	name = "icy snow"
	desc = "Looks colder."
	baseturfs = /turf/open/floor/plating/asteroid/snow/ice
	initial_gas_mix = "o2=0;n2=82;plasma=24;TEMP=120"
	floor_variance = 0
	icon_state = "snow-ice"
	icon_plating = "snow-ice"
	environment_type = "snow_cavern"
	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/plating/asteroid/snow/ice/icemoon
	baseturfs = /turf/open/floor/plating/asteroid/snow/ice/icemoon
	initial_gas_mix = ICEMOON_DEFAULT_ATMOS
	planetary_atmos = TRUE
	slowdown = 0

/turf/open/floor/plating/asteroid/snow/ice/burn_tile()
	return FALSE

/turf/open/floor/plating/asteroid/snow/airless
	initial_gas_mix = AIRLESS_ATMOS

/turf/open/floor/plating/asteroid/snow/temperatre
	initial_gas_mix = "o2=22;n2=82;TEMP=255.37"

/turf/open/floor/plating/asteroid/snow/atmosphere
	initial_gas_mix = FROZEN_ATMOS
	planetary_atmos = FALSE

/turf/open/floor/plating/asteroid/snow/under
	icon_state = "snow_dug"
	planetary_atmos = TRUE

/turf/open/floor/plating/asteroid/snow/under/lit
	light_range = 2
	light_power = 1

/turf/open/floor/plating/asteroid/basalt/lava_land_surface/lit
	light_power = 0.55
	light_range = 2

/turf/open/floor/plating/asteroid/basalt/purple
	icon = 'icons/turf/lavaland_purple.dmi'
	baseturfs = /turf/open/floor/plating/asteroid/basalt/purple
	turf_type = /turf/open/floor/plating/asteroid/basalt/purple
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	planetary_atmos = TRUE

/turf/open/floor/plating/asteroid/basalt/purple/lit
	light_power = 1
	light_range = 2

/turf/open/floor/plating/asteroid/purple
	name = "ashen sand"
	desc = "Sand, tinted by the chemicals in the atmosphere to an uncanny shade of purple."
	icon = 'icons/turf/lavaland_purple.dmi'
	baseturfs = /turf/open/floor/plating/asteroid/purple
	turf_type = /turf/open/floor/plating/asteroid/basalt/purple
	initial_gas_mix = LAVALAND_DEFAULT_ATMOS
	planetary_atmos = TRUE

/turf/open/floor/plating/asteroid/purple/lit
	light_power = 1
	light_range = 2

/turf/open/floor/plating/asteroid/sand
	name = "sand"
	icon = 'icons/misc/beach.dmi'
	icon_state = "sand"
	base_icon_state = "sand"
	environment_type = "sand"
	baseturfs = /turf/open/floor/plating/asteroid/sand
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS //custom atmos? lots of oxygen, hot?
	digResult = /obj/item/stack/ore/glass
	planetary_atmos = TRUE

/turf/open/floor/plating/asteroid/sand/Initialize(mapload, inherited_virtual_z)
	. = ..()
	icon_state = "[base_icon_state]"

/turf/open/floor/plating/asteroid/sand/lit
	light_range = 2
	light_power = 0.80
	light_color = LIGHT_COLOR_TUNGSTEN

/turf/open/floor/plating/asteroid/sand/dense
	icon_state = "light_sand"
	planetary_atmos = TRUE
	base_icon_state = "light_sand"

/turf/open/floor/plating/asteroid/sand/dense/lit
	light_range = 2
	light_power = 0.80
	light_color = LIGHT_COLOR_TUNGSTEN
