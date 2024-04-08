// @input Asset.MLAsset localAsset
// @input string cofRuleML
// @input string cofRuleFallback
// @input Component.ScriptComponent[] mlControllers
// @input vec3 cropFactor
// @input Component.ScriptComponent lensModeController
// @input SceneObject loadingSpinner

// @input string mlInputName

// @input bool useColorConstants = true
// @input Component.ScriptComponent shaderColorController {"showIf":"useColorConstants","hint":"Device Class"}
// @input bool useColorMetaData = true
// @input Component.ScriptComponent shaderController {"showIf":"useColorMetaData","hint":"Device Class"}
// @input bool useFallback = false
// @input bool useFallbackIos {"showIf":"useFallback","hint":"Fallback Ios"}
// @input bool useFallbackAndroid {"showIf":"useFallback","hint":"Fallback Android"}
// @input bool useFallbackVideo {"showIf":"useFallback","hint":"Fallback Video"}
// @input bool useFallbackML {"showIf":"useFallback","hint":"Fallback ML"}
// @input bool debugPrints = false
// @input bool timePrints = false

var buildTime = 0;
var startTime = getTime();
var mlControllersMax = script.mlControllers.length;
var usedAsset = {}

script.mlOutputNames = [];
script.mlPlaceholders = [];
script.onMLBuiltCallback = function() {}

if (script.loadingSpinner) {
    script.loadingSpinner.enabled = true;
}

if (!script.cofRuleML) script.cofRuleML = "no_rules";

var osType = global.deviceInfoSystem.getOS();
var defaultValue = true;

if (osType == OS.MacOS) {
    defaultValue = false;
}

if (global.assetSystem.downloadDeviceDependentAsset != null) {
    global.assetSystem.downloadDeviceDependentAsset(
        function(id, path, asset) {
            usedAsset = asset;
            getCofLensMode();
        },
        function(id) {
            print("Used local ml");
            usedAsset = script.localAsset;
            getCofLensMode();
        },
        script.cofRuleML
    );
}

function getCofLensMode(){
    if (script.useFallback) {
        global.ConfigurationReader.getBooleanAsync(script.cofRuleFallback, defaultValue, setLensMode);
    } else {
        setLensMode(false);
    }
}

function setLensMode(isFallback){
    if (isFallback) {
        if (osType == OS.iOS && !script.useFallbackIos) {
            isFallback = false;
        }
        if (osType == OS.Android && !script.useFallbackAndroid) {
            isFallback = false;
        }
    }

    if (script.timePrints) {
        print("Is Fallback - " + isFallback);
    }

    script.lensModeController.setLensMode(isFallback);
    
    utilizePrefab(usedAsset);
}

function utilizePrefab(asset) {   
    if (asset == null) {
        print("Failed - мodel not found");
        return;
    }
    
    if (asset.getTypeName() != "Asset.MLAsset") {
        print("Failed - мodel is broken");
        return;
    }

    for (var i = 0; i < mlControllersMax; i++) {
        script.mlControllers[i].setCropFactor(script.cropFactor);
        script.mlControllers[i].mlComponent.model = asset;
    }

    var modelName = script.mlControllers[0].mlComponent.model.name;

    for (var i = 0; i < mlControllersMax; i++) {
        script.mlOutputNames = initModelComponent(script.mlControllers[i].mlComponent);
    }

    if (script.useColorConstants){
        script.shaderColorController.setMaterialsColor(modelName);
    }

    if (script.timePrints) {
        print("Model name - " + modelName);
    }

    buildMLs();
}

function buildMLs(){
    if (!script.lensModeController.realtime) {
        script.createEvent("SnapImageCaptureEvent").bind(takeSnapOnLow);
        script.createEvent("SnapRecordStartEvent").bind(takeVideoOnLow);
    }

    for (var i = 0; i < mlControllersMax; i++){
        if (script.lensModeController.realtime || script.useFallbackML) {
            script.mlControllers[i].buildML();
        } else {
            waitingForBuildID.enabled = false;
            if (script.loadingSpinner) {
                script.loadingSpinner.enabled = false;
            }
        }
    }

    if (script.timePrints) {
        buildTime = getTime();
    }
    
    var modelName = script.mlControllers[0].mlComponent.model.name;
    script.onMLBuiltCallback(modelName);
}

function initModelComponent(mlComponent){
    var inputs = mlComponent.getInputs();
    var outputs = mlComponent.getOutputs();
    var outputNames = [];

    var placeholders = [];
    if (script.debugPrints) {
        print("Inputs = " + inputs.length);
    }

    for (var i = 0; i < inputs.length; i++) {
        if (script.debugPrints) {
            print(inputs[i].name + inputs[i].shape);
        }
        placeholders.push( createInput(inputs[i].name, inputs[i].shape) );
    }

    if (script.debugPrints) {
        print("Outputs = " + outputs.length);
    }
    for (var i = 0; i < outputs.length; i++) {
        var dataType = MachineLearning.OutputMode.Texture;
        if (outputs[i].shape.z > 4) {
            dataType = MachineLearning.OutputMode.Data;
        }
        if (script.debugPrints) {
            print(outputs[i].name + " " + outputs[i].shape + " " + dataType);
        }
        outputNames.push(outputs[i].name);
        placeholders.push( createOutput(outputs[i].name, outputs[i].shape, dataType) );
    }

    script.mlPlaceholders.push(placeholders);
    return outputNames;
}

function takeVideoOnLow(){
    if (!script.useFallbackVideo) {
        takeSnapOnLow();
        global.snapRecordingSystem.stopSnapRecording();
    }
}

function takeSnapOnLow(){
    if (script.useFallbackML) {
        for (var i = 0; i < mlControllersMax; i++){
            if (!script.mlControllers[i].mlControllerIsBuilt) {
                script.mlControllers[i].buildML();
            }
        }
        
        for (var i = 0; i < mlControllersMax; i++){
            if (!script.mlControllers[i].mlControllerIsBuilt) {
                script.mlControllers[i].waitML();
                script.mlControllers[i].initML();
            }
        }
        
        for (var i = 0; i < mlControllersMax; i++){
            script.mlControllers[i].cropFaceRender();
        }
    }
}

function createInput(name, vector) {
    var condBuilder = MachineLearning.createInputBuilder();
        condBuilder.setName(name);
        condBuilder.setShape(vector);
    return condBuilder.build();
}

function createOutput(name, vector, type){
    var outputBuilder = MachineLearning.createOutputBuilder();
    outputBuilder.setName(name);
    outputBuilder.setShape(vector);
    outputBuilder.setOutputMode(type);
    return outputBuilder.build();
}

function waitingForBuild(){
    for (var i = 0; i < mlControllersMax; i++){
        if (script.mlControllers[i].mlControllerIsBuilt == false) return;
    }
    
    if (script.timePrints) {
        var dbTime = Math.floor((getTime() - buildTime) * 1000) / 1000;
        var dsTime = Math.floor((getTime() - startTime) * 1000) / 1000;
        print("Start time - " + dsTime + ", Build time - " + dbTime);
    }
    
    if (script.useColorMetaData) {
        script.shaderController.setShaderFromSettings(usedAsset.getMetadata());
    }

    if (script.loadingSpinner) {
        script.loadingSpinner.enabled = false;
    }
    
    waitingForBuildID.enabled = false;
}

var waitingForBuildID = script.createEvent("UpdateEvent");
waitingForBuildID.bind(waitingForBuild);