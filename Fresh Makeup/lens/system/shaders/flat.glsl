#define SC_USE_USER_DEFINED_VS_MAIN

#include <std.glsl>
#include <std_vs.glsl>
#include <std_fs.glsl>
#include <std_texture.glsl>

#ifndef BLEND_MODES_GLSL
#define BLEND_MODES_GLSL

#include <std_fs.glsl>

#ifndef BLEND_MODES_EYECOLOR_GLSL
#define BLEND_MODES_EYECOLOR_GLSL

#ifndef RGBHSL_GLSL
#define RGBHSL_GLSL

vec3 RGBtoHCV(vec3 rgb)
{
	vec4 p=(rgb.g < rgb.b) ? vec4(rgb.bg,-1.0,2.0/3.0) : vec4(rgb.gb,0.0,-1.0/3.0);
	vec4 q=(rgb.r < p.x) ? vec4(p.xyw,rgb.r) : vec4(rgb.r,p.yzx);

	float c=q.x -min(q.w,q.y);
	float h=abs((q.w -q.y)/(6.0*c+1e-7)+q.z);
	float v=q.x;

	return vec3(h,c,v);
}

vec3 RGBToHSL(vec3 rgb)
{
	vec3 hcv=RGBtoHCV(rgb);

	float lum=hcv.z -hcv.y*0.5;
	float sat=hcv.y/(1.0 -abs(2.0*lum -1.0)+1e-7);

	return vec3(hcv.x,sat,lum);
}

vec3 HUEtoRGB(float hue)
{
	float r=abs(6.0*hue -3.0) -1.0;
	float g=2.0 -abs(6.0*hue -2.0);
	float b=2.0 -abs(6.0*hue -4.0);
	return clamp(vec3(r,g,b),0.0,1.0);
}

vec3 HSLToRGB(vec3 hsl)
{
	vec3 rgb=HUEtoRGB(hsl.x);
	float c=(1.0 -abs(2.0*hsl.z -1.0))*hsl.y;
	rgb=(rgb -0.5)*c+hsl.z;
	return rgb;
}

#endif

#ifdef BLEND_MODE_REALISTIC
#define COLOR_MODE 0
#endif

#ifdef BLEND_MODE_DIVISION
#define COLOR_MODE 1
#endif

#ifdef BLEND_MODE_BRIGHT
#define COLOR_MODE 2
#endif

#ifdef BLEND_MODE_FORGRAY
#define COLOR_MODE 3
#endif

#ifdef BLEND_MODE_NOTBRIGHT
#define COLOR_MODE 4
#endif

#ifdef BLEND_MODE_INTENSE
#define COLOR_MODE 5
#endif

#ifdef COLOR_MODE

uniform float	correctedIntensity;
uniform sampler2D intensityTexture;

#if COLOR_MODE==0 || COLOR_MODE==3 || COLOR_MODE==4

float transformSingleColor(float original,float intMap,float target){
	return original/pow((1.0 -target),intMap);
}

#endif
#if COLOR_MODE==1

float transformSingleColor(float original,float intMap,float target){
	return original/(1.0 -target);
}

#endif
#if COLOR_MODE==2

float transformSingleColor(float original,float intMap,float target){
	return original/pow((1.0 -target),2.0 -2.0*original);
}

#endif

#if COLOR_MODE !=5

vec3 transformColor(float yValue,vec3 original,vec3 target,float weight,float intMap){
	vec3 tmpColor;
	tmpColor.r=transformSingleColor(yValue,intMap,target.r);
	tmpColor.g=transformSingleColor(yValue,intMap,target.g);
	tmpColor.b=transformSingleColor(yValue,intMap,target.b);
	tmpColor=clamp(tmpColor,0.0,1.0);
	vec3 resColor=mix(original,tmpColor,weight);
	return resColor;
}

#endif

#if COLOR_MODE==5

vec3 transformColor(float yValue,vec3 original,vec3 target,float weight,float intMap){
	vec3 hslOrig=RGBToHSL(original);
	vec3 res;
	res.r=target.r;
	res.g=target.g;
	res.b=hslOrig.b;
	res=HSLToRGB(res);
	vec3 resColor=mix(original,res,weight);
	return resColor;
}

#endif

float unpack1(float inp,float mul){
	return inp*mul;
}

