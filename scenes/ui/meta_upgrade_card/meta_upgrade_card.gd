extends PanelContainer
class_name MetaUpgradeCard


var meta_upgrade: MetaUpgrade

@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var name_label := $%NameLabel as Label
@onready var description_label := $%DescriptionLabel as Label
@onready var unlock_button := $%UnlockButton as Button
@onready var progress_bar := $%ProgressBar as ProgressBar
@onready var progress_label := %ProgressLabel as Label


func _ready() -> void:
	unlock_button.pressed.connect(_on_unlock_pressed)


func select_card() -> void:
	if meta_upgrade == null:
		return
	animation_player.play("selected")
	
	MetaProgression.add_meta_upgrade(meta_upgrade)
	MetaProgression.save_data["currency"] -= meta_upgrade.cost
	MetaProgression.save_game()
	get_tree().call_group("meta_upgrade_card", "update_progress")


func set_meta_upgrade(upgrade: MetaUpgrade) -> void:
	meta_upgrade = upgrade
	name_label.text = upgrade.name
	description_label.text = upgrade.description
	update_progress()


func update_progress() -> void:
	var level := 0
	if MetaProgression.save_data["upgrades"].has(meta_upgrade.id):
		level = MetaProgression.save_data["upgrades"][meta_upgrade.id]["level"] as int
	var max_level := level == meta_upgrade.max_level
	var currency := MetaProgression.save_data["currency"] as float
	var percent := minf(float(currency / meta_upgrade.cost), 1.0)
	
	progress_bar.value = percent
	progress_label.text = str(currency) + "/" + str(meta_upgrade.cost)
	
	unlock_button.text = "Unlock {0}/{1}".format([level, meta_upgrade.max_level])
	unlock_button.disabled = progress_bar.value < 1 or max_level
	if max_level:
		unlock_button.text = "Max Level"


func _on_unlock_pressed() -> void:
	select_card()


