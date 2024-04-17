// @input SceneObject[] realtimeList
// @input SceneObject[] fallbackList

script.realtime = false;

function setLensMode(isFallback){
    isFallback = false;

    if (isFallback) {
        script.realtimeList.forEach(disable);
        script.fallbackList.forEach(enable);
    } else {
        script.realtime = true;
        script.realtimeList.forEach(enable);
        script.fallbackList.forEach(disable);
    }
}

function enable(so) {
    so.enabled = true;
}
function disable(so) {
    so.enabled = false;
}

script.setLensMode = setLensMode;