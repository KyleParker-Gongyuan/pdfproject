extends Node2D

var _plugin_name = "PdfPlugin"
var _android_plugin

@onready var labelPdfPath = $BoxContainer/labelPdfPath
var pdfPath = ""

signal onSuccess(message)
signal onFailure(message)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.has_singleton(_plugin_name):
		_android_plugin = Engine.get_singleton(_plugin_name)
		_android_plugin.connect("onSuccess", self, "_on_success")
		_android_plugin.connect("onFailure", self, "_on_failure")
	else:
		printerr("Cound't found plugin: " + _plugin_name)

# Define success and failure event handlers
func _on_success(message):
	printerr("Success:", message)

func _on_failure(message):
	printerr("Failure:", message)
	
	

func _on_button_1_pressed() -> void:
	if _android_plugin:
		var image = get_viewport().get_texture().get_image()
		var SavedImage = OS.get_user_data_dir() + "/savedImage.png"
		image.save_png(SavedImage)
		pdfPath = _android_plugin.convertImageToPdf(SavedImage)
		labelPdfPath.text = pdfPath

func _on_button_2_pressed() -> void:
	if _android_plugin:
		_android_plugin.writeTempImageFile()
		pdfPath = _android_plugin.convertImageToPdf("/storage/emulated/0/Android/data/com.example.pdfproject/files/logo.png")
		labelPdfPath.text = pdfPath


func _on_button_print_pressed() -> void:
	if _android_plugin:
		printerr(pdfPath)
		_android_plugin.printPdf(pdfPath)