float unpack2(vec2 inp,float mul){
	return (inp[0]*256.0+inp[1])/257.0*mul;
}

float unpack3(vec3 inp,float mul){

	return (inp[0]*256.0+inp[1]+inp[2]/256.0)/(256.0+1.0+1.0/256.0)*mul;
}

float getYValue(vec3 rgb){
	return 0.299*rgb.r+0.587*rgb.g+0.114*rgb.b;
}

vec3 eyeColorBlend(vec3 texColor,vec3 resColor)
{
	float newYValue=getYValue(texColor);

	float weight=1.0;
	float fragmentCorrectedIntensity=pow(newYValue,1.0/correctedIntensity);
	vec3 intenseMapCompressed=texture2D(intensityTexture,vec2(fragmentCorrectedIntensity,0.5)).rgb;
	float intenseMapValue=unpack3(intenseMapCompressed,16.0);

#if COLOR_MODE==3
	intenseMapValue=max(intenseMapValue,1.0);
#endif
#if COLOR_MODE==4
	intenseMapValue=min(intenseMapValue,1.0);
#endif

	vec3 newColor=transformColor(newYValue,texColor,resColor,weight,intenseMapValue);
	return newColor;
}

#define definedBlend eyeColorBlend

#endif

#endif
#ifndef RGBHSL_GLSL
#define RGBHSL_GLSL

vec3 RGBtoHCV(vec3 rgb)
{
	vec4 p=(rgb.g < rgb.b) ? vec4(rgb.bg,-1.0,2.0/3.0) : vec4(rgb.gb,0.0,-1.0/3.0);
	vec4 q=(rgb.r < p.x) ? vec4(p.xyw,rgb.r) : vec4(rgb.r,p.yzx);

	float c=q.x -min(q.w,q.y);
	float h=abs((q.w -q.y)/(6.0*c+1e-7)+q.z);
	float v=q.x;

	return vec3(h,c,v);
}

vec3 RGBToHSL(vec3 rgb)
{
	vec3 hcv=RGBtoHCV(rgb);

	float lum=hcv.z -hcv.y*0.5;
	float sat=hcv.y/(1.0 -abs(2.0*lum -1.0)+1e-7);

	return vec3(hcv.x,sat,lum);
}

vec3 HUEtoRGB(float hue)
{
	float r=abs(6.0*hue -3.0) -1.0;
	float g=2.0 -abs(6.0*hue -2.0);
	float b=2.0 -abs(6.0*hue -4.0);
	return clamp(vec3(r,g,b),0.0,1.0);
}

vec3 HSLToRGB(vec3 hsl)
{
	vec3 rgb=HUEtoRGB(hsl.x);
	float c=(1.0 -abs(2.0*hsl.z -1.0))*hsl.y;
	rgb=(rgb -0.5)*c+hsl.z;
	return rgb;
}

#endif

#ifdef FRAGMENT_SHADER
#ifdef sc_BlendMode_Custom

vec3 ContrastSaturationBrightness(vec3 color,float brt,float sat,float con)
{

	const float AvgLumR=0.5;
	const float AvgLumG=0.5;
	const float AvgLumB=0.5;

	const vec3 LumCoeff=vec3(0.2125,0.7154,0.0721);

	vec3 AvgLumin=vec3(AvgLumR,AvgLumG,AvgLumB);
	vec3 brtColor=color*brt;
	vec3 intensity=vec3(dot(brtColor,LumCoeff));
	vec3 satColor=mix(intensity,brtColor,sat);
	vec3 conColor=mix(AvgLumin,satColor,con);
	return conColor;
}

