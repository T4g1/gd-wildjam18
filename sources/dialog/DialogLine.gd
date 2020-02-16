"""
Stores one line of dialog
"""
extends Node
class_name DialogLine


export (String) var content		# What is being said
export (NodePath) var who		# Who said that? none for narrator
export (bool) var thinking		# Thinking or said out loud?
