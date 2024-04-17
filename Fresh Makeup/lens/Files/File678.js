//@input int minDeviceClass
//@input Asset.Texture[] cameraTextures

var deviceClass = global.deviceInfoSystem.getDeviceClass();
var msaaEnabled = deviceClass >= script.minDeviceClass;

script.cameraTextures.forEach(function (texture) {
    texture.control.msaa = msaaEnabled;
})