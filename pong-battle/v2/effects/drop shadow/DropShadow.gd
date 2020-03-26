extends Sprite

export (Vector2) var shadow_offset: Vector2
export (NodePath) var shadow_caster_path: NodePath

onready var shadow_caster: Node2D = self.get_node(self.shadow_caster_path)

func _ready() -> void:
	var sprite: Sprite = shadow_caster.get_node("Sprite")
	self.texture = sprite.texture
	self.hframes = sprite.hframes
	self.vframes = sprite.vframes
	self.frame = sprite.frame
	shadow_caster.connect("tree_exited", self, "queue_free")

func _process(_delta: float) -> void:
	self.global_position = shadow_caster.global_position + shadow_offset
	self.rotation = shadow_caster.rotation
