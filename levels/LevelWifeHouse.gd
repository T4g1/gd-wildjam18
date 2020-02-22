"""
Specific logic for the level Ex-Wife's house
"""
extends "res://sources/level/Level.gd"


func _ready() -> void:
	assert($Wife.connect("interacted", self, "on_wife_interacted") == OK)
	assert($Son.connect("interacted", self, "on_son_interacted") == OK)
	assert($Wreckage.connect("interacted", self, "on_wreckage_interacted") == OK)
	assert($Car.connect("interacted", self, "on_car_interacted") == OK)
	assert($GasCan.connect("interacted", self, "on_gas_interacted") == OK)
	assert($Tires.connect("interacted", self, "on_tires_interacted") == OK)
	assert($Tools.connect("interacted", self, "on_tools_interacted") == OK)

	introduction()


func introduction() -> void:
	"""
	Level start hidden with a dialog
	When dialogs end, level fade in and player can start playing
	"""

	yield(start_dialog($UI/Introduction), "completed")


func on_wife_interacted(__) -> void:
	yield(start_dialog($UI/BritanyPanic), "completed")

	$Son.enable()
	$Wife.disable()


func on_son_interacted(__) -> void:
	yield(start_dialog($UI/BilyStuck), "completed")

	$Son.disable()
	$Tools.enable()


func on_tools_interacted(__) -> void:
	yield(start_dialog($UI/GotCrowbar), "completed")

	$Tools.disable()
	$Wreckage.enable()


func on_wreckage_interacted(__) -> void:
	yield(start_dialog($UI/BilySaved), "completed")

	$Wreckage.disable()
	$Tires.enable()
	$GasCan.enable()


func on_gas_interacted(__) -> void:
	yield(start_dialog($UI/GotGas), "completed")

	$GasCan.disable()

	check_can_enter_car()


func on_tires_interacted(__) -> void:
	yield(start_dialog($UI/GotTires), "completed")

	$Tires.disable()

	check_can_enter_car()


func check_can_enter_car():
	"""
	Check if we got gascan and tires
	"""
	if $Tires.interactable or $GasCan.interactable:
		return

	yield(start_dialog($UI/EverythingReady), "completed")

	$Car.enable()


func on_car_interacted(__) -> void:
	end()



