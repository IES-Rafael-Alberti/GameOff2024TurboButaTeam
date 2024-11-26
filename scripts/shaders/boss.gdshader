shader_type canvas_item;


uniform bool isSpecial = true;
uniform bool isProtecting = true;

group_uniforms Outline;
// Texture outline parameters
uniform float maxLineWidth: hint_range(0.0, 100.0) = 10.0;// Max distance from texture.
uniform float minLineWidth: hint_range(0.0, 100.0) = 5.0;// Min distance from texture.
uniform float speed: hint_range(0.0, 10.0) = 1.0;// How often to recompute the outline.
uniform float blockSize: hint_range(0.001, 100.0) = 20.0;// How big the outline blotches are.
uniform sampler2D scrollingTexture: hint_default_white;// The texture to scroll with.
uniform vec2 textureScale = vec2(1.0);// The scroll texture scale.
uniform float angle: hint_range(0.0, 360.0) = 45.0;// Angle to scroll towards. In degrees. Starts at the right.
uniform float textureSpeed: hint_range(-10.0, 10.0) = 0.1;// Speed to scroll at.
uniform float tolerance: hint_range(0.0, 0.999) = 0.0;// Used to compensate for alpha values.
group_uniforms;

group_uniforms Highlight;
// Texture highlight parameters
uniform sampler2D vertical_gradient; // used to set alpha values. So you can use this to make the effect dis-/re-appear at points
uniform sampler2D color_gradient; // sets the effect color, supports 2d gradients
uniform float size_effect: hint_range(-5.0, 5.0, 0.05) = 0.1; // size of the effect
uniform float speed_highlight = 1; // effect speed; Will reverse effect is set to negative
uniform float highlight_strength: hint_range(-4.0, 4.0, 0.05) = 0.5; // how strong the color overides the base color
uniform bool color_mode_toggle = false; // changes how the color gradient is applied. Default is on the entire texture, if set to true it is only applied to the effect
uniform bool is_horizontal = false; //changes direction from vertical to horizontal 
group_uniforms;

// Compensate UV for outline.
void vertex() {
	if(isSpecial)
		//VERTEX = vec2(VERTEX.x * (1.0 + TEXTURE_PIXEL_SIZE.x * thickness * 2.0), VERTEX.y * (1.0 + TEXTURE_PIXEL_SIZE.y * thickness * 2.0));
		VERTEX = vec2(VERTEX.x * (1.0 + TEXTURE_PIXEL_SIZE.x * max(maxLineWidth, minLineWidth) * 2.0), VERTEX.y * (1.0 + TEXTURE_PIXEL_SIZE.y * max(maxLineWidth, minLineWidth) * 2.0));
}

// Checks a fragment for the edge of an uv.
bool border(vec2 uv) {
	vec2 uvBorder = abs(uv - vec2(0.5));
	return max(step(0.5, uvBorder.x), step(0.5, uvBorder.y)) > 0.0;
}

// Gets alpha of given fragment if not near the edge.
float get_alpha(sampler2D tex, vec2 uv){
	float res = 0.0;
	if (!border(uv)) {
		res = texture(tex, uv).a;
	}
	return res;
}


// Pseudorandom number
float hash(vec2 p, float s) {
	return fract(35.1 * sin(dot(vec3(112.3, 459.2, 753.2), vec3(p, s))));
}

// Noise function.
float noise(vec2 p, float s) {
	vec2 d = vec2(0, 1);
	vec2 b = floor(p);
	vec2 f = fract(p);
	return mix(
		mix(hash(b + d.xx, s), hash(b + d.yx, s), f.x),
		mix(hash(b + d.xy, s), hash(b + d.yy, s), f.x), f.y);
}

// Randomize line width at fragment.
float get_line_width(vec2 p, float s) {
	p /= blockSize;
	float w = 0.0;
	float intensity = 1.0;
	for (int i = 0; i < 3; i++) {
		w = mix(w, noise(p, s), intensity);
		p /= 2.0;
		intensity /= 2.0;
	}
	
	return mix(maxLineWidth, minLineWidth, w);
}

