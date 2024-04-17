// -----JS CODE-----
//@input SceneObject[] obj
var isHigh = global.deviceInfoSystem.getDeviceClass() > 2;

if(!isHigh) {
    for(var i = 0; i < script.obj.length; i++) {
        script.obj[i].enabled = false;
    }
}