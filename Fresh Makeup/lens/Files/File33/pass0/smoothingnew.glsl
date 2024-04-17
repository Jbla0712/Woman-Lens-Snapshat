#include <required.glsl>

uniform sampler2D inputTexture;
uniform mat3	inputTextureTransform;

uniform sampler2D gaussTexture;
uniform mat3	gaussTextureTransform;

uniform float alpha;

varying vec2 varTex0;
varying vec2 varTex1;

#define UnsharpAmount 0.05
#define UnsharpThreshold 0.1

#ifdef VERTEX_SHADER
attribute vec4 position;
attribute vec2 texture0;

void main(){
	gl_Position=position;
	varTex0=vec2(inputTextureTransform*vec3(texture0,1.0));
	varTex1=vec2(gaussTextureTransform*vec3(texture0,1.0));
}
#endif

#ifdef FRAGMENT_SHADER

void main(){
	vec3 original=texture2D(inputTexture,varTex0).rgb;
	vec3 gauss=texture2D(gaussTexture,varTex1).rgb;

	vec3 difference=gauss -original;

	vec3 curve=clamp(-0.391731*original*original+1.4554*original-0.0637,0.0,1.0);

	float val2=clamp(length(original.gb) -length(gauss.gb)+0.5,0.0,1.0);
	vec2 case1=vec2(val2,1.0 -val2);
	case1*=case1;
	case1*=case1;
	case1=case1*case1*128.0;

	float val2mixAmount=step(val2,0.5);
	val2=mix(1.0 -case1.y,case1.x,val2mixAmount);

	vec3 origCurve=mix(curve,original,val2);

	float mixAmount=step(UnsharpThreshold*UnsharpThreshold,dot(difference,difference));
	vec3 smoothCol=origCurve+(mixAmount*UnsharpAmount)*difference;

	gl_FragColor=vec4(mix(original,smoothCol,alpha),1.0);
}
#endif

#if sc_IsEditor
#error This is an exported shader. Please do not use shaders in Studio that have already been exported to a lens! Only use fresh shaders,presets,or shaders from existing Studio projects!
#endif

/// Exported with Lens Studio 4.0.1.0 Internal
