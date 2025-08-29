extends Node

enum UpgradeType {
	ZOMBIE,
	SKELETON,
	GOBLIN,
	VAMPIRE,
	STONE_GOLEM,
	CRAWLER,
	UNDEAD_ARCHER,
	EXPLODER,
	VAMPIRE_KNIGHT
}

var machine_upgrades : float = 50

# Monster Upgrades
# Each upgrade should be applied from here at spawn time to the friednlies
# Upgrade : [hp, atk, upgrade_level, biscuit_cost]
# All upgrades are initially 0,0, each next upgrade bought from the shop
# will add value to these two numbers, which will then get added
# to the friendly monsters on spawn.

var zombie_upgrade = [0,0,0,2]
var skeleton_upgrade = [0,0,0,3]
var goblin_upgrade = [0,0,0,2]
var vampire_upgrade = [0,0,0,5]
var stone_golem_upgrade = [0,0,0,5]
var crawler_upgrade = [0,0,0,3]
var undead_archer_upgrade = [0,0,0,10]
var exploder_upgrade = [0,0,0,5]
var vampire_knight_upgrade = [0,0,0,15]
