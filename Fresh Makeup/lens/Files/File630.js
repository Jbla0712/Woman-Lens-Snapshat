// -----JS CODE-----
// -----JS CODE-----

//@input Component.Head head

//  @input SceneObject[] rotationObjects

// @input float limitRotationUp
// @input float limitRotationDown

// @input int upAttachPoint
// @input int downAttachPoint

//  @ui {"widget":"separator"}
// @input float lerpT = 0.8

var head = script.head;
var lerpT = script.lerpT;

const RAD = Math.PI / 180;

const OPENED = 55.0;
const CLOSED = 10.0;
const DELTA_DIST = OPENED - CLOSED;

const DELTA_ROT = script.limitRotationUp - script.limitRotationDown;

function getXVec3(x) {
    return vec3.right().uniformScale(x * RAD);
}

var rotationObjectsTransfrom = [];
script.rotationObjects.forEach(function (obj) {
    rotationObjectsTransfrom.push(obj.getTransform());
})

function clamp(v) {
    if (v < 0) return 0;
    if (v > 1) return 1;
    return v;
}

function lerpRotation(objTransform, rotationX) {
    var curRotation = toEuler(objTransform.getLocalRotation());
    // print("curRotation.x " + curRotation.x + " rotationX " + rotationX)
    curRotation.x = curRotation.x * lerpT + RAD * rotationX * (1.0 - lerpT);
    objTransform.setLocalRotation(fromEuler(curRotation));
}

function onUpdate() {
    if (head.getFacesCount() < 1) {
        return;
    }

    var headHigh = head.getPosition(0).y - head.getPosition(10).y;

    var upperPosition = head.getPosition(script.upAttachPoint);
    var lowerPosition = head.getPosition(script.downAttachPoint);


    var d_left = (upperPosition.distance(lowerPosition) / headHigh) * 1000 + headHigh / 20;

    var ratio = (d_left - CLOSED) / DELTA_DIST;
    ratio = clamp(ratio)

    var rot = script.limitRotationDown + DELTA_ROT * ratio;

    rotationObjectsTransfrom.forEach(function (objTransform) {
        lerpRotation(objTransform, rot);
    });

}
script.createEvent("UpdateEvent").bind(onUpdate);