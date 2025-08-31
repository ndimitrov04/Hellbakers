extends TextureButton

@onready var shop = $"../../../../../.."

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("pressed", _on_pressed)
	update_tooltip()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_pressed():
	var upgrade_type : Upgrades.UpgradeType = get_meta("type")
	match upgrade_type:
		# +5 HP + 0 ATK on LvUP
		Upgrades.UpgradeType.ZOMBIE:
			print("click!")
			if ShopData.biscuits >= Upgrades.zombie_upgrade[3] and Upgrades.zombie_upgrade[2] < 3:
				Upgrades.zombie_upgrade[0] += 5
				Upgrades.zombie_upgrade[1] += 3
				Upgrades.zombie_upgrade[2] += 1
				ShopData.biscuits -= Upgrades.zombie_upgrade[3]
				Upgrades.zombie_upgrade[3] *= 2
		# +3 HP + 3 ATK on LvUP
		Upgrades.UpgradeType.SKELETON:
			if ShopData.biscuits >= Upgrades.skeleton_upgrade[3] and Upgrades.skeleton_upgrade[2] < 3:
				Upgrades.skeleton_upgrade[0] += 6
				Upgrades.skeleton_upgrade[1] += 6
				Upgrades.skeleton_upgrade[2] += 1
				ShopData.biscuits -= Upgrades.skeleton_upgrade[3]
				Upgrades.skeleton_upgrade[3] *= 2
		# +0 HP + 3 ATK on LvUP
		Upgrades.UpgradeType.GOBLIN:
			if ShopData.biscuits >= Upgrades.goblin_upgrade[3] and Upgrades.goblin_upgrade[2] < 3:
				Upgrades.goblin_upgrade[0] += 2
				Upgrades.goblin_upgrade[1] += 6
				Upgrades.goblin_upgrade[2] += 1
				ShopData.biscuits -= Upgrades.goblin_upgrade[3]
				Upgrades.goblin_upgrade[3] *= 2
		# +15 HP + 0 ATK on LvUP
		Upgrades.UpgradeType.STONE_GOLEM:
			if ShopData.biscuits >= Upgrades.stone_golem_upgrade[3] and Upgrades.stone_golem_upgrade[2] < 3:
				Upgrades.stone_golem_upgrade[0] += 15
				Upgrades.stone_golem_upgrade[1] += 5
				Upgrades.stone_golem_upgrade[2] += 1
				ShopData.biscuits -= Upgrades.stone_golem_upgrade[3]
				Upgrades.stone_golem_upgrade[3] *= 2
		# +2 HP + 2 ATK on LvUP
		Upgrades.UpgradeType.VAMPIRE:
			if ShopData.biscuits >= Upgrades.vampire_upgrade[3] and Upgrades.vampire_upgrade[2] < 3:
				Upgrades.vampire_upgrade[0] += 10
				Upgrades.vampire_upgrade[1] += 2
				Upgrades.vampire_upgrade[2] += 1
				ShopData.biscuits -= Upgrades.vampire_upgrade[3]
				Upgrades.vampire_upgrade[3] *= 2
		# +5 HP + 2 ATK on LvUP
		Upgrades.UpgradeType.CRAWLER:
			if ShopData.biscuits >= Upgrades.crawler_upgrade[3] and Upgrades.crawler_upgrade[2] < 3:
				Upgrades.crawler_upgrade[0] += 5
				Upgrades.crawler_upgrade[1] += 5
				Upgrades.crawler_upgrade[2] += 1
				ShopData.biscuits -= Upgrades.crawler_upgrade[3]
				Upgrades.crawler_upgrade[3] *= 2
		# +0 HP + 5 ATK on LvUP
		Upgrades.UpgradeType.UNDEAD_ARCHER:
			if ShopData.biscuits >= Upgrades.undead_archer_upgrade[3] and Upgrades.undead_archer_upgrade[2] < 3:
				Upgrades.undead_archer_upgrade[0] += 5
				Upgrades.undead_archer_upgrade[1] += 7
				Upgrades.undead_archer_upgrade[2] += 1
				ShopData.biscuits -= Upgrades.undead_archer_upgrade[3]
				Upgrades.undead_archer_upgrade[3] *= 2
		# +10 HP + 0 ATK on LvUP
		Upgrades.UpgradeType.EXPLODER:
			if ShopData.biscuits >= Upgrades.exploder_upgrade[3] and Upgrades.exploder_upgrade[2] < 3:
				Upgrades.exploder_upgrade[0] += 10
				Upgrades.exploder_upgrade[1] += 10
				Upgrades.exploder_upgrade[2] += 1
				ShopData.biscuits -= Upgrades.exploder_upgrade[3]
				Upgrades.exploder_upgrade[3] *= 2
		# +5 HP + 2 ATK on LvUP
		Upgrades.UpgradeType.VAMPIRE_KNIGHT:
			if ShopData.biscuits >= Upgrades.vampire_knight_upgrade[3] and Upgrades.vampire_knight_upgrade[2] < 3:
				Upgrades.vampire_knight_upgrade[0] += 15
				Upgrades.vampire_knight_upgrade[1] += 5
				Upgrades.vampire_knight_upgrade[2] += 1
				ShopData.biscuits -= Upgrades.vampire_knight_upgrade[3]
				Upgrades.vampire_knight_upgrade[3] *= 2
	shop.biscuits.text = "Biscuits: " + str(ShopData.biscuits)
	update_tooltip()

