// @input Asset.Material[] warpMaterials
// @input Asset.BinAsset[] colorDataJSON

var mlNames = [];

function getJSONFileName(path){
    var name = path.split("/");
    name = name[name.length - 1];
    name = name.split(".");
    return name[0];
}

function fillMlNamesArray(){
    script.colorDataJSON.forEach(function(item){
        mlNames.push(getJSONFileName(item.name));
    });
}

fillMlNamesArray();

function getMLTypeIndex(mlPath){
    for (var i = 0; i < mlNames.length; i++){
        if (mlPath.search(mlNames[i]) >= 0) {
            return i;
        }
    }
    return -1;
}

function setMaterialsColor(mlPath){
    var mlIndex = getMLTypeIndex(mlPath);
    for (var i = 0; i < script.warpMaterials.length; i++) {
        switchParameters(mlIndex, script.warpMaterials[i]);
    }
}

function switchParameters(index, warpMaterial) {
    var c = JSON.parse(script.colorDataJSON[index].readText()).rgba_stats;
    var w = JSON.parse(script.colorDataJSON[index].readText()).source_warp_stats;

    var colorMax = new vec4(c.r_max, c.g_max, c.b_max, c.a_max);
    var colorMin = new vec4(c.r_min, c.g_min, c.b_min, c.a_min);
    var warpMax = new vec4(w.x_max, w.y_max, 1.0, 1.0);
    var warpMin = new vec4(w.x_min, w.y_min, 1.0, 1.0);

    setColor(warpMaterial, colorMax, colorMin);
    setWarp(warpMaterial, warpMax, warpMin);
}

function setColor(warpMaterial, colorMax, colorMin){
    warpMaterial.mainPass.colorMax = colorMax;
    warpMaterial.mainPass.colorMin = colorMin;
}

function setWarp(warpMaterial, warpMax, warpMin){
    warpMaterial.mainPass.warpMax = warpMax;
    warpMaterial.mainPass.warpMin = warpMin;
}

script.setMaterialsColor = setMaterialsColor;