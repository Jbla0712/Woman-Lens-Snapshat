// @input Asset.MLAsset localAsset
// @input string cofRuleML
// @input Component.ScriptComponent[] mlControllers
// @input vec3 cropFactor
// @input Component.ScriptComponent lensModeController
// @input Component.ScriptComponent conditionController
// @input SceneObject loadingSpinner

// @input string mlInputName

//@ui {"widget":"group_start","label":"Color constants"}
// @input bool useColorConstants = true
// @input Component.ScriptComponent shaderColorController {"showIf":"useColorConstants","hint":"Device Class"}
// @input bool useColorMetaData = true
// @input Component.ScriptComponent shaderController {"showIf":"useColorMetaData","hint":"Device Class"}
//@ui {"widget":"group_end"}

//@ui {"widget":"group_start","label":"Fallback Config"}
// @input bool useFallback = false {"label":"Enable all"}
//@ui {"widget":"group_start", "label":"IOs", "showIf":"useFallback"}
// @input bool useFallbackIos {"label":"Enable"}
// @input int fallbackIOs {"label":"Claster value"}
//@ui {"widget":"group_end"}
//@ui {"widget":"group_start","label":"Android", "showIf":"useFallback"}
// @input bool useFallbackAndroid {"label":"Enable"}
// @input int fallbackAndroid {"label":"Claster value"}
//@ui {"widget":"group_end"}
// @input bool useFallbackVideo {"showIf":"useFallback", "label":"Video, no ML"}
// @input bool useFallbackML {"showIf":"useFallback", "label":"ML effect"}
//@ui {"widget":"group_end"}

// @input bool debugPrints = false
// @input bool timePrints = false

// @input bool debugTestUCO = false

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

var useSync = false;
if (global.deviceInfoSystem.isEditor() && script.debugTestUCO) {
    useSync = true;
} else {
    // Check if the entrypoint API is available
    if (LensEntryPoint.PostCapturePreview !== undefined && LensEntryPoint.PostCaptureTranscoding !== undefined) {
        var entryPoint = global.scene.getLensEntryPoint();
        if (entryPoint == LensEntryPoint.PostCapturePreview || entryPoint == LensEntryPoint.PostCaptureTranscoding) {
            useSync = true;
        }
    }
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

function requireDeviceCluster(callback) {
    global.ConfigurationReader.getStringAsync("LENSCORE_GET_DEVICE_CLUSTER", "-1", callback);
}

function requireGpuCluster(callback) {
    global.ConfigurationReader.getStringAsync("LENSCORE_GET_GPU_CLUSTER", "-1", callback);
}

function getCofLensMode(){
    if (useSync) {
        updateSyncMode(true);
        setLensMode(false);
    } else if (script.useFallback) {
        if (global.deviceInfoSystem.getOS() == OS.iOS && script.useFallbackIos) {
            requireDeviceCluster(function(cluster) {
                deviceCluster = parseInt(cluster);
                print("IOs claster from COF - " + deviceCluster + ", " + script.fallbackIOs);
                setLensMode(deviceCluster <= script.fallbackIOs);
            });
        } else if (global.deviceInfoSystem.getOS() == OS.Android && script.useFallbackAndroid) {
            requireGpuCluster(function(cluster) {
                gpuCluster = parseInt(cluster);
                print("Android claster from COF - " + gpuCluster + ", " + script.fallbackAndroid);
                setLensMode(gpuCluster <= script.fallbackAndroid);
            });
        } else {
            setLensMode(false);
        }
    } else {
        setLensMode(false);
    }
}

function updateSyncMode(isSync) {
    script.lensModeController.setSync(isSync);

    for (var i = 0; i < mlControllersMax; i++) {
        script.mlControllers[i].setSync(isSync);
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
    
    if (asset.getMetadata().isFallback == true) {
        print("Empty Model is downloaded, skiping model manager configuring");
        if (script.loadingSpinner) {
            script.loadingSpinner.enabled = false;
        }    
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

    if (useSync) {
        waitingForBuild();
    }

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
        if (waitingForBuildID.enabled) {
            return;
        }        
        
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

    if (useSync) {
        for (var i = 0; i < mlControllersMax; i++){
            script.mlControllers[i].cropFaceRender();
        }
        if (script.conditionController && script.conditionController.waitingForBuild) {
            script.conditionController.waitingForBuild();
        }
    }

    if (script.loadingSpinner) {
        script.loadingSpinner.enabled = false;
    }
    
    waitingForBuildID.enabled = false;

    var modelName = script.mlControllers[0].mlComponent.model.name;
    script.onMLBuiltCallback(modelName);
}

var waitingForBuildID = script.createEvent("UpdateEvent");
waitingForBuildID.bind(waitingForBuild);

script.takeSnapOnLow = takeSnapOnLow;
