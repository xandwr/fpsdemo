class_name Gun extends Weapon

@export var ammo_count: int
@export var max_ammo: int

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var can_reload: bool = false
var is_reloading: bool = false  # Track if reload is happening
var is_firing: bool = false  # New variable to track if firing animation is in progress

func _process(_delta: float) -> void:
	can_reload = ammo_count < max_ammo


func fire():
	if not get_tree().paused:
		# Prevent firing if reloading, if fire cooldown is active, or if firing animation is in progress
		if ammo_count > 0 and can_fire and not is_reloading and not is_firing:
			# Block input until the firing process is done
			is_firing = true  # Set firing state to block further input

			# Play fire animation
			if not animation_player.is_playing() or animation_player.current_animation != "shoot":
				animation_player.play("shoot")

			# Reduce ammo and start cooldown
			ammo_count -= 1
			can_fire = false  # Disable firing until the cooldown is over
			
			# Wait for cooldown and end firing state
			await start_fire_cooldown()

		elif ammo_count == 0:
			print("No ammo")


func reload():
	if not get_tree().paused:
		# Prevent reloading if already reloading or if no need to reload
		if can_reload and not is_reloading:
			is_reloading = true  # Set reloading flag
			animation_player.play("reload")
			can_reload = false
			can_fire = false  # Disable firing during reload
			await start_reload_cooldown()


func start_fire_cooldown() -> void:
	# Wait for the fire animation to complete
	await get_tree().create_timer(animation_player.get_animation("shoot").length).timeout
	is_firing = false  # Allow firing again after animation finishes

	# After the cooldown, check if reloading is still happening
	if not is_reloading:
		can_fire = true


func start_reload_cooldown() -> void:
	# Wait for the reload animation to finish
	await get_tree().create_timer(animation_player.get_animation("reload").length).timeout
	
	# After the animation finishes, refill ammo and allow firing again
	ammo_count = max_ammo
	can_reload = true
	can_fire = true  # Allow firing after reload completes
	is_reloading = false  # Reset reloading flag
