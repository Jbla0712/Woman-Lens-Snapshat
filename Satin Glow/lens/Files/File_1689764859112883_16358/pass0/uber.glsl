#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//attribute vec4 color 18
//sampler sampler colorTexSmpSC 2:17
//sampler sampler inputTexSmpSC 2:18
//sampler sampler intensityTextureSmpSC 2:19
//sampler sampler opacityTexSmpSC 2:20
//sampler sampler sc_OITCommonSampler 2:21
//sampler sampler screenTexSmpSC 2:22
//sampler sampler texWarpSmpSC 2:24
//texture texture2D colorTex 2:1:2:17
//texture texture2D inputTex 2:2:2:18
//texture texture2D intensityTexture 2:3:2:19
//texture texture2D opacityTex 2:4:2:20
//texture texture2D sc_OITAlpha0 2:5:2:21
//texture texture2D sc_OITAlpha1 2:6:2:21
//texture texture2D sc_OITDepthHigh0 2:7:2:21
//texture texture2D sc_OITDepthHigh1 2:8:2:21
//texture texture2D sc_OITDepthLow0 2:9:2:21
//texture texture2D sc_OITDepthLow1 2:10:2:21
//texture texture2D sc_OITFilteredDepthBoundsTexture 2:11:2:21
//texture texture2D sc_OITFrontDepthTexture 2:12:2:21
//texture texture2D screenTex 2:13:2:22
//texture texture2D texWarp 2:14:2:24
//SG_REFLECTION_END
#if defined VERTEX_SHADER
#if 0
NGS_BACKEND_SHADER_FLAGS_BEGIN__
NGS_BACKEND_SHADER_FLAGS_END__
#endif
#include <std2.glsl>
#include <std2_vs.glsl>
#include <std2_texture.glsl>
#include <std2_receiver.glsl>
#include <std2_fs.glsl>
uniform vec4 intensityTextureDims;
uniform vec4 screenTexDims;
uniform vec4 alphaTexDims;
uniform vec4 texWarpOutDims;
uniform vec4 texWarpDims;
uniform vec4 inputTexDims;
uniform vec4 colorTexDims;
uniform vec4 opacityTexDims;
uniform int overrideTimeEnabled;
uniform float overrideTimeElapsed;
uniform float overrideTimeDelta;
uniform float correctedIntensity;
uniform vec4 intensityTextureSize;
uniform vec4 intensityTextureView;
uniform mat3 intensityTextureTransform;
uniform vec4 intensityTextureUvMinMax;
uniform vec4 intensityTextureBorderColor;
uniform float reflBlurWidth;
uniform float reflBlurMinRough;
uniform float reflBlurMaxRough;
uniform float alphaTestThreshold;
uniform vec4 screenTexSize;
uniform vec4 screenTexView;
uniform mat3 screenTexTransform;
uniform vec4 screenTexUvMinMax;
uniform vec4 screenTexBorderColor;
uniform vec4 alphaTexSize;
uniform vec4 alphaTexView;
uniform mat3 alphaTexTransform;
uniform vec4 alphaTexUvMinMax;
uniform vec4 alphaTexBorderColor;
uniform vec4 texWarpOutSize;
uniform vec4 texWarpOutView;
uniform mat3 texWarpOutTransform;
uniform vec4 texWarpOutUvMinMax;
uniform vec4 texWarpOutBorderColor;
uniform vec4 wrapOutMax;
uniform vec4 wrapOutMin;
uniform vec4 texWarpSize;
uniform vec4 texWarpView;
uniform mat3 texWarpTransform;
uniform vec4 texWarpUvMinMax;
uniform vec4 texWarpBorderColor;
uniform vec4 warpMax;
uniform vec4 warpMin;
uniform float warp_intensity;
uniform vec3 alphaMax;
uniform vec3 alphaMin;
uniform vec4 inputTexSize;
uniform vec4 inputTexView;
uniform mat3 inputTexTransform;
uniform vec4 inputTexUvMinMax;
uniform vec4 inputTexBorderColor;
uniform float Tweak_N110;
uniform vec4 colorTexSize;
uniform vec4 colorTexView;
uniform mat3 colorTexTransform;
uniform vec4 colorTexUvMinMax;
uniform vec4 colorTexBorderColor;
uniform vec4 colorMax;
uniform vec4 colorMin;
uniform float textureintensity;
uniform vec4 opacityTexSize;
uniform vec4 opacityTexView;
uniform mat3 opacityTexTransform;
uniform vec4 opacityTexUvMinMax;
uniform vec4 opacityTexBorderColor;
uniform float overallintensity;
uniform float depthRef;
varying vec4 varColor;
attribute vec4 color;
void ngsVertexShaderEnd(inout sc_Vertex_t v,vec3 WorldPosition,vec3 WorldNormal,vec3 WorldTangent,vec4 ScreenPosition)
{
varPos=WorldPosition;
varNormal=normalize(WorldNormal);
vec3 l9_0=normalize(WorldTangent);
varTangent=vec4(l9_0.x,l9_0.y,l9_0.z,varTangent.w);
varTangent.w=tangent.w;
#if (UseViewSpaceDepthVariant&&((sc_OITDepthGatherPass||sc_OITCompositingPass)||sc_OITDepthBoundsPass))
{
varViewSpaceDepth=-sc_ObjectToView(v.position).z;
}
#endif
vec4 l9_1;
#if (sc_RenderingSpace==3)
{
l9_1=ScreenPosition;
}
#else
{
vec4 l9_2;
#if (sc_RenderingSpace==4)
{
l9_2=(sc_ModelViewMatrixArray[sc_GetStereoViewIndex()]*v.position)*vec4(1.0/sc_Camera.aspect,1.0,1.0,1.0);
}
#else
{
vec4 l9_3;
#if (sc_RenderingSpace==2)
{
l9_3=sc_ViewProjectionMatrixArray[sc_GetStereoViewIndex()]*vec4(varPos,1.0);
}
#else
{
vec4 l9_4;
#if (sc_RenderingSpace==1)
{
l9_4=sc_ViewProjectionMatrixArray[sc_GetStereoViewIndex()]*vec4(varPos,1.0);
}
#else
{
l9_4=vec4(0.0);
}
#endif
l9_3=l9_4;
}
#endif
l9_2=l9_3;
}
#endif
l9_1=l9_2;
}
#endif
varPackedTex=vec4(v.texture0,v.texture1);
#if (sc_ProjectiveShadowsReceiver)
{
varShadowTex=getProjectedTexCoords(v.position);
}
#endif
sc_SetClipPosition(applyDepthAlgorithm(l9_1));
}
void main()
{
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
sc_BlendVertex(l9_0);
sc_SkinVertex(l9_0);
sc_Vertex_t l9_1=l9_0;
#if (sc_RenderingSpace==3)
{
varPos=vec3(0.0);
varNormal=l9_1.normal;
varTangent=vec4(l9_1.tangent.x,l9_1.tangent.y,l9_1.tangent.z,varTangent.w);
}
#else
{
#if (sc_RenderingSpace==4)
{
varPos=vec3(0.0);
varNormal=l9_1.normal;
varTangent=vec4(l9_1.tangent.x,l9_1.tangent.y,l9_1.tangent.z,varTangent.w);
}
#else
{
#if (sc_RenderingSpace==2)
{
varPos=l9_1.position.xyz;
varNormal=l9_1.normal;
varTangent=vec4(l9_1.tangent.x,l9_1.tangent.y,l9_1.tangent.z,varTangent.w);
}
#else
{
#if (sc_RenderingSpace==1)
{
varPos=(sc_ModelMatrix*l9_1.position).xyz;
varNormal=sc_NormalMatrix*l9_1.normal;
vec3 l9_2=sc_NormalMatrix*l9_1.tangent;
varTangent=vec4(l9_2.x,l9_2.y,l9_2.z,varTangent.w);
}
#endif
}
#endif
}
#endif
}
#endif
varColor=color;
vec3 l9_3=varPos;
vec3 l9_4=varNormal;
sc_Vertex_t param=l9_1;
ngsVertexShaderEnd(param,l9_3,l9_4,varTangent.xyz,l9_1.position);
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#if 0
NGS_BACKEND_SHADER_FLAGS_BEGIN__
NGS_BACKEND_SHADER_FLAGS_END__
#endif
#include <std2.glsl>
#include <std2_vs.glsl>
#include <std2_texture.glsl>
#include <std2_receiver.glsl>
#include <std2_fs.glsl>
struct ssGlobals
{
float gTimeElapsed;
float gTimeDelta;
float gTimeElapsedShifted;
vec2 gScreenCoord;
vec2 Surface_UVCoord0;
};
#ifndef intensityTextureHasSwappedViews
#define intensityTextureHasSwappedViews 0
#elif intensityTextureHasSwappedViews==1
#undef intensityTextureHasSwappedViews
#define intensityTextureHasSwappedViews 1
#endif
#ifndef intensityTextureLayout
#define intensityTextureLayout 0
#endif
#ifndef BLEND_MODE_REALISTIC
#define BLEND_MODE_REALISTIC 0
#elif BLEND_MODE_REALISTIC==1
#undef BLEND_MODE_REALISTIC
#define BLEND_MODE_REALISTIC 1
#endif
#ifndef BLEND_MODE_FORGRAY
#define BLEND_MODE_FORGRAY 0
#elif BLEND_MODE_FORGRAY==1
#undef BLEND_MODE_FORGRAY
#define BLEND_MODE_FORGRAY 1
#endif
#ifndef BLEND_MODE_NOTBRIGHT
#define BLEND_MODE_NOTBRIGHT 0
#elif BLEND_MODE_NOTBRIGHT==1
#undef BLEND_MODE_NOTBRIGHT
#define BLEND_MODE_NOTBRIGHT 1
#endif
#ifndef BLEND_MODE_DIVISION
#define BLEND_MODE_DIVISION 0
#elif BLEND_MODE_DIVISION==1
#undef BLEND_MODE_DIVISION
#define BLEND_MODE_DIVISION 1
#endif
#ifndef BLEND_MODE_BRIGHT
#define BLEND_MODE_BRIGHT 0
#elif BLEND_MODE_BRIGHT==1
#undef BLEND_MODE_BRIGHT
#define BLEND_MODE_BRIGHT 1
#endif
#ifndef BLEND_MODE_INTENSE
#define BLEND_MODE_INTENSE 0
#elif BLEND_MODE_INTENSE==1
#undef BLEND_MODE_INTENSE
#define BLEND_MODE_INTENSE 1
#endif
#ifndef SC_USE_UV_TRANSFORM_intensityTexture
#define SC_USE_UV_TRANSFORM_intensityTexture 0
#elif SC_USE_UV_TRANSFORM_intensityTexture==1
#undef SC_USE_UV_TRANSFORM_intensityTexture
#define SC_USE_UV_TRANSFORM_intensityTexture 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_intensityTexture
#define SC_SOFTWARE_WRAP_MODE_U_intensityTexture -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_intensityTexture
#define SC_SOFTWARE_WRAP_MODE_V_intensityTexture -1
#endif
#ifndef SC_USE_UV_MIN_MAX_intensityTexture
#define SC_USE_UV_MIN_MAX_intensityTexture 0
#elif SC_USE_UV_MIN_MAX_intensityTexture==1
#undef SC_USE_UV_MIN_MAX_intensityTexture
#define SC_USE_UV_MIN_MAX_intensityTexture 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_intensityTexture
#define SC_USE_CLAMP_TO_BORDER_intensityTexture 0
#elif SC_USE_CLAMP_TO_BORDER_intensityTexture==1
#undef SC_USE_CLAMP_TO_BORDER_intensityTexture
#define SC_USE_CLAMP_TO_BORDER_intensityTexture 1
#endif
#ifndef BLEND_MODE_LIGHTEN
#define BLEND_MODE_LIGHTEN 0
#elif BLEND_MODE_LIGHTEN==1
#undef BLEND_MODE_LIGHTEN
#define BLEND_MODE_LIGHTEN 1
#endif
#ifndef BLEND_MODE_DARKEN
#define BLEND_MODE_DARKEN 0
#elif BLEND_MODE_DARKEN==1
#undef BLEND_MODE_DARKEN
#define BLEND_MODE_DARKEN 1
#endif
#ifndef BLEND_MODE_DIVIDE
#define BLEND_MODE_DIVIDE 0
#elif BLEND_MODE_DIVIDE==1
#undef BLEND_MODE_DIVIDE
#define BLEND_MODE_DIVIDE 1
#endif
#ifndef BLEND_MODE_AVERAGE
#define BLEND_MODE_AVERAGE 0
#elif BLEND_MODE_AVERAGE==1
#undef BLEND_MODE_AVERAGE
#define BLEND_MODE_AVERAGE 1
#endif
#ifndef BLEND_MODE_SUBTRACT
#define BLEND_MODE_SUBTRACT 0
#elif BLEND_MODE_SUBTRACT==1
#undef BLEND_MODE_SUBTRACT
#define BLEND_MODE_SUBTRACT 1
#endif
#ifndef BLEND_MODE_DIFFERENCE
#define BLEND_MODE_DIFFERENCE 0
#elif BLEND_MODE_DIFFERENCE==1
#undef BLEND_MODE_DIFFERENCE
#define BLEND_MODE_DIFFERENCE 1
#endif
#ifndef BLEND_MODE_NEGATION
#define BLEND_MODE_NEGATION 0
#elif BLEND_MODE_NEGATION==1
#undef BLEND_MODE_NEGATION
#define BLEND_MODE_NEGATION 1
#endif
#ifndef BLEND_MODE_EXCLUSION
#define BLEND_MODE_EXCLUSION 0
#elif BLEND_MODE_EXCLUSION==1
#undef BLEND_MODE_EXCLUSION
#define BLEND_MODE_EXCLUSION 1
#endif
#ifndef BLEND_MODE_OVERLAY
#define BLEND_MODE_OVERLAY 0
#elif BLEND_MODE_OVERLAY==1
#undef BLEND_MODE_OVERLAY
#define BLEND_MODE_OVERLAY 1
#endif
#ifndef BLEND_MODE_SOFT_LIGHT
#define BLEND_MODE_SOFT_LIGHT 0
#elif BLEND_MODE_SOFT_LIGHT==1
#undef BLEND_MODE_SOFT_LIGHT
#define BLEND_MODE_SOFT_LIGHT 1
#endif
#ifndef BLEND_MODE_HARD_LIGHT
#define BLEND_MODE_HARD_LIGHT 0
#elif BLEND_MODE_HARD_LIGHT==1
#undef BLEND_MODE_HARD_LIGHT
#define BLEND_MODE_HARD_LIGHT 1
#endif
#ifndef BLEND_MODE_COLOR_DODGE
#define BLEND_MODE_COLOR_DODGE 0
#elif BLEND_MODE_COLOR_DODGE==1
#undef BLEND_MODE_COLOR_DODGE
#define BLEND_MODE_COLOR_DODGE 1
#endif
#ifndef BLEND_MODE_COLOR_BURN
#define BLEND_MODE_COLOR_BURN 0
#elif BLEND_MODE_COLOR_BURN==1
#undef BLEND_MODE_COLOR_BURN
#define BLEND_MODE_COLOR_BURN 1
#endif
#ifndef BLEND_MODE_LINEAR_LIGHT
#define BLEND_MODE_LINEAR_LIGHT 0
#elif BLEND_MODE_LINEAR_LIGHT==1
#undef BLEND_MODE_LINEAR_LIGHT
#define BLEND_MODE_LINEAR_LIGHT 1
#endif
#ifndef BLEND_MODE_VIVID_LIGHT
#define BLEND_MODE_VIVID_LIGHT 0
#elif BLEND_MODE_VIVID_LIGHT==1
#undef BLEND_MODE_VIVID_LIGHT
#define BLEND_MODE_VIVID_LIGHT 1
#endif
#ifndef BLEND_MODE_PIN_LIGHT
#define BLEND_MODE_PIN_LIGHT 0
#elif BLEND_MODE_PIN_LIGHT==1
#undef BLEND_MODE_PIN_LIGHT
#define BLEND_MODE_PIN_LIGHT 1
#endif
#ifndef BLEND_MODE_HARD_MIX
#define BLEND_MODE_HARD_MIX 0
#elif BLEND_MODE_HARD_MIX==1
#undef BLEND_MODE_HARD_MIX
#define BLEND_MODE_HARD_MIX 1
#endif
#ifndef BLEND_MODE_HARD_REFLECT
#define BLEND_MODE_HARD_REFLECT 0
#elif BLEND_MODE_HARD_REFLECT==1
#undef BLEND_MODE_HARD_REFLECT
#define BLEND_MODE_HARD_REFLECT 1
#endif
#ifndef BLEND_MODE_HARD_GLOW
#define BLEND_MODE_HARD_GLOW 0
#elif BLEND_MODE_HARD_GLOW==1
#undef BLEND_MODE_HARD_GLOW
#define BLEND_MODE_HARD_GLOW 1
#endif
#ifndef BLEND_MODE_HARD_PHOENIX
#define BLEND_MODE_HARD_PHOENIX 0
#elif BLEND_MODE_HARD_PHOENIX==1
#undef BLEND_MODE_HARD_PHOENIX
#define BLEND_MODE_HARD_PHOENIX 1
#endif
#ifndef BLEND_MODE_HUE
#define BLEND_MODE_HUE 0
#elif BLEND_MODE_HUE==1
#undef BLEND_MODE_HUE
#define BLEND_MODE_HUE 1
#endif
#ifndef BLEND_MODE_SATURATION
#define BLEND_MODE_SATURATION 0
#elif BLEND_MODE_SATURATION==1
#undef BLEND_MODE_SATURATION
#define BLEND_MODE_SATURATION 1
#endif
#ifndef BLEND_MODE_COLOR
#define BLEND_MODE_COLOR 0
#elif BLEND_MODE_COLOR==1
#undef BLEND_MODE_COLOR
#define BLEND_MODE_COLOR 1
#endif
#ifndef BLEND_MODE_LUMINOSITY
#define BLEND_MODE_LUMINOSITY 0
#elif BLEND_MODE_LUMINOSITY==1
#undef BLEND_MODE_LUMINOSITY
#define BLEND_MODE_LUMINOSITY 1
#endif
#ifndef screenTexHasSwappedViews
#define screenTexHasSwappedViews 0
#elif screenTexHasSwappedViews==1
#undef screenTexHasSwappedViews
#define screenTexHasSwappedViews 1
#endif
#ifndef screenTexLayout
#define screenTexLayout 0
#endif
#ifndef texWarpHasSwappedViews
#define texWarpHasSwappedViews 0
#elif texWarpHasSwappedViews==1
#undef texWarpHasSwappedViews
#define texWarpHasSwappedViews 1
#endif
#ifndef texWarpLayout
#define texWarpLayout 0
#endif
#ifndef inputTexHasSwappedViews
#define inputTexHasSwappedViews 0
#elif inputTexHasSwappedViews==1
#undef inputTexHasSwappedViews
#define inputTexHasSwappedViews 1
#endif
#ifndef inputTexLayout
#define inputTexLayout 0
#endif
#ifndef colorTexHasSwappedViews
#define colorTexHasSwappedViews 0
#elif colorTexHasSwappedViews==1
#undef colorTexHasSwappedViews
#define colorTexHasSwappedViews 1
#endif
#ifndef colorTexLayout
#define colorTexLayout 0
#endif
#ifndef opacityTexHasSwappedViews
#define opacityTexHasSwappedViews 0
#elif opacityTexHasSwappedViews==1
#undef opacityTexHasSwappedViews
#define opacityTexHasSwappedViews 1
#endif
#ifndef opacityTexLayout
#define opacityTexLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_texWarp
#define SC_USE_UV_TRANSFORM_texWarp 0
#elif SC_USE_UV_TRANSFORM_texWarp==1
#undef SC_USE_UV_TRANSFORM_texWarp
#define SC_USE_UV_TRANSFORM_texWarp 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_texWarp
#define SC_SOFTWARE_WRAP_MODE_U_texWarp -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_texWarp
#define SC_SOFTWARE_WRAP_MODE_V_texWarp -1
#endif
#ifndef SC_USE_UV_MIN_MAX_texWarp
#define SC_USE_UV_MIN_MAX_texWarp 0
#elif SC_USE_UV_MIN_MAX_texWarp==1
#undef SC_USE_UV_MIN_MAX_texWarp
#define SC_USE_UV_MIN_MAX_texWarp 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_texWarp
#define SC_USE_CLAMP_TO_BORDER_texWarp 0
#elif SC_USE_CLAMP_TO_BORDER_texWarp==1
#undef SC_USE_CLAMP_TO_BORDER_texWarp
#define SC_USE_CLAMP_TO_BORDER_texWarp 1
#endif
#ifndef SC_USE_UV_TRANSFORM_inputTex
#define SC_USE_UV_TRANSFORM_inputTex 0
#elif SC_USE_UV_TRANSFORM_inputTex==1
#undef SC_USE_UV_TRANSFORM_inputTex
#define SC_USE_UV_TRANSFORM_inputTex 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_inputTex
#define SC_SOFTWARE_WRAP_MODE_U_inputTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_inputTex
#define SC_SOFTWARE_WRAP_MODE_V_inputTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_inputTex
#define SC_USE_UV_MIN_MAX_inputTex 0
#elif SC_USE_UV_MIN_MAX_inputTex==1
#undef SC_USE_UV_MIN_MAX_inputTex
#define SC_USE_UV_MIN_MAX_inputTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_inputTex
#define SC_USE_CLAMP_TO_BORDER_inputTex 0
#elif SC_USE_CLAMP_TO_BORDER_inputTex==1
#undef SC_USE_CLAMP_TO_BORDER_inputTex
#define SC_USE_CLAMP_TO_BORDER_inputTex 1
#endif
#ifndef SC_USE_UV_TRANSFORM_colorTex
#define SC_USE_UV_TRANSFORM_colorTex 0
#elif SC_USE_UV_TRANSFORM_colorTex==1
#undef SC_USE_UV_TRANSFORM_colorTex
#define SC_USE_UV_TRANSFORM_colorTex 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_colorTex
#define SC_SOFTWARE_WRAP_MODE_U_colorTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_colorTex
#define SC_SOFTWARE_WRAP_MODE_V_colorTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_colorTex
#define SC_USE_UV_MIN_MAX_colorTex 0
#elif SC_USE_UV_MIN_MAX_colorTex==1
#undef SC_USE_UV_MIN_MAX_colorTex
#define SC_USE_UV_MIN_MAX_colorTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_colorTex
#define SC_USE_CLAMP_TO_BORDER_colorTex 0
#elif SC_USE_CLAMP_TO_BORDER_colorTex==1
#undef SC_USE_CLAMP_TO_BORDER_colorTex
#define SC_USE_CLAMP_TO_BORDER_colorTex 1
#endif
#ifndef SC_USE_UV_TRANSFORM_screenTex
#define SC_USE_UV_TRANSFORM_screenTex 0
#elif SC_USE_UV_TRANSFORM_screenTex==1
#undef SC_USE_UV_TRANSFORM_screenTex
#define SC_USE_UV_TRANSFORM_screenTex 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_screenTex
#define SC_SOFTWARE_WRAP_MODE_U_screenTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_screenTex
#define SC_SOFTWARE_WRAP_MODE_V_screenTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_screenTex
#define SC_USE_UV_MIN_MAX_screenTex 0
#elif SC_USE_UV_MIN_MAX_screenTex==1
#undef SC_USE_UV_MIN_MAX_screenTex
#define SC_USE_UV_MIN_MAX_screenTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_screenTex
#define SC_USE_CLAMP_TO_BORDER_screenTex 0
#elif SC_USE_CLAMP_TO_BORDER_screenTex==1
#undef SC_USE_CLAMP_TO_BORDER_screenTex
#define SC_USE_CLAMP_TO_BORDER_screenTex 1
#endif
#ifndef SC_USE_UV_TRANSFORM_opacityTex
#define SC_USE_UV_TRANSFORM_opacityTex 0
#elif SC_USE_UV_TRANSFORM_opacityTex==1
#undef SC_USE_UV_TRANSFORM_opacityTex
#define SC_USE_UV_TRANSFORM_opacityTex 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_opacityTex
#define SC_SOFTWARE_WRAP_MODE_U_opacityTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_opacityTex
#define SC_SOFTWARE_WRAP_MODE_V_opacityTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_opacityTex
#define SC_USE_UV_MIN_MAX_opacityTex 0
#elif SC_USE_UV_MIN_MAX_opacityTex==1
#undef SC_USE_UV_MIN_MAX_opacityTex
#define SC_USE_UV_MIN_MAX_opacityTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_opacityTex
#define SC_USE_CLAMP_TO_BORDER_opacityTex 0
#elif SC_USE_CLAMP_TO_BORDER_opacityTex==1
#undef SC_USE_CLAMP_TO_BORDER_opacityTex
#define SC_USE_CLAMP_TO_BORDER_opacityTex 1
#endif
uniform vec4 intensityTextureDims;
uniform float correctedIntensity;
uniform mat3 intensityTextureTransform;
uniform vec4 intensityTextureUvMinMax;
uniform vec4 intensityTextureBorderColor;
uniform float alphaTestThreshold;
uniform vec4 screenTexDims;
uniform vec4 alphaTexDims;
uniform vec4 texWarpOutDims;
uniform vec4 texWarpDims;
uniform vec4 inputTexDims;
uniform vec4 colorTexDims;
uniform vec4 opacityTexDims;
uniform vec4 wrapOutMax;
uniform vec4 wrapOutMin;
uniform vec4 warpMax;
uniform vec4 warpMin;
uniform float warp_intensity;
uniform mat3 texWarpTransform;
uniform vec4 texWarpUvMinMax;
uniform vec4 texWarpBorderColor;
uniform vec3 alphaMax;
uniform vec3 alphaMin;
uniform float Tweak_N110;
uniform mat3 inputTexTransform;
uniform vec4 inputTexUvMinMax;
uniform vec4 inputTexBorderColor;
uniform vec4 colorMax;
uniform vec4 colorMin;
uniform float textureintensity;
uniform mat3 colorTexTransform;
uniform vec4 colorTexUvMinMax;
uniform vec4 colorTexBorderColor;
uniform float overallintensity;
uniform int overrideTimeEnabled;
uniform float overrideTimeElapsed;
uniform float overrideTimeDelta;
uniform mat3 screenTexTransform;
uniform vec4 screenTexUvMinMax;
uniform vec4 screenTexBorderColor;
uniform mat3 opacityTexTransform;
uniform vec4 opacityTexUvMinMax;
uniform vec4 opacityTexBorderColor;
uniform vec4 intensityTextureSize;
uniform vec4 intensityTextureView;
uniform float reflBlurWidth;
uniform float reflBlurMinRough;
uniform float reflBlurMaxRough;
uniform vec4 screenTexSize;
uniform vec4 screenTexView;
uniform vec4 alphaTexSize;
uniform vec4 alphaTexView;
uniform mat3 alphaTexTransform;
uniform vec4 alphaTexUvMinMax;
uniform vec4 alphaTexBorderColor;
uniform vec4 texWarpOutSize;
uniform vec4 texWarpOutView;
uniform mat3 texWarpOutTransform;
uniform vec4 texWarpOutUvMinMax;
uniform vec4 texWarpOutBorderColor;
uniform vec4 texWarpSize;
uniform vec4 texWarpView;
uniform vec4 inputTexSize;
uniform vec4 inputTexView;
uniform vec4 colorTexSize;
uniform vec4 colorTexView;
uniform vec4 opacityTexSize;
uniform vec4 opacityTexView;
uniform mediump sampler2D screenTex;
uniform mediump sampler2D colorTex;
uniform mediump sampler2D texWarp;
uniform mediump sampler2D inputTex;
uniform mediump sampler2D opacityTex;
uniform mediump sampler2D intensityTexture;
uniform mediump sampler2D sc_OITFrontDepthTexture;
uniform mediump sampler2D sc_OITFilteredDepthBoundsTexture;
uniform mediump sampler2D sc_OITDepthHigh0;
uniform mediump sampler2D sc_OITDepthLow0;
uniform mediump sampler2D sc_OITAlpha0;
uniform mediump sampler2D sc_OITDepthHigh1;
uniform mediump sampler2D sc_OITDepthLow1;
uniform mediump sampler2D sc_OITAlpha1;
varying vec4 varColor;
void Node94_If_else(float Bool1,vec3 Value1,vec3 Default,out vec3 Result,ssGlobals Globals)
{
int l9_0;
#if (texWarpHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
vec4 l9_1=(((sc_SampleTextureBiasOrLevel(texWarpDims.xy,texWarpLayout,l9_0,Globals.Surface_UVCoord0,(int(SC_USE_UV_TRANSFORM_texWarp)!=0),texWarpTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_texWarp,SC_SOFTWARE_WRAP_MODE_V_texWarp),(int(SC_USE_UV_MIN_MAX_texWarp)!=0),texWarpUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_texWarp)!=0),texWarpBorderColor,0.0,texWarp)*(warpMax-warpMin))+warpMin)*vec4(1.0,-1.0,1.0,1.0))*vec4(warp_intensity);
vec4 l9_2=vec4(l9_1.x,l9_1.y,vec4(0.0).z,vec4(0.0).w);
l9_2.z=0.0;
vec4 l9_3=l9_2;
l9_3.w=0.0;
vec2 l9_4=Globals.gScreenCoord;
int l9_5;
#if (inputTexHasSwappedViews)
{
l9_5=1-sc_GetStereoViewIndex();
}
#else
{
l9_5=sc_GetStereoViewIndex();
}
#endif
Default=sc_SampleTextureBiasOrLevel(inputTexDims.xy,inputTexLayout,l9_5,clamp((((mat4(vec4(0.5,0.0,0.0,0.0),vec4(0.0,0.5,0.0,0.0),vec4(0.0),vec4(0.5,0.5,0.0,1.0))*sc_ModelViewProjectionMatrixArray[sc_GetStereoViewIndex()])*mat4(vec4(2.0,0.0,0.0,0.0),vec4(0.0,2.0,0.0,0.0),vec4(0.0),vec4(-1.0,-1.0,0.0,1.0)))*l9_3).xy+l9_4,vec2(0.01),vec2(0.99)),(int(SC_USE_UV_TRANSFORM_inputTex)!=0),inputTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_inputTex,SC_SOFTWARE_WRAP_MODE_V_inputTex),(int(SC_USE_UV_MIN_MAX_inputTex)!=0),inputTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_inputTex)!=0),inputTexBorderColor,0.0,inputTex).xyz;
Result=Default;
}
void Node32_If_else(float Bool1,vec3 Value1,vec3 Default,out vec3 Result,ssGlobals Globals)
{
int l9_0;
#if (colorTexHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
vec4 l9_1=((sc_SampleTextureBiasOrLevel(colorTexDims.xy,colorTexLayout,l9_0,Globals.Surface_UVCoord0,(int(SC_USE_UV_TRANSFORM_colorTex)!=0),colorTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_colorTex,SC_SOFTWARE_WRAP_MODE_V_colorTex),(int(SC_USE_UV_MIN_MAX_colorTex)!=0),colorTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_colorTex)!=0),colorTexBorderColor,0.0,colorTex)*(colorMax-colorMin))+colorMin)*vec4(textureintensity);
vec3 l9_2;
Node94_If_else(0.0,vec3(0.0),vec3(0.0),l9_2,Globals);
Default=(vec3(1.0-l9_1.w)*l9_2)+l9_1.xyz;
Result=Default;
}
vec3 transformColor(float yValue,vec3 original,vec3 target,float weight,float intMap)
{
vec3 l9_0;
#if (BLEND_MODE_INTENSE)
{
vec3 l9_1=original;
vec4 l9_2;
if (l9_1.y<l9_1.z)
{
l9_2=vec4(l9_1.zy,-1.0,0.666667);
}
else
{
l9_2=vec4(l9_1.yz,0.0,-0.333333);
}
vec4 l9_3;
if (l9_1.x<l9_2.x)
{
l9_3=vec4(l9_2.xy,0.0,l9_1.x);
}
else
{
l9_3=vec4(l9_1.x,l9_2.y,0.0,l9_2.x);
}
float l9_4=l9_3.x-((l9_3.x-min(l9_3.w,l9_3.y))*0.5);
float l9_5=6.0*target.x;
l9_0=mix(original,((clamp(vec3(abs(l9_5-3.0)-1.0,2.0-abs(l9_5-2.0),2.0-abs(l9_5-4.0)),vec3(0.0),vec3(1.0))-vec3(0.5))*((1.0-abs((2.0*l9_4)-1.0))*target.y))+vec3(l9_4),vec3(weight));
}
#else
{
float l9_6=yValue;
float l9_7=intMap;
float l9_8=target.x;
float l9_9;
#if ((BLEND_MODE_REALISTIC||BLEND_MODE_FORGRAY)||BLEND_MODE_NOTBRIGHT)
{
l9_9=l9_6/pow(1.0-l9_8,l9_7);
}
#else
{
float l9_10;
#if (BLEND_MODE_DIVISION)
{
l9_10=l9_6/(1.0-l9_8);
}
#else
{
float l9_11;
#if (BLEND_MODE_BRIGHT)
{
l9_11=l9_6/pow(1.0-l9_8,2.0-(2.0*l9_6));
}
#else
{
l9_11=0.0;
}
#endif
l9_10=l9_11;
}
#endif
l9_9=l9_10;
}
#endif
vec3 l9_12=vec3(0.0);
l9_12.x=l9_9;
float l9_13=yValue;
float l9_14=intMap;
float l9_15=target.y;
float l9_16;
#if ((BLEND_MODE_REALISTIC||BLEND_MODE_FORGRAY)||BLEND_MODE_NOTBRIGHT)
{
l9_16=l9_13/pow(1.0-l9_15,l9_14);
}
#else
{
float l9_17;
#if (BLEND_MODE_DIVISION)
{
l9_17=l9_13/(1.0-l9_15);
}
#else
{
float l9_18;
#if (BLEND_MODE_BRIGHT)
{
l9_18=l9_13/pow(1.0-l9_15,2.0-(2.0*l9_13));
}
#else
{
l9_18=0.0;
}
#endif
l9_17=l9_18;
}
#endif
l9_16=l9_17;
}
#endif
vec3 l9_19=l9_12;
l9_19.y=l9_16;
float l9_20=yValue;
float l9_21=intMap;
float l9_22=target.z;
float l9_23;
#if ((BLEND_MODE_REALISTIC||BLEND_MODE_FORGRAY)||BLEND_MODE_NOTBRIGHT)
{
l9_23=l9_20/pow(1.0-l9_22,l9_21);
}
#else
{
float l9_24;
#if (BLEND_MODE_DIVISION)
{
l9_24=l9_20/(1.0-l9_22);
}
#else
{
float l9_25;
#if (BLEND_MODE_BRIGHT)
{
l9_25=l9_20/pow(1.0-l9_22,2.0-(2.0*l9_20));
}
#else
{
l9_25=0.0;
}
#endif
l9_24=l9_25;
}
#endif
l9_23=l9_24;
}
#endif
vec3 l9_26=l9_19;
l9_26.z=l9_23;
l9_0=mix(original,clamp(l9_26,vec3(0.0),vec3(1.0)),vec3(weight));
}
#endif
return l9_0;
}
vec3 definedBlend(vec3 a,vec3 b)
{
vec3 l9_0;
#if (BLEND_MODE_LIGHTEN)
{
l9_0=max(a,b);
}
#else
{
vec3 l9_1;
#if (BLEND_MODE_DARKEN)
{
l9_1=min(a,b);
}
#else
{
vec3 l9_2;
#if (BLEND_MODE_DIVIDE)
{
l9_2=b/a;
}
#else
{
vec3 l9_3;
#if (BLEND_MODE_AVERAGE)
{
l9_3=(a+b)*0.5;
}
#else
{
vec3 l9_4;
#if (BLEND_MODE_SUBTRACT)
{
l9_4=max((a+b)-vec3(1.0),vec3(0.0));
}
#else
{
vec3 l9_5;
#if (BLEND_MODE_DIFFERENCE)
{
l9_5=abs(a-b);
}
#else
{
vec3 l9_6;
#if (BLEND_MODE_NEGATION)
{
l9_6=vec3(1.0)-abs((vec3(1.0)-a)-b);
}
#else
{
vec3 l9_7;
#if (BLEND_MODE_EXCLUSION)
{
l9_7=(a+b)-((a*2.0)*b);
}
#else
{
vec3 l9_8;
#if (BLEND_MODE_OVERLAY)
{
float l9_9;
if (a.x<0.5)
{
l9_9=(2.0*a.x)*b.x;
}
else
{
l9_9=1.0-((2.0*(1.0-a.x))*(1.0-b.x));
}
float l9_10;
if (a.y<0.5)
{
l9_10=(2.0*a.y)*b.y;
}
else
{
l9_10=1.0-((2.0*(1.0-a.y))*(1.0-b.y));
}
float l9_11;
if (a.z<0.5)
{
l9_11=(2.0*a.z)*b.z;
}
else
{
l9_11=1.0-((2.0*(1.0-a.z))*(1.0-b.z));
}
l9_8=vec3(l9_9,l9_10,l9_11);
}
#else
{
vec3 l9_12;
#if (BLEND_MODE_SOFT_LIGHT)
{
l9_12=(((vec3(1.0)-(b*2.0))*a)*a)+((a*2.0)*b);
}
#else
{
vec3 l9_13;
#if (BLEND_MODE_HARD_LIGHT)
{
float l9_14;
if (b.x<0.5)
{
l9_14=(2.0*b.x)*a.x;
}
else
{
l9_14=1.0-((2.0*(1.0-b.x))*(1.0-a.x));
}
float l9_15;
if (b.y<0.5)
{
l9_15=(2.0*b.y)*a.y;
}
else
{
l9_15=1.0-((2.0*(1.0-b.y))*(1.0-a.y));
}
float l9_16;
if (b.z<0.5)
{
l9_16=(2.0*b.z)*a.z;
}
else
{
l9_16=1.0-((2.0*(1.0-b.z))*(1.0-a.z));
}
l9_13=vec3(l9_14,l9_15,l9_16);
}
#else
{
vec3 l9_17;
#if (BLEND_MODE_COLOR_DODGE)
{
float l9_18;
if (b.x==1.0)
{
l9_18=b.x;
}
else
{
l9_18=min(a.x/(1.0-b.x),1.0);
}
float l9_19;
if (b.y==1.0)
{
l9_19=b.y;
}
else
{
l9_19=min(a.y/(1.0-b.y),1.0);
}
float l9_20;
if (b.z==1.0)
{
l9_20=b.z;
}
else
{
l9_20=min(a.z/(1.0-b.z),1.0);
}
l9_17=vec3(l9_18,l9_19,l9_20);
}
#else
{
vec3 l9_21;
#if (BLEND_MODE_COLOR_BURN)
{
float l9_22;
if (b.x==0.0)
{
l9_22=b.x;
}
else
{
l9_22=max(1.0-((1.0-a.x)/b.x),0.0);
}
float l9_23;
if (b.y==0.0)
{
l9_23=b.y;
}
else
{
l9_23=max(1.0-((1.0-a.y)/b.y),0.0);
}
float l9_24;
if (b.z==0.0)
{
l9_24=b.z;
}
else
{
l9_24=max(1.0-((1.0-a.z)/b.z),0.0);
}
l9_21=vec3(l9_22,l9_23,l9_24);
}
#else
{
vec3 l9_25;
#if (BLEND_MODE_LINEAR_LIGHT)
{
float l9_26;
if (b.x<0.5)
{
l9_26=max((a.x+(2.0*b.x))-1.0,0.0);
}
else
{
l9_26=min(a.x+(2.0*(b.x-0.5)),1.0);
}
float l9_27;
if (b.y<0.5)
{
l9_27=max((a.y+(2.0*b.y))-1.0,0.0);
}
else
{
l9_27=min(a.y+(2.0*(b.y-0.5)),1.0);
}
float l9_28;
if (b.z<0.5)
{
l9_28=max((a.z+(2.0*b.z))-1.0,0.0);
}
else
{
l9_28=min(a.z+(2.0*(b.z-0.5)),1.0);
}
l9_25=vec3(l9_26,l9_27,l9_28);
}
#else
{
vec3 l9_29;
#if (BLEND_MODE_VIVID_LIGHT)
{
float l9_30;
if (b.x<0.5)
{
float l9_31;
if ((2.0*b.x)==0.0)
{
l9_31=2.0*b.x;
}
else
{
l9_31=max(1.0-((1.0-a.x)/(2.0*b.x)),0.0);
}
l9_30=l9_31;
}
else
{
float l9_32;
if ((2.0*(b.x-0.5))==1.0)
{
l9_32=2.0*(b.x-0.5);
}
else
{
l9_32=min(a.x/(1.0-(2.0*(b.x-0.5))),1.0);
}
l9_30=l9_32;
}
float l9_33;
if (b.y<0.5)
{
float l9_34;
if ((2.0*b.y)==0.0)
{
l9_34=2.0*b.y;
}
else
{
l9_34=max(1.0-((1.0-a.y)/(2.0*b.y)),0.0);
}
l9_33=l9_34;
}
else
{
float l9_35;
if ((2.0*(b.y-0.5))==1.0)
{
l9_35=2.0*(b.y-0.5);
}
else
{
l9_35=min(a.y/(1.0-(2.0*(b.y-0.5))),1.0);
}
l9_33=l9_35;
}
float l9_36;
if (b.z<0.5)
{
float l9_37;
if ((2.0*b.z)==0.0)
{
l9_37=2.0*b.z;
}
else
{
l9_37=max(1.0-((1.0-a.z)/(2.0*b.z)),0.0);
}
l9_36=l9_37;
}
else
{
float l9_38;
if ((2.0*(b.z-0.5))==1.0)
{
l9_38=2.0*(b.z-0.5);
}
else
{
l9_38=min(a.z/(1.0-(2.0*(b.z-0.5))),1.0);
}
l9_36=l9_38;
}
l9_29=vec3(l9_30,l9_33,l9_36);
}
#else
{
vec3 l9_39;
#if (BLEND_MODE_PIN_LIGHT)
{
float l9_40;
if (b.x<0.5)
{
l9_40=min(a.x,2.0*b.x);
}
else
{
l9_40=max(a.x,2.0*(b.x-0.5));
}
float l9_41;
if (b.y<0.5)
{
l9_41=min(a.y,2.0*b.y);
}
else
{
l9_41=max(a.y,2.0*(b.y-0.5));
}
float l9_42;
if (b.z<0.5)
{
l9_42=min(a.z,2.0*b.z);
}
else
{
l9_42=max(a.z,2.0*(b.z-0.5));
}
l9_39=vec3(l9_40,l9_41,l9_42);
}
#else
{
vec3 l9_43;
#if (BLEND_MODE_HARD_MIX)
{
float l9_44;
if (b.x<0.5)
{
float l9_45;
if ((2.0*b.x)==0.0)
{
l9_45=2.0*b.x;
}
else
{
l9_45=max(1.0-((1.0-a.x)/(2.0*b.x)),0.0);
}
l9_44=l9_45;
}
else
{
float l9_46;
if ((2.0*(b.x-0.5))==1.0)
{
l9_46=2.0*(b.x-0.5);
}
else
{
l9_46=min(a.x/(1.0-(2.0*(b.x-0.5))),1.0);
}
l9_44=l9_46;
}
bool l9_47=l9_44<0.5;
float l9_48;
if (b.y<0.5)
{
float l9_49;
if ((2.0*b.y)==0.0)
{
l9_49=2.0*b.y;
}
else
{
l9_49=max(1.0-((1.0-a.y)/(2.0*b.y)),0.0);
}
l9_48=l9_49;
}
else
{
float l9_50;
if ((2.0*(b.y-0.5))==1.0)
{
l9_50=2.0*(b.y-0.5);
}
else
{
l9_50=min(a.y/(1.0-(2.0*(b.y-0.5))),1.0);
}
l9_48=l9_50;
}
bool l9_51=l9_48<0.5;
float l9_52;
if (b.z<0.5)
{
float l9_53;
if ((2.0*b.z)==0.0)
{
l9_53=2.0*b.z;
}
else
{
l9_53=max(1.0-((1.0-a.z)/(2.0*b.z)),0.0);
}
l9_52=l9_53;
}
else
{
float l9_54;
if ((2.0*(b.z-0.5))==1.0)
{
l9_54=2.0*(b.z-0.5);
}
else
{
l9_54=min(a.z/(1.0-(2.0*(b.z-0.5))),1.0);
}
l9_52=l9_54;
}
l9_43=vec3(l9_47 ? 0.0 : 1.0,l9_51 ? 0.0 : 1.0,(l9_52<0.5) ? 0.0 : 1.0);
}
#else
{
vec3 l9_55;
#if (BLEND_MODE_HARD_REFLECT)
{
float l9_56;
if (b.x==1.0)
{
l9_56=b.x;
}
else
{
l9_56=min((a.x*a.x)/(1.0-b.x),1.0);
}
float l9_57;
if (b.y==1.0)
{
l9_57=b.y;
}
else
{
l9_57=min((a.y*a.y)/(1.0-b.y),1.0);
}
float l9_58;
if (b.z==1.0)
{
l9_58=b.z;
}
else
{
l9_58=min((a.z*a.z)/(1.0-b.z),1.0);
}
l9_55=vec3(l9_56,l9_57,l9_58);
}
#else
{
vec3 l9_59;
#if (BLEND_MODE_HARD_GLOW)
{
float l9_60;
if (a.x==1.0)
{
l9_60=a.x;
}
else
{
l9_60=min((b.x*b.x)/(1.0-a.x),1.0);
}
float l9_61;
if (a.y==1.0)
{
l9_61=a.y;
}
else
{
l9_61=min((b.y*b.y)/(1.0-a.y),1.0);
}
float l9_62;
if (a.z==1.0)
{
l9_62=a.z;
}
else
{
l9_62=min((b.z*b.z)/(1.0-a.z),1.0);
}
l9_59=vec3(l9_60,l9_61,l9_62);
}
#else
{
vec3 l9_63;
#if (BLEND_MODE_HARD_PHOENIX)
{
l9_63=(min(a,b)-max(a,b))+vec3(1.0);
}
#else
{
vec3 l9_64;
#if (BLEND_MODE_HUE)
{
vec3 l9_65=a;
vec3 l9_66=b;
vec4 l9_67;
if (l9_65.y<l9_65.z)
{
l9_67=vec4(l9_65.zy,-1.0,0.666667);
}
else
{
l9_67=vec4(l9_65.yz,0.0,-0.333333);
}
vec4 l9_68;
if (l9_65.x<l9_67.x)
{
l9_68=vec4(l9_67.xy,0.0,l9_65.x);
}
else
{
l9_68=vec4(l9_65.x,l9_67.y,0.0,l9_67.x);
}
float l9_69=l9_68.x-min(l9_68.w,l9_68.y);
float l9_70=l9_68.x-(l9_69*0.5);
float l9_71=abs((2.0*l9_70)-1.0);
vec4 l9_72;
if (l9_66.y<l9_66.z)
{
l9_72=vec4(l9_66.zy,-1.0,0.666667);
}
else
{
l9_72=vec4(l9_66.yz,0.0,-0.333333);
}
vec4 l9_73;
if (l9_66.x<l9_72.x)
{
l9_73=vec4(l9_72.xyw,l9_66.x);
}
else
{
l9_73=vec4(l9_66.x,l9_72.yzx);
}
float l9_74=6.0*abs(((l9_73.w-l9_73.y)/((6.0*(l9_73.x-min(l9_73.w,l9_73.y)))+1e-07))+l9_73.z);
l9_64=((clamp(vec3(abs(l9_74-3.0)-1.0,2.0-abs(l9_74-2.0),2.0-abs(l9_74-4.0)),vec3(0.0),vec3(1.0))-vec3(0.5))*((1.0-l9_71)*(l9_69/(1.0-l9_71))))+vec3(l9_70);
}
#else
{
vec3 l9_75;
#if (BLEND_MODE_SATURATION)
{
vec3 l9_76=a;
vec3 l9_77=b;
vec4 l9_78;
if (l9_76.y<l9_76.z)
{
l9_78=vec4(l9_76.zy,-1.0,0.666667);
}
else
{
l9_78=vec4(l9_76.yz,0.0,-0.333333);
}
vec4 l9_79;
if (l9_76.x<l9_78.x)
{
l9_79=vec4(l9_78.xyw,l9_76.x);
}
else
{
l9_79=vec4(l9_76.x,l9_78.yzx);
}
float l9_80=l9_79.x-min(l9_79.w,l9_79.y);
float l9_81=l9_79.x-(l9_80*0.5);
vec4 l9_82;
if (l9_77.y<l9_77.z)
{
l9_82=vec4(l9_77.zy,-1.0,0.666667);
}
else
{
l9_82=vec4(l9_77.yz,0.0,-0.333333);
}
vec4 l9_83;
if (l9_77.x<l9_82.x)
{
l9_83=vec4(l9_82.xy,0.0,l9_77.x);
}
else
{
l9_83=vec4(l9_77.x,l9_82.y,0.0,l9_82.x);
}
float l9_84=l9_83.x-min(l9_83.w,l9_83.y);
float l9_85=6.0*abs(((l9_79.w-l9_79.y)/((6.0*l9_80)+1e-07))+l9_79.z);
l9_75=((clamp(vec3(abs(l9_85-3.0)-1.0,2.0-abs(l9_85-2.0),2.0-abs(l9_85-4.0)),vec3(0.0),vec3(1.0))-vec3(0.5))*((1.0-abs((2.0*l9_81)-1.0))*(l9_84/(1.0-abs((2.0*(l9_83.x-(l9_84*0.5)))-1.0)))))+vec3(l9_81);
}
#else
{
vec3 l9_86;
#if (BLEND_MODE_COLOR)
{
vec3 l9_87=a;
vec3 l9_88=b;
vec4 l9_89;
if (l9_88.y<l9_88.z)
{
l9_89=vec4(l9_88.zy,-1.0,0.666667);
}
else
{
l9_89=vec4(l9_88.yz,0.0,-0.333333);
}
vec4 l9_90;
if (l9_88.x<l9_89.x)
{
l9_90=vec4(l9_89.xyw,l9_88.x);
}
else
{
l9_90=vec4(l9_88.x,l9_89.yzx);
}
float l9_91=l9_90.x-min(l9_90.w,l9_90.y);
vec4 l9_92;
if (l9_87.y<l9_87.z)
{
l9_92=vec4(l9_87.zy,-1.0,0.666667);
}
else
{
l9_92=vec4(l9_87.yz,0.0,-0.333333);
}
vec4 l9_93;
if (l9_87.x<l9_92.x)
{
l9_93=vec4(l9_92.xy,0.0,l9_87.x);
}
else
{
l9_93=vec4(l9_87.x,l9_92.y,0.0,l9_92.x);
}
float l9_94=l9_93.x-((l9_93.x-min(l9_93.w,l9_93.y))*0.5);
float l9_95=6.0*abs(((l9_90.w-l9_90.y)/((6.0*l9_91)+1e-07))+l9_90.z);
l9_86=((clamp(vec3(abs(l9_95-3.0)-1.0,2.0-abs(l9_95-2.0),2.0-abs(l9_95-4.0)),vec3(0.0),vec3(1.0))-vec3(0.5))*((1.0-abs((2.0*l9_94)-1.0))*(l9_91/(1.0-abs((2.0*(l9_90.x-(l9_91*0.5)))-1.0)))))+vec3(l9_94);
}
#else
{
vec3 l9_96;
#if (BLEND_MODE_LUMINOSITY)
{
vec3 l9_97=a;
vec3 l9_98=b;
vec4 l9_99;
if (l9_97.y<l9_97.z)
{
l9_99=vec4(l9_97.zy,-1.0,0.666667);
}
else
{
l9_99=vec4(l9_97.yz,0.0,-0.333333);
}
vec4 l9_100;
if (l9_97.x<l9_99.x)
{
l9_100=vec4(l9_99.xyw,l9_97.x);
}
else
{
l9_100=vec4(l9_97.x,l9_99.yzx);
}
float l9_101=l9_100.x-min(l9_100.w,l9_100.y);
vec4 l9_102;
if (l9_98.y<l9_98.z)
{
l9_102=vec4(l9_98.zy,-1.0,0.666667);
}
else
{
l9_102=vec4(l9_98.yz,0.0,-0.333333);
}
vec4 l9_103;
if (l9_98.x<l9_102.x)
{
l9_103=vec4(l9_102.xy,0.0,l9_98.x);
}
else
{
l9_103=vec4(l9_98.x,l9_102.y,0.0,l9_102.x);
}
float l9_104=l9_103.x-((l9_103.x-min(l9_103.w,l9_103.y))*0.5);
float l9_105=6.0*abs(((l9_100.w-l9_100.y)/((6.0*l9_101)+1e-07))+l9_100.z);
l9_96=((clamp(vec3(abs(l9_105-3.0)-1.0,2.0-abs(l9_105-2.0),2.0-abs(l9_105-4.0)),vec3(0.0),vec3(1.0))-vec3(0.5))*((1.0-abs((2.0*l9_104)-1.0))*(l9_101/(1.0-abs((2.0*(l9_100.x-(l9_101*0.5)))-1.0)))))+vec3(l9_104);
}
#else
{
vec3 l9_106=a;
vec3 l9_107=b;
float l9_108=((0.299*l9_106.x)+(0.587*l9_106.y))+(0.114*l9_106.z);
int l9_109;
#if (intensityTextureHasSwappedViews)
{
l9_109=1-sc_GetStereoViewIndex();
}
#else
{
l9_109=sc_GetStereoViewIndex();
}
#endif
vec4 l9_110=sc_SampleTextureBiasOrLevel(intensityTextureDims.xy,intensityTextureLayout,l9_109,vec2(pow(l9_108,1.0/correctedIntensity),0.5),(int(SC_USE_UV_TRANSFORM_intensityTexture)!=0),intensityTextureTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture,SC_SOFTWARE_WRAP_MODE_V_intensityTexture),(int(SC_USE_UV_MIN_MAX_intensityTexture)!=0),intensityTextureUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_intensityTexture)!=0),intensityTextureBorderColor,0.0,intensityTexture);
float l9_111=(((l9_110.x*256.0)+l9_110.y)+(l9_110.z*0.00390625))*0.0622559;
float l9_112;
#if (BLEND_MODE_FORGRAY)
{
l9_112=max(l9_111,1.0);
}
#else
{
l9_112=l9_111;
}
#endif
float l9_113;
#if (BLEND_MODE_NOTBRIGHT)
{
l9_113=min(l9_112,1.0);
}
#else
{
l9_113=l9_112;
}
#endif
l9_96=transformColor(l9_108,l9_106,l9_107,1.0,l9_113);
}
#endif
l9_86=l9_96;
}
#endif
l9_75=l9_86;
}
#endif
l9_64=l9_75;
}
#endif
l9_63=l9_64;
}
#endif
l9_59=l9_63;
}
#endif
l9_55=l9_59;
}
#endif
l9_43=l9_55;
}
#endif
l9_39=l9_43;
}
#endif
l9_29=l9_39;
}
#endif
l9_25=l9_29;
}
#endif
l9_21=l9_25;
}
#endif
l9_17=l9_21;
}
#endif
l9_13=l9_17;
}
#endif
l9_12=l9_13;
}
#endif
l9_8=l9_12;
}
#endif
l9_7=l9_8;
}
#endif
l9_6=l9_7;
}
#endif
l9_5=l9_6;
}
#endif
l9_4=l9_5;
}
#endif
l9_3=l9_4;
}
#endif
l9_2=l9_3;
}
#endif
l9_1=l9_2;
}
#endif
l9_0=l9_1;
}
#endif
return l9_0;
}
vec4 ngsPixelShader(vec4 result)
{
#if (sc_ProjectiveShadowsCaster)
{
return evaluateShadowCasterColor(result);
}
#else
{
#if (sc_RenderAlphaToColor)
{
return vec4(result.w);
}
#endif
}
#endif
#if (sc_BlendMode_Custom)
{
vec3 l9_0=getFramebufferColor().xyz;
vec3 l9_1=mix(l9_0,definedBlend(l9_0,result.xyz).xyz,vec3(result.w));
vec4 l9_2=vec4(l9_1.x,l9_1.y,l9_1.z,vec4(0.0).w);
l9_2.w=1.0;
result=l9_2;
}
#else
{
result=sc_ApplyBlendModeModifications(result);
}
#endif
return result;
}
void oitDepthGather(vec4 materialColor)
{
#if (sc_OITDepthGatherPass)
{
vec2 l9_0=getScreenUV();
#if (sc_OITMaxLayers4Plus1)
{
vec4 l9_1=texture2D(sc_OITFrontDepthTexture,l9_0);
float l9_2;
#if (sc_SkinBonesCount>0)
{
l9_2=5e-07;
}
#else
{
l9_2=5e-08;
}
#endif
if ((sc_GetGlFragCoord().z-l9_1.x)<=l9_2)
{
discard;
}
}
#endif
mediump vec4 l9_3=texture2D(sc_OITFilteredDepthBoundsTexture,l9_0);
float l9_4;
#if (UseViewSpaceDepthVariant&&((sc_OITDepthGatherPass||sc_OITCompositingPass)||sc_OITDepthBoundsPass))
{
l9_4=varViewSpaceDepth;
}
#else
{
l9_4=sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][3].z/(sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][2].z+((sc_GetGlFragCoord().z*2.0)-1.0));
}
#endif
float l9_5=(1.0-l9_3.x)*1000.0;
float l9_6=l9_4-l9_5;
int l9_7=int(clamp(l9_6/((l9_3.y*1000.0)-l9_5),0.0,1.0)*65535.0);
float l9_8=materialColor.w;
int l9_9=int(l9_8*255.0);
float l9_10;
int l9_11;
#if (sc_OITDepthGatherPass)
{
l9_11=l9_7/4;
l9_10=floor(floor(mod(float(l9_7),4.0))*64.0)*0.00392157;
}
#else
{
l9_11=l9_7;
l9_10=0.0;
}
#endif
vec4 l9_12=vec4(0.0);
l9_12.x=l9_10;
float l9_13;
int l9_14;
#if (sc_OITDepthGatherPass)
{
l9_14=l9_11/4;
l9_13=floor(floor(mod(float(l9_11),4.0))*64.0)*0.00392157;
}
#else
{
l9_14=l9_11;
l9_13=0.0;
}
#endif
vec4 l9_15=l9_12;
l9_15.y=l9_13;
float l9_16;
int l9_17;
#if (sc_OITDepthGatherPass)
{
l9_17=l9_14/4;
l9_16=floor(floor(mod(float(l9_14),4.0))*64.0)*0.00392157;
}
#else
{
l9_17=l9_14;
l9_16=0.0;
}
#endif
vec4 l9_18=l9_15;
l9_18.z=l9_16;
float l9_19;
int l9_20;
#if (sc_OITDepthGatherPass)
{
l9_20=l9_17/4;
l9_19=floor(floor(mod(float(l9_17),4.0))*64.0)*0.00392157;
}
#else
{
l9_20=l9_17;
l9_19=0.0;
}
#endif
vec4 l9_21=l9_18;
l9_21.w=l9_19;
float l9_22;
int l9_23;
#if (sc_OITDepthGatherPass)
{
l9_23=l9_20/4;
l9_22=floor(floor(mod(float(l9_20),4.0))*64.0)*0.00392157;
}
#else
{
l9_23=l9_20;
l9_22=0.0;
}
#endif
vec4 l9_24=vec4(0.0);
l9_24.x=l9_22;
float l9_25;
int l9_26;
#if (sc_OITDepthGatherPass)
{
l9_26=l9_23/4;
l9_25=floor(floor(mod(float(l9_23),4.0))*64.0)*0.00392157;
}
#else
{
l9_26=l9_23;
l9_25=0.0;
}
#endif
vec4 l9_27=l9_24;
l9_27.y=l9_25;
float l9_28;
int l9_29;
#if (sc_OITDepthGatherPass)
{
l9_29=l9_26/4;
l9_28=floor(floor(mod(float(l9_26),4.0))*64.0)*0.00392157;
}
#else
{
l9_29=l9_26;
l9_28=0.0;
}
#endif
vec4 l9_30=l9_27;
l9_30.z=l9_28;
float l9_31;
#if (sc_OITDepthGatherPass)
{
l9_31=floor(floor(mod(float(l9_29),4.0))*64.0)*0.00392157;
}
#else
{
l9_31=0.0;
}
#endif
vec4 l9_32=l9_30;
l9_32.w=l9_31;
float l9_33;
int l9_34;
#if (sc_OITDepthGatherPass)
{
l9_34=l9_9/4;
l9_33=floor(floor(mod(float(l9_9),4.0))*64.0)*0.00392157;
}
#else
{
l9_34=l9_9;
l9_33=0.0;
}
#endif
vec4 l9_35=vec4(0.0);
l9_35.x=l9_33;
float l9_36;
int l9_37;
#if (sc_OITDepthGatherPass)
{
l9_37=l9_34/4;
l9_36=floor(floor(mod(float(l9_34),4.0))*64.0)*0.00392157;
}
#else
{
l9_37=l9_34;
l9_36=0.0;
}
#endif
vec4 l9_38=l9_35;
l9_38.y=l9_36;
float l9_39;
int l9_40;
#if (sc_OITDepthGatherPass)
{
l9_40=l9_37/4;
l9_39=floor(floor(mod(float(l9_37),4.0))*64.0)*0.00392157;
}
#else
{
l9_40=l9_37;
l9_39=0.0;
}
#endif
vec4 l9_41=l9_38;
l9_41.z=l9_39;
float l9_42;
#if (sc_OITDepthGatherPass)
{
l9_42=floor(floor(mod(float(l9_40),4.0))*64.0)*0.00392157;
}
#else
{
l9_42=0.0;
}
#endif
vec4 l9_43=l9_41;
l9_43.w=l9_42;
sc_writeFragData0(l9_32);
sc_writeFragData1(l9_21);
sc_writeFragData2(l9_43);
#if (sc_OITMaxLayersVisualizeLayerCount)
{
sc_writeFragData2(vec4(0.00392157,0.0,0.0,0.0));
}
#endif
}
#endif
}
void oitCompositing(vec4 materialColor)
{
#if (sc_OITCompositingPass)
{
vec2 l9_0=getScreenUV();
#if (sc_OITMaxLayers4Plus1)
{
vec4 l9_1=texture2D(sc_OITFrontDepthTexture,l9_0);
float l9_2;
#if (sc_SkinBonesCount>0)
{
l9_2=5e-07;
}
#else
{
l9_2=5e-08;
}
#endif
if ((sc_GetGlFragCoord().z-l9_1.x)<=l9_2)
{
discard;
}
}
#endif
int depths[8];
int alphas[8];
int l9_3=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_3<8)
{
depths[l9_3]=0;
alphas[l9_3]=0;
l9_3++;
continue;
}
else
{
break;
}
}
int l9_4;
#if (sc_OITMaxLayers8)
{
l9_4=2;
}
#else
{
l9_4=1;
}
#endif
vec4 l9_5;
vec4 l9_6;
vec4 l9_7;
l9_7=vec4(0.0);
l9_6=vec4(0.0);
l9_5=vec4(0.0);
vec4 l9_8;
vec4 l9_9;
vec4 l9_10;
int l9_11=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_11<l9_4)
{
vec4 l9_12;
vec4 l9_13;
vec4 l9_14;
if (l9_11==0)
{
l9_14=texture2D(sc_OITAlpha0,l9_0);
l9_13=texture2D(sc_OITDepthLow0,l9_0);
l9_12=texture2D(sc_OITDepthHigh0,l9_0);
}
else
{
l9_14=l9_7;
l9_13=l9_6;
l9_12=l9_5;
}
if (l9_11==1)
{
l9_10=texture2D(sc_OITAlpha1,l9_0);
l9_9=texture2D(sc_OITDepthLow1,l9_0);
l9_8=texture2D(sc_OITDepthHigh1,l9_0);
}
else
{
l9_10=l9_14;
l9_9=l9_13;
l9_8=l9_12;
}
if (any(notEqual(l9_8,vec4(0.0)))||any(notEqual(l9_9,vec4(0.0))))
{
int param[8];
param[0]=depths[0];
param[1]=depths[1];
param[2]=depths[2];
param[3]=depths[3];
param[4]=depths[4];
param[5]=depths[5];
param[6]=depths[6];
param[7]=depths[7];
#if (sc_OITCompositingPass)
{
int l9_15=((l9_11+1)*4)-1;
float l9_16=floor((l9_8.w*255.0)+0.5);
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_15>=(l9_11*4))
{
param[l9_15]=(param[l9_15]*4)+int(floor(mod(l9_16,4.0)));
l9_16=floor(l9_16*0.25);
l9_15--;
continue;
}
else
{
break;
}
}
}
#endif
depths[0]=param[0];
depths[1]=param[1];
depths[2]=param[2];
depths[3]=param[3];
depths[4]=param[4];
depths[5]=param[5];
depths[6]=param[6];
depths[7]=param[7];
int param_1[8];
param_1[0]=param[0];
param_1[1]=param[1];
param_1[2]=param[2];
param_1[3]=param[3];
param_1[4]=param[4];
param_1[5]=param[5];
param_1[6]=param[6];
param_1[7]=param[7];
#if (sc_OITCompositingPass)
{
int l9_17=((l9_11+1)*4)-1;
float l9_18=floor((l9_8.z*255.0)+0.5);
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_17>=(l9_11*4))
{
param_1[l9_17]=(param_1[l9_17]*4)+int(floor(mod(l9_18,4.0)));
l9_18=floor(l9_18*0.25);
l9_17--;
continue;
}
else
{
break;
}
}
}
#endif
depths[0]=param_1[0];
depths[1]=param_1[1];
depths[2]=param_1[2];
depths[3]=param_1[3];
depths[4]=param_1[4];
depths[5]=param_1[5];
depths[6]=param_1[6];
depths[7]=param_1[7];
int param_2[8];
param_2[0]=param_1[0];
param_2[1]=param_1[1];
param_2[2]=param_1[2];
param_2[3]=param_1[3];
param_2[4]=param_1[4];
param_2[5]=param_1[5];
param_2[6]=param_1[6];
param_2[7]=param_1[7];
#if (sc_OITCompositingPass)
{
int l9_19=((l9_11+1)*4)-1;
float l9_20=floor((l9_8.y*255.0)+0.5);
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_19>=(l9_11*4))
{
param_2[l9_19]=(param_2[l9_19]*4)+int(floor(mod(l9_20,4.0)));
l9_20=floor(l9_20*0.25);
l9_19--;
continue;
}
else
{
break;
}
}
}
#endif
depths[0]=param_2[0];
depths[1]=param_2[1];
depths[2]=param_2[2];
depths[3]=param_2[3];
depths[4]=param_2[4];
depths[5]=param_2[5];
depths[6]=param_2[6];
depths[7]=param_2[7];
int param_3[8];
param_3[0]=param_2[0];
param_3[1]=param_2[1];
param_3[2]=param_2[2];
param_3[3]=param_2[3];
param_3[4]=param_2[4];
param_3[5]=param_2[5];
param_3[6]=param_2[6];
param_3[7]=param_2[7];
#if (sc_OITCompositingPass)
{
int l9_21=((l9_11+1)*4)-1;
float l9_22=floor((l9_8.x*255.0)+0.5);
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_21>=(l9_11*4))
{
param_3[l9_21]=(param_3[l9_21]*4)+int(floor(mod(l9_22,4.0)));
l9_22=floor(l9_22*0.25);
l9_21--;
continue;
}
else
{
break;
}
}
}
#endif
depths[0]=param_3[0];
depths[1]=param_3[1];
depths[2]=param_3[2];
depths[3]=param_3[3];
depths[4]=param_3[4];
depths[5]=param_3[5];
depths[6]=param_3[6];
depths[7]=param_3[7];
int param_4[8];
param_4[0]=param_3[0];
param_4[1]=param_3[1];
param_4[2]=param_3[2];
param_4[3]=param_3[3];
param_4[4]=param_3[4];
param_4[5]=param_3[5];
param_4[6]=param_3[6];
param_4[7]=param_3[7];
#if (sc_OITCompositingPass)
{
int l9_23=((l9_11+1)*4)-1;
float l9_24=floor((l9_9.w*255.0)+0.5);
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_23>=(l9_11*4))
{
param_4[l9_23]=(param_4[l9_23]*4)+int(floor(mod(l9_24,4.0)));
l9_24=floor(l9_24*0.25);
l9_23--;
continue;
}
else
{
break;
}
}
}
#endif
depths[0]=param_4[0];
depths[1]=param_4[1];
depths[2]=param_4[2];
depths[3]=param_4[3];
depths[4]=param_4[4];
depths[5]=param_4[5];
depths[6]=param_4[6];
depths[7]=param_4[7];
int param_5[8];
param_5[0]=param_4[0];
param_5[1]=param_4[1];
param_5[2]=param_4[2];
param_5[3]=param_4[3];
param_5[4]=param_4[4];
param_5[5]=param_4[5];
param_5[6]=param_4[6];
param_5[7]=param_4[7];
#if (sc_OITCompositingPass)
{
int l9_25=((l9_11+1)*4)-1;
float l9_26=floor((l9_9.z*255.0)+0.5);
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_25>=(l9_11*4))
{
param_5[l9_25]=(param_5[l9_25]*4)+int(floor(mod(l9_26,4.0)));
l9_26=floor(l9_26*0.25);
l9_25--;
continue;
}
else
{
break;
}
}
}
#endif
depths[0]=param_5[0];
depths[1]=param_5[1];
depths[2]=param_5[2];
depths[3]=param_5[3];
depths[4]=param_5[4];
depths[5]=param_5[5];
depths[6]=param_5[6];
depths[7]=param_5[7];
int param_6[8];
param_6[0]=param_5[0];
param_6[1]=param_5[1];
param_6[2]=param_5[2];
param_6[3]=param_5[3];
param_6[4]=param_5[4];
param_6[5]=param_5[5];
param_6[6]=param_5[6];
param_6[7]=param_5[7];
#if (sc_OITCompositingPass)
{
int l9_27=((l9_11+1)*4)-1;
float l9_28=floor((l9_9.y*255.0)+0.5);
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_27>=(l9_11*4))
{
param_6[l9_27]=(param_6[l9_27]*4)+int(floor(mod(l9_28,4.0)));
l9_28=floor(l9_28*0.25);
l9_27--;
continue;
}
else
{
break;
}
}
}
#endif
depths[0]=param_6[0];
depths[1]=param_6[1];
depths[2]=param_6[2];
depths[3]=param_6[3];
depths[4]=param_6[4];
depths[5]=param_6[5];
depths[6]=param_6[6];
depths[7]=param_6[7];
int param_7[8];
param_7[0]=param_6[0];
param_7[1]=param_6[1];
param_7[2]=param_6[2];
param_7[3]=param_6[3];
param_7[4]=param_6[4];
param_7[5]=param_6[5];
param_7[6]=param_6[6];
param_7[7]=param_6[7];
#if (sc_OITCompositingPass)
{
int l9_29=((l9_11+1)*4)-1;
float l9_30=floor((l9_9.x*255.0)+0.5);
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_29>=(l9_11*4))
{
param_7[l9_29]=(param_7[l9_29]*4)+int(floor(mod(l9_30,4.0)));
l9_30=floor(l9_30*0.25);
l9_29--;
continue;
}
else
{
break;
}
}
}
#endif
depths[0]=param_7[0];
depths[1]=param_7[1];
depths[2]=param_7[2];
depths[3]=param_7[3];
depths[4]=param_7[4];
depths[5]=param_7[5];
depths[6]=param_7[6];
depths[7]=param_7[7];
int param_8[8];
param_8[0]=alphas[0];
param_8[1]=alphas[1];
param_8[2]=alphas[2];
param_8[3]=alphas[3];
param_8[4]=alphas[4];
param_8[5]=alphas[5];
param_8[6]=alphas[6];
param_8[7]=alphas[7];
#if (sc_OITCompositingPass)
{
int l9_31=((l9_11+1)*4)-1;
float l9_32=floor((l9_10.w*255.0)+0.5);
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_31>=(l9_11*4))
{
param_8[l9_31]=(param_8[l9_31]*4)+int(floor(mod(l9_32,4.0)));
l9_32=floor(l9_32*0.25);
l9_31--;
continue;
}
else
{
break;
}
}
}
#endif
alphas[0]=param_8[0];
alphas[1]=param_8[1];
alphas[2]=param_8[2];
alphas[3]=param_8[3];
alphas[4]=param_8[4];
alphas[5]=param_8[5];
alphas[6]=param_8[6];
alphas[7]=param_8[7];
int param_9[8];
param_9[0]=param_8[0];
param_9[1]=param_8[1];
param_9[2]=param_8[2];
param_9[3]=param_8[3];
param_9[4]=param_8[4];
param_9[5]=param_8[5];
param_9[6]=param_8[6];
param_9[7]=param_8[7];
#if (sc_OITCompositingPass)
{
int l9_33=((l9_11+1)*4)-1;
float l9_34=floor((l9_10.z*255.0)+0.5);
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_33>=(l9_11*4))
{
param_9[l9_33]=(param_9[l9_33]*4)+int(floor(mod(l9_34,4.0)));
l9_34=floor(l9_34*0.25);
l9_33--;
continue;
}
else
{
break;
}
}
}
#endif
alphas[0]=param_9[0];
alphas[1]=param_9[1];
alphas[2]=param_9[2];
alphas[3]=param_9[3];
alphas[4]=param_9[4];
alphas[5]=param_9[5];
alphas[6]=param_9[6];
alphas[7]=param_9[7];
int param_10[8];
param_10[0]=param_9[0];
param_10[1]=param_9[1];
param_10[2]=param_9[2];
param_10[3]=param_9[3];
param_10[4]=param_9[4];
param_10[5]=param_9[5];
param_10[6]=param_9[6];
param_10[7]=param_9[7];
#if (sc_OITCompositingPass)
{
int l9_35=((l9_11+1)*4)-1;
float l9_36=floor((l9_10.y*255.0)+0.5);
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_35>=(l9_11*4))
{
param_10[l9_35]=(param_10[l9_35]*4)+int(floor(mod(l9_36,4.0)));
l9_36=floor(l9_36*0.25);
l9_35--;
continue;
}
else
{
break;
}
}
}
#endif
alphas[0]=param_10[0];
alphas[1]=param_10[1];
alphas[2]=param_10[2];
alphas[3]=param_10[3];
alphas[4]=param_10[4];
alphas[5]=param_10[5];
alphas[6]=param_10[6];
alphas[7]=param_10[7];
int param_11[8];
param_11[0]=param_10[0];
param_11[1]=param_10[1];
param_11[2]=param_10[2];
param_11[3]=param_10[3];
param_11[4]=param_10[4];
param_11[5]=param_10[5];
param_11[6]=param_10[6];
param_11[7]=param_10[7];
#if (sc_OITCompositingPass)
{
int l9_37=((l9_11+1)*4)-1;
float l9_38=floor((l9_10.x*255.0)+0.5);
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_37>=(l9_11*4))
{
param_11[l9_37]=(param_11[l9_37]*4)+int(floor(mod(l9_38,4.0)));
l9_38=floor(l9_38*0.25);
l9_37--;
continue;
}
else
{
break;
}
}
}
#endif
alphas[0]=param_11[0];
alphas[1]=param_11[1];
alphas[2]=param_11[2];
alphas[3]=param_11[3];
alphas[4]=param_11[4];
alphas[5]=param_11[5];
alphas[6]=param_11[6];
alphas[7]=param_11[7];
}
l9_7=l9_10;
l9_6=l9_9;
l9_5=l9_8;
l9_11++;
continue;
}
else
{
break;
}
}
mediump vec4 l9_39=texture2D(sc_OITFilteredDepthBoundsTexture,l9_0);
int l9_40;
#if (sc_SkinBonesCount>0)
{
float l9_41;
#if (sc_SkinBonesCount>0)
{
l9_41=0.001;
}
#else
{
l9_41=0.0;
}
#endif
float l9_42=(1.0-l9_39.x)*1000.0;
l9_40=int(clamp(((l9_42+l9_41)-l9_42)/((l9_39.y*1000.0)-l9_42),0.0,1.0)*65535.0);
}
#else
{
l9_40=0;
}
#endif
float l9_43;
#if (UseViewSpaceDepthVariant&&((sc_OITDepthGatherPass||sc_OITCompositingPass)||sc_OITDepthBoundsPass))
{
l9_43=varViewSpaceDepth;
}
#else
{
l9_43=sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][3].z/(sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][2].z+((sc_GetGlFragCoord().z*2.0)-1.0));
}
#endif
float l9_44=(1.0-l9_39.x)*1000.0;
float l9_45=l9_43-l9_44;
vec4 l9_46;
l9_46=materialColor*materialColor.w;
vec4 l9_47;
int l9_48=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_48<8)
{
int l9_49=depths[l9_48];
int l9_50=int(clamp(l9_45/((l9_39.y*1000.0)-l9_44),0.0,1.0)*65535.0)-l9_40;
bool l9_51=l9_49<l9_50;
bool l9_52;
if (l9_51)
{
l9_52=depths[l9_48]>0;
}
else
{
l9_52=l9_51;
}
if (l9_52)
{
vec3 l9_53=l9_46.xyz*(1.0-(float(alphas[l9_48])*0.00392157));
l9_47=vec4(l9_53.x,l9_53.y,l9_53.z,l9_46.w);
}
else
{
l9_47=l9_46;
}
l9_46=l9_47;
l9_48++;
continue;
}
else
{
break;
}
}
sc_writeFragData0(l9_46);
#if (sc_OITMaxLayersVisualizeLayerCount)
{
discard;
}
#endif
}
#endif
}
void main()
{
#if (sc_DepthOnly)
{
return;
}
#endif
sc_DiscardStereoFragment();
bool l9_0=overrideTimeEnabled==1;
float l9_1;
if (l9_0)
{
l9_1=overrideTimeElapsed;
}
else
{
l9_1=sc_Time.x;
}
float l9_2;
if (l9_0)
{
l9_2=overrideTimeDelta;
}
else
{
l9_2=sc_Time.y;
}
vec2 l9_3=getScreenUV();
int l9_4;
#if (screenTexHasSwappedViews)
{
l9_4=1-sc_GetStereoViewIndex();
}
#else
{
l9_4=sc_GetStereoViewIndex();
}
#endif
vec4 l9_5=sc_SampleTextureBiasOrLevel(screenTexDims.xy,screenTexLayout,l9_4,l9_3,(int(SC_USE_UV_TRANSFORM_screenTex)!=0),screenTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_screenTex,SC_SOFTWARE_WRAP_MODE_V_screenTex),(int(SC_USE_UV_MIN_MAX_screenTex)!=0),screenTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_screenTex)!=0),screenTexBorderColor,0.0,screenTex);
vec3 l9_6;
Node32_If_else(0.0,vec3(0.0),vec3(0.0),l9_6,ssGlobals(l9_1,l9_2,0.0,l9_3,varPackedTex.xy));
vec4 l9_7=vec4(l9_6.x,l9_6.y,l9_6.z,vec4(0.0).w);
l9_7.w=1.0;
int l9_8;
#if (opacityTexHasSwappedViews)
{
l9_8=1-sc_GetStereoViewIndex();
}
#else
{
l9_8=sc_GetStereoViewIndex();
}
#endif
vec4 l9_9=sc_SampleTextureBiasOrLevel(opacityTexDims.xy,opacityTexLayout,l9_8,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_opacityTex)!=0),opacityTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_opacityTex,SC_SOFTWARE_WRAP_MODE_V_opacityTex),(int(SC_USE_UV_MIN_MAX_opacityTex)!=0),opacityTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_opacityTex)!=0),opacityTexBorderColor,0.0,opacityTex);
vec4 l9_10=mix(l9_5,mix(l9_5,l9_7,l9_9),vec4(overallintensity));
float l9_11=l9_10.w;
#if (sc_BlendMode_AlphaTest)
{
if (l9_11<alphaTestThreshold)
{
discard;
}
}
#endif
#if (ENABLE_STIPPLE_PATTERN_TEST)
{
if (l9_11<((mod(dot(floor(mod(sc_GetGlFragCoord().xy,vec2(4.0))),vec2(4.0,1.0))*9.0,16.0)+1.0)*0.0588235))
{
discard;
}
}
#endif
vec4 l9_12=ngsPixelShader(l9_10);
vec4 l9_13=max(l9_12,vec4(0.0));
sc_writeFragData0(l9_13);
vec4 l9_14=clamp(l9_13,vec4(0.0),vec4(1.0));
#if (sc_OITDepthBoundsPass)
{
#if (sc_OITDepthBoundsPass)
{
float l9_15;
#if (UseViewSpaceDepthVariant&&((sc_OITDepthGatherPass||sc_OITCompositingPass)||sc_OITDepthBoundsPass))
{
l9_15=varViewSpaceDepth;
}
#else
{
l9_15=sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][3].z/(sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][2].z+((sc_GetGlFragCoord().z*2.0)-1.0));
}
#endif
float l9_16=clamp(l9_15*0.001,0.0,1.0);
sc_writeFragData0(vec4(max(0.0,1.00392-l9_16),min(1.0,l9_16+0.00392157),0.0,0.0));
}
#endif
}
#else
{
#if (sc_OITDepthPrepass)
{
sc_writeFragData0(vec4(1.0));
}
#else
{
#if (sc_OITDepthGatherPass)
{
oitDepthGather(l9_14);
}
#else
{
#if (sc_OITCompositingPass)
{
oitCompositing(l9_14);
}
#else
{
#if (sc_OITFrontLayerPass)
{
#if (sc_OITFrontLayerPass)
{
vec4 l9_17=texture2D(sc_OITFrontDepthTexture,getScreenUV());
float l9_18;
#if (sc_SkinBonesCount>0)
{
l9_18=5e-07;
}
#else
{
l9_18=5e-08;
}
#endif
if (abs(sc_GetGlFragCoord().z-l9_17.x)>l9_18)
{
discard;
}
sc_writeFragData0(l9_14);
}
#endif
}
#else
{
sc_writeFragData0(l9_13);
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif
}
#endif // #elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
