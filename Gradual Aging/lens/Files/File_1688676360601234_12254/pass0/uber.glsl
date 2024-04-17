#version 100 sc_convert_to 300 es
#if defined VERTEX_SHADER
#include <std2.glsl>
#include <std2_vs.glsl>
#include <std2_texture.glsl>
#include <std2_receiver.glsl>
#include <std2_fs.glsl>
//SG_REFLECTION_BEGIN(100)
//attribute vec4 color 18
//sampler sampler Tweak_N63SmpSC 2:11
//sampler sampler Tweak_N85SmpSC 2:12
//sampler sampler intensityTextureSmpSC 2:13
//sampler sampler sc_OITCommonSampler 2:14
//SG_REFLECTION_END
uniform vec4 intensityTextureDims;
uniform vec4 Tweak_N63Dims;
uniform vec4 Tweak_N85Dims;
uniform float depthRef;
uniform int overrideTimeEnabled;
uniform float overrideTimeElapsed;
uniform float overrideTimeDelta;
uniform float correctedIntensity;
uniform vec4 intensityTextureSize;
uniform vec4 intensityTextureView;
uniform mat3 intensityTextureTransform;
uniform vec4 intensityTextureUvMinMax;
uniform vec4 intensityTextureBorderColor;
uniform int DebugAlbedo;
uniform int DebugSpecColor;
uniform int DebugRoughness;
uniform int DebugNormal;
uniform int DebugAo;
uniform float DebugDirectDiffuse;
uniform float DebugDirectSpecular;
uniform float DebugIndirectDiffuse;
uniform float DebugIndirectSpecular;
uniform float DebugRoughnessOffset;
uniform float DebugRoughnessScale;
uniform float DebugNormalIntensity;
uniform int DebugEnvBRDFApprox;
uniform int DebugEnvBentNormal;
uniform float DebugEnvMip;
uniform int DebugFringelessMetallic;
uniform int DebugAcesToneMapping;
uniform int DebugLinearToneMapping;
uniform float reflBlurWidth;
uniform float reflBlurMinRough;
uniform float reflBlurMaxRough;
uniform float alphaTestThreshold;
uniform vec4 Tweak_N63Size;
uniform vec4 Tweak_N63View;
uniform mat3 Tweak_N63Transform;
uniform vec4 Tweak_N63UvMinMax;
uniform vec4 Tweak_N63BorderColor;
uniform float transition;
uniform float Tweak_N60;
uniform float Tweak_N83;
uniform vec2 Tweak_N65;
uniform float Tweak_N8;
uniform float Tweak_N44;
uniform float CoreWidth;
uniform float Tweak_N30;
uniform float Tweak_N25;
uniform float Tweak_N21;
uniform vec4 Tweak_N85Size;
uniform vec4 Tweak_N85View;
uniform mat3 Tweak_N85Transform;
uniform vec4 Tweak_N85UvMinMax;
uniform vec4 Tweak_N85BorderColor;
varying vec4 varColor;
attribute vec4 color;
mat3 g9_79;
vec2 g9_80;
vec3 g9_81;
void ngsVertexShaderEnd(sc_Vertex_t v,vec3 WorldPosition,vec3 WorldNormal,vec3 WorldTangent,vec4 ScreenPosition)
{
varPos=WorldPosition;
varNormal=normalize(WorldNormal);
vec3 l9_0=normalize(WorldTangent);
varTangent=vec4(l9_0.x,l9_0.y,l9_0.z,varTangent.w);
varTangent.w=tangent.w;
#if (UseViewSpaceDepthVariant&&((sc_OITDepthGatherPass||sc_OITCompositingPass)||sc_OITDepthBoundsPass))
{
vec4 param=v.position;
varViewSpaceDepth=-sc_ObjectToView(param).z;
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
vec4 param_1=v.position;
varShadowTex=getProjectedTexCoords(param_1);
}
#endif
vec4 param_2=l9_1;
vec4 l9_5=applyDepthAlgorithm(param_2);
vec4 param_3=l9_5;
sc_SetClipPosition(param_3);
}
void main()
{
#if (sc_ProxyMode)
{
vec4 param=vec4(position.xy,depthRef,1.0);
sc_SetClipPosition(param);
return;
}
#endif
sc_Vertex_t l9_0=sc_LoadVertexAttributes();
sc_BlendVertex(l9_0);
sc_Vertex_t l9_1=l9_0;
sc_SkinVertex(l9_1);
sc_Vertex_t l9_2=l9_1;
#if (sc_RenderingSpace==3)
{
varPos=vec3(0.0);
varNormal=l9_2.normal;
varTangent=vec4(l9_2.tangent.x,l9_2.tangent.y,l9_2.tangent.z,varTangent.w);
}
#else
{
#if (sc_RenderingSpace==4)
{
varPos=vec3(0.0);
varNormal=l9_2.normal;
varTangent=vec4(l9_2.tangent.x,l9_2.tangent.y,l9_2.tangent.z,varTangent.w);
}
#else
{
#if (sc_RenderingSpace==2)
{
varPos=l9_2.position.xyz;
varNormal=l9_2.normal;
varTangent=vec4(l9_2.tangent.x,l9_2.tangent.y,l9_2.tangent.z,varTangent.w);
}
#else
{
#if (sc_RenderingSpace==1)
{
varPos=(sc_ModelMatrix*l9_2.position).xyz;
varNormal=sc_NormalMatrix*l9_2.normal;
vec3 l9_3=sc_NormalMatrix*l9_2.tangent;
varTangent=vec4(l9_3.x,l9_3.y,l9_3.z,varTangent.w);
}
#endif
}
#endif
}
#endif
}
#endif
varColor=color;
sc_Vertex_t param_1=l9_2;
vec3 param_2=varPos;
vec3 param_3=varNormal;
vec3 param_4=varTangent.xyz;
vec4 param_5=l9_2.position;
ngsVertexShaderEnd(param_1,param_2,param_3,param_4,param_5);
}
#elif defined FRAGMENT_SHADER // #if defined VERTEX_SHADER
#include <std2.glsl>
#include <std2_vs.glsl>
#include <std2_texture.glsl>
#include <std2_receiver.glsl>
#include <std2_fs.glsl>
//SG_REFLECTION_BEGIN(100)
//sampler sampler Tweak_N63SmpSC 2:11
//sampler sampler Tweak_N85SmpSC 2:12
//sampler sampler intensityTextureSmpSC 2:13
//sampler sampler sc_OITCommonSampler 2:14
//texture texture2D Tweak_N63 2:0:2:11
//texture texture2D Tweak_N85 2:1:2:12
//texture texture2D intensityTexture 2:2:2:13
//texture texture2D sc_OITAlpha0 2:3:2:14
//texture texture2D sc_OITAlpha1 2:4:2:14
//texture texture2D sc_OITDepthHigh0 2:5:2:14
//texture texture2D sc_OITDepthHigh1 2:6:2:14
//texture texture2D sc_OITDepthLow0 2:7:2:14
//texture texture2D sc_OITDepthLow1 2:8:2:14
//texture texture2D sc_OITFilteredDepthBoundsTexture 2:9:2:14
//texture texture2D sc_OITFrontDepthTexture 2:10:2:14
//SG_REFLECTION_END
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
const ivec2 g9_48=ivec2(SC_SOFTWARE_WRAP_MODE_U_intensityTexture,SC_SOFTWARE_WRAP_MODE_V_intensityTexture);
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
#ifndef Tweak_N63HasSwappedViews
#define Tweak_N63HasSwappedViews 0
#elif Tweak_N63HasSwappedViews==1
#undef Tweak_N63HasSwappedViews
#define Tweak_N63HasSwappedViews 1
#endif
#ifndef Tweak_N63Layout
#define Tweak_N63Layout 0
#endif
#ifndef Tweak_N85HasSwappedViews
#define Tweak_N85HasSwappedViews 0
#elif Tweak_N85HasSwappedViews==1
#undef Tweak_N85HasSwappedViews
#define Tweak_N85HasSwappedViews 1
#endif
#ifndef Tweak_N85Layout
#define Tweak_N85Layout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_Tweak_N63
#define SC_USE_UV_TRANSFORM_Tweak_N63 0
#elif SC_USE_UV_TRANSFORM_Tweak_N63==1
#undef SC_USE_UV_TRANSFORM_Tweak_N63
#define SC_USE_UV_TRANSFORM_Tweak_N63 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_Tweak_N63
#define SC_SOFTWARE_WRAP_MODE_U_Tweak_N63 -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_Tweak_N63
#define SC_SOFTWARE_WRAP_MODE_V_Tweak_N63 -1
#endif
const ivec2 g9_55=ivec2(SC_SOFTWARE_WRAP_MODE_U_Tweak_N63,SC_SOFTWARE_WRAP_MODE_V_Tweak_N63);
#ifndef SC_USE_UV_MIN_MAX_Tweak_N63
#define SC_USE_UV_MIN_MAX_Tweak_N63 0
#elif SC_USE_UV_MIN_MAX_Tweak_N63==1
#undef SC_USE_UV_MIN_MAX_Tweak_N63
#define SC_USE_UV_MIN_MAX_Tweak_N63 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_Tweak_N63
#define SC_USE_CLAMP_TO_BORDER_Tweak_N63 0
#elif SC_USE_CLAMP_TO_BORDER_Tweak_N63==1
#undef SC_USE_CLAMP_TO_BORDER_Tweak_N63
#define SC_USE_CLAMP_TO_BORDER_Tweak_N63 1
#endif
#ifndef SC_USE_UV_TRANSFORM_Tweak_N85
#define SC_USE_UV_TRANSFORM_Tweak_N85 0
#elif SC_USE_UV_TRANSFORM_Tweak_N85==1
#undef SC_USE_UV_TRANSFORM_Tweak_N85
#define SC_USE_UV_TRANSFORM_Tweak_N85 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_Tweak_N85
#define SC_SOFTWARE_WRAP_MODE_U_Tweak_N85 -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_Tweak_N85
#define SC_SOFTWARE_WRAP_MODE_V_Tweak_N85 -1
#endif
const ivec2 g9_56=ivec2(SC_SOFTWARE_WRAP_MODE_U_Tweak_N85,SC_SOFTWARE_WRAP_MODE_V_Tweak_N85);
#ifndef SC_USE_UV_MIN_MAX_Tweak_N85
#define SC_USE_UV_MIN_MAX_Tweak_N85 0
#elif SC_USE_UV_MIN_MAX_Tweak_N85==1
#undef SC_USE_UV_MIN_MAX_Tweak_N85
#define SC_USE_UV_MIN_MAX_Tweak_N85 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_Tweak_N85
#define SC_USE_CLAMP_TO_BORDER_Tweak_N85 0
#elif SC_USE_CLAMP_TO_BORDER_Tweak_N85==1
#undef SC_USE_CLAMP_TO_BORDER_Tweak_N85
#define SC_USE_CLAMP_TO_BORDER_Tweak_N85 1
#endif
uniform vec4 intensityTextureDims;
uniform float correctedIntensity;
uniform mat3 intensityTextureTransform;
uniform vec4 intensityTextureUvMinMax;
uniform vec4 intensityTextureBorderColor;
uniform float alphaTestThreshold;
uniform vec4 Tweak_N63Dims;
uniform vec4 Tweak_N85Dims;
uniform float transition;
uniform float Tweak_N60;
uniform float Tweak_N83;
uniform vec2 Tweak_N65;
uniform float Tweak_N8;
uniform float Tweak_N44;
uniform float CoreWidth;
uniform float Tweak_N30;
uniform float Tweak_N25;
uniform float Tweak_N21;
uniform int overrideTimeEnabled;
uniform float overrideTimeElapsed;
uniform float overrideTimeDelta;
uniform mat3 Tweak_N63Transform;
uniform vec4 Tweak_N63UvMinMax;
uniform vec4 Tweak_N63BorderColor;
uniform mat3 Tweak_N85Transform;
uniform vec4 Tweak_N85UvMinMax;
uniform vec4 Tweak_N85BorderColor;
uniform vec4 intensityTextureSize;
uniform vec4 intensityTextureView;
uniform int DebugAlbedo;
uniform int DebugSpecColor;
uniform int DebugRoughness;
uniform int DebugNormal;
uniform int DebugAo;
uniform float DebugDirectDiffuse;
uniform float DebugDirectSpecular;
uniform float DebugIndirectDiffuse;
uniform float DebugIndirectSpecular;
uniform float DebugRoughnessOffset;
uniform float DebugRoughnessScale;
uniform float DebugNormalIntensity;
uniform int DebugEnvBRDFApprox;
uniform int DebugEnvBentNormal;
uniform float DebugEnvMip;
uniform int DebugFringelessMetallic;
uniform int DebugAcesToneMapping;
uniform int DebugLinearToneMapping;
uniform float reflBlurWidth;
uniform float reflBlurMinRough;
uniform float reflBlurMaxRough;
uniform vec4 Tweak_N63Size;
uniform vec4 Tweak_N63View;
uniform vec4 Tweak_N85Size;
uniform vec4 Tweak_N85View;
uniform mediump sampler2D Tweak_N63;
uniform mediump sampler2D Tweak_N85;
uniform mediump sampler2D intensityTexture;
uniform mediump sampler2D sc_OITFrontDepthTexture;
uniform mediump sampler2D sc_OITDepthHigh0;
uniform mediump sampler2D sc_OITDepthLow0;
uniform mediump sampler2D sc_OITAlpha0;
uniform mediump sampler2D sc_OITDepthHigh1;
uniform mediump sampler2D sc_OITDepthLow1;
uniform mediump sampler2D sc_OITAlpha1;
uniform mediump sampler2D sc_OITFilteredDepthBoundsTexture;
varying vec4 varColor;
vec3 g9_63;
vec4 g9_64;
vec4 g9_65;
vec4 g9_66;
float g9_67;
int Tweak_N63GetStereoViewIndex()
{
#if (Tweak_N63HasSwappedViews)
{
return 1-sc_GetStereoViewIndex();
}
#else
{
return sc_GetStereoViewIndex();
}
#endif
}
int Tweak_N85GetStereoViewIndex()
{
#if (Tweak_N85HasSwappedViews)
{
return 1-sc_GetStereoViewIndex();
}
#else
{
return sc_GetStereoViewIndex();
}
#endif
}
int intensityTextureGetStereoViewIndex()
{
#if (intensityTextureHasSwappedViews)
{
return 1-sc_GetStereoViewIndex();
}
#else
{
return sc_GetStereoViewIndex();
}
#endif
}
float transformSingleColor(float original,float intMap,float target)
{
#if ((BLEND_MODE_REALISTIC||BLEND_MODE_FORGRAY)||BLEND_MODE_NOTBRIGHT)
{
return original/pow(1.0-target,intMap);
}
#else
{
#if (BLEND_MODE_DIVISION)
{
return original/(1.0-target);
}
#else
{
#if (BLEND_MODE_BRIGHT)
{
return original/pow(1.0-target,2.0-(2.0*original));
}
#endif
}
#endif
}
#endif
return 0.0;
}
vec3 transformColor(float yValue,vec3 original,vec3 target,float weight,float intMap)
{
#if (BLEND_MODE_INTENSE)
{
vec3 l9_0=original;
vec4 l9_1;
if (l9_0.y<l9_0.z)
{
l9_1=vec4(l9_0.zy,-1.0,0.666667);
}
else
{
l9_1=vec4(l9_0.yz,0.0,-0.333333);
}
vec4 l9_2;
if (l9_0.x<l9_1.x)
{
l9_2=vec4(l9_1.xy,g9_67,l9_0.x);
}
else
{
l9_2=vec4(l9_0.x,l9_1.y,g9_67,l9_1.x);
}
float l9_3=l9_2.x-((l9_2.x-min(l9_2.w,l9_2.y))*0.5);
float l9_4=6.0*target.x;
return mix(original,((clamp(vec3(abs(l9_4-3.0)-1.0,2.0-abs(l9_4-2.0),2.0-abs(l9_4-4.0)),vec3(0.0),vec3(1.0))-vec3(0.5))*((1.0-abs((2.0*l9_3)-1.0))*target.y))+vec3(l9_3),vec3(weight));
}
#else
{
float param=yValue;
float param_1=intMap;
float param_2=target.x;
vec3 l9_5=g9_63;
l9_5.x=transformSingleColor(param,param_1,param_2);
float param_3=yValue;
float param_4=intMap;
float param_5=target.y;
vec3 l9_6=l9_5;
l9_6.y=transformSingleColor(param_3,param_4,param_5);
float param_6=yValue;
float param_7=intMap;
float param_8=target.z;
vec3 l9_7=l9_6;
l9_7.z=transformSingleColor(param_6,param_7,param_8);
return mix(original,clamp(l9_7,vec3(0.0),vec3(1.0)),vec3(weight));
}
#endif
}
vec3 definedBlend(vec3 a,vec3 b)
{
#if (BLEND_MODE_LIGHTEN)
{
return max(a,b);
}
#else
{
#if (BLEND_MODE_DARKEN)
{
return min(a,b);
}
#else
{
#if (BLEND_MODE_DIVIDE)
{
return b/a;
}
#else
{
#if (BLEND_MODE_AVERAGE)
{
return (a+b)*0.5;
}
#else
{
#if (BLEND_MODE_SUBTRACT)
{
return max((a+b)-vec3(1.0),vec3(0.0));
}
#else
{
#if (BLEND_MODE_DIFFERENCE)
{
return abs(a-b);
}
#else
{
#if (BLEND_MODE_NEGATION)
{
return vec3(1.0)-abs((vec3(1.0)-a)-b);
}
#else
{
#if (BLEND_MODE_EXCLUSION)
{
return (a+b)-((a*2.0)*b);
}
#else
{
#if (BLEND_MODE_OVERLAY)
{
float l9_0;
if (a.x<0.5)
{
l9_0=(2.0*a.x)*b.x;
}
else
{
l9_0=1.0-((2.0*(1.0-a.x))*(1.0-b.x));
}
float l9_1;
if (a.y<0.5)
{
l9_1=(2.0*a.y)*b.y;
}
else
{
l9_1=1.0-((2.0*(1.0-a.y))*(1.0-b.y));
}
float l9_2;
if (a.z<0.5)
{
l9_2=(2.0*a.z)*b.z;
}
else
{
l9_2=1.0-((2.0*(1.0-a.z))*(1.0-b.z));
}
return vec3(l9_0,l9_1,l9_2);
}
#else
{
#if (BLEND_MODE_SOFT_LIGHT)
{
return (((vec3(1.0)-(b*2.0))*a)*a)+((a*2.0)*b);
}
#else
{
#if (BLEND_MODE_HARD_LIGHT)
{
float l9_3;
if (b.x<0.5)
{
l9_3=(2.0*b.x)*a.x;
}
else
{
l9_3=1.0-((2.0*(1.0-b.x))*(1.0-a.x));
}
float l9_4;
if (b.y<0.5)
{
l9_4=(2.0*b.y)*a.y;
}
else
{
l9_4=1.0-((2.0*(1.0-b.y))*(1.0-a.y));
}
float l9_5;
if (b.z<0.5)
{
l9_5=(2.0*b.z)*a.z;
}
else
{
l9_5=1.0-((2.0*(1.0-b.z))*(1.0-a.z));
}
return vec3(l9_3,l9_4,l9_5);
}
#else
{
#if (BLEND_MODE_COLOR_DODGE)
{
float l9_6;
if (b.x==1.0)
{
l9_6=b.x;
}
else
{
l9_6=min(a.x/(1.0-b.x),1.0);
}
float l9_7;
if (b.y==1.0)
{
l9_7=b.y;
}
else
{
l9_7=min(a.y/(1.0-b.y),1.0);
}
float l9_8;
if (b.z==1.0)
{
l9_8=b.z;
}
else
{
l9_8=min(a.z/(1.0-b.z),1.0);
}
return vec3(l9_6,l9_7,l9_8);
}
#else
{
#if (BLEND_MODE_COLOR_BURN)
{
float l9_9;
if (b.x==0.0)
{
l9_9=b.x;
}
else
{
l9_9=max(1.0-((1.0-a.x)/b.x),0.0);
}
float l9_10;
if (b.y==0.0)
{
l9_10=b.y;
}
else
{
l9_10=max(1.0-((1.0-a.y)/b.y),0.0);
}
float l9_11;
if (b.z==0.0)
{
l9_11=b.z;
}
else
{
l9_11=max(1.0-((1.0-a.z)/b.z),0.0);
}
return vec3(l9_9,l9_10,l9_11);
}
#else
{
#if (BLEND_MODE_LINEAR_LIGHT)
{
float l9_12;
if (b.x<0.5)
{
l9_12=max((a.x+(2.0*b.x))-1.0,0.0);
}
else
{
l9_12=min(a.x+(2.0*(b.x-0.5)),1.0);
}
float l9_13;
if (b.y<0.5)
{
l9_13=max((a.y+(2.0*b.y))-1.0,0.0);
}
else
{
l9_13=min(a.y+(2.0*(b.y-0.5)),1.0);
}
float l9_14;
if (b.z<0.5)
{
l9_14=max((a.z+(2.0*b.z))-1.0,0.0);
}
else
{
l9_14=min(a.z+(2.0*(b.z-0.5)),1.0);
}
return vec3(l9_12,l9_13,l9_14);
}
#else
{
#if (BLEND_MODE_VIVID_LIGHT)
{
float l9_15;
if (b.x<0.5)
{
float l9_16;
if ((2.0*b.x)==0.0)
{
l9_16=2.0*b.x;
}
else
{
l9_16=max(1.0-((1.0-a.x)/(2.0*b.x)),0.0);
}
l9_15=l9_16;
}
else
{
float l9_17;
if ((2.0*(b.x-0.5))==1.0)
{
l9_17=2.0*(b.x-0.5);
}
else
{
l9_17=min(a.x/(1.0-(2.0*(b.x-0.5))),1.0);
}
l9_15=l9_17;
}
float l9_18;
if (b.y<0.5)
{
float l9_19;
if ((2.0*b.y)==0.0)
{
l9_19=2.0*b.y;
}
else
{
l9_19=max(1.0-((1.0-a.y)/(2.0*b.y)),0.0);
}
l9_18=l9_19;
}
else
{
float l9_20;
if ((2.0*(b.y-0.5))==1.0)
{
l9_20=2.0*(b.y-0.5);
}
else
{
l9_20=min(a.y/(1.0-(2.0*(b.y-0.5))),1.0);
}
l9_18=l9_20;
}
float l9_21;
if (b.z<0.5)
{
float l9_22;
if ((2.0*b.z)==0.0)
{
l9_22=2.0*b.z;
}
else
{
l9_22=max(1.0-((1.0-a.z)/(2.0*b.z)),0.0);
}
l9_21=l9_22;
}
else
{
float l9_23;
if ((2.0*(b.z-0.5))==1.0)
{
l9_23=2.0*(b.z-0.5);
}
else
{
l9_23=min(a.z/(1.0-(2.0*(b.z-0.5))),1.0);
}
l9_21=l9_23;
}
return vec3(l9_15,l9_18,l9_21);
}
#else
{
#if (BLEND_MODE_PIN_LIGHT)
{
float l9_24;
if (b.x<0.5)
{
l9_24=min(a.x,2.0*b.x);
}
else
{
l9_24=max(a.x,2.0*(b.x-0.5));
}
float l9_25;
if (b.y<0.5)
{
l9_25=min(a.y,2.0*b.y);
}
else
{
l9_25=max(a.y,2.0*(b.y-0.5));
}
float l9_26;
if (b.z<0.5)
{
l9_26=min(a.z,2.0*b.z);
}
else
{
l9_26=max(a.z,2.0*(b.z-0.5));
}
return vec3(l9_24,l9_25,l9_26);
}
#else
{
#if (BLEND_MODE_HARD_MIX)
{
float l9_27;
if (b.x<0.5)
{
float l9_28;
if ((2.0*b.x)==0.0)
{
l9_28=2.0*b.x;
}
else
{
l9_28=max(1.0-((1.0-a.x)/(2.0*b.x)),0.0);
}
l9_27=l9_28;
}
else
{
float l9_29;
if ((2.0*(b.x-0.5))==1.0)
{
l9_29=2.0*(b.x-0.5);
}
else
{
l9_29=min(a.x/(1.0-(2.0*(b.x-0.5))),1.0);
}
l9_27=l9_29;
}
bool l9_30=l9_27<0.5;
float l9_31;
if (b.y<0.5)
{
float l9_32;
if ((2.0*b.y)==0.0)
{
l9_32=2.0*b.y;
}
else
{
l9_32=max(1.0-((1.0-a.y)/(2.0*b.y)),0.0);
}
l9_31=l9_32;
}
else
{
float l9_33;
if ((2.0*(b.y-0.5))==1.0)
{
l9_33=2.0*(b.y-0.5);
}
else
{
l9_33=min(a.y/(1.0-(2.0*(b.y-0.5))),1.0);
}
l9_31=l9_33;
}
bool l9_34=l9_31<0.5;
float l9_35;
if (b.z<0.5)
{
float l9_36;
if ((2.0*b.z)==0.0)
{
l9_36=2.0*b.z;
}
else
{
l9_36=max(1.0-((1.0-a.z)/(2.0*b.z)),0.0);
}
l9_35=l9_36;
}
else
{
float l9_37;
if ((2.0*(b.z-0.5))==1.0)
{
l9_37=2.0*(b.z-0.5);
}
else
{
l9_37=min(a.z/(1.0-(2.0*(b.z-0.5))),1.0);
}
l9_35=l9_37;
}
return vec3(l9_30 ? 0.0 : 1.0,l9_34 ? 0.0 : 1.0,(l9_35<0.5) ? 0.0 : 1.0);
}
#else
{
#if (BLEND_MODE_HARD_REFLECT)
{
float l9_38;
if (b.x==1.0)
{
l9_38=b.x;
}
else
{
l9_38=min((a.x*a.x)/(1.0-b.x),1.0);
}
float l9_39;
if (b.y==1.0)
{
l9_39=b.y;
}
else
{
l9_39=min((a.y*a.y)/(1.0-b.y),1.0);
}
float l9_40;
if (b.z==1.0)
{
l9_40=b.z;
}
else
{
l9_40=min((a.z*a.z)/(1.0-b.z),1.0);
}
return vec3(l9_38,l9_39,l9_40);
}
#else
{
#if (BLEND_MODE_HARD_GLOW)
{
float l9_41;
if (a.x==1.0)
{
l9_41=a.x;
}
else
{
l9_41=min((b.x*b.x)/(1.0-a.x),1.0);
}
float l9_42;
if (a.y==1.0)
{
l9_42=a.y;
}
else
{
l9_42=min((b.y*b.y)/(1.0-a.y),1.0);
}
float l9_43;
if (a.z==1.0)
{
l9_43=a.z;
}
else
{
l9_43=min((b.z*b.z)/(1.0-a.z),1.0);
}
return vec3(l9_41,l9_42,l9_43);
}
#else
{
#if (BLEND_MODE_HARD_PHOENIX)
{
return (min(a,b)-max(a,b))+vec3(1.0);
}
#else
{
#if (BLEND_MODE_HUE)
{
vec3 l9_44=a;
vec3 l9_45=b;
vec4 l9_46;
if (l9_44.y<l9_44.z)
{
l9_46=vec4(l9_44.zy,-1.0,0.666667);
}
else
{
l9_46=vec4(l9_44.yz,0.0,-0.333333);
}
vec4 l9_47;
if (l9_44.x<l9_46.x)
{
l9_47=vec4(l9_46.xy,g9_67,l9_44.x);
}
else
{
l9_47=vec4(l9_44.x,l9_46.y,g9_67,l9_46.x);
}
float l9_48=l9_47.x-min(l9_47.w,l9_47.y);
float l9_49=l9_47.x-(l9_48*0.5);
float l9_50=abs((2.0*l9_49)-1.0);
vec4 l9_51;
if (l9_45.y<l9_45.z)
{
l9_51=vec4(l9_45.zy,-1.0,0.666667);
}
else
{
l9_51=vec4(l9_45.yz,0.0,-0.333333);
}
vec4 l9_52;
if (l9_45.x<l9_51.x)
{
l9_52=vec4(l9_51.xyw,l9_45.x);
}
else
{
l9_52=vec4(l9_45.x,l9_51.yzx);
}
float l9_53=6.0*abs(((l9_52.w-l9_52.y)/((6.0*(l9_52.x-min(l9_52.w,l9_52.y)))+1e-07))+l9_52.z);
return ((clamp(vec3(abs(l9_53-3.0)-1.0,2.0-abs(l9_53-2.0),2.0-abs(l9_53-4.0)),vec3(0.0),vec3(1.0))-vec3(0.5))*((1.0-l9_50)*(l9_48/(1.0-l9_50))))+vec3(l9_49);
}
#else
{
#if (BLEND_MODE_SATURATION)
{
vec3 l9_54=a;
vec3 l9_55=b;
vec4 l9_56;
if (l9_54.y<l9_54.z)
{
l9_56=vec4(l9_54.zy,-1.0,0.666667);
}
else
{
l9_56=vec4(l9_54.yz,0.0,-0.333333);
}
vec4 l9_57;
if (l9_54.x<l9_56.x)
{
l9_57=vec4(l9_56.xyw,l9_54.x);
}
else
{
l9_57=vec4(l9_54.x,l9_56.yzx);
}
float l9_58=l9_57.x-min(l9_57.w,l9_57.y);
float l9_59=l9_57.x-(l9_58*0.5);
vec4 l9_60;
if (l9_55.y<l9_55.z)
{
l9_60=vec4(l9_55.zy,-1.0,0.666667);
}
else
{
l9_60=vec4(l9_55.yz,0.0,-0.333333);
}
vec4 l9_61;
if (l9_55.x<l9_60.x)
{
l9_61=vec4(l9_60.xy,g9_67,l9_55.x);
}
else
{
l9_61=vec4(l9_55.x,l9_60.y,g9_67,l9_60.x);
}
float l9_62=l9_61.x-min(l9_61.w,l9_61.y);
float l9_63=6.0*abs(((l9_57.w-l9_57.y)/((6.0*l9_58)+1e-07))+l9_57.z);
return ((clamp(vec3(abs(l9_63-3.0)-1.0,2.0-abs(l9_63-2.0),2.0-abs(l9_63-4.0)),vec3(0.0),vec3(1.0))-vec3(0.5))*((1.0-abs((2.0*l9_59)-1.0))*(l9_62/(1.0-abs((2.0*(l9_61.x-(l9_62*0.5)))-1.0)))))+vec3(l9_59);
}
#else
{
#if (BLEND_MODE_COLOR)
{
vec3 l9_64=a;
vec3 l9_65=b;
vec4 l9_66;
if (l9_65.y<l9_65.z)
{
l9_66=vec4(l9_65.zy,-1.0,0.666667);
}
else
{
l9_66=vec4(l9_65.yz,0.0,-0.333333);
}
vec4 l9_67;
if (l9_65.x<l9_66.x)
{
l9_67=vec4(l9_66.xyw,l9_65.x);
}
else
{
l9_67=vec4(l9_65.x,l9_66.yzx);
}
float l9_68=l9_67.x-min(l9_67.w,l9_67.y);
vec4 l9_69;
if (l9_64.y<l9_64.z)
{
l9_69=vec4(l9_64.zy,-1.0,0.666667);
}
else
{
l9_69=vec4(l9_64.yz,0.0,-0.333333);
}
vec4 l9_70;
if (l9_64.x<l9_69.x)
{
l9_70=vec4(l9_69.xy,g9_67,l9_64.x);
}
else
{
l9_70=vec4(l9_64.x,l9_69.y,g9_67,l9_69.x);
}
float l9_71=l9_70.x-((l9_70.x-min(l9_70.w,l9_70.y))*0.5);
float l9_72=6.0*abs(((l9_67.w-l9_67.y)/((6.0*l9_68)+1e-07))+l9_67.z);
return ((clamp(vec3(abs(l9_72-3.0)-1.0,2.0-abs(l9_72-2.0),2.0-abs(l9_72-4.0)),vec3(0.0),vec3(1.0))-vec3(0.5))*((1.0-abs((2.0*l9_71)-1.0))*(l9_68/(1.0-abs((2.0*(l9_67.x-(l9_68*0.5)))-1.0)))))+vec3(l9_71);
}
#else
{
#if (BLEND_MODE_LUMINOSITY)
{
vec3 l9_73=a;
vec3 l9_74=b;
vec4 l9_75;
if (l9_73.y<l9_73.z)
{
l9_75=vec4(l9_73.zy,-1.0,0.666667);
}
else
{
l9_75=vec4(l9_73.yz,0.0,-0.333333);
}
vec4 l9_76;
if (l9_73.x<l9_75.x)
{
l9_76=vec4(l9_75.xyw,l9_73.x);
}
else
{
l9_76=vec4(l9_73.x,l9_75.yzx);
}
float l9_77=l9_76.x-min(l9_76.w,l9_76.y);
vec4 l9_78;
if (l9_74.y<l9_74.z)
{
l9_78=vec4(l9_74.zy,-1.0,0.666667);
}
else
{
l9_78=vec4(l9_74.yz,0.0,-0.333333);
}
vec4 l9_79;
if (l9_74.x<l9_78.x)
{
l9_79=vec4(l9_78.xy,g9_67,l9_74.x);
}
else
{
l9_79=vec4(l9_74.x,l9_78.y,g9_67,l9_78.x);
}
float l9_80=l9_79.x-((l9_79.x-min(l9_79.w,l9_79.y))*0.5);
float l9_81=6.0*abs(((l9_76.w-l9_76.y)/((6.0*l9_77)+1e-07))+l9_76.z);
return ((clamp(vec3(abs(l9_81-3.0)-1.0,2.0-abs(l9_81-2.0),2.0-abs(l9_81-4.0)),vec3(0.0),vec3(1.0))-vec3(0.5))*((1.0-abs((2.0*l9_80)-1.0))*(l9_77/(1.0-abs((2.0*(l9_76.x-(l9_77*0.5)))-1.0)))))+vec3(l9_80);
}
#else
{
vec3 l9_82=a;
vec3 l9_83=b;
float l9_84=((0.299*l9_82.x)+(0.587*l9_82.y))+(0.114*l9_82.z);
vec2 l9_85=intensityTextureDims.xy;
int l9_86=intensityTextureLayout;
int l9_87=intensityTextureGetStereoViewIndex();
vec2 l9_88=vec2(pow(l9_84,1.0/correctedIntensity),0.5);
bool l9_89=(int(SC_USE_UV_TRANSFORM_intensityTexture)!=0);
mat3 l9_90=intensityTextureTransform;
ivec2 l9_91=g9_48;
bool l9_92=(int(SC_USE_UV_MIN_MAX_intensityTexture)!=0);
vec4 l9_93=intensityTextureUvMinMax;
bool l9_94=(int(SC_USE_CLAMP_TO_BORDER_intensityTexture)!=0);
vec4 l9_95=intensityTextureBorderColor;
float l9_96=0.0;
vec4 l9_97=sc_SampleTextureBiasOrLevel(l9_85,l9_86,l9_87,l9_88,l9_89,l9_90,l9_91,l9_92,l9_93,l9_94,l9_95,l9_96,intensityTexture);
float l9_98=(((l9_97.x*256.0)+l9_97.y)+(l9_97.z*0.00390625))*0.0622559;
float l9_99;
#if (BLEND_MODE_FORGRAY)
{
l9_99=max(l9_98,1.0);
}
#else
{
l9_99=l9_98;
}
#endif
float l9_100;
#if (BLEND_MODE_NOTBRIGHT)
{
l9_100=min(l9_99,1.0);
}
#else
{
l9_100=l9_99;
}
#endif
float l9_101=l9_84;
vec3 l9_102=l9_82;
vec3 l9_103=l9_83;
float l9_104=1.0;
float l9_105=l9_100;
return transformColor(l9_101,l9_102,l9_103,l9_104,l9_105);
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
#endif
}
#endif
}
#endif
}
#endif
}
vec4 ngsPixelShader(inout vec4 result)
{
#if (sc_ProjectiveShadowsCaster)
{
vec4 param=result;
return evaluateShadowCasterColor(param);
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
vec3 l9_1=l9_0;
vec3 l9_2=result.xyz;
vec3 l9_3=mix(l9_0,definedBlend(l9_1,l9_2).xyz,vec3(result.w));
vec4 l9_4=vec4(l9_3.x,l9_3.y,l9_3.z,g9_66.w);
l9_4.w=1.0;
result=l9_4;
}
#else
{
#if (sc_BlendMode_MultiplyOriginal)
{
vec3 l9_5=mix(vec3(1.0),result.xyz,vec3(result.w));
result=vec4(l9_5.x,l9_5.y,l9_5.z,result.w);
}
#else
{
#if (sc_BlendMode_Screen)
{
vec3 l9_6=result.xyz*result.w;
result=vec4(l9_6.x,l9_6.y,l9_6.z,result.w);
}
#endif
}
#endif
}
#endif
return result;
}
float getFrontLayerZTestEpsilon()
{
#if (sc_SkinBonesCount>0)
{
return 5e-07;
}
#else
{
return 5e-08;
}
#endif
}
float getDepthOrderingEpsilon()
{
#if (sc_SkinBonesCount>0)
{
return 0.001;
}
#else
{
return 0.0;
}
#endif
}
float viewSpaceDepth()
{
#if (UseViewSpaceDepthVariant&&((sc_OITDepthGatherPass||sc_OITCompositingPass)||sc_OITDepthBoundsPass))
{
return varViewSpaceDepth;
}
#else
{
return sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][3].z/(sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][2].z+((sc_GetGlFragCoord().z*2.0)-1.0));
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
if ((sc_GetGlFragCoord().z-texture2D(sc_OITFrontDepthTexture,l9_0).x)<=getFrontLayerZTestEpsilon())
{
discard;
}
}
#endif
int depths[8];
int alphas[8];
int l9_1=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_1<8)
{
depths[l9_1]=0;
alphas[l9_1]=0;
l9_1++;
continue;
}
else
{
break;
}
}
int l9_2;
#if (sc_OITMaxLayers8)
{
l9_2=2;
}
#else
{
l9_2=1;
}
#endif
vec4 l9_3;
vec4 l9_4;
vec4 l9_5;
l9_5=g9_65;
l9_4=g9_65;
l9_3=g9_65;
vec4 l9_6;
vec4 l9_7;
vec4 l9_8;
int l9_9=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_9<l9_2)
{
vec4 l9_10;
vec4 l9_11;
vec4 l9_12;
if (l9_9==0)
{
l9_12=texture2D(sc_OITAlpha0,l9_0);
l9_11=texture2D(sc_OITDepthLow0,l9_0);
l9_10=texture2D(sc_OITDepthHigh0,l9_0);
}
else
{
l9_12=l9_5;
l9_11=l9_4;
l9_10=l9_3;
}
if (l9_9==1)
{
l9_8=texture2D(sc_OITAlpha1,l9_0);
l9_7=texture2D(sc_OITDepthLow1,l9_0);
l9_6=texture2D(sc_OITDepthHigh1,l9_0);
}
else
{
l9_8=l9_12;
l9_7=l9_11;
l9_6=l9_10;
}
if (any(notEqual(l9_6,vec4(0.0)))||any(notEqual(l9_7,vec4(0.0))))
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
int l9_13=((l9_9+1)*4)-1;
float l9_14=floor((l9_6.w*255.0)+0.5);
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_13>=(l9_9*4))
{
param[l9_13]=(param[l9_13]*4)+int(floor(mod(l9_14,4.0)));
l9_14=floor(l9_14*0.25);
l9_13--;
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
int l9_15=((l9_9+1)*4)-1;
float l9_16=floor((l9_6.z*255.0)+0.5);
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_15>=(l9_9*4))
{
param_1[l9_15]=(param_1[l9_15]*4)+int(floor(mod(l9_16,4.0)));
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
int l9_17=((l9_9+1)*4)-1;
float l9_18=floor((l9_6.y*255.0)+0.5);
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_17>=(l9_9*4))
{
param_2[l9_17]=(param_2[l9_17]*4)+int(floor(mod(l9_18,4.0)));
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
int l9_19=((l9_9+1)*4)-1;
float l9_20=floor((l9_6.x*255.0)+0.5);
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_19>=(l9_9*4))
{
param_3[l9_19]=(param_3[l9_19]*4)+int(floor(mod(l9_20,4.0)));
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
int l9_21=((l9_9+1)*4)-1;
float l9_22=floor((l9_7.w*255.0)+0.5);
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_21>=(l9_9*4))
{
param_4[l9_21]=(param_4[l9_21]*4)+int(floor(mod(l9_22,4.0)));
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
int l9_23=((l9_9+1)*4)-1;
float l9_24=floor((l9_7.z*255.0)+0.5);
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_23>=(l9_9*4))
{
param_5[l9_23]=(param_5[l9_23]*4)+int(floor(mod(l9_24,4.0)));
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
int l9_25=((l9_9+1)*4)-1;
float l9_26=floor((l9_7.y*255.0)+0.5);
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_25>=(l9_9*4))
{
param_6[l9_25]=(param_6[l9_25]*4)+int(floor(mod(l9_26,4.0)));
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
int l9_27=((l9_9+1)*4)-1;
float l9_28=floor((l9_7.x*255.0)+0.5);
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_27>=(l9_9*4))
{
param_7[l9_27]=(param_7[l9_27]*4)+int(floor(mod(l9_28,4.0)));
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
int l9_29=((l9_9+1)*4)-1;
float l9_30=floor((l9_8.w*255.0)+0.5);
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_29>=(l9_9*4))
{
param_8[l9_29]=(param_8[l9_29]*4)+int(floor(mod(l9_30,4.0)));
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
int l9_31=((l9_9+1)*4)-1;
float l9_32=floor((l9_8.z*255.0)+0.5);
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_31>=(l9_9*4))
{
param_9[l9_31]=(param_9[l9_31]*4)+int(floor(mod(l9_32,4.0)));
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
int l9_33=((l9_9+1)*4)-1;
float l9_34=floor((l9_8.y*255.0)+0.5);
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_33>=(l9_9*4))
{
param_10[l9_33]=(param_10[l9_33]*4)+int(floor(mod(l9_34,4.0)));
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
int l9_35=((l9_9+1)*4)-1;
float l9_36=floor((l9_8.x*255.0)+0.5);
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_35>=(l9_9*4))
{
param_11[l9_35]=(param_11[l9_35]*4)+int(floor(mod(l9_36,4.0)));
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
alphas[0]=param_11[0];
alphas[1]=param_11[1];
alphas[2]=param_11[2];
alphas[3]=param_11[3];
alphas[4]=param_11[4];
alphas[5]=param_11[5];
alphas[6]=param_11[6];
alphas[7]=param_11[7];
}
l9_5=l9_8;
l9_4=l9_7;
l9_3=l9_6;
l9_9++;
continue;
}
else
{
break;
}
}
mediump vec4 l9_37=texture2D(sc_OITFilteredDepthBoundsTexture,l9_0);
int l9_38;
#if (sc_SkinBonesCount>0)
{
float l9_39=(1.0-l9_37.x)*1000.0;
l9_38=int(clamp(((l9_39+getDepthOrderingEpsilon())-l9_39)/((l9_37.y*1000.0)-l9_39),0.0,1.0)*65535.0);
}
#else
{
l9_38=0;
}
#endif
float l9_40=(1.0-l9_37.x)*1000.0;
vec4 l9_41;
l9_41=materialColor*materialColor.w;
vec4 l9_42;
int l9_43=0;
for (int snapLoopIndex=0; snapLoopIndex==0; snapLoopIndex+=0)
{
if (l9_43<8)
{
int l9_44=depths[l9_43];
int l9_45=int(clamp((viewSpaceDepth()-l9_40)/((l9_37.y*1000.0)-l9_40),0.0,1.0)*65535.0)-l9_38;
bool l9_46=l9_44<l9_45;
bool l9_47;
if (l9_46)
{
l9_47=depths[l9_43]>0;
}
else
{
l9_47=l9_46;
}
if (l9_47)
{
vec3 l9_48=l9_41.xyz*(1.0-(float(alphas[l9_43])*0.00392157));
l9_42=vec4(l9_48.x,l9_48.y,l9_48.z,l9_41.w);
}
else
{
l9_42=l9_41;
}
l9_41=l9_42;
l9_43++;
continue;
}
else
{
break;
}
}
vec4 param_12=l9_41;
sc_writeFragData0(param_12);
#if (sc_OITMaxLayersVisualizeLayerCount)
{
discard;
}
#endif
}
#endif
}
float packValue(inout int value)
{
#if (sc_OITDepthGatherPass)
{
int l9_0=value;
value/=4;
return floor(floor(mod(float(l9_0),4.0))*64.0)*0.00392157;
}
#else
{
return 0.0;
}
#endif
}
void oitDepthGather(vec4 materialColor)
{
#if (sc_OITDepthGatherPass)
{
vec2 l9_0=getScreenUV();
#if (sc_OITMaxLayers4Plus1)
{
if ((sc_GetGlFragCoord().z-texture2D(sc_OITFrontDepthTexture,l9_0).x)<=getFrontLayerZTestEpsilon())
{
discard;
}
}
#endif
mediump vec4 l9_1=texture2D(sc_OITFilteredDepthBoundsTexture,l9_0);
float l9_2=(1.0-l9_1.x)*1000.0;
int param=int(clamp((viewSpaceDepth()-l9_2)/((l9_1.y*1000.0)-l9_2),0.0,1.0)*65535.0);
float l9_3=packValue(param);
vec4 l9_4=g9_64;
l9_4.x=l9_3;
int param_1=param;
float l9_5=packValue(param_1);
vec4 l9_6=l9_4;
l9_6.y=l9_5;
int param_2=param_1;
float l9_7=packValue(param_2);
vec4 l9_8=l9_6;
l9_8.z=l9_7;
int param_3=param_2;
float l9_9=packValue(param_3);
vec4 l9_10=l9_8;
l9_10.w=l9_9;
int param_4=param_3;
float l9_11=packValue(param_4);
vec4 l9_12=g9_64;
l9_12.x=l9_11;
int param_5=param_4;
float l9_13=packValue(param_5);
vec4 l9_14=l9_12;
l9_14.y=l9_13;
int param_6=param_5;
float l9_15=packValue(param_6);
vec4 l9_16=l9_14;
l9_16.z=l9_15;
int param_7=param_6;
float l9_17=packValue(param_7);
vec4 l9_18=l9_16;
l9_18.w=l9_17;
int param_8=int(materialColor.w*255.0);
float l9_19=packValue(param_8);
vec4 l9_20=g9_64;
l9_20.x=l9_19;
int param_9=param_8;
float l9_21=packValue(param_9);
vec4 l9_22=l9_20;
l9_22.y=l9_21;
int param_10=param_9;
float l9_23=packValue(param_10);
vec4 l9_24=l9_22;
l9_24.z=l9_23;
int param_11=param_10;
float l9_25=packValue(param_11);
vec4 l9_26=l9_24;
l9_26.w=l9_25;
vec4 param_12=l9_18;
sc_writeFragData0(param_12);
vec4 param_13=l9_10;
sc_writeFragData1(param_13);
vec4 param_14=l9_26;
sc_writeFragData2(param_14);
#if (sc_OITMaxLayersVisualizeLayerCount)
{
vec4 param_15=vec4(0.00392157,0.0,0.0,0.0);
sc_writeFragData2(param_15);
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
vec2 l9_0=(varPackedTex.xy-vec2(0.5))*vec2(sc_Camera.aspect,1.0);
vec2 l9_1=l9_0*vec2(2.0);
vec2 l9_2=l9_1*l9_1;
float l9_3=l9_2.x+l9_2.y;
float l9_4;
if (l9_3<=0.0)
{
l9_4=0.0;
}
else
{
l9_4=sqrt(l9_3);
}
vec2 l9_5=vec2(0.0);
l9_5.x=l9_4;
vec2 l9_6=l9_5;
l9_6.y=(atan(l9_1.y,l9_1.x)*0.159155)+0.5;
float l9_7=1.0-transition;
vec2 param=Tweak_N63Dims.xy;
int param_1=Tweak_N63Layout;
int param_2=Tweak_N63GetStereoViewIndex();
vec2 param_3=((l9_6+vec2(l9_7*Tweak_N60,0.0))+vec2(Tweak_N83))*Tweak_N65;
bool param_4=(int(SC_USE_UV_TRANSFORM_Tweak_N63)!=0);
mat3 param_5=Tweak_N63Transform;
ivec2 param_6=g9_55;
bool param_7=(int(SC_USE_UV_MIN_MAX_Tweak_N63)!=0);
vec4 param_8=Tweak_N63UvMinMax;
bool param_9=(int(SC_USE_CLAMP_TO_BORDER_Tweak_N63)!=0);
vec4 param_10=Tweak_N63BorderColor;
float param_11=0.0;
vec4 l9_8=sc_SampleTextureBiasOrLevel(param,param_1,param_2,param_3,param_4,param_5,param_6,param_7,param_8,param_9,param_10,param_11,Tweak_N63);
float l9_9=Tweak_N8*0.7;
float l9_10=((transition-l9_9)/(1.0-l9_9))*Tweak_N44;
float l9_11;
if (Tweak_N44>0.0)
{
l9_11=clamp(l9_10,0.0,Tweak_N44);
}
else
{
l9_11=clamp(l9_10,Tweak_N44,0.0);
}
float l9_12=(l9_8.x-0.3)*l9_11;
float l9_13=CoreWidth*0.1;
float l9_14=(l9_13+Tweak_N8)*0.5;
float l9_15=(-0.25)-l9_14;
float l9_16=abs((((distance(l9_0+vec2(0.5),vec2(0.5))-l9_12)+((l9_7*((l9_14+0.5)-l9_15))+l9_15))*2.0)+(-1.0));
float l9_17=clamp(((l9_16/Tweak_N8)*(-1.0))+1.0,0.0,1.0);
float l9_18;
if (l9_17<=0.0)
{
l9_18=0.0;
}
else
{
l9_18=pow(l9_17,1.4);
}
float l9_19=l9_18*Tweak_N30;
vec2 param_12=Tweak_N85Dims.xy;
int param_13=Tweak_N85Layout;
int param_14=Tweak_N85GetStereoViewIndex();
vec2 param_15=varPackedTex.xy;
bool param_16=(int(SC_USE_UV_TRANSFORM_Tweak_N85)!=0);
mat3 param_17=Tweak_N85Transform;
ivec2 param_18=g9_56;
bool param_19=(int(SC_USE_UV_MIN_MAX_Tweak_N85)!=0);
vec4 param_20=Tweak_N85UvMinMax;
bool param_21=(int(SC_USE_CLAMP_TO_BORDER_Tweak_N85)!=0);
vec4 param_22=Tweak_N85BorderColor;
float param_23=0.0;
vec4 l9_20=sc_SampleTextureBiasOrLevel(param_12,param_13,param_14,param_15,param_16,param_17,param_18,param_19,param_20,param_21,param_22,param_23,Tweak_N85);
float l9_21=(l9_19+(smoothstep(l9_13,l9_13-(Tweak_N25*l9_13),l9_16)*Tweak_N21))*l9_20.x;
#if (sc_BlendMode_AlphaTest)
{
if (l9_21<alphaTestThreshold)
{
discard;
}
}
#endif
#if (ENABLE_STIPPLE_PATTERN_TEST)
{
if (l9_21<((mod(dot(floor(mod(sc_GetGlFragCoord().xy,vec2(4.0))),vec2(4.0,1.0))*9.0,16.0)+1.0)*0.0588235))
{
discard;
}
}
#endif
vec4 param_24=vec4(1.0,1.0,1.0,l9_21);
vec4 l9_22=ngsPixelShader(param_24);
vec4 l9_23=max(l9_22,vec4(0.0));
vec4 param_25=l9_23;
sc_writeFragData0(param_25);
vec4 l9_24=clamp(l9_23,vec4(0.0),vec4(1.0));
#if (sc_OITDepthBoundsPass)
{
#if (sc_OITDepthBoundsPass)
{
float l9_25=clamp(viewSpaceDepth()*0.001,0.0,1.0);
vec4 l9_26=vec4(max(0.0,1.00392-l9_25),min(1.0,l9_25+0.00392157),0.0,0.0);
sc_writeFragData0(l9_26);
}
#endif
}
#else
{
#if (sc_OITDepthPrepass)
{
vec4 l9_27=vec4(1.0);
sc_writeFragData0(l9_27);
}
#else
{
#if (sc_OITDepthGatherPass)
{
vec4 l9_28=l9_24;
oitDepthGather(l9_28);
}
#else
{
#if (sc_OITCompositingPass)
{
vec4 l9_29=l9_24;
oitCompositing(l9_29);
}
#else
{
#if (sc_OITFrontLayerPass)
{
#if (sc_OITFrontLayerPass)
{
if (abs(sc_GetGlFragCoord().z-texture2D(sc_OITFrontDepthTexture,getScreenUV()).x)>getFrontLayerZTestEpsilon())
{
discard;
}
vec4 l9_30=l9_24;
sc_writeFragData0(l9_30);
}
#endif
}
#else
{
vec4 l9_31=l9_24;
sc_writeFragData0(l9_31);
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
