class_name BaseEntity extends CharacterBody2D

@export var algorithm: Dictionary[int, BaseAction]
var cur_index: int = 0

@onready var timer: Timer = Timer.new()

func _ready() -> void:
	add_child(timer)
	timer.wait_time = 1.0
	timer.timeout.connect(timer_handler_timeout)
	timer.start()
	
func _on_end_loop() -> void:
	pass
	
func timer_handler_timeout() -> void:
	print("Entity loop step")
	var action:BaseAction = algorithm[cur_index - int((cur_index/ algorithm.keys().size()))*algorithm.keys().size()]
	if action:
		action._on_turn(self)
	
func start_loop() -> void:
	if timer:
		timer.start()
		
func _physics_process(delta):
	velocity.x = lerp(velocity.x, 0.0, 0.075)
	velocity += delta * get_gravity()
	move_and_slide()
