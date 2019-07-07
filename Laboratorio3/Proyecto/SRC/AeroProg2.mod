(*4317743 4585215*)
MODULE AeroProg2; 

FROM STextIO   IMPORT WriteString, WriteLn;
FROM Strings   IMPORT Equal,Length,Concat;
FROM Comando   IMPORT Comando,NombreComando,Parametro,
		      LeerComando,ObtenerNombreComando,ObtenerCantParamComando,
		      ObtenerParamComando,DestruirComando,ParametroACondicion;
FROM WholeStr  IMPORT StrToCard,ConvResults;
FROM Manejador IMPORT Manejador,CrearManejador,AltaCliente,AltaAvion,AltaLinea,
                      Iniciar,SiguienteDia,Comprar,Reservar,Cancelar,ListarClientes,
		      ListarLineas,ListarVuelosHoy,InfoCliente,InfoLinea,InfoVuelo,
		      DestruirManejador,FiltrarLineas,NombreArchivo,InfoAvion,
		      BuscarCombinaciones,PersistirAerolinea,RecuperarAerolinea;
FROM ImpresionResultado IMPORT ImpresionResultado,CrearImpresionResultado,
			       AsignarCodigoImpresionResultado,ImprimirImpresionResultado,
			       CodigoResultado,DestruirImpresionResultado;
FROM Cliente IMPORT TNomCliente,TApellCliente,TIdPasaporte,TIdNacionalidad;
FROM Linea   IMPORT TIdLinea,TIdAeropuerto,TTipoLinea,TModoPago;
FROM Avion   IMPORT TDscAvion,TClaseAsiento;
FROM Fecha   IMPORT Fecha,TDiaSemana,CrearFecha;
FROM ListaOrdenLinea IMPORT ListaOrdenLinea,CrearListaOrdenLinea,AgregarListaOrdenLinea,DestruirListaOrdenLinea;
FROM OrdenLinea IMPORT OrdenLinea,CrearOrdenLinea,TOrdenarPor,TOrdenForma;
FROM Condicion IMPORT Condicion,DestruirCondicion;

CONST
      (* comandos *)
      COM_SALIR                = "salir";
      COM_ALTA_CLIENTE         = "altaCliente";
      COM_ALTA_LINEA           = "altaLinea";
      COM_ALTA_AVION           = "altaAvion";
      COM_INICIAR              = "iniciar";
      COM_SIGUIENTE_DIA        = "siguienteDia";
      COM_COMPRAR              = "compra";
      COM_RESERVAR             = "reserva";
      COM_CANCELAR             = "cancela";
      COM_LISTAR_CLIENTES      = "listarClientes";
      COM_LISTAR_LINEAS        = "listarLineas";
      COM_LISTAR_VUELOS_HOY    = "listarVuelosHoy";
      COM_INFO_CLIENTE         = "infoCliente";
      COM_INFO_LINEA           = "infoLinea";
      COM_INFO_VUELO           = "infoVuelo";
      COM_FILTRAR_LINEAS       = "filtrarLineas";
      COM_INFO_AVION           = "infoAvion";
      COM_BUSCAR_COMBINACIONES = "buscarCombinaciones";
      COM_PERSISTIR            = "persistir";
      COM_RECUPERAR            = "recuperar";
      COM_COMENTARIO           = "#";


PROCEDURE ImprimirBienvenida ();
BEGIN
      WriteString("Bienvenidos a AeroProg2"); WriteLn;
      WriteString("version 2.0"); WriteLn;
      WriteString("InCo-FIng-UdelaR"); WriteLn; WriteLn;
END ImprimirBienvenida;


VAR
	nomComando : NombreComando;
	dur,hs,idav  : CARDINAL;
	Param,Parami : Parametro;
	com        : Comando;
	man        : Manejador;
	ir         : ImpresionResultado;
	res        : ConvResults;
	numPri,numTur,i,j,idAv,num : CARDINAL;
	nomCliente   : TNomCliente;
	apellCliente : TApellCliente;
	pasCliente   : TIdPasaporte;
	paisCliente  : TIdNacionalidad;
	idlin : TIdLinea;
	origen,destino : TIdAeropuerto;
	Dsc : TDscAvion;
	frec : TTipoLinea;
	dia  : TDiaSemana;
	fecha : Fecha;
	mpag : TModoPago;
	clase : TClaseAsiento;
	atri : TOrdenarPor;
	por  : TOrdenForma;
	o : OrdenLinea;
	ListaOrden : ListaOrdenLinea;
	c : Condicion;
	nomarch : NombreArchivo;
	
