#define OVERMAP_GENERATOR_SOLAR "solar_system"
#define OVERMAP_GENERATOR_RANDOM "random"

// Star spectral types. A star's visible color is based on this.
// Only loosely adherent to real spectral types, because real spectral types
// are actually just a tool for classifying stellar emission spectra and
// don't exactly correspond to different "types" of star.
#define STAR_O 0 // Very hot/bright blue giant (IRL some of these are main-sequence)
#define STAR_B 1 // Bright blue main sequence star / blue giant / white dwarf
#define STAR_A 2 // Light blue main sequence star / cool blue giant/dwarf
#define STAR_F 3 // White main sequence star
#define STAR_G 4 // Yellow main sequence star / yellow giant
#define STAR_K 5 // Orange main sequence star / hot red giant
#define STAR_M 6 // Red dwarf or red giant
#define STAR_L 7 // Cool red dwarf/giant OR very warm brown dwarf
#define STAR_T 8 // Medium brown dwarf
#define STAR_Y 9 // Very cool brown dwarf

//Amount of times the overmap generator will attempt to place something before giving up
#define MAX_OVERMAP_PLACEMENT_ATTEMPTS 5

//Possible dynamic encounter types
#define DYNAMIC_WORLD_LAVA "lava" //base planets
#define DYNAMIC_WORLD_ICE "ice"
#define DYNAMIC_WORLD_SAND "sand"
#define DYNAMIC_WORLD_JUNGLE "jungle"

#define DYNAMIC_WORLD_ROCKPLANET "rockplanet" //wacky planets
#define DYNAMIC_WORLD_BEACHPLANET "beachplanet"
#define DYNAMIC_WORLD_WASTEPLANET "wasteplanet"

#define DYNAMIC_WORLD_WATERPLANET "waterplanet" //minor planets
#define DYNAMIC_WORLD_BLOBPLANET "blobplanet"
#define DYNAMIC_WORLD_PHORON_GIANT "phorongiant"
#define DYNAMIC_WORLD_DUSTBALL "phorongiant"
#define DYNAMIC_WORLD_MOON "moon"

#define DYNAMIC_WORLD_REEBE "reebe" //celestial bodies
#define DYNAMIC_WORLD_ASTEROID "asteroid"
#define DYNAMIC_WORLD_MINOR_PLANET "minor"
#define DYNAMIC_WORLD_SPACERUIN "space"

//Possible ship states
#define OVERMAP_SHIP_IDLE "idle"
#define OVERMAP_SHIP_FLYING "flying"
#define OVERMAP_SHIP_ACTING "acting"
#define OVERMAP_SHIP_DOCKING "docking"
#define OVERMAP_SHIP_UNDOCKING "undocking"

///Used to get the turf on the "physical" overmap representation.
#define OVERMAP_TOKEN_TURF(x_pos, y_pos) locate(SSovermap.overmap_vlevel.low_x + SSovermap.overmap_vlevel.reserved_margin + x_pos - 1, SSovermap.overmap_vlevel.low_y + SSovermap.overmap_vlevel.reserved_margin + y_pos - 1, SSovermap.overmap_vlevel.z_value)