float BlendAddf(float base,float blend){
	return min(base+blend,1.0);
}
float BlendSubtractf(float base,float blend){
	return max(base+blend -1.0,0.0);
}
float BlendLinearDodgef(float base,float blend){
	return min(base+blend,1.0);
}
float BlendLinearBurnf(float base,float blend){
	return max(base+blend -1.0,0.0);
}
float BlendLightenf(float base,float blend){
	return max(blend,base);
}
float BlendDarkenf(float base,float blend){
	return min(blend,base);
}
float BlendScreenf(float base,float blend){
	return (1.0 - ((1.0 - (base))*(1.0 - (blend))));
}
float BlendOverlayf(float base,float blend){
	return (base < 0.5 ? (2.0*(base)*(blend)) : (1.0 -2.0*(1.0 - (base))*(1.0 - (blend))));
}
float BlendSoftLightf(float base,float blend){
	return ((1.0 -2.0*(blend))*(base)*(base)+2.0*(base)*(blend));
}
float BlendColorDodgef(float base,float blend){
	return ((blend==1.0) ? blend : min((base)/(1.0 - (blend)),1.0));
}
float BlendColorBurnf(float base,float blend){
	return ((blend==0.0) ? blend : max((1.0 - ((1.0 - (base))/(blend))),0.0));
}
float BlendLinearLightf(float base,float blend){
	if(blend < 0.5){
		return BlendLinearBurnf(base,2.0*blend);
	}
	else {
		return BlendLinearDodgef(base,2.0*(blend -0.5));
	}
}
float BlendVividLightf(float base,float blend){
	if(blend < 0.5){
		return BlendColorBurnf(base,2.0*blend);
	}
	else {
		return BlendColorDodgef(base,2.0*(blend -0.5));
	}
}
float BlendPinLightf(float base,float blend){
	if(blend < 0.5){
		return BlendDarkenf(base,2.0*blend);
	}
	else {
		return BlendLightenf(base,2.0*(blend -0.5));
	}
}
float BlendHardMixf(float base,float blend){
	if(BlendVividLightf(base,blend) < 0.5){
		return 0.0;
	}
	else {
		return 1.0;
	}
}
float BlendReflectf(float base,float blend){
	return ((blend==1.0) ? blend : min((base)*(base)/(1.0 - (blend)),1.0));
}

#define BlendNormal(base,blend) 		(blend)
#define BlendLighten(base,blend)		(vec3(BlendLightenf(base.r,blend.r),BlendLightenf(base.g,blend.g),BlendLightenf(base.b,blend.b)))
#define BlendDarken(base,blend)		(vec3(BlendDarkenf(base.r,blend.r),BlendDarkenf(base.g,blend.g),BlendDarkenf(base.b,blend.b)))
#define BlendMultiply(base,blend) 		((base)*(blend))
#define BlendDivide(base,blend) 		((blend)/(base))
#define BlendAverage(base,blend) 		((base+blend)/2.0)
#define BlendAdd(base,blend) 			min(base+blend,vec3(1.0))
#define BlendSubtract(base,blend) 		max(base+blend -vec3(1.0),vec3(0.0))
#define BlendDifference(base,blend) 	abs(base - (blend))
#define BlendNegation(base,blend) 		(vec3(1.0) -abs(vec3(1.0) - (base) - (blend)))
#define BlendExclusion(base,blend) 	(base+blend -2.0*(base)*(blend))
#define BlendScreen(base,blend) 		vec3(BlendScreenf(base.r,blend.r),BlendScreenf(base.g,blend.g),BlendScreenf(base.b,blend.b))

#define BlendOverlay(base,blend) 		vec3(BlendOverlayf(base.r,blend.r),BlendOverlayf(base.g,blend.g),BlendOverlayf(base.b,blend.b))
#define BlendSoftLight(base,blend) 	vec3(BlendSoftLightf(base.r,blend.r),BlendSoftLightf(base.g,blend.g),BlendSoftLightf(base.b,blend.b))
#define BlendHardLight(base,blend) 	BlendOverlay(blend,base)
#define BlendColorDodge(base,blend) 	vec3(BlendColorDodgef(base.r,blend.r),BlendColorDodgef(base.g,blend.g),BlendColorDodgef(base.b,blend.b))
#define BlendColorBurn(base,blend) 	vec3(BlendColorBurnf(base.r,blend.r),BlendColorBurnf(base.g,blend.g),BlendColorBurnf(base.b,blend.b))
#define BlendLinearDodge(base,blend)	BlendAdd(base,blend)
#define BlendLinearBurn(base,blend)	BlendSubtract(base,blend)

