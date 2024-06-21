package Controller;

import java.time.LocalDate;
import java.time.Period;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import org.zkoss.zhtml.Filedownload;
import org.zkoss.zk.ui.ext.AfterCompose;
import org.zkoss.zul.Borderlayout;
import org.zkoss.zul.Button;
import org.zkoss.zul.Intbox;
import org.zkoss.zul.Label;
import org.zkoss.zul.Listbox;
import org.zkoss.zul.Listcell;
import org.zkoss.zul.Listitem;
import org.zkoss.zul.Messagebox;
import org.zkoss.zul.Textbox;
import org.zkoss.util.media.*;
import dto.Persona;
import sun.util.logging.resources.logging;

public class ControllerFormulario extends Borderlayout implements AfterCompose {
	
	private static final long serialVersionUID = 1L;
	Label resultado;
	List<Persona> personas;
	Listbox listado;
	Listbox opciones;
	Textbox documentoPer;
    Button btn_nuevo;
    Button btn_guardar;
	Button btn_Actualizar;
    Button btn_eliminar;
    Textbox nombre;
	Textbox apellido;
	Textbox documento;
	Intbox edad;
	Listbox sexo;
	static Label mostrar;
	
	private Persona personaSel;


	@Override
	public void afterCompose() {
		// TODO Auto-generated method stub
		inivariables();
		cargarListas();
		listarPersonas();
		fecha();
		calcularEdad();
	}

	public void inivariables() {

		mostrar = (Label) this.getFellow("mostrar");
		resultado = (Label) this.getFellow("resultado");
		listado = (Listbox) this.getFellow("listado");
		opciones = (Listbox) this.getFellow("opciones");
		documentoPer = (Textbox) this.getFellow("documentoPer");
		resultado.setValue("");
		nombre = (Textbox) this.getFellow("nombre");
		apellido = (Textbox) this.getFellow("apellido");
		documento = (Textbox) this.getFellow("documento");
		edad = (Intbox) this.getFellow("edad");
		sexo = (Listbox) this.getFellow("sexo");
	    
	    btn_nuevo = (Button) this.getFellow("btn_nuevo");
	    btn_guardar = (Button) this.getFellow("btn_guardar");
	    btn_eliminar = (Button) this.getFellow("btn_eliminar");
	    btn_Actualizar = (Button) this.getFellow("btn_Actualizar");
	  
	
	}

	public void cargarListas() {
		personas = new ArrayList<Persona>();
		personas.add(new Persona("MELISA", "VALVIRI", "104750900", 19, 'f'));
		personas.add(new Persona("HERNAN", "ASENCIO", "104751294", 25, 'm'));
		personas.add(new Persona("LORENA", "VANEGA", "1029345678", 27, 'f'));
		personas.add(new Persona("MARIANA", "ANDRES", "1047980965", 29, 'm'));
		personas.add(new Persona("MARLON", "RESTREPO", "104759090", 19, 'f'));
		personas.add(new Persona("LUCIA", "MENDEZ", "104751234", 25, 'm'));
		personas.add(new Persona("ELIANA", "RONDON", "1021945968", 27, 'f'));
	}

