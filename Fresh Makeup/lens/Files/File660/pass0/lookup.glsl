#define SC_USE_USER_DEFINED_VS_MAIN

#include <std.glsl>
#include <std_vs.glsl>
#include <std_fs.glsl>

uniform sampler2D baseTex;

#ifdef USE_OPACITY_MASK
uniform sampler2D opacityTex;
uniform mat3	opacityTexTransform;
#endif

uniform float lookupIntens;

#ifdef VERTEX_SHADER

void main(){
	sc_Vertex_t v=sc_LoadVertexAttributes();
	sc_ProcessVertex(v);

#ifdef USE_OPACITY_MASK
	varTex0=vec2(opacityTexTransform*vec3(varTex0,1.0));
#endif
}

#endif

#ifdef FRAGMENT_SHADER

vec3 mapColor(vec3 orgColor){
	const vec3 pxSize=vec3(256.0,256.0,16.0);

	float bValue=orgColor.b*15.0;

	vec2 mulB=clamp(floor(bValue)+vec2(0.0,1.0),0.0,15.0);
	vec3 lookup=orgColor.rrg*(15.0/pxSize)+vec3(mulB*(16.0/pxSize.x),0.0)+0.5/pxSize;
	float b1w=bValue -mulB.x;

	vec3 sampled1=texture2D(baseTex,lookup.xz).rgb;
	vec3 sampled2=texture2D(baseTex,lookup.yz).rgb;

	vec3 res=mix(sampled1,sampled2,b1w);
	return res;
}

void main(){
	vec3 originalColor=getFramebufferColor().rgb;
	vec3 color=mapColor(originalColor);

#ifndef USE_OPACITY_MASK
	float factor=lookupIntens;
#else
	float factor=texture2D(opacityTex,varTex0).r*lookupIntens;
#endif

	gl_FragColor=vec4(mix(originalColor,color,factor),1.0);
}

#endif

#if sc_IsEditor
#error This is an exported shader. Please do not use shaders in Studio that have already been exported to a lens! Only use fresh shaders,presets,or shaders from existing Studio projects!
#endif

/// Exported with Lens Studio 4.0.1.0 Internal
