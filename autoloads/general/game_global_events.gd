## This is where all the main and common signals are located, otherwise referred to as a SignalBus
extends Node

signal game_tick
signal gold_updated(value: int)
signal update_inventory()
signal place_cell(cell: Cell)
signal create_cell(cell: Cell)
signal selected_cell(cell: Cell)
signal place_item(attached: Variant)