#define BlendLinearLight(base,blend) 	vec3(BlendLinearLightf(base.r,blend.r),BlendLinearLightf(base.g,blend.g),BlendLinearLightf(base.b,blend.b))
#define BlendVividLight(base,blend) 	vec3(BlendVividLightf(base.r,blend.r),BlendVividLightf(base.g,blend.g),BlendVividLightf(base.b,blend.b))
#define BlendPinLight(base,blend) 		vec3(BlendPinLightf(base.r,blend.r),BlendPinLightf(base.g,blend.g),BlendPinLightf(base.b,blend.b))
#define BlendHardMix(base,blend) 		vec3(BlendHardMixf(base.r,blend.r),BlendHardMixf(base.g,blend.g),BlendHardMixf(base.b,blend.b))
#define BlendReflect(base,blend) 		vec3(BlendReflectf(base.r,blend.r),BlendReflectf(base.g,blend.g),BlendReflectf(base.b,blend.b))
#define BlendGlow(base,blend) 			BlendReflect(blend,base)
#define BlendPhoenix(base,blend) 		(min(base,blend) -max(base,blend)+vec3(1.0))
#define BlendOpacity(base,blend,F,O) 	(F(base,blend)*O+(blend)*(1.0 -O))

vec3 BlendHue(vec3 base,vec3 blend)
{
	vec3 baseHSL=RGBToHSL(base);
	return HSLToRGB(vec3(RGBToHSL(blend).r,baseHSL.g,baseHSL.b));
}

vec3 BlendSaturation(vec3 base,vec3 blend)
{
	vec3 baseHSL=RGBToHSL(base);
	return HSLToRGB(vec3(baseHSL.r,RGBToHSL(blend).g,baseHSL.b));
}

vec3 BlendColor(vec3 base,vec3 blend)
{
	vec3 blendHSL=RGBToHSL(blend);
	return HSLToRGB(vec3(blendHSL.r,blendHSL.g,RGBToHSL(base).b));
}

vec3 BlendLuminosity(vec3 base,vec3 blend)
{
	vec3 baseHSL=RGBToHSL(base);
	return HSLToRGB(vec3(baseHSL.r,baseHSL.g,RGBToHSL(blend).b));
}

#define GammaCorrection(color,gamma)								pow(color,1.0/gamma)

#define LevelsControlInputRange(color,minInput,maxInput)				min(max(color -vec3(minInput),vec3(0.0))/(vec3(maxInput) -vec3(minInput)),vec3(1.0))
#define LevelsControlInput(color,minInput,gamma,maxInput)				GammaCorrection(LevelsControlInputRange(color,minInput,maxInput),gamma)
#define LevelsControlOutputRange(color,minOutput,maxOutput) 			mix(vec3(minOutput),vec3(maxOutput),color)
#define LevelsControl(color,minInput,gamma,maxInput,minOutput,maxOutput) 	LevelsControlOutputRange(LevelsControlInput(color,minInput,gamma,maxInput),minOutput,maxOutput)

#if defined BLEND_MODE_NORMAL
#define definedBlend(a,b) BlendNormal(a,b)

#elif defined BLEND_MODE_LIGHTEN
#define definedBlend(a,b) BlendLighten(a,b)

#elif defined BLEND_MODE_DARKEN
#define definedBlend(a,b) BlendDarken(a,b)

#elif defined BLEND_MODE_MULTIPLY
#define definedBlend(a,b) BlendMultiply(a,b)

#elif defined BLEND_MODE_DIVIDE
#define definedBlend(a,b) BlendDivide(a,b)

#elif defined BLEND_MODE_AVERAGE
#define definedBlend(a,b) BlendAverage(a,b)

#elif defined BLEND_MODE_ADD
#define definedBlend(a,b) BlendAdd(a,b)

#elif defined BLEND_MODE_SUBTRACT
#define definedBlend(a,b) BlendSubtract(a,b)

#elif defined BLEND_MODE_DIFFERENCE
#define definedBlend(a,b) BlendDifference(a,b)

#elif defined BLEND_MODE_NEGATION
#define definedBlend(a,b) BlendNegation(a,b)

#elif defined BLEND_MODE_EXCLUSION
#define definedBlend(a,b) BlendExclusion(a,b)

#elif defined BLEND_MODE_SCREEN
#define definedBlend(a,b) BlendScreen(a,b)

#elif defined BLEND_MODE_OVERLAY
#define definedBlend(a,b) BlendOverlay(a,b)

#elif defined BLEND_MODE_SOFT_LIGHT
#define definedBlend(a,b) BlendSoftLight(a,b)

#elif defined BLEND_MODE_HARD_LIGHT
#define definedBlend(a,b) BlendHardLight(a,b)

#elif defined BLEND_MODE_COLOR_DODGE
#define definedBlend(a,b) BlendColorDodge(a,b)

