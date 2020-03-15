extends Node2D

onready var slow_mo_tween: Tween = $SlowMoTween

var winner_name: String

func _ready():
	slow_mo_tween.interpolate_property(Engine, "time_scale", Engine.time_scale, 0.2, 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
	disable_movement()

func disable_movement():
	get_tree().paused = true

func enable_movement():
	get_tree().paused = false

func trigger_ending():
	$GUI/MatchUI/AnimationPlayer.play("end_game")
	slow_mo_tween.start()
	
func show_results():
	disable_movement()
	$GUI/MatchUI/MatchResults/WinnerTextContainer/WinnerName.text = winner_name
	slow_mo_tween.stop_all()
	Engine.time_scale = 1
	$GUI/MatchUI/AnimationPlayer.play("show_results")

func _on_Player1_defeated():
	self.winner_name = "Player 2"
	trigger_ending()

func _on_Player2_defeated():
	self.winner_name = "Player 1"
	trigger_ending()

func _on_TryAgainButton_pressed():
	SceneTransition.switch_scene(self, SceneTransition.MainGame)
