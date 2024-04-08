// @input SceneObject inactiveButton
// @input SceneObject activeButton
// @input Component.Image aim

//@input vec4 activeColor = {0.137255, 0.356863,0.858824,1} {"widget":"color"}
//@input vec4 inactiveColor = {0.443137, 0.443137, 0.443137, 1} {"widget":"color"}


function Range(l, r) {
    this.l = l;
    this.r = r;
}

const PI = Math.PI;
const PIx2 = Math.PI * 2;

const zRotRange = new Range(-0.4, 0.2);
const screenPosRange = new Range(0.1, 0.9);
const xyRotLimit = 0.3;


var newSO = global.scene.createSceneObject("head1");
var head = newSO.createComponent("Component.Head");
var aimPass = script.aim && script.aim.mainPass;


function isInRange(pos, range) {
    return range.l <= pos && pos <= range.r;
}

function shiftAngle(angle) {
    return angle < PI ? angle : angle - PIx2;
}

var updateEvent = script.createEvent("UpdateEvent");
updateEvent.bind(function() {
    var ready = faceReadyForShot(head);
    setEnabled(script.inactiveButton, !ready);
    setEnabled(script.activeButton, ready);

    setEnabled(script.aim, true);
    
    if (aimPass) {
        if (ready) {
            aimPass.baseColor = script.activeColor;
        } else {
            aimPass.baseColor = script.inactiveColor;
        }
    }
});

function faceReadyForShot(head) {
    if (head.getFacesCount() == 0 || head.getSize().x > 0.8) {
        return false;
    }

    var rotation = head.getRotation().toEuler();
    var x = Math.abs(shiftAngle(rotation.x));
    var y = Math.abs(shiftAngle(rotation.y));
    var z = shiftAngle(rotation.z);

    return isInRange(z, zRotRange) 
        && x < xyRotLimit
        && y < xyRotLimit
        && isFacePointVisiable(0)
        && isFacePointVisiable(16)
        && isFacePointVisiable(8)
        && isFacePointVisiable(71);
}

function isFacePointVisiable(pointIndex) {
    var screenPos = head.getPosition2d(pointIndex);
    
    return isInRange(screenPos.x, screenPosRange)
        && isInRange(screenPos.y, screenPosRange);
}

function setEnabled(visual, enabled) {
    if (visual) visual.enabled = enabled;
}
