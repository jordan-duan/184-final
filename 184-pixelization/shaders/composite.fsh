#version 150

in vec2 texCoord;
out vec4 fragColor;

uniform sampler2D gcolor;

void main() {
    vec2 texelSize = 1.0 / vec2(textureSize(gcolor, 0)); // get dynamic resolution

    vec3 center = texture(gcolor, texCoord).rgb;
    vec3 blur = vec3(0.0);

    float kernel[9] = float[](
        1.0,  1.0, 1.0,
        1.0, -8.0, 1.0,
        1.0,  1.0, 1.0
    );

    int index = 0;
    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
            vec2 offset = vec2(float(x), float(y)) * texelSize;
            blur += texture(gcolor, texCoord + offset).rgb * kernel[index];
            index++;
        }
    }

    // Unsharp mask technique: sharpened = original + strength * (original - blur)
    float strength = 2.0;
    vec3 sharpened = center - strength * blur;

    fragColor = vec4(sharpened, 1.0);
}
