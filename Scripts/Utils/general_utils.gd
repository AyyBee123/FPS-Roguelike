class_name Utils extends Node

## this is to prevent certain effects from recursively proccing
static func copy_groups(from: Node, to: Node) -> void:
	for group in from.get_groups():
		to.add_to_group(group)
