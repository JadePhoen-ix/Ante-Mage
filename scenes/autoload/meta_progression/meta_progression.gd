extends Node


const SAVE_DATA_PATH := "user://game.save"

var save_data := {
		"currency" : 0,
		"upgrades" : {},
}


func _ready() -> void:
	GameEvents.experience_vial_collected.connect(_on_experience_collected)
	load_save_data()


func load_save_data() -> void:
	if not FileAccess.file_exists(SAVE_DATA_PATH):
		return
	var file = FileAccess.open(SAVE_DATA_PATH, FileAccess.READ)
	save_data = file.get_var()


func save_game() -> void:
	var file = FileAccess.open(SAVE_DATA_PATH, FileAccess.WRITE)
	file.store_var(save_data)


func add_meta_upgrade(upgrade: MetaUpgrade) -> void:
	if not save_data["upgrades"].has(upgrade.id):
		save_data["upgrades"][upgrade.id] = {
				"level" : 0
		}
	
	save_data["upgrades"][upgrade.id]["level"] += 1
	save_game()


func get_upgrade_level(upgrade_id: String) -> int:
	if save_data["upgrades"].has(upgrade_id):
		return save_data["upgrades"][upgrade_id]["level"]
	return 0


func _on_experience_collected(value: float) -> void:
	save_data["currency"] += value
	save_game()



