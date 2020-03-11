extends RigidBody2D

export var initial_force = 200
#
#func _ready():
#	randomize()
#	apply_impulse(Vector2(), get_random_dir() * initial_force)

func get_random_dir() -> Vector2:
	return Vector2(randf(), randf()).normalized()

#func _integrate_forces(state: Physics2DDirectBodyState):
#	pass