	public void listarPersonas() {

		listado.getChildren().clear();
		String textoDocumento = documentoPer.getValue();
		if (textoDocumento != "") {

			if (opciones.getSelectedItem().getValue().equals("0")) {

				for (int i = 0; i < personas.size(); i++) {
					Persona dto = personas.get(i);

					if (dto.getNombre().toLowerCase().equals(textoDocumento.toLowerCase())) {

						Listitem listitem = new Listitem();
						listitem.appendChild(new Listcell(""));
						listitem.appendChild(new Listcell(dto.getNombre()));
						listitem.appendChild(new Listcell(dto.getApelldo()));
						listitem.appendChild(new Listcell(dto.getIdentificacion()));
						listitem.appendChild(new Listcell(dto.getEdad() + ""));
						listitem.appendChild(
								new Listcell(String.valueOf(dto.getSexo()).equals("m") ? "Masculino" : "Femenino"));

						listado.appendChild(listitem);

						// i=personas.size();
					}
				}

			} else if (opciones.getSelectedItem().getValue().equals("1")) {

				for (int i = 0; i < personas.size(); i++) {
					Persona dto = personas.get(i);

					if (dto.getApelldo().equals(textoDocumento)) {

						Listitem listitem = new Listitem();
						listitem.appendChild(new Listcell(""));
						listitem.appendChild(new Listcell(dto.getNombre()));
						listitem.appendChild(new Listcell(dto.getApelldo()));
						listitem.appendChild(new Listcell(dto.getIdentificacion()));
						listitem.appendChild(new Listcell(dto.getEdad() + ""));
						listitem.appendChild(
								new Listcell(String.valueOf(dto.getSexo()).equals("m") ? "Masculino" : "Femenino"));

						listado.appendChild(listitem);

						// i=personas.size();
					}
				}

			} else if (opciones.getSelectedItem().getValue().equals("2")) {
				for (int i = 0; i < personas.size(); i++) {
					Persona dto = personas.get(i);

					if (dto.getIdentificacion().toLowerCase().equals(textoDocumento.toLowerCase())) {

						Listitem listitem = new Listitem();
						listitem.appendChild(new Listcell(""));
						listitem.appendChild(new Listcell(dto.getNombre()));
						listitem.appendChild(new Listcell(dto.getApelldo()));
						listitem.appendChild(new Listcell(dto.getIdentificacion()));
						listitem.appendChild(new Listcell(dto.getEdad() + ""));
						listitem.appendChild(
								new Listcell(String.valueOf(dto.getSexo()).equals("m") ? "Masculino" : "Femenino"));

						listado.appendChild(listitem);

						i = personas.size();
					}
				}

			} else if (opciones.getSelectedItem().getValue().equals("3")) {
				for (int i = 0; i < personas.size(); i++) {
					Persona dto = personas.get(i);

					if (dto.getEdad() == (Integer.parseInt(textoDocumento))) {

						Listitem listitem = new Listitem();
						listitem.appendChild(new Listcell(""));
						listitem.appendChild(new Listcell(dto.getNombre()));
						listitem.appendChild(new Listcell(dto.getApelldo()));
						listitem.appendChild(new Listcell(dto.getIdentificacion()));
						listitem.appendChild(new Listcell(dto.getEdad() + ""));
						listitem.appendChild(
								new Listcell(String.valueOf(dto.getSexo()).equals("m") ? "Masculino" : "Femenino"));

						listado.appendChild(listitem);

						// i=personas.size();
					}
				}

			} else if (opciones.getSelectedItem().getValue().equals("4")) {
				for (int i = 0; i < personas.size(); i++) {
					Persona dto = personas.get(i);

					if (dto.getSexo() == textoDocumento.toLowerCase().charAt(0)) {
						Listitem listitem = new Listitem();
						listitem.appendChild(new Listcell(""));
						listitem.appendChild(new Listcell(dto.getNombre()));
						listitem.appendChild(new Listcell(dto.getApelldo()));
						listitem.appendChild(new Listcell(dto.getIdentificacion()));
						listitem.appendChild(new Listcell(dto.getEdad() + ""));
						listitem.appendChild(
								new Listcell(String.valueOf(dto.getSexo()).equals("m") ? "Masculino" : "Femenino"));

						listado.appendChild(listitem);

						// i=personas.size();

						System.out.println("recorrido");
					}
				}

			}

		} else {

			for (Persona persona : personas) {

				Listitem listitem = new Listitem();
				listitem.appendChild(new Listcell(""));
				listitem.appendChild(new Listcell(persona.getNombre()));
				listitem.appendChild(new Listcell(persona.getApelldo()));
				listitem.appendChild(new Listcell(persona.getIdentificacion()));
				listitem.appendChild(new Listcell(persona.getEdad() + ""));
				listitem.appendChild(
						new Listcell(String.valueOf(persona.getSexo()).equals("m") ? "Masculino" : "Femenino"));
				listitem.setValue(persona);
				listitem.setId("");

				listado.appendChild(listitem);
			}
		}
	}

	public void seleccionarPersona() {
		personaSel = (Persona) listado.getSelectedItem().getValue();
		System.out.println("--->" + personaSel.getNombre());

		nombre.setValue(personaSel.getNombre());
		apellido.setValue(personaSel.getApelldo());
		documento.setValue(personaSel.getIdentificacion());
		edad.setValue(personaSel.getEdad());
		sexo.setSelectedIndex((personaSel.getSexo() + "").equals("m") ? 0 : 1);
		btn_eliminar.setDisabled(false);
		
	}

	public void nuevo() {
		nombre.setDisabled(false);
		apellido.setDisabled(false);
		documento.setDisabled(false);
		edad.setDisabled(false);
		sexo.setDisabled(false);
		//btn_nuevo.setDisabled(false);
		btn_guardar.setDisabled(false);
		//btn_Actualizar.setDisabled(false);
		//System.out.println(div_botones);
	}

