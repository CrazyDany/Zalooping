extends Node

var cur_enemy: BaseEntity
var player: BaseEntity

func on_player_loop_end() -> void:
	if cur_enemy:
		cur_enemy.start_loop()

func on_enemy_loop_end() -> void:
	if player:
		player.start_loop()
