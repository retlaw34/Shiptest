/datum/export/large/gas_canister
	cost = 10 //Base cost of canister. You get more for nice gases inside.
	unit_name = "Gas Canister"
	export_types = list(/obj/machinery/portable_atmospherics/canister)
/datum/export/large/gas_canister/get_cost(obj/O)
	var/obj/machinery/portable_atmospherics/canister/C = O
	var/worth = 10

	worth += C.air_contents.get_moles(GAS_BZ)*2
	worth += C.air_contents.get_moles(GAS_STIMULUM)*100
	worth += C.air_contents.get_moles(GAS_HYPERNOB)*1000
	worth += C.air_contents.get_moles(GAS_MIASMA)*4
	worth += C.air_contents.get_moles(GAS_TRITIUM)*4
	worth += C.air_contents.get_moles(GAS_PLUOXIUM)*5
	return worth
