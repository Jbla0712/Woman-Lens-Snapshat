// @input Component.MLComponent mlComponent
// @input Asset.Texture inputTexture
// @input Asset.Texture[] outTextures
// @input Component.Image warpedImage
// @input Component.Head head
// @input Component.ScriptComponent customCropScript
// @input Component.ScriptComponent modelManager
// @input Component.ScriptComponent lensModeController

var warpedImageTransform = script.warpedImage.getSceneObject().getComponent("Component.ScreenTransform");
script.customCropScript.setHead(script.head);
var faceIndex = script.head.faceIndex;
script.mlControllerIsBuilt = false;

var useSync = false;

hide();

function setInput(texture){
    try{
        script.mlComponent.getInput(script.modelManager.mlInputName).texture = texture;
    }
    catch(e){
        print(e);
    }
}

function isHierarchyEnabled(so) {
    if (!so) {
        return true;
    } else if (so.enabled) {
        return isHierarchyEnabled(so.getParent());
    } else {
        return false;
    }
}

function runImmediate(){
    if (!script.mlControllerIsBuilt) return;
    if (!useSync && !script.inputTexture.control.isLoaded() ) return;

    try{
        if (isHierarchyEnabled(script.warpedImage.getSceneObject())) {
            script.mlComponent.runScheduled(false, MachineLearning.FrameTiming.OnRender, MachineLearning.FrameTiming.OnRender);
        }
    } catch(e) {
        print(e);
    }

    show();
}

function cropFaceRender(){
    hide();
    if (script.head.getFacesCount() > faceIndex) {
        script.customCropScript.getCrop();

        warpedImageTransform.anchors = script.customCropScript.anchors;
        warpedImageTransform.rotation = script.customCropScript.rotation;
    }

    if (script.head.getFacesCount() > faceIndex) {
        runImmediate();
    }
}

function hide(){
    script.warpedImage.enabled = false;
}

function show(){
    script.warpedImage.enabled = true;
}

function connectInput(inputTexture){
    script.mlComponent.getInput(script.modelManager.mlInputName).texture = inputTexture;
}

function connectOutput(){
    for (var i = 0; i < script.modelManager.mlOutputNames.length; i++) {
        var output = script.mlComponent.getOutput(script.modelManager.mlOutputNames[i]);
        script.outTextures[i].control = output.texture.control;
    }
}

function buildML(){
    script.mlComponent.inferenceMode = MachineLearning.InferenceMode.Auto;
    script.mlComponent.build(script.modelManager.mlPlaceholders[faceIndex]);
    script.mlComponent.stop();
    if (useSync) {
        script.mlComponent.waitOnLoading();
        onLoadingFinished();
    }
}

function waitML(){
    script.mlComponent.waitOnLoading();
}

function initML(){
    script.mlControllerIsBuilt = true;
    connectInput(script.inputTexture);    
    connectOutput();
}

function onLoadingFinished(eventData){
    initML();

    if (script.lensModeController.realtime) {
        initEventForRealTime();
    }
}

function initEventForRealTime(){
    script.createEvent("UpdateEvent").bind(cropFaceRender);
}

function getInput(name){
    return script.mlComponent.getInput(name);
}

function getOutput(name){
    return script.mlComponent.getOutput(name);
}

function setCropFactor(factorSize){
    script.customCropScript.size.x = factorSize.x;
    script.customCropScript.size.y = factorSize.y;
    script.customCropScript.face_center_mouth_weight = factorSize.z;
}

function setSync(sync) {
    useSync = sync;
}

script.mlComponent.onLoadingFinished = onLoadingFinished;

script.initML = initML;
script.buildML = buildML;
script.waitML = waitML;
script.setInput = setInput;
script.cropFaceRender = cropFaceRender;
script.runImmediate = runImmediate;
script.show = show;
script.hide = hide;
script.getInput = getInput;
script.getOutput = getOutput;
script.mlComponent = script.mlComponent;
script.setCropFactor = setCropFactor;
script.setSync = setSync;