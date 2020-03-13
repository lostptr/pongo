extends RigidBody2D

signal initialized(player)
signal stat_changed(stat_name, stat_value)
signal defeated

export (String) var ui_name: String = "P1"
export (String) var tag: String = "player1"
export (String) var up_action: String = "up_1"
export (String) var down_action: String = "down_1"
export (String) var left_action: String = "left_1"
export (String) var right_action: String = "right_1"
export (String) var a_action: String = "a_1"

export var boost_duration: float = 10.0
export var boost: float = boost_duration setget set_boost
export var move_force = 100
export var rotation_force = 200
export var multiplier = 3

onready var respawn_timer: Timer = $RespawnTimer
onready var spawn_position: Vector2 = self.global_position
onready var anim: AnimationPlayer = $AnimationPlayer

var dir_input: Vector2
var rotation_dir: int
var boost_input: bool
var pause: bool = false setget set_pause
var set_pos_requested: bool = false

var stocks: int = 3 setget set_stocks
var perc: float = 200.0 setget set_perc

func _ready():
	call_deferred("init_ui")
	
func init_ui():
	emit_signal("initialized", self)

func get_input():
	dir_input = Vector2.ZERO
	
	if Input.is_action_pressed(up_action):
		dir_input.y -= 1
	if Input.is_action_pressed(down_action):
		dir_input.y += 1
	if Input.is_action_pressed(left_action):
		dir_input.x -= 1
	if Input.is_action_pressed(right_action):
		dir_input.x += 1
		
	dir_input = dir_input.normalized()
	
	if Input.is_action_just_pressed(a_action):
		boost_input = true
		anim.play("boost")
	elif Input.is_action_just_released(a_action):
		boost_input = false
		anim.play("idle")

func _integrate_forces(state: Physics2DDirectBodyState):
	
	if self.set_pos_requested:
		state.transform = Transform2D(0, self.spawn_position)
		self.set_pos_requested = false
		return
	
	if self.pause:
		return
		
	get_input()
	var m = 1
	
	if boost_input and boost > 0:
		m = multiplier
		self.boost -= 0.3
	applied_force = dir_input * move_force * m
	
#	rotation_dir = 0
#	if Input.is_action_pressed("b_1"):
#		rotation_dir += 1
#	applied_torque = rotation_dir * rotation_force
	
	
func set_pause(value):
	pause = value
	if pause:
		anim.play("hurt")
	else:
		anim.play("idle")
		
func set_boost(value):
	boost = min(value, boost_duration)
	emit_signal("stat_changed", "boost", boost)

func set_perc(value):
	perc = value
	emit_signal("stat_changed", "perc", perc)
	
func set_stocks(value):
	stocks = value
	emit_signal("stat_changed", "stocks", stocks)

func apply_damage(velocity: Vector2):
	var magnitude = velocity.length()
	self.perc += magnitude / 12.0
	
func apply_knockback(velocity: Vector2):
	var mul = (10 * (perc / 100.0)) + 5
	self.add_central_force(velocity.rotated(deg2rad(180)) * mul)

func _on_Player_body_entered(body: Node):
	if body.is_in_group(tag):
		self.pause = true
		apply_knockback(body.linear_velocity)
		apply_damage(body.linear_velocity)
		yield(anim, "animation_finished")
		self.pause = false
		
func die():
	self.stocks -= 1
	
	if self.stocks <= 0:
		emit_signal("defeated")
		queue_free()
	else:
		reset()
		self.respawn_timer.start()
	
func reset():
	self.perc = 0.0
	self.boost_input = false
	self.boost = self.boost_duration
	
func _on_BoostTimer_timeout():
	self.boost += 0.5

func _on_RespawnTimer_timeout():
	# Go back to spawn position
	self.set_pos_requested = true