#elif defined BLEND_MODE_COLOR_BURN
#define definedBlend(a,b) BlendColorBurn(a,b)

#elif defined BLEND_MODE_LINEAR_LIGHT
#define definedBlend(a,b) BlendLinearLight(a,b)

#elif defined BLEND_MODE_VIVID_LIGHT
#define definedBlend(a,b) BlendVividLight(a,b)

#elif defined BLEND_MODE_PIN_LIGHT
#define definedBlend(a,b) BlendPinLight(a,b)

#elif defined BLEND_MODE_HARD_MIX
#define definedBlend(a,b) BlendHardMix(a,b)

#elif defined BLEND_MODE_HARD_REFLECT
#define definedBlend(a,b) BlendReflect(a,b)

#elif defined BLEND_MODE_HARD_GLOW
#define definedBlend(a,b) BlendGlow(a,b)

#elif defined BLEND_MODE_HARD_PHOENIX
#define definedBlend(a,b) BlendPhoenix(a,b)

#elif defined BLEND_MODE_HUE
#define definedBlend(a,b) BlendHue(a,b)

#elif defined BLEND_MODE_SATURATION
#define definedBlend(a,b) BlendSaturation(a,b)

#elif defined BLEND_MODE_COLOR
#define definedBlend(a,b) BlendColor(a,b)

#elif defined BLEND_MODE_LUMINOSITY
#define definedBlend(a,b) BlendLuminosity(a,b)

#endif

#ifndef definedBlend
#error If you define sc_BlendMode_Custom,you must also define a BLEND_MODE_*!
#endif

vec4 applyCustomBlend(vec4 color){
	vec4 result;
	vec3 framebuffer=getFramebufferColor().rgb;
	result.rgb=definedBlend(framebuffer,color.rgb);
	result.rgb=mix(framebuffer,result.rgb,color.a);
	result.a=1.0;
	return result;
}

#endif
#endif

#endif

#ifndef OIT_GLSL
#define OIT_GLSL

#ifdef FRAGMENT_SHADER

uniform sampler2D sc_OITDepthHigh0;
uniform sampler2D sc_OITDepthLow0;
uniform sampler2D sc_OITAlpha0;

#if defined(sc_OITMaxLayers8)
#define OitDepthGatherPassCount 2
uniform sampler2D sc_OITDepthHigh1;
uniform sampler2D sc_OITDepthLow1;
uniform sampler2D sc_OITAlpha1;
#else
#define OitDepthGatherPassCount 1
#endif

#define DepthsPerGatherPass 4
#define MaxDepths (OitDepthGatherPassCount*DepthsPerGatherPass)

#define MAX_SCENE_DEPTH 1000.0

uniform sampler2D sc_OITFilteredDepthBoundsTexture;
uniform highp sampler2D sc_OITFrontDepthTexture;

#if defined(sc_SkinBonesCount)

const highp float FrontLayerZTestEpsilon=5e-7;

const highp float DepthOrderingEpsilon=1e-3;
#else
const highp float FrontLayerZTestEpsilon=5e-8;

#endif

float packValue(inout int value){
	float lowOrderBits=floor(mod(float(value),4.0));
	lowOrderBits=floor(lowOrderBits*64.0);
	value=value/4;
	return lowOrderBits/255.0;
}

#if defined(sc_OITCompositingPass)

void unpackValues(float channel,int passIndex,inout int values[MaxDepths]){
	channel=floor(channel*255.0+0.5);

	for (int i=(passIndex+1)*DepthsPerGatherPass -1;i >=(passIndex*DepthsPerGatherPass);--i){
		values[i]=values[i]*4+int(floor(mod(channel,4.0)));
		channel=floor(channel/4.0);
	}
}

#endif

int encodeDepth(highp float depth,vec2 depthBounds){

	highp float minDepth=(1.0 -depthBounds.x)*MAX_SCENE_DEPTH;
	highp float maxDepth=depthBounds.y*MAX_SCENE_DEPTH;
	highp float normalizedDepth=clamp((depth -minDepth)/(maxDepth -minDepth),0.0,1.0);
	return int(normalizedDepth*65535.0);
}

int depthEpsilonToIntDepth(highp float range,vec2 depthBounds){
	highp float minDepth=(1.0 -depthBounds.x)*MAX_SCENE_DEPTH;
	return encodeDepth(minDepth+range,depthBounds);
}

