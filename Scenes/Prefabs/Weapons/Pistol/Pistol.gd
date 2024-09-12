class_name Pistol extends Gun


func _init() -> void:
	self.weapon_name = "Pistol"
	self.ammo_count = 15
	self.max_ammo = 15
	self.weapon_position = Vector3(0.4, 1.4, -0.4)
	self.weapon_rotation = Vector3(0, 90, 0)
