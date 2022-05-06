
/datum/design/floor_painter
	name = "Floor Painter"
	id = "floor_painter"
	build_type = AUTOLATHE | PROTOLATHE
	materials = list(/datum/material/iron = 300, /datum/material/glass = 100)
	build_path = /obj/item/floor_painter
	category = list("initial","Tools","Tool Designs")
	departmental_flags = DEPARTMENTAL_FLAG_ENGINEERING | DEPARTMENTAL_FLAG_SERVICE

/datum/design/zip_ammo_9mm
	name = "Budget Pistol 9mm Magazine"
	id = "ZipAmmo9mm"
	build_type = AUTOLATHE
	materials = list(/datum/material/iron = 20000)
	build_path = /obj/item/ammo_box/magazine/zip_ammo_9mm
	category = list("hacked", "Security")

/datum/design/pipedispenser
	name = "Pipe Dispenser (Machine Board)"
	id = "pipedispenser"
	build_type = AUTOLATHE
	materials = list(/datum/material/glass = 500)
	build_path = /obj/item/circuitboard/machine/pipedispenser
	category = list("initial", "Machinery")
