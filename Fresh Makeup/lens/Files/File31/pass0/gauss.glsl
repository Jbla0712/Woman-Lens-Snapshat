#include <required.glsl>

varying vec2 blurCoordinates[5];

uniform sampler2D sc_ScreenTexture;
uniform vec4 sc_ScreenTextureSize;

#ifdef VERTEX_SHADER
#ifndef IMAGE_HEIGHT
#define IMAGE_HEIGHT 160.0
#endif
attribute vec4 position;

void main()
{
	gl_Position=position;
	vec2 coordsTex=position.xy*0.5+0.5;
	blurCoordinates[0]=coordsTex;
	blurCoordinates[1]=coordsTex+vec2(0.0,1.444444*sc_ScreenTextureSize[3]);
	blurCoordinates[2]=coordsTex -vec2(0.0,1.444444*sc_ScreenTextureSize[3]);
	blurCoordinates[3]=coordsTex+vec2(0.0,3.357143*sc_ScreenTextureSize[3]);
	blurCoordinates[4]=coordsTex -vec2(0.0,3.357143*sc_ScreenTextureSize[3]);
}

#endif

#ifdef FRAGMENT_SHADER
void main()
{
	vec4 sum=texture2D(sc_ScreenTexture,blurCoordinates[0])*0.18;
	sum+=texture2D(sc_ScreenTexture,blurCoordinates[1])*0.27;
	sum+=texture2D(sc_ScreenTexture,blurCoordinates[2])*0.27;
	sum+=texture2D(sc_ScreenTexture,blurCoordinates[3])*0.14;
	sum+=texture2D(sc_ScreenTexture,blurCoordinates[4])*0.14;
	gl_FragColor=sum;
}
#endif

#if sc_IsEditor
#error This is an exported shader. Please do not use shaders in Studio that have already been exported to a lens! Only use fresh shaders,presets,or shaders from existing Studio projects!
#endif

/// Exported with Lens Studio 4.0.1.0 Internal
