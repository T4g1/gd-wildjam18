extends Node2D

signal player_entered

func _ready():
	# Connect signals of the area used for interaction range
	var area = $Area2D

	assert(area)
	assert(area.connect("body_entered", self, "_on_range_entered") == OK)

#func _process(delta):
#	pass

func _on_range_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return

	emit_signal("player_entered", body)
	self.on_range_entered(body)

func on_range_entered(body: Node) -> void:
	"""Sub class override this function for special behavior
	"""
	pass
