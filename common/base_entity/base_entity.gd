class_name BaseEntity extends CharacterBody2D

@export var step_loop_duration: float = 1.0
@export var algorithm: Array[BaseAction]
var cur_index: int = 0

@onready var timer: Timer = Timer.new()
@export var animation_player: AnimationPlayer

var max_health: float = 100.0
var health: float = 100.0

var has_block: bool = false

var states: Dictionary[String, int] = {
	"jump": 0,
}
@export var needed_states_to_hurt:Dictionary[String, int]

func deal_damage(damage: float) -> void:
	if has_block:
		var real_damage : float = damage/100
		if real_damage >= health:
			return die()
		else:
			health -= real_damage
		play_animation("block")
		has_block = false
	else:
		if damage >= health:
			return die()
		else:
			health -= damage
			play_animation("hurt")

func heal(a_heal: float) -> void:
	health += a_heal
	play_animation("heal")
	if health > max_health:
		health = max_health
		
func die() -> void:
	play_animation("death")
	
func _ready() -> void:
	if states:
		states = states.duplicate()
	if needed_states_to_hurt:
		needed_states_to_hurt = needed_states_to_hurt.duplicate()
		
	add_child(timer)
	timer.timeout.connect(timer_handler_timeout)
	timer.wait_time = step_loop_duration
	
	if name == "Player":
		Events.player = self
		start_loop()
	else:
		if not Events.cur_enemy:
			Events.cur_enemy = self
			
		play_animation("ready")
	
func _on_end_loop() -> void:
	for state in states.keys():
		states[state] = 0
	
func timer_handler_timeout() -> void:
	for state in states.keys():
		states[state] -= 1
		if states[state] < 0:
			states[state] = 0
			
	if algorithm:
		print(cur_index)
		var action:BaseAction = algorithm[cur_index]
		if action:
			action._on_turn(self)
	
func start_loop() -> void:
	if timer:
		timer.start()
		
func _physics_process(delta):
	#print(name + "'s health: " + str(health))
	velocity.x = lerp(velocity.x, 0.0, 0.075)
	velocity += delta * get_gravity()
	move_and_slide()

func play_animation(animation_name: String) -> void:
	if animation_player:
		if animation_player.has_animation(animation_name):
			animation_player.play(animation_name)	
