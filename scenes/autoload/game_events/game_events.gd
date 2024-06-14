extends Node


signal experience_vial_collected(value: float)
signal upgrade_added(upgrade: Upgrade, current_upgrades: Dictionary)
signal player_damaged()
signal spell_cast(spell: Spell)


func emit_experience_vial_collected(value: float) -> void:
	experience_vial_collected.emit(value)


func emit_upgrade_added(upgrade: Upgrade, current_upgrades: Dictionary) -> void:
	upgrade_added.emit(upgrade, current_upgrades)


func emit_player_damaged() -> void:
	player_damaged.emit()


func emit_spell_cast(spell: Spell) -> void:
	spell_cast.emit(spell)


