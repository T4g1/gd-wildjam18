"""
Stores one line of dialog
"""
extends Node
class_name DialogLine


export (String, MULTILINE) var content		# What is being said
export (String) var who						# Who said that? empty for narrator
export (bool) var thinking					# Thinking or said out loud?
