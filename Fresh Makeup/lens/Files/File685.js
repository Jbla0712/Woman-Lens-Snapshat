// -----JS CODE-----
//@input SceneObject object
//@input int targetDevices = 2 {"widget":"combobox", "values":[{"label":"Low", "value":1}, {"label":"Mid+Low", "value":2}]}


var deviceClass = global.deviceInfoSystem.getDeviceClass();

if (deviceClass <= script.targetDevices && script.object) {
    script.object.enabled = true
}