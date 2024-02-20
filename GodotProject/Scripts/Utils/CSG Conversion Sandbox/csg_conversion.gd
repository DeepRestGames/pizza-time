extends Node3D


@onready var static_box_scene = preload("res://Scenes/Prefabs/Level Design Elements/StaticBox.tscn")
@onready var static_cylinder_scene = preload("res://Scenes/Prefabs/Level Design Elements/StaticCylinder.tscn")


func _init():
	print("Script start")


func _ready():
	print("Starting conversion..")
	
	var root = get_tree().current_scene
	
	var csg_nodes = find_csg_nodes(root)
	
	print("Found " + str(csg_nodes.size()) + " CSG nodes in current scene")
	
	for csg_node in csg_nodes:
		var parent_node = csg_node.get_parent()
		var current_node_name = csg_node.name
		var current_node_index = csg_node.get_index()
		var converted_node
		
		# BOX CONVERSION
		if csg_node is CSGBox3D:
			var csg_box = csg_node as CSGBox3D
			converted_node = static_box_scene.instantiate() as Node3D
			converted_node.transform = csg_box.transform
			converted_node.scale = csg_box.size
		
		# CYLINDER CONVERSION
		if csg_node is CSGCylinder3D:
			var csg_cylinder = csg_node as CSGCylinder3D
			converted_node = static_cylinder_scene.instantiate() as Node3D
			converted_node.transform = csg_cylinder.transform
			converted_node.scale.y = csg_cylinder.height
			converted_node.scale.x = csg_cylinder.radius
			converted_node.scale.z = csg_cylinder.radius
		
		if converted_node != null:
			parent_node.add_child(converted_node)			
			parent_node.move_child(converted_node, current_node_index)
			parent_node.remove_child(csg_node)
			converted_node.set_owner(root)
			converted_node.name = current_node_name

	var new_scene = PackedScene.new()
	new_scene.pack(root)
	ResourceSaver.save(new_scene, "res://CSG Conversion Sandbox/ConvertedScene01.tscn")
	
	print("Conversion completed!")
	
	csg_nodes = find_csg_nodes(root)
	print("Remaining CSG nodes:")
	print(csg_nodes)


func find_csg_nodes(node):
	var csg_nodes = []

	if node is CSGShape3D:
		csg_nodes.append(node)

	for child in node.get_children():
		csg_nodes += find_csg_nodes(child)

	return csg_nodes
