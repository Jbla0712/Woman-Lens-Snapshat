// @input Asset.Texture mouthClosedMask
var mouthClosedMask = script.mouthClosedMask

//@input bool tuning = false
//@input float lipsBound = 0.03 {"showIf":"tuning"}
//@input Component.FaceMaskVisual faceSub {"showIf":"tuning"}

var scnObject = script.getSceneObject()
var head
var mouthOpenedMask

var BOUND_EPS
var faceSub
if (script.tuning) {
	BOUND_EPS = script.lipsBound
	faceSub = script.faceSub
} else {
	BOUND_EPS = 0.03
	faceSub = scnObject.getFirstComponent("Component.FaceMaskVisual")
}

var event = script.createEvent("UpdateEvent");
event.enabled = false

function updateMask() {
	if (head.getFacesCount() < 1) {
		return
	}
	var upperLip = head.getPosition2d(62)
	var lowerLip = head.getPosition2d(66)
	var faceHeight = head.getSize().y * 0.5

	var dist = upperLip.distance(lowerLip) / faceHeight

	if (dist < BOUND_EPS) {
		faceSub.mainMaterial.mainPass.opacityTex = mouthClosedMask
	} else {
		faceSub.mainMaterial.mainPass.opacityTex = mouthOpenedMask
	}
}

if (faceSub) {
	var faceIndex = faceSub.faceIndex
	head = scnObject.createComponent("Component.Head")
	head.faceIndex = faceIndex
	mouthOpenedMask = faceSub.mainMaterial.mainPass.opacityTex

	event.bind(updateMask);
	event.enabled = true
	print(">>> LipsFix: enabled")
} else {
	print(">>> LipsFIx: WARNING! FaceSub is not found, lips fix is disabled.")
}