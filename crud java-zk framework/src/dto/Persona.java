package dto;

import java.io.Serializable;

public class Persona implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 6379498264222152289L;
	String nombre;
	String apelldo;
	String identificacion;
	int edad;
	char sexo;
	
	public Persona(String nombre, String apelldo, String identificacion, int edad, char sexo) {
		this.nombre = nombre;
		this.apelldo = apelldo;
		this.identificacion = identificacion;
		this.edad = edad;
		this.sexo = sexo;
	}
	public String getNombre() {
		return nombre;
	}
	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	public String getApelldo() {
		return apelldo;
	}
	public void setApelldo(String apelldo) {
		this.apelldo = apelldo;
	}
	public String getIdentificacion() {
		return identificacion;
	}
	public void setIdentificacion(String identificacion) {
		this.identificacion = identificacion;
	}
	public int getEdad() {
		return edad;
	}
	public void setEdad(int edad) {
		this.edad = edad;
	}
	public char getSexo() {
		return sexo;
	}
	public void setSexo(char sexo) {
		this.sexo = sexo;
	}
	
	

}