vec2 sampleDepthBounds(vec2 screenUV){
	return texture2D(sc_OITFilteredDepthBoundsTexture,vec2(screenUV.x,screenUV.y)).xy;
}

highp float viewSpaceDepth(){
	#if defined(UseViewSpaceDepthVariant) && (defined(sc_OITDepthGatherPass) || defined(sc_OITCompositingPass) || defined(sc_OITDepthBoundsPass))
		return varViewSpaceDepth;
	#else
		highp float m22=sc_ProjectionMatrix[2][2];
		highp float m32=sc_ProjectionMatrix[3][2];
		highp float clipSpaceDepth=gl_FragCoord.z*2.0 -1.0;
		return m32/(m22+clipSpaceDepth);
	#endif
}

#if defined(sc_OITDepthPrepass)

void oitDepthPrepass(){
	sc_FragData0=vec4(1.0);
}

#endif

#if defined(sc_OITDepthBoundsPass)

void oitWriteDepthBounds(){
	float normalizedDepth=clamp(viewSpaceDepth()/MAX_SCENE_DEPTH,0.0,1.0);

	float epsilon=1.0/255.0;
	sc_FragData0=vec4(max(0.0,1.0 - (normalizedDepth -epsilon)),min(1.0,normalizedDepth+epsilon),0.0,0.0);
}

#endif

#if defined(sc_OITDepthGatherPass)

void oitDepthGather(vec4 materialColor){
	vec2 screenUV=getScreenTextureUV();

	#if defined(sc_OITMaxLayers4Plus1)
	highp float frontDepth=texture2D(sc_OITFrontDepthTexture,screenUV).r;
	if ((gl_FragCoord.z -frontDepth) <=FrontLayerZTestEpsilon){
		discard;
		return;
	}
	#endif

	vec2 depthBounds=sampleDepthBounds(screenUV);
	int depth=encodeDepth(viewSpaceDepth(),depthBounds);
	int alpha=int(materialColor.a*255.0);

	vec4 depthLow;
	vec4 depthHigh;
	vec4 alphas;

	depthLow.r=packValue(depth);
	depthLow.g=packValue(depth);
	depthLow.b=packValue(depth);
	depthLow.a=packValue(depth);
	depthHigh.r=packValue(depth);
	depthHigh.g=packValue(depth);
	depthHigh.b=packValue(depth);
	depthHigh.a=packValue(depth);
	alphas.r=packValue(alpha);
	alphas.g=packValue(alpha);
	alphas.b=packValue(alpha);
	alphas.a=packValue(alpha);

	sc_FragData0=depthHigh;
	sc_FragData1=depthLow;
	sc_FragData2=alphas;

	#if defined(sc_OITMaxLayersVisualizeLayerCount)

		sc_FragData2=vec4(1.0/255.0,0.0,0.0,0.0);
	#endif
}

#endif

#if defined(sc_OITCompositingPass)

void oitCompositing(vec4 materialColor){
	vec2 screenUV=getScreenTextureUV();
	#if defined(sc_OITMaxLayers4Plus1)
	highp float frontDepth=texture2D(sc_OITFrontDepthTexture,screenUV).r;
	if ((gl_FragCoord.z -frontDepth) <=FrontLayerZTestEpsilon){
		discard;
		return;
	}
	#endif

	int depths[MaxDepths];
	int alphas[MaxDepths];
	for (int i=0;i < MaxDepths;++i){
		depths[i]=0;
		alphas[i]=0;
	}

	for (int pass=0;pass < OitDepthGatherPassCount;++pass){
		vec4 high;
		vec4 low;
		vec4 alpha;
		if (pass==0){
			high=texture2D(sc_OITDepthHigh0,screenUV);
			low=texture2D(sc_OITDepthLow0,screenUV);
			alpha=texture2D(sc_OITAlpha0,screenUV);
		}
		#if defined(sc_OITMaxLayers8)
		if (pass==1){
			high=texture2D(sc_OITDepthHigh1,screenUV);
			low=texture2D(sc_OITDepthLow1,screenUV);
			alpha=texture2D(sc_OITAlpha1,screenUV);
		}
		#endif
		if (high !=vec4(0.0) || low !=vec4(0.0)){

			unpackValues(high.a,pass,depths);
			unpackValues(high.b,pass,depths);
			unpackValues(high.g,pass,depths);
			unpackValues(high.r,pass,depths);
			unpackValues(low.a,pass,depths);
			unpackValues(low.b,pass,depths);
			unpackValues(low.g,pass,depths);
			unpackValues(low.r,pass,depths);
			unpackValues(alpha.a,pass,alphas);
			unpackValues(alpha.b,pass,alphas);
			unpackValues(alpha.g,pass,alphas);
			unpackValues(alpha.r,pass,alphas);
		}
	}

	vec2 depthBounds=sampleDepthBounds(screenUV);
	#if defined(sc_SkinBonesCount)
	int intDepthEpsilon=depthEpsilonToIntDepth(DepthOrderingEpsilon,depthBounds);
	#else
	int intDepthEpsilon=0;
	#endif

	int curDepth=encodeDepth(viewSpaceDepth(),depthBounds);
	vec4 finalColor=materialColor*materialColor.a;

	for (int i=0;i < MaxDepths;++i){
		if (depths[i] < curDepth -intDepthEpsilon && depths[i] > 0){
			finalColor.rgb*=(1.0 -float(alphas[i])/255.0);
		}
	}

	sc_FragData0=finalColor;
	#if defined(sc_OITMaxLayersVisualizeLayerCount)

		discard;
	#endif
}

