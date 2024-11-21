shader_type canvas_item;

uniform bool isBurning = true;
uniform bool isHighlight = false;
/*
	BURN SHADER
*/
uniform sampler2D dissolve_texture : source_color;
uniform float dissolve_value : hint_range(0,1);
uniform float burn_size: hint_range(0.0, 1.0, 0.01);
uniform vec4 burn_color: source_color;
/**/

/*
	HIGHLIGHT SHADER
*/
uniform float speed : hint_range(0.0, 5.0) = 1.0; // Velocidad de movimiento de la línea
uniform float line_width : hint_range(0.0, 0.2) = 0.15; // Ancho de la línea de brillo
uniform vec4 line_color = vec4(1.0, 1.0, 1.0, 1.0); // Color de la línea de brillo
uniform float pause_duration : hint_range(0.0, 2.0) = 0.05; // Duración de la pausa al final del recorrido
uniform float offset = 2.0;
/**/

void fragment(){
	
/*
	BURN SHADER
*/
if(isBurning){
	
    vec4 main_texture = texture(TEXTURE, UV);
    vec4 noise_texture = texture(dissolve_texture, UV);

	float burn_size_step = burn_size * step(0.001, dissolve_value) * step(dissolve_value, 0.999);
	float threshold = smoothstep(noise_texture.x-burn_size_step, noise_texture.x, dissolve_value);
	float border = smoothstep(noise_texture.x, noise_texture.x + burn_size_step, dissolve_value);
	
	COLOR.a *= threshold;
	COLOR.rgb = mix(burn_color.rgb, main_texture.rgb, border);
}
/**/

/*
	HIGHLIGHT SHADER
*/
if(isHighlight){
	
// Configuración del tiempo con pausa al final del recorrido
    float cycle_duration = offset + pause_duration; // Duración total del ciclo
    float adjusted_time = mod(TIME * speed, cycle_duration);
    
    // Movimiento de la línea con pausa (invertido, de derecha a izquierda)
    float line_position;
    if (adjusted_time <= offset) {
        line_position = offset - adjusted_time; // Movimiento de la línea hacia la izquierda (invertido)
    } else {
        line_position = -0.3; // Pausa
    }
    
    // Rotación diagonal de la línea
    vec2 rotated_uv = vec2(UV.x + UV.y, UV.y - UV.x) * 0.5;
    float dist = abs(rotated_uv.x - line_position);

    // Control de ancho y suavidad de la línea
    float line_intensity = smoothstep(line_width, 0.0, dist);

    // Máscara de alfa del `Sprite` para limitar el área de la línea solo a los píxeles opacos
    vec4 base_texture = texture(TEXTURE, UV); // Color base del `Sprite`
    float alpha_mask = step(0.01, base_texture.a); // Máscara de alfa (evita completamente los píxeles transparentes)

    // Aplicar el color de la línea solo a los píxeles opacos
    vec3 final_color = mix(base_texture.rgb, line_color.rgb, line_intensity * alpha_mask);

    // Combinar la transparencia del sprite original y la intensidad de la línea
    COLOR = vec4(final_color, base_texture.a * alpha_mask);
	/**/
}
	
}