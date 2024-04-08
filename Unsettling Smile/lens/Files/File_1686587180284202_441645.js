// @input SceneObject[] realtimeList
// @input SceneObject[] fallbackList

// @input SceneObject[] syncDisableList

script.realtime = false;
script.sync = false;

function setLensMode(isFallback){
    if (isFallback) {
        script.realtimeList.forEach(disable);
        script.fallbackList.forEach(enable);
    } else {
        script.realtime = true;
        script.realtimeList.forEach(enable);
        script.fallbackList.forEach(disable);
    }
}

function setSync(isSync) {
    script.sync = isSync;
    if (isSync) {
        script.syncDisableList.forEach(disable);
    }
}

function enable(so) {
    so.enabled = true;
}
function disable(so) {
    so.enabled = false;
}

script.setLensMode = setLensMode;
script.setSync = setSync;