extends RigidBody2D

export (String) var tag: String = "player1"
export (String) var up_action: String = "up_1"
export (String) var down_action: String = "down_1"
export (String) var left_action: String = "left_1"
export (String) var right_action: String = "right_1"
export (String) var a_action: String = "a_1"

export var max_boost_duration: float = 10.0
export var boost_duration: float = max_boost_duration setget set_boost_duration
export var move_force = 100
export var rotation_force = 200
export var multiplier = 3

onready var anim: AnimationPlayer = $AnimationPlayer

onready var bar: ProgressBar = $ProgressBar

var dir_input: Vector2
var rotation_dir: int
var boost_input: bool
var pause: bool = false setget set_pause

var perc: float = 0.0 setget set_perc

func _ready():
	self.bar.max_value = self.max_boost_duration

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
	if self.pause:
		return
		
	get_input()
	var m = 1
	
	if boost_input and boost_duration > 0:
		m = multiplier
		self.boost_duration -= 0.3
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
		
func set_boost_duration(value):
	boost_duration = min(value, max_boost_duration)
	self.bar.value = boost_duration

func set_perc(value):
	perc = value
	print(name + ": " + str(perc))

func apply_damage(velocity: Vector2):
	var magnitude = velocity.length()
	self.perc += magnitude / 5.0
	
func apply_knockback(velocity: Vector2):
	var mul = (20 * (perc / 100.0)) + 10
	self.add_central_force(velocity.rotated(deg2rad(180)) * mul)

func _on_Player_body_entered(body: Node):
	if body.is_in_group(tag):
		self.pause = true
		apply_knockback(body.linear_velocity)
		apply_damage(body.linear_velocity)
		yield(anim, "animation_finished")
		self.pause = false
		
func _on_BoostTimer_timeout():
	self.boost_duration += 0.5