	public void guardarPersona() {

		String nombreObt = nombre.getValue();
		String apellidoObt = apellido.getValue();
		int edadObt = edad.getValue();
		String sexoObj = sexo.getSelectedItem().getValue();
		String documentoObt = documento.getValue();
		int existe = 0;
		
		for (int i = 0; i < personas.size(); i++) {
			Persona dto = personas.get(i);
			if (dto.getIdentificacion().equals(documentoObt)) {
				existe = 1;
			}
			

		}
		
		if (existe == 1) {
			Messagebox.show("el registro existe", "Warning", Messagebox.OK, Messagebox.EXCLAMATION);			
			return;	
			
		}
		personas.add(new Persona(nombreObt, apellidoObt, documentoObt, edadObt, sexoObj.charAt(0)));
		System.out.println("--->objeto insertado");
		listarPersonas();
		Messagebox.show("registro guardado", "guardado", Messagebox.OK, Messagebox.QUESTION);			
		
		
		limpiarCampo();
	}
	public void limpiarCampo() {
		nombre.setRawValue(null);
		apellido.setRawValue(null);
		edad.setRawValue(null);
		documento.setRawValue(null);
	}

	public void actualizarPersona() {

		String nombreObt = nombre.getValue();
		String apellidoObt = apellido.getValue();
		String documentoObt = documento.getValue();
		int edadObt = edad.getValue();
		String sexoObj = sexo.getSelectedItem().getValue();

		for (int i = 0; i < personas.size(); i++) {
			Persona dto = personas.get(i);

			if (dto.getIdentificacion().equals(personaSel.getIdentificacion())) {
				personas.set(i, new Persona(nombreObt, apellidoObt, documentoObt, edadObt, sexoObj.charAt(0)));
				 Messagebox.show("registro actualizado", "Information", Messagebox.OK, Messagebox.INFORMATION);
				i = personas.size();

			}

		}
		
		
		listarPersonas();
		
	}

	public void eliminarPersona() {
		String nombreObt = nombre.getValue();
		String apellidoObt = apellido.getValue();
		String documentoObt = documento.getValue();
		//int edadObt = edad.getValue();
		
		for (int i = 0; i < personas.size(); i++) {
			Persona dto = personas.get(i);
			
			if(nombreObt.isEmpty() && apellidoObt.isEmpty() && documentoObt.isEmpty()) {
				 Messagebox.show("no selecciono registro", "Error", Messagebox.OK, Messagebox.ERROR);
			System.out.println("entro en validoddc::"+dto);
			}else {
				if (dto.getIdentificacion().equals(personaSel.getIdentificacion()) ) {
					

				//	i = personas.size();
					 Messagebox.show("registro eliminado..", "Error", Messagebox.OK, Messagebox.ERROR);
					  personas.remove(i);
				}
			}
		}

		listarPersonas();
	}

	public void refrescarLista() {

		documentoPer.setValue("");
		listarPersonas();
	}

	public void fecha() {
		Calendar fechaNacimiento = new GregorianCalendar(2006, 4, 10);
		Calendar ahora = Calendar.getInstance();

		long edadEnDias = (ahora.getTimeInMillis() - fechaNacimiento.getTimeInMillis())
		                        / 1000 / 60 / 60 / 24;

		int anos = Double.valueOf(edadEnDias / 365.25d).intValue();
		int dias = Double.valueOf(edadEnDias % 365.25d).intValue();

		System.out.println(String.format("%d años y %d días", anos, dias));
		System.out.println(String.format("%d",anos));
		calcularEdad();
		  
	
	}
	
		 

		static void calcularEdad() {
			LocalDate fechaHoy = LocalDate.now();
			LocalDate fechaNacimiento = LocalDate.of(2004, 12, 10);
	 
			Period periodo = Period.between(fechaNacimiento, fechaHoy);
			System.out.println(periodo.getYears());
			
		//	 LocalDate hoy = LocalDate.now();   
			// LocalDate nacimiento = usuarioActivo.getFechaNacimiento().toInstant().
			 //    atZone(ZoneId.systemDefault()).toLocalDate(); 
			// long edad = ChronoUnit.YEARS.between(nacimiento, hoy); 
			
			mostrar.setValue("	"+fechaHoy);
		}
	 
		
		public void cargar() {	
		
			            
						org.zkoss.util.media.Media 
			            media = event.getMedia();
			            if (media instanceof org.zkoss.image.Image) {
			                org.zkoss.zul.Image image = new org.zkoss.zul.Image();
			                image.setContent(media);
			                image.setParent(pics);
			            } else {
			                Messagebox.show("Not an image: "+media, "Error", Messagebox.OK, Messagebox.ERROR);
			                break;
			            }
			        
		
		}	
		
		public void descargar() {	
			Filedownload.save( "/img/sun.jpg", null,"");
		
		}	
		
		
		
}
	