#endif

#if defined(sc_OITFrontLayerPass)

void oitFrontLayer(vec4 shaderOutputColor){
	vec2 screenUV=getScreenTextureUV();
	highp float frontDepth=texture2D(sc_OITFrontDepthTexture,screenUV).r;
	if (abs(gl_FragCoord.z -frontDepth) > FrontLayerZTestEpsilon){
		discard;
	} else {
		sc_FragData0=shaderOutputColor;
	}
}

#endif

void processOIT(vec4 shaderOutputColor){
	shaderOutputColor=clamp(shaderOutputColor,0.0,1.0);
#if defined(sc_OITDepthBoundsPass)
	oitWriteDepthBounds();
#elif defined(sc_OITDepthPrepass)
	oitDepthPrepass();
#elif defined(sc_OITDepthGatherPass)
	oitDepthGather(shaderOutputColor);
#elif defined(sc_OITCompositingPass)
	oitCompositing(shaderOutputColor);
#elif defined(sc_OITFrontLayerPass)
	oitFrontLayer(shaderOutputColor);
#else
sc_FragData0=shaderOutputColor;
#endif
}

#endif

#endif

#ifndef saturate
#define saturate(A) clamp(A,0.0,1.0)
#endif

uniform vec4	baseColor;

#if !defined(NOTEXTURE)
DECLARE_TEXTURE(baseTex)
#endif

#if !defined(NOMASK)
DECLARE_TEXTURE(opacityTex)
#endif

varying vec4 varColor;

#ifdef VERTEX_SHADER

attribute vec4 color;

void main(void){
	sc_Vertex_t v=sc_LoadVertexAttributes();
	varColor=color;
	sc_ProcessVertex(v);
}

#endif

#ifdef FRAGMENT_SHADER

void main(void){
	vec4 result=baseColor;

#ifdef ENABLE_VERTEX_COLOR_BASE
	result*=varColor;
#endif

#ifndef NOTEXTURE
	SAMPLE_TEX(baseTex,varTex0,0.0);
	result*=baseTexSample;
#endif

#ifndef NOMASK
	SAMPLE_TEX(opacityTex,varTex1,0.0);
	result.a*=opacityTexSample.r;
#endif

#ifdef sc_BlendMode_Custom
	result=applyCustomBlend(result);
#elif defined(sc_BlendMode_MultiplyOriginal)
	result.rgb=mix(vec3(1.0),result.rgb,result.a);
#elif defined(sc_BlendMode_Screen)
	result.rgb*=result.a;
#elif defined(sc_BlendMode_PremultipliedAlpha)
	result.rgb*=result.a;
#elif defined(sc_BlendMode_PremultipliedAlphaHardware)
	result.rgb*=baseColor.a;
#endif

	processOIT(result);
}

#endif

#if sc_IsEditor
#error This is an exported shader. Please do not use shaders in Studio that have already been exported to a lens! Only use fresh shaders,presets,or shaders from existing Studio projects!
#endif

/// Exported with Lens Studio 4.0.1.0 Internal
