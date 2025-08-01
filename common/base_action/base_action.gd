class_name BaseAction extends Resource

@export var step_length: int = 1
@export var end: bool = false

@export_group("Action Doings", "on_action")
@export var on_action_add_states: Dictionary[String, int]
@export var on_action_animation_name: String
@export var on_action_add_block: bool = false
@export var on_action_enemy_attack: float = 0.0
#@export var on_action_self_damage: float = 0.0

func _on_turn(entity: BaseEntity) -> void:
#	Animation on action player
	entity.play_animation(on_action_animation_name)
#	Attack on action
	# Заменяем блок атаки на:
	var can_attack = true
	
	if on_action_add_block:
		entity.has_block = true

	if on_action_enemy_attack != 0.0:
		if entity.name == "Player":
			for state in Events.cur_enemy.needed_states_to_hurt.keys():
				if entity.states.get(state, 0) < Events.cur_enemy.needed_states_to_hurt[state]:
					can_attack = false
					break
			if can_attack:
				Events.cur_enemy.deal_damage(on_action_enemy_attack)
		else:
			for state in Events.player.needed_states_to_hurt.keys():
				if entity.states.get(state, 0) < Events.player.needed_states_to_hurt[state]:
					can_attack = false
					break
					
			if can_attack:
				Events.player.deal_damage(on_action_enemy_attack)
	if end:
		entity._on_end_loop()
		entity.cur_index = 0
		entity.timer.stop()
		if entity.name == "Player":
			Events.on_player_loop_end()
		else:
			Events.on_enemy_loop_end()
	else:
		for add_state in on_action_add_states.keys():
			entity.states[add_state] += on_action_add_states[add_state]
		entity.cur_index += step_length