func update_tooltip():
	var upgrade_type : Upgrades.UpgradeType = get_meta("type")
	match upgrade_type:
		Upgrades.UpgradeType.ZOMBIE:
			tooltip_text = "Zombie\nLevel: " + str(Upgrades.zombie_upgrade[2]+1) + "\nUpgrade Cost: " + str(Upgrades.zombie_upgrade[3]) + " Biscuits\n+ 5 HP\n+ 3 ATK"
			if Upgrades.zombie_upgrade[2] >= 3:
				hide()
		Upgrades.UpgradeType.SKELETON:
			tooltip_text = "Skeleton\nLevel: " + str(Upgrades.skeleton_upgrade[2]+1) + "\nUpgrade Cost: " + str(Upgrades.skeleton_upgrade[3]) + " Biscuits\n+ 6 HP\n+ 6 ATK"
			if Upgrades.skeleton_upgrade[2] >= 3:
				hide()
		Upgrades.UpgradeType.GOBLIN:
			tooltip_text = "Goblin\nLevel: " + str(Upgrades.goblin_upgrade[2]+1) + "\nUpgrade Cost: " + str(Upgrades.goblin_upgrade[3]) + " Biscuits\n+ 2 HP\n+ 6 ATK"
			if Upgrades.goblin_upgrade[2] >= 3:
				hide()
		Upgrades.UpgradeType.STONE_GOLEM:
			tooltip_text = "Stone Golem\nLevel: " + str(Upgrades.stone_golem_upgrade[2]+1) + "\nUpgrade Cost: " + str(Upgrades.stone_golem_upgrade[3]) + " Biscuits\n+ 15 HP\n+ 5 ATK"
			if Upgrades.stone_golem_upgrade[2] >= 3:
				hide()
		Upgrades.UpgradeType.VAMPIRE:
			tooltip_text = "Vampire\nLevel: " + str(Upgrades.vampire_upgrade[2]+1) + "\nUpgrade Cost: " + str(Upgrades.vampire_upgrade[3]) + " Biscuits\n+ 10 HP\n+ 2 ATK"
			if Upgrades.vampire_upgrade[2] >= 3:
				hide()
		Upgrades.UpgradeType.CRAWLER:
			tooltip_text = "Crawler\nLevel: " + str(Upgrades.crawler_upgrade[2]+1) + "\nUpgrade Cost: " + str(Upgrades.crawler_upgrade[3]) + " Biscuits\n+ 5 HP\n+ 5 ATK"
			if Upgrades.crawler_upgrade[2] >= 3:
				hide()
		Upgrades.UpgradeType.UNDEAD_ARCHER:
			tooltip_text = "Undead Archer\nLevel: " + str(Upgrades.undead_archer_upgrade[2]+1) + "\nUpgrade Cost: " + str(Upgrades.undead_archer_upgrade[3]) + " Biscuits\n+ 5 HP\n+ 7 ATK"
			if Upgrades.undead_archer_upgrade[2] >= 3:
				hide()
		Upgrades.UpgradeType.EXPLODER:
			tooltip_text = "Exploder\nLevel: " + str(Upgrades.exploder_upgrade[2]+1) + "\nUpgrade Cost: " + str(Upgrades.exploder_upgrade[3]) + " Biscuits\n+ 10 HP\n+ 10 ATK"
			if Upgrades.exploder_upgrade[2] >= 3:
				hide()
		Upgrades.UpgradeType.VAMPIRE_KNIGHT:
			tooltip_text = "Vampire Knight\nLevel: " + str(Upgrades.vampire_knight_upgrade[2]+1) + "\nUpgrade Cost: " + str(Upgrades.vampire_knight_upgrade[3]) + " Biscuits\n+ 15 HP\n+ 5 ATK"
			if Upgrades.vampire_knight_upgrade[2] >= 3:
				hide()
