// -----JS CODE-----
const EMPTY_CALLBACK = function(){};

var onTapCallback = EMPTY_CALLBACK;

const tapEvent = script.createEvent("TapEvent");
tapEvent.bind(function() {
    onTapCallback();
});

script.setOnTapCallback = function(cb) {
    onTapCallback = cb || EMPTY_CALLBACK;
}

script.getSceneObject().getComponent("InteractionComponent").isFilteredByDepth = true;