// Checks for neighboring pixels.
float compute_outline(vec2 size, sampler2D tex, vec2 uv) {
	float res = 0.0;
	for (float i = -1.0; i < 2.0; i += 2.0) {
		res += get_alpha(tex, uv + vec2(i * size.x, 0.0));
		res += get_alpha(tex, uv + vec2(0.0, i * size.y));
		for (float j = -1.0; j < 2.0; j += 2.0) {
			res += get_alpha(tex, uv + vec2(i * size.x, j * size.y));
			res += get_alpha(tex, uv + vec2(i * size.x, j * size.y * 0.5));
		}
	}
	return res;
}


// Checks for neighboring pixels.
float in_range(vec2 size, sampler2D tex, vec2 uv) {
	float res = 0.0;
	for (float i = -1.0; i < 2.0; i += 2.0) {
		res += get_alpha(tex, uv + vec2(i * size.x, 0.0));
		res += get_alpha(tex, uv + vec2(0.0, i * size.y));
		for (float j = -1.0; j < 2.0; j += 2.0) {
			res += get_alpha(tex, uv + vec2(i * size.x, j * size.y));
			res += get_alpha(tex, uv + vec2(i * size.x, j * size.y * 0.5));
		}
	}
	return res;
}

void fragment() {
	
	if(isSpecial) {
		
		if (max(maxLineWidth, minLineWidth) > 0.0) {
			// Correct image size to for outline in frame.
			vec2 uv = UV;
			uv -= vec2(0.5);
			vec2 edge = TEXTURE_PIXEL_SIZE * max(maxLineWidth, minLineWidth) * 2.0;
			uv = uv + uv * edge;
			uv += vec2(0.5);
			
			// Apply outline.
			vec4 newColor = texture(TEXTURE, uv);
			if (newColor.a <= tolerance || border(uv)) {
				// Correct angle to start at right and convert to radians.
				float radiansAngle = radians(angle + 180.0);
				// Make a vector out of the angle.
				vec2 vector = vec2(cos(radiansAngle), sin(radiansAngle));
				float timeStep = floor(TIME * speed);
				vec2 size = TEXTURE_PIXEL_SIZE;
				size *= get_line_width(uv / TEXTURE_PIXEL_SIZE, timeStep);
				vec4 textureColor = texture(scrollingTexture, fract(UV / textureScale + vector * textureSpeed * TIME));
				vec4 finalColor = step(1.0 - tolerance, in_range(size, TEXTURE, uv)) * textureColor;
				newColor = finalColor;
			}
			COLOR = newColor;
		}
	}
	
	if(isProtecting) {
		// set up base parameters
		vec4 old_color = COLOR;
		float time = TIME * speed_highlight;
		float current_time = fract(time);
		current_time = abs(sin(current_time * PI));
		// sets time to fit better with the effect. (Barely detectable change) 
		current_time = mix(1.5 - size_effect, -.4 + size_effect, current_time);
		float effect_lower_bound = current_time - size_effect;
		float effect_upper_bound = current_time + size_effect;
		float position_value = (is_horizontal) ? UV.x : UV.y;
		// smoothes out the lower/upper bounds with the UV values to calculate how far from the middle point(the effect) the pixel is away
		float effect_distance = smoothstep(effect_lower_bound, current_time, position_value) - smoothstep(current_time, effect_upper_bound, position_value);
		// gets the position of the pixel within the effect for the inner_gradient color mode
		float inner_effect_position = smoothstep(effect_lower_bound, effect_upper_bound, position_value);
		vec2 color_position = (color_mode_toggle) ? vec2(UV.x, inner_effect_position) : vec2(current_time);
		// gets the new color from the gradient
		vec4 new_color = vec4(texture(color_gradient, color_position));
		// this step calculates the vertical gradient and alpha_values
		new_color = mix(old_color, new_color, vec4(texture(vertical_gradient, vec2(current_time))));
		// apply the color to the texture
		COLOR.rgb = mix(old_color.rgb, new_color.rgb, vec3(effect_distance * highlight_strength));
	}
	
}