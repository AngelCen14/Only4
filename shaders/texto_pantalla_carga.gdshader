shader_type canvas_item;

uniform float altura = 5.0;     
uniform float velocidad = 5.0;   
uniform float frecuencia = 20.0; 

// La funcion vertex se ejecuta por cada vertice del objeto
void vertex() {
	/*
	* UV.x es la coordenada x de la textura 
	* TIME es el tiempo transcurrido desde el inicio del programa
	*/ 
	VERTEX.y += sin((UV.x * frecuencia) + (TIME * velocidad)) * altura;
}