// -----JS CODE-----
//@input Asset.Texture inputTexture
//@input float alpha {"widget": "slider", "min": 0.0, "max": 2.0, "step": 0.01}
//@input int GaussRenderLayer = 10 {"hint":"render layer for first pass, should not overlap with anything in scene"}
//@input bool advancedSetup
//@input Asset.Material blurPass1 {"showIf":"advancedSetup","hint":"material for first pass"}
//@input Asset.Material blurPass2 {"showIf":"advancedSetup","hint":"material for second pass"}
//@input Asset.Material smooth {"showIf":"advancedSetup","hint":"material for 3rd pass"}

function createCameraToRenderLayer(layerId) {
    var camera = script.getSceneObject().createComponent('Camera');
    camera.renderLayer = LayerSet.fromNumber(layerId);
    return camera;
}

function createMeshForPass(layerId, material, renderOrder) {
    var meshSceneObj = scene.createSceneObject("");
    meshSceneObj.setRenderLayer(layerId);
    var mesh = meshSceneObj.createComponent("PostEffectVisual");
    mesh.mainMaterial = material;
    mesh.setRenderOrder(renderOrder);
    return mesh;
}

// construct meshes
var mesh1 = createMeshForPass(script.GaussRenderLayer, script.blurPass1, 0);
var mesh2 = createMeshForPass(script.GaussRenderLayer, script.blurPass2, 1);

// internal texture for communication between passes
var gaussTextureProvider = scene.createResourceProvider('RenderTargetProvider');
gaussTextureProvider.useScreenResolution = false;
gaussTextureProvider.resolution = new vec2(90, 160);
gaussTextureProvider.inputTexture = script.inputTexture;

// render target
var intTexture = assetSystem.createAsset('Texture');
intTexture.control = gaussTextureProvider;

// Camera for downsample
var gaussCam = createCameraToRenderLayer(script.GaussRenderLayer);
gaussCam.renderTarget = intTexture;
gaussCam.renderOrder = -1;

script.smooth.mainPass.inputTexture = script.inputTexture;
script.smooth.mainPass.gaussTexture = intTexture;
script.smooth.mainPass.alpha = script.alpha;