// @input Component.MLComponent[] mlComponents
// @input Component.ScriptComponent[] mlController
// @input string mlInputName
// @input int inputSize
// @input int conditionValue
// @input vec2 baseValues

// @input Component.Image startVFX
// @input Component.Image retryButton
// @input float transitionFrames

// @input Component.ScriptComponent resetButtonTapScript
// @input Component.InteractionComponent fullScreenInteractionComp
// @input bool isMaleFirst

var inputPlaceholder = [];
var initOnce = false;

var n_cond = script.inputSize;  // change to your number of conditions
var startId = 0;
var id = startId;
var blockTransitions = false;
var transitionCoef = 0.0;
var retryButtonAlpha = 0.0;
var alphaDt = -0.1;
var blockTouch = true;

var pause = 1.0;
var coef = 0;
var ifMaleShift = (script.isMaleFirst) ? 6 : 0;

script.fullScreenInteractionComp.isFilteredByDepth = true;
script.fullScreenInteractionComp.onTap.add(function() {
    ifMaleShift = (ifMaleShift == 0) ? 6 : 0;
    print(ifMaleShift);
});

function pauseAfterTime() {
    pauseTrans();
    retryButtonShown.reset(0.5);
}

function getInput() {
    try {
        script.mlComponents.forEach(function (ml) {
            inputPlaceholder.push(ml.getInput("cond"));
        });
    } catch (e) {
        print(e);
        return;
    }
}

function waitingForBuild() {
    var isBuilt = true;
    script.mlComponents.forEach(function (ml) {
        if (ml.state != MachineLearning.ModelState.Idle) {
            isBuilt = false;
        }
    });
    if (!isBuilt) return;
    if (!initOnce) {
        initOnce = true
        init()
    }
    waitingForBuildID.enabled = false;

    getInput();
}
var waitingForBuildID = script.createEvent("UpdateEvent");
waitingForBuildID.bind(waitingForBuild);


function init() {
    resumeTrans();
}

function updateCond(lerpValue) {
    var newValueX = script.baseValues.x * (1.0 - lerpValue) + script.baseValues.y * lerpValue;

    var arr = [];
    for (var i = 0; i < n_cond*2; i++) {
        arr.push(0);
    }

    arr[id + ifMaleShift] = 1.0 - newValueX;
    arr[(id + 1) % n_cond + ifMaleShift] = newValueX;
    cond = new Float32Array(arr);
    
    inputPlaceholder.forEach(function (item) {
        item.data.set(cond);
    })
}

var retryButtonShown = script.createEvent("DelayedCallbackEvent")
retryButtonShown.bind(function () {
    alphaDt = 0.1;
    blockTouch = false;
});

script.createEvent("UpdateEvent").bind(function () {
    coef += pause;
    coef = Math.min(coef, script.transitionFrames);
    coef = Math.max(coef, 0);
    if (coef == script.transitionFrames) {
        id++;
        if (id == (n_cond - 2)) { pauseAfterTime(); }
        id %= n_cond;
        coef = 0.0;
        if (blockTransitions) {
            pause = 0.0;
        }
    }
    updateCond(coef / script.transitionFrames);
    retryButtonAlpha += alphaDt;
    retryButtonAlpha = Math.max(0.0, retryButtonAlpha);
    retryButtonAlpha = Math.min(1.0, retryButtonAlpha);
    script.retryButton.mainPass.baseColor = new vec4(1.0, 1.0, 1.0, retryButtonAlpha);

})

script.createEvent("SnapRecordStartEvent").bind(resumeTrans);
script.createEvent("SnapImageCaptureEvent").bind(pauseTrans);

function onTapped(eventData) {
    if (!blockTouch) {
        alphaDt = -0.1;
        blockTouch = true;
        resumeTrans();
        id = startId;
    }
}

function pauseTrans() {
    blockTransitions = true;
}

function resumeTrans() {
    blockTransitions = false;
    pause = 1.0;
}

function isPaused() {
    return blockTransitions;
}

script.resetButtonTapScript.setOnTapCallback(onTapped);
