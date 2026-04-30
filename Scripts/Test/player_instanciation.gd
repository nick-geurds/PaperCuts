extends Node
class_name PlayerInstanitation

@export var player_scene : PackedScene
@export var slot_manager : SlotManager

func _ready() -> void:
	for i in GameManager.assigned_controllers.keys():
		var player = player_scene.instantiate()
		
		var playerInput = player as PlayerInput
		print("isPlayerOne gezet: ", playerInput.isPlayerOne)
		
		if playerInput:
			if i == 1:
				playerInput.isPlayerOne = true
				playerInput.start_slot = 0
			else: 
				playerInput.isPlayerOne = false
				playerInput.start_slot = slot_manager.slot_index.size() - 1
		add_child(player)
