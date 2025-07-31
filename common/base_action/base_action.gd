class_name BaseAction extends Resource

@export var step_length: int = 1
@export var end: bool = false

@export_group("Action Doings", "on_action")
@export var on_action_velocity: Vector2

func _on_turn(entity: BaseEntity) -> void:
	entity.velocity += on_action_velocity
	if end:
		entity._on_end_loop()
		entity.cur_index = 0
		entity.timer.stop()
	else:
		entity.cur_index += step_length
