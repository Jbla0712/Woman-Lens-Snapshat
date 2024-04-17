// @input Asset.Texture crop
// @input Asset.Texture cameraTex

script.size = vec2.zero();
script.face_center_mouth_weight = 0;

var left_eye = vec2.zero();
var right_eye = vec2.zero();
var mouth_center = vec2.zero();
var eye_center = vec2.zero();
var eye_vector = vec2.zero();
var mouth_to_eye_vector = vec2.zero();
var mouth_to_eye_vector_transp = vec2.zero();
var rotation_vector = vec2.zero();
var rotation_center = vec2.zero();

var eyeL = []; 
var eyeR = []; 
for (var i = 0; i < 6; i++){
    eyeL.push(vec2.zero());
    eyeR.push(vec2.zero());
}

var head = {};

var mouth = [];
mouth.push(vec2.zero());
mouth.push(vec2.zero());

var left_temple = vec2.zero();
var right_temple = vec2.zero();

var rect = Rect.create(0, 0, 0, 0);

var aspect = 1.0;

function setHead(hd){
    head = hd;
}

function getTransformedLandmark(p, index) {
    var lm = head.getLandmark(index);
    p.x = 2.0 * lm.x - 1.0;
    p.y = 1.0 - 2.0 * lm.y;
}

function add(v1, v2){
    v1.x += v2.x;
    v1.y += v2.y;
}

function sub(v0, v1, v2){
    v0.x = v1.x - v2.x;
    v0.y = v1.y - v2.y;
}

function scale(v1, s){
    v1.x *= s;
    v1.y *= s;
}

function getAverage(faceItem, points) {
    faceItem.x = 0;
    faceItem.y = 0;
    
    points.forEach(function(point) {
        add(faceItem, point);
    });

    scale(faceItem, 1 / points.length);
}

function getScalarAverage(arr, n){
    res = 0;
    for (var i = 0; i < n; i++){
        res += arr[i].x;
    }
    return res / n;
}

function getCrop() {
    getAspect();
    for (var i = 0; i < 6; i++){
        getTransformedLandmark(eyeL[i], 36 + i);
        getTransformedLandmark(eyeR[i], 42 + i);
    }
    
    getAverage(left_eye, [eyeL[0], eyeL[3], eyeL[4], eyeL[5]]);
    left_eye.x = getScalarAverage(eyeL, 6);
    getAverage(right_eye, [eyeR[0], eyeR[3], eyeR[4], eyeR[5]]);
    right_eye.x = getScalarAverage(eyeR, 6);
    getAverage(eye_center, [left_eye, right_eye]);
        
    getTransformedLandmark(mouth[0], 48);
    getTransformedLandmark(mouth[1], 54);

    getAverage(mouth_center, [mouth[0], mouth[1]]);
    
    sub(eye_vector, left_eye, right_eye);
    
    sub(mouth_to_eye_vector, eye_center, mouth_center);
    mouth_to_eye_vector_transp.x = mouth_to_eye_vector.y;
    mouth_to_eye_vector_transp.y = -mouth_to_eye_vector.x;

    sub(rotation_vector, eye_vector, mouth_to_eye_vector_transp);
    //var angle = Math.atan2(rotation_vector.y, -rotation_vector.x);
    var angle = Math.atan2(eye_vector.y / aspect, -eye_vector.x);
    
    scale(mouth_to_eye_vector, script.face_center_mouth_weight);
    sub(rotation_center, eye_center, mouth_to_eye_vector);
    
    getTransformedLandmark(left_temple, 0);
    getTransformedLandmark(right_temple, 16);
    
    var dx = aspect * (left_temple.x - right_temple.x);
    var dy = left_temple.y - right_temple.y;

    var halfSide = Math.sqrt( dx * dx + dy * dy );

    rect.left = rotation_center.x - halfSide / aspect * script.size.x;
    rect.right = rotation_center.x + halfSide / aspect * script.size.x;
    rect.bottom = rotation_center.y - halfSide * script.size.y;
    rect.top = rotation_center.y + halfSide * script.size.y;

    script.crop.control.cropRect = rect;
    script.crop.control.rotation = angle;

    script.anchors = rect;
    script.rotation = quat.fromEulerAngles(0, 0, -angle);
}

script.getCrop = getCrop;
script.setHead = setHead;

function getAspect() {
    aspect = script.cameraTex.control.getAspect();
}

script.createEvent("TurnOnEvent").bind(getAspect);