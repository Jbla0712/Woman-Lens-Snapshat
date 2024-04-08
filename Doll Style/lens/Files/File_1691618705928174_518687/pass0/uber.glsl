#version 100 sc_convert_to 300 es
//SG_REFLECTION_BEGIN(100)
//attribute vec4 color 18
//sampler sampler baseTexSmpSC 2:11
//sampler sampler sc_OITCommonSampler 2:14
//texture texture2D baseTex 2:0:2:11
//texture texture2D sc_OITAlpha0 2:3:2:14
//texture texture2D sc_OITAlpha1 2:4:2:14
//texture texture2D sc_OITDepthHigh0 2:5:2:14
//texture texture2D sc_OITDepthHigh1 2:6:2:14
//texture texture2D sc_OITDepthLow0 2:7:2:14
//texture texture2D sc_OITDepthLow1 2:8:2:14
//texture texture2D sc_OITFilteredDepthBoundsTexture 2:9:2:14
//texture texture2D sc_OITFrontDepthTexture 2:10:2:14
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
uniform vec4 baseTexDims;
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
uniform vec4 baseColor;
uniform vec4 baseTexSize;
uniform vec4 baseTexView;
uniform mat3 baseTexTransform;
uniform vec4 baseTexUvMinMax;
uniform vec4 baseTexBorderColor;
uniform vec2 uv2Scale;
uniform vec2 uv2Offset;
uniform vec2 uv3Scale;
uniform vec2 uv3Offset;
uniform vec4 opacityTexSize;
uniform vec4 opacityTexView;
uniform mat3 opacityTexTransform;
uniform vec4 opacityTexUvMinMax;
uniform vec4 opacityTexBorderColor;
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
#ifndef baseTexHasSwappedViews
#define baseTexHasSwappedViews 0
#elif baseTexHasSwappedViews==1
#undef baseTexHasSwappedViews
#define baseTexHasSwappedViews 1
#endif
#ifndef baseTexLayout
#define baseTexLayout 0
#endif
#ifndef SC_USE_UV_TRANSFORM_baseTex
#define SC_USE_UV_TRANSFORM_baseTex 0
#elif SC_USE_UV_TRANSFORM_baseTex==1
#undef SC_USE_UV_TRANSFORM_baseTex
#define SC_USE_UV_TRANSFORM_baseTex 1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_U_baseTex
#define SC_SOFTWARE_WRAP_MODE_U_baseTex -1
#endif
#ifndef SC_SOFTWARE_WRAP_MODE_V_baseTex
#define SC_SOFTWARE_WRAP_MODE_V_baseTex -1
#endif
#ifndef SC_USE_UV_MIN_MAX_baseTex
#define SC_USE_UV_MIN_MAX_baseTex 0
#elif SC_USE_UV_MIN_MAX_baseTex==1
#undef SC_USE_UV_MIN_MAX_baseTex
#define SC_USE_UV_MIN_MAX_baseTex 1
#endif
#ifndef SC_USE_CLAMP_TO_BORDER_baseTex
#define SC_USE_CLAMP_TO_BORDER_baseTex 0
#elif SC_USE_CLAMP_TO_BORDER_baseTex==1
#undef SC_USE_CLAMP_TO_BORDER_baseTex
#define SC_USE_CLAMP_TO_BORDER_baseTex 1
#endif
uniform vec4 intensityTextureDims;
uniform float correctedIntensity;
uniform mat3 intensityTextureTransform;
uniform vec4 intensityTextureUvMinMax;
uniform vec4 intensityTextureBorderColor;
uniform float alphaTestThreshold;
uniform vec4 baseTexDims;
uniform vec4 opacityTexDims;
uniform vec4 baseColor;
uniform vec2 uv2Scale;
uniform vec2 uv2Offset;
uniform vec2 uv3Scale;
uniform vec2 uv3Offset;
uniform mat3 baseTexTransform;
uniform vec4 baseTexUvMinMax;
uniform vec4 baseTexBorderColor;
uniform int overrideTimeEnabled;
uniform float overrideTimeElapsed;
uniform float overrideTimeDelta;
uniform vec4 intensityTextureSize;
uniform vec4 intensityTextureView;
uniform float reflBlurWidth;
uniform float reflBlurMinRough;
uniform float reflBlurMaxRough;
uniform vec4 baseTexSize;
uniform vec4 baseTexView;
uniform vec4 opacityTexSize;
uniform vec4 opacityTexView;
uniform mat3 opacityTexTransform;
uniform vec4 opacityTexUvMinMax;
uniform vec4 opacityTexBorderColor;
uniform mediump sampler2D baseTex;
uniform mediump sampler2D sc_OITFrontDepthTexture;
uniform mediump sampler2D sc_OITFilteredDepthBoundsTexture;
uniform mediump sampler2D sc_OITDepthHigh0;
uniform mediump sampler2D sc_OITDepthLow0;
uniform mediump sampler2D sc_OITAlpha0;
uniform mediump sampler2D sc_OITDepthHigh1;
uniform mediump sampler2D sc_OITDepthLow1;
uniform mediump sampler2D sc_OITAlpha1;
varying vec4 varColor;
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
l9_8=(((vec3(1.0)-(b*2.0))*a)*a)+((a*2.0)*b);
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
vec3 l9_0=getFramebufferColor().xyz;
vec3 l9_1=mix(l9_0,definedBlend(l9_0,result.xyz).xyz,vec3(result.w));
vec4 l9_2=vec4(l9_1.x,l9_1.y,l9_1.z,vec4(0.0).w);
l9_2.w=1.0;
result=l9_2;
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
int l9_0;
#if (baseTexHasSwappedViews)
{
l9_0=1-sc_GetStereoViewIndex();
}
#else
{
l9_0=sc_GetStereoViewIndex();
}
#endif
vec4 l9_1=sc_SampleTextureBiasOrLevel(baseTexDims.xy,baseTexLayout,l9_0,varPackedTex.xy,(int(SC_USE_UV_TRANSFORM_baseTex)!=0),baseTexTransform,ivec2(SC_SOFTWARE_WRAP_MODE_U_baseTex,SC_SOFTWARE_WRAP_MODE_V_baseTex),(int(SC_USE_UV_MIN_MAX_baseTex)!=0),baseTexUvMinMax,(int(SC_USE_CLAMP_TO_BORDER_baseTex)!=0),baseTexBorderColor,0.0,baseTex);
vec4 l9_2=baseColor*l9_1;
float l9_3=l9_2.w;
vec4 l9_4=vec4(l9_2.x,l9_2.y,l9_2.z,vec4(0.0).w);
l9_4.w=l9_3;
#if (sc_BlendMode_AlphaTest)
{
if (l9_3<alphaTestThreshold)
{
discard;
}
}
#endif
#if (ENABLE_STIPPLE_PATTERN_TEST)
{
if (l9_3<((mod(dot(floor(mod(sc_GetGlFragCoord().xy,vec2(4.0))),vec2(4.0,1.0))*9.0,16.0)+1.0)*0.0588235))
{
discard;
}
}
#endif
vec4 l9_5=ngsPixelShader(l9_4);
vec4 l9_6=max(l9_5,vec4(0.0));
sc_writeFragData0(l9_6);
vec4 l9_7=clamp(l9_6,vec4(0.0),vec4(1.0));
#if (sc_OITDepthBoundsPass)
{
#if (sc_OITDepthBoundsPass)
{
float l9_8;
#if (UseViewSpaceDepthVariant&&((sc_OITDepthGatherPass||sc_OITCompositingPass)||sc_OITDepthBoundsPass))
{
l9_8=varViewSpaceDepth;
}
#else
{
l9_8=sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][3].z/(sc_ProjectionMatrixArray[sc_GetStereoViewIndex()][2].z+((sc_GetGlFragCoord().z*2.0)-1.0));
}
#endif
float l9_9=clamp(l9_8*0.001,0.0,1.0);
sc_writeFragData0(vec4(max(0.0,1.00392-l9_9),min(1.0,l9_9+0.00392157),0.0,0.0));
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
oitDepthGather(l9_7);
}
#else
{
#if (sc_OITCompositingPass)
{
oitCompositing(l9_7);
}
#else
{
#if (sc_OITFrontLayerPass)
{
#if (sc_OITFrontLayerPass)
{
vec4 l9_10=texture2D(sc_OITFrontDepthTexture,getScreenUV());
float l9_11;
#if (sc_SkinBonesCount>0)
{
l9_11=5e-07;
}
#else
{
l9_11=5e-08;
}
#endif
if (abs(sc_GetGlFragCoord().z-l9_10.x)>l9_11)
{
discard;
}
sc_writeFragData0(l9_7);
}
#endif
}
#else
{
sc_writeFragData0(l9_6);
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
