extends KinematicBody2D

export (float) var speed: float = 1

onready var tween: Tween = $FlipTween
onready var anim: AnimationPlayer = $AnimationPlayer

var velocity: Vector2
var is_fliping: bool = false

var bounce_dir: Vector2

func _unhandled_input(event):
	if event.is_action_pressed("action_1") and not self.is_fliping:
		flip()

func get_input():
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("up_1"):
		velocity.y -= 1
	if Input.is_action_pressed("down_1"):
		velocity.y += 1
	if Input.is_action_pressed("left_1"):
		velocity.x -= 1
	if Input.is_action_pressed("right_1"):
		velocity.x += 1
		
	velocity = velocity.normalized() * speed
	

func flip():
	self.tween.interpolate_property(self, "rotation_degrees", self.rotation_degrees, self.rotation_degrees + 90, 0.25, Tween.TRANS_EXPO, Tween.EASE_OUT)
	self.tween.start()
	self.anim.play("bounce")
	self.is_fliping = true

func _draw():
	draw_line(Vector2.ZERO, bounce_dir, Color.green, 4)

func _physics_process(delta):
	get_input()
	var col = move_and_collide(velocity * delta)
	if col != null and col.collider.is_in_group("ball"):
#		col.collider.speed_up()
		bounce_dir = col.normal
		col.collider.bounce(bounce_dir, true)
		update()

func _on_FlipTween_tween_all_completed():
	self.is_fliping = false
