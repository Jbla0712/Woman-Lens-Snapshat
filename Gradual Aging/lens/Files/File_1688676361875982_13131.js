// @input Asset.Material[] materials
// @input bool useWarping

function setColor(warpMaterial, colorMax, colorMin) {
    warpMaterial.mainPass.colorMax = colorMax;
    warpMaterial.mainPass.colorMin = colorMin;
}

function setWarp(warpMaterial, warpMax, warpMin) {
    warpMaterial.mainPass.warpMax = warpMax;
    warpMaterial.mainPass.warpMin = warpMin;
}

function setShaderFromSettings (settings) {
    var rgba_stats = settings.rgba_stats;
    var warp_stats = settings.source_warp_stats;
    
    script.materials.forEach(function(warpMaterial) {
        var colorMax = new vec4(rgba_stats.r_max, rgba_stats.g_max, rgba_stats.b_max, rgba_stats.a_max);
        var colorMin = new vec4(rgba_stats.r_min, rgba_stats.g_min, rgba_stats.b_min, rgba_stats.a_min);
        setColor(warpMaterial, colorMax, colorMin);
    });

    if (script.useWarping){
        script.materials.forEach(function(warpMaterial) {
            var warpMax = new vec4(warp_stats.x_max, warp_stats.y_max, 0, 0);
            var warpMin = new vec4(warp_stats.x_min, warp_stats.y_min, 0, 0);
            setWarp(warpMaterial, warpMax, warpMin);
        });  
    }
};

script.setShaderFromSettings = setShaderFromSettings;