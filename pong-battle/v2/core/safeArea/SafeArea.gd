extends Area2D

func _on_SafeArea_body_exited(body):
	body.die()