BEGIN
	ImprimirBienvenida();
	man := CrearManejador();
	WriteString(">");
	com := LeerComando();
	nomComando := ObtenerNombreComando(com);
	WHILE NOT Equal(nomComando,COM_SALIR) DO
		IF Equal(nomComando,COM_ALTA_CLIENTE) THEN
			Param := ObtenerParamComando(1,com);
			i := 2;
			WHILE Param[Length(Param) - 1] <> "'" DO
				Parami := ObtenerParamComando(i,com);
				Concat(Param," ",Param);
				Concat(Param,Parami,Param);
				i := i + 1
			END;
			FOR j := 0 TO Length(Param) DO
				nomCliente[j] := Param[j]
			END;
			Param := ObtenerParamComando(i,com);
			WHILE Param[Length(Param) - 1] <> "'" DO
				i := i + 1;
				Parami := ObtenerParamComando(i,com);
				Concat(Param," ",Param);
				Concat(Param,Parami,Param)
			END;
			FOR j := 0 TO Length(Param) DO
				apellCliente[j] := Param[j]
			END;
			i := i + 1;
			Param := ObtenerParamComando(i,com);
			FOR j := 0 TO Length(Param) DO
				pasCliente[j] := Param[j]
			END;
			Param := ObtenerParamComando(i + 1,com);
			FOR j := 0 TO Length(Param) DO
				paisCliente[j] := Param[j]
			END;
			AltaCliente(paisCliente,pasCliente,nomCliente,apellCliente,man,ir)
		ELSIF Equal(nomComando,COM_ALTA_AVION) THEN
			Param := ObtenerParamComando(1,com);
			StrToCard(Param,numPri,res);
			Param := ObtenerParamComando(2,com);
			StrToCard(Param,numTur,res);
			Param := ObtenerParamComando(3,com);
			FOR j := 0 TO Length(Param) DO
				Dsc[j] := Param[j]
			END;
			AltaAvion(numPri,numTur,Dsc,man,ir)
		ELSIF Equal(nomComando,COM_ALTA_LINEA) THEN
			Param := ObtenerParamComando(1,com);
			FOR j := 0 TO Length(Param) DO
				idlin[j] := Param[j]
			END;
			Param := ObtenerParamComando(2,com);
			StrToCard(Param,idAv,res);
			Param := ObtenerParamComando(3,com);
			j := 0;
			REPEAT
				origen[j] := Param[j];
				j := j + 1
			UNTIL (Length(Param) = j) OR (j = 4);
			Param := ObtenerParamComando(4,com);
			j := 0;
			REPEAT
				destino[j] := Param[j];
				j := j + 1
			UNTIL (Length(Param) = j) OR (j = 4);
			Param := ObtenerParamComando(5,com);
			StrToCard(Param,hs,res);
			Param := ObtenerParamComando(6,com);
			StrToCard(Param,dur,res);
			Param := ObtenerParamComando(7,com);
			IF Equal(Param,"SEMANAL") THEN
				frec  := SEMANAL;
				Param := ObtenerParamComando(8,com);
				IF Equal(Param,"LUNES") THEN
					dia := LUNES
				ELSIF Equal(Param,"MARTES") THEN
					dia := MARTES
				ELSIF Equal(Param,"MIERCOLES") THEN
					dia := MIERCOLES
				ELSIF Equal(Param,"JUEVES") THEN
					dia := JUEVES
				ELSIF Equal(Param,"VIERNES") THEN
					dia := VIERNES
				ELSIF Equal(Param,"SABADO") THEN
					dia := SABADO
				ELSE
					dia := DOMINGO
				END
			ELSE
				frec := DIARIA
			END;
			AltaLinea(idlin,idAv,origen,destino,hs,dur,frec,dia,man,ir)
		ELSIF Equal(nomComando,COM_INICIAR) THEN
			Param := ObtenerParamComando(1,com);
			fecha := CrearFecha(Param);
			Iniciar(fecha,man,ir)
		ELSIF Equal(nomComando,COM_SIGUIENTE_DIA) THEN
			SiguienteDia(man,ir)
		ELSIF Equal(nomComando,COM_COMPRAR) THEN
			Param := ObtenerParamComando(1,com);
			FOR j := 0 TO Length(Param) DO
				idlin[j] := Param[j]
			END;
			Param := ObtenerParamComando(2,com);
			fecha := CrearFecha(Param);
			Param := ObtenerParamComando(3,com);
			FOR j := 0 TO Length(Param) DO
				pasCliente[j] := Param[j]
			END;
			Param := ObtenerParamComando(4,com);
			FOR j := 0 TO Length(Param) DO
				paisCliente[j] := Param[j]
			END;
			Param := ObtenerParamComando(5,com);
			IF Equal(Param,"PUNTOS") THEN
				mpag := PUNTOS
			ELSE
				mpag := EFECTIVO
			END;
			Param := ObtenerParamComando(6,com);
			IF Equal(Param,"PRIMERA") THEN
				clase := PRIMERA
			ELSE
				clase := TURISTA
			END;
			num := 0;
			IF ObtenerCantParamComando(com) = 7 THEN
				Param := ObtenerParamComando(7,com);
				StrToCard(Param,num,res)
			END;
			Comprar(paisCliente,pasCliente,idlin,fecha,mpag,clase,num,man,ir)
		ELSIF Equal(nomComando,COM_RESERVAR) THEN
			Param := ObtenerParamComando(1,com);
			FOR j := 0 TO Length(Param) DO
				idlin[j] := Param[j]
			END;
			Param := ObtenerParamComando(2,com);
			fecha := CrearFecha(Param);
			Param := ObtenerParamComando(3,com);
			FOR j := 0 TO Length(Param) DO
				pasCliente[j] := Param[j]
			END;
			Param := ObtenerParamComando(4,com);
			FOR j := 0 TO Length(Param) DO
				paisCliente[j] := Param[j]
			END;
			Param := ObtenerParamComando(5,com);
			IF Equal(Param,"PRIMERA") THEN
				clase := PRIMERA
			ELSE
				clase := TURISTA
			END;
			num := 0;
			IF ObtenerCantParamComando(com) = 6 THEN
				Param := ObtenerParamComando(6,com);
				StrToCard(Param,num,res)
			END;
			Reservar(paisCliente,pasCliente,idlin,fecha,clase,num,man,ir)
		ELSIF Equal(nomComando,COM_CANCELAR) THEN
			Param := ObtenerParamComando(1,com);
			FOR j := 0 TO Length(Param) DO
				idlin[j] := Param[j]
			END;
			Param := ObtenerParamComando(2,com);
			fecha := CrearFecha(Param);
			Param := ObtenerParamComando(3,com);
			FOR j := 0 TO Length(Param) DO
				pasCliente[j] := Param[j]
			END;
			Param := ObtenerParamComando(4,com);
			FOR j := 0 TO Length(Param) DO
				paisCliente[j] := Param[j]
			END;
			Param := ObtenerParamComando(5,com);
			IF Equal(Param,"PRIMERA") THEN
				clase := PRIMERA
			ELSE
				clase := TURISTA
			END;
			num := 0;
			IF ObtenerCantParamComando(com) = 6 THEN
				Param := ObtenerParamComando(6,com);
				StrToCard(Param,num,res)
			END;
			Cancelar(paisCliente,pasCliente,idlin,fecha,clase,num,man,ir)
		ELSIF Equal(nomComando,COM_LISTAR_CLIENTES) THEN
			ListarClientes(man)
		ELSIF Equal(nomComando,COM_LISTAR_LINEAS) THEN
			Param  := ObtenerParamComando(1,com);
			Parami := ObtenerParamComando(2,com);
			i := 0;
			j := 0;
			ListaOrden := CrearListaOrdenLinea();
			WHILE i <= Length(Param) DO
				IF Param[i] = 'I' THEN
					atri := ORDEN_ID;
					IF Parami[j] = 'A' THEN
						por := ASC
					ELSE
						por := DSC
					END;
					i := i + 3
				ELSIF Param[i] = 'A' THEN
					atri := ORDEN_AVION;
				        IF Parami[j] = 'A' THEN
						por := ASC
					ELSE
						por := DSC
					END;
					i := i + 6
				ELSIF Param[i] = 'O' THEN
					atri := ORDEN_ORIGEN;
					IF Parami[j] = 'A' THEN
						por := ASC
					ELSE
						por := DSC
					END;
					i := i + 7
				ELSIF Param[i] = 'D' THEN
					IF Param[i + 1] = 'E' THEN
						atri := ORDEN_DESTINO;
						IF Parami[j] = 'A' THEN
							por := ASC
						ELSE
							por := DSC
						END;
						i := i + 8
					ELSE
						atri := ORDEN_DURACION;
						IF Parami[j] = 'A' THEN
							por := ASC
						ELSE
							por := DSC
						END;
						i := i + 9
					END
				ELSIF Param[i] = 'H' THEN
					atri := ORDEN_HORA;
					IF Parami[j] = 'A' THEN
						por := ASC
					ELSE
						por := DSC
					END;
					i := i + 5
				END;
				IF por = ASC THEN
					j := j + 4
				ELSE
					j := j + 5
				END;	
				o := CrearOrdenLinea(atri,por);
				AgregarListaOrdenLinea(o,ListaOrden)
			END;
			ListarLineas(ListaOrden,man);
			DestruirListaOrdenLinea(ListaOrden)
		ELSIF Equal(nomComando,COM_FILTRAR_LINEAS) THEN
			Param := ObtenerParamComando(1,com);
			c := ParametroACondicion(Param);
			FiltrarLineas(c,man);
			DestruirCondicion(c)	
		ELSIF Equal(nomComando,COM_LISTAR_VUELOS_HOY) THEN
			ListarVuelosHoy(man,ir)
		ELSIF Equal(nomComando,COM_INFO_CLIENTE) THEN
			Param := ObtenerParamComando(1,com);
			FOR j := 0 TO Length(Param) DO
				pasCliente[j] := Param[j]
			END;
			Param := ObtenerParamComando(2,com);
			FOR j := 0 TO Length(Param) DO
				paisCliente[j] := Param[j]
			END;
			InfoCliente(paisCliente,pasCliente,man,ir)
		ELSIF Equal(nomComando,COM_INFO_LINEA) THEN
			Param := ObtenerParamComando(1,com);
			FOR j := 0 TO Length(Param) DO
				idlin[j] := Param[j]
			END;
			InfoLinea(idlin,man,ir)
		ELSIF Equal(nomComando,COM_INFO_VUELO) THEN
			Param := ObtenerParamComando(1,com);
			FOR j := 0 TO Length(Param) DO
				idlin[j] := Param[j]
			END;
			Param := ObtenerParamComando(2,com);
			fecha := CrearFecha(Param);
			InfoVuelo(idlin,fecha,man,ir)
		ELSIF Equal(nomComando,COM_INFO_AVION) THEN
			Param := ObtenerParamComando(1,com);
			StrToCard(Param,idav,res);
			InfoAvion(idav,man,ir)
		ELSIF Equal(nomComando,COM_BUSCAR_COMBINACIONES) THEN
			Param := ObtenerParamComando(1,com);
			FOR j := 0 TO Length(Param) DO
				origen[j] := Param[j]
			END;
			Param := ObtenerParamComando(2,com);
			FOR j := 0 TO Length(Param) DO
				destino[j] := Param[j]
			END;
			Param := ObtenerParamComando(3,com);
			fecha := CrearFecha(Param);
			Param := ObtenerParamComando(4,com);
			IF Equal(Param,"PRIMERA") THEN
				clase := PRIMERA
			ELSE
				clase := TURISTA
			END;
			BuscarCombinaciones(origen,destino,fecha,clase,man,ir)
		ELSIF Equal(nomComando,COM_PERSISTIR) THEN
			Param := ObtenerParamComando(1,com);
			FOR j := 0 TO Length(Param) DO
				nomarch[j] := Param[j]
			END;
			PersistirAerolinea(nomarch,man,ir)
		ELSIF Equal(nomComando,COM_RECUPERAR) THEN
			Param := ObtenerParamComando(1,com);
			FOR j := 0 TO Length(Param) DO
				nomarch[j] := Param[j]
			END;
			RecuperarAerolinea(nomarch,man,ir)
		ELSIF Equal(nomComando,COM_COMENTARIO) THEN
			Param := ObtenerParamComando(1,com);
			FOR i := 2 TO ObtenerCantParamComando(com) DO
				Parami := ObtenerParamComando(i,com);
				Concat(Param," ",Parami)
			END;
			WriteString(Param);WriteLn	 	
		END;
		DestruirComando(com);
		WriteString(">");
		com := LeerComando();
		nomComando := ObtenerNombreComando(com)
	END;
	ir := CrearImpresionResultado();
	AsignarCodigoImpresionResultado(SALIR,ir);
	ImprimirImpresionResultado(ir);
	DestruirImpresionResultado(ir);
	DestruirManejador(man)		
END AeroProg2.