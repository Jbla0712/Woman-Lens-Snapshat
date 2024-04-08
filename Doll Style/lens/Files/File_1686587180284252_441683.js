// @input Component.MLComponent[] mlComponents
// @input SceneObject[] mlControllers
// @input string mlInputName
// @input int inputSize
// @input int conditionValue
// @input Asset.Material transitionMat
// @input Asset.Material transitionMat2
// @input SceneObject[] faceEffects

var inputPlaceholder = [];
var vibroOneTime = true
var hintComponent = script.getSceneObject().createComponent("Component.HintsComponent")
var firstTime = true

function getInput(){
    try {
        script.mlComponents.forEach(function(ml) {
            inputPlaceholder.push(ml.getInput("cond"));
        });
    } catch (e) {
        print(e);
        return;
    }
}

function setCondition(newState){
    var arr = []
    for (var i = 0; i < script.inputSize; i++) {
        if (i == newState) {
            arr.push(1);
        } else {
            arr.push(0);
        }
    }
    cond = new Float32Array(arr);

    inputPlaceholder.forEach(function(input) {
        input.data.set(cond);
    });
}

function waitingForBuild(){
    touchStartEvt.enabled = true
    var isBuilt = true;
    script.mlComponents.forEach(function(ml) {
        if (ml.state != MachineLearning.ModelState.Idle) {
            isBuilt = false;
        }
    });
    if (!isBuilt) return;

    waitingForBuildID.enabled = false;

    getInput();

    if (script.conditionValue < 1) {
        script.conditionValue = 1;
    } 
    if (script.conditionValue > script.inputSize) {
        script.conditionValue = script.inputSize;
    } 
//    setCondition(script.conditionValue - 1);
    var delayedCllback = script.createEvent("DelayedCallbackEvent")
    delayedCllback.bind(touchAction)
    delayedCllback.reset(0.5)
    script.mlControllers.forEach(function(item){
        item.enabled = false
    })
    script.faceEffects.forEach(function(item){
        item.enabled = true
    })
//    touchAction()
}

var value = 0.0
var speed = 0.0
var currState = 1
var newState = 1
var touchStartEvt = script.createEvent("TouchStartEvent")
touchStartEvt.enabled = false

script.createEvent("UpdateEvent").bind(function(){
    value += speed
    value = Math.max(value, 0.0)
    value = Math.min(value, 1.0)
    if ((value >= 0.2)){
        if (vibroOneTime){
            global.hapticFeedbackSystem.hapticFeedback(HapticFeedbackType.Vibration)
            vibroOneTime = false
        }
        currState = newState
        if (currState == 1){
            script.mlControllers.forEach(function(item){
            item.enabled = false
            })
            script.faceEffects.forEach(function(item){
                item.enabled = true
            })
        }
        else{
            script.mlControllers.forEach(function(item){
            item.enabled = true
        })
            script.faceEffects.forEach(function(item){
            item.enabled = false
            })
        }
//        print(currState + " ")
//        setCondition(currState)
    }
    if (value == 1.0){
        if (firstTime){
            hintComponent.showHint("lens_hint_tap", 2.5)
            firstTime = false
        }
        touchStartEvt.enabled = true
        value = 0.0
        speed = 0.0
    }
    script.transitionMat.mainPass.transition = value
    script.transitionMat2.mainPass.transition = value
})
function touchAction(){
    vibroOneTime = true
    speed = 0.05
    newState = 1 - currState
    touchStartEvt.enabled = false
}
touchStartEvt.bind(touchAction)

var waitingForBuildID = script.createEvent("UpdateEvent");
waitingForBuildID.bind(waitingForBuild);