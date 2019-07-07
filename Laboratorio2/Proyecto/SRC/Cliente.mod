(*4317743 4585215*)
IMPLEMENTATION MODULE Cliente;


FROM Historial IMPORT AgregarMovimientoHistorial,ObtenerPrimerMovimientoHistorial,
                      ObtenerRestoHistorial,Historial,EsVacioHistorial,
		      ImprimirHistorial,DestruirHistorial,CrearHistorial;
FROM Fecha IMPORT Fecha,IgualesFecha;
FROM MovimientoCliente IMPORT MovimientoCliente,CrearMovimientoCliente,
                              ObtenerAsientoMovimientoCliente,
			      ObtenerIdLineaMovimientoCliente,
			      ObtenerFechaMovimientoCliente,
			      CambiarEstadoMovimientoCliente,
			      TEstadoMovimiento,ObtenerEstadoMovimientoCliente;
FROM Storage IMPORT ALLOCATE,DEALLOCATE;
FROM STextIO IMPORT WriteString,WriteLn;
FROM Linea IMPORT TIdLinea, TDuracion;
FROM Avion IMPORT TAsiento;
FROM Strings IMPORT Equal;
FROM SWholeIO IMPORT WriteInt;






TYPE
	Cliente = POINTER TO NodoCliente;
	NodoCliente = RECORD
	 	pais: TIdNacionalidad;
		pasaporte: TIdPasaporte;
		nombre: TNomCliente;
		apell: TApellCliente;
		puntos: INTEGER;
		historial: Historial;
	END;


PROCEDURE CrearCliente (pais: TIdNacionalidad; pasaporte: TIdPasaporte;
                        nombre: TNomCliente; apell: TApellCliente): Cliente;
VAR
	cliente: Cliente;
BEGIN
	NEW(cliente);
	cliente^.pais := pais;
	cliente^.pasaporte := pasaporte;
	cliente^.nombre := nombre;
	cliente^.apell := apell;
	cliente^.puntos := 0;
	cliente^.historial := CrearHistorial();
	RETURN (cliente)
END CrearCliente;


PROCEDURE SumarPuntosCliente (p: INTEGER; VAR c: Cliente);
BEGIN
	c^.puntos := c^.puntos + p;
END SumarPuntosCliente;


PROCEDURE EditarMovimiento (lin: TIdLinea; f: Fecha; asiento: TAsiento;
                dur: TDuracion; estado: TEstadoMovimiento; VAR c:Cliente);
VAR
	caux: Historial;
	mov: MovimientoCliente;
	idlin: TIdLinea;
	fecha: Fecha;
	as: TAsiento;
BEGIN
	IF (estado = M_RESERVA) THEN
		mov := CrearMovimientoCliente(lin,f,asiento,dur,estado);
		AgregarMovimientoHistorial(mov,c^.historial);
	ELSIF (estado = M_CANCELA) OR (estado = M_MULTA) THEN
		caux := ObtenerHistorialCliente(c);
		REPEAT
			mov := ObtenerPrimerMovimientoHistorial(caux);
			idlin := ObtenerIdLineaMovimientoCliente(mov);
			fecha := ObtenerFechaMovimientoCliente(mov);
			as := ObtenerAsientoMovimientoCliente(mov);
			caux := ObtenerRestoHistorial(caux);
		UNTIL (Equal(idlin,lin)) AND (IgualesFecha(fecha,f))
		       AND (as.num = asiento.num) AND (as.clase = asiento.clase)
		       AND (ObtenerEstadoMovimientoCliente(mov) = M_RESERVA);
		CambiarEstadoMovimientoCliente(estado,mov);
	ELSIF (estado = M_COMPRA) THEN
		IF (EsVacioHistorial(c^.historial)) THEN
				mov := CrearMovimientoCliente(lin,f,asiento,dur,estado);
			        AgregarMovimientoHistorial(mov,c^.historial);
		ELSE
			caux := ObtenerHistorialCliente(c);
			REPEAT
				mov := ObtenerPrimerMovimientoHistorial(caux);
				idlin := ObtenerIdLineaMovimientoCliente(mov);
				fecha := ObtenerFechaMovimientoCliente(mov);
				as := ObtenerAsientoMovimientoCliente(mov);
				caux := ObtenerRestoHistorial(caux);
			UNTIL ((Equal(idlin,lin)) AND (IgualesFecha(fecha,f))
		              AND (as.num = asiento.num)
			      AND (as.clase = asiento.clase))
			      AND (ObtenerEstadoMovimientoCliente(mov) = M_RESERVA)
			      OR  (EsVacioHistorial(caux));
			IF ((Equal(idlin,lin)) AND (IgualesFecha(fecha,f))
		              AND (as.num = asiento.num)
			      AND (as.clase = asiento.clase))
			      AND (ObtenerEstadoMovimientoCliente(mov) = M_RESERVA) THEN
				CambiarEstadoMovimientoCliente(M_COMPRA,mov);
			ELSIF (EsVacioHistorial(caux)) THEN
				mov := CrearMovimientoCliente(lin,f,asiento,dur,estado);
			        AgregarMovimientoHistorial(mov,c^.historial);
			END;
		END;
	END;
END EditarMovimiento;




		
PROCEDURE ObtenerNacionalidadCliente (c: Cliente): TIdNacionalidad;
BEGIN
	RETURN(c^.pais);
END ObtenerNacionalidadCliente;



PROCEDURE ObtenerPasaporteCliente (c: Cliente): TIdPasaporte;
BEGIN
	RETURN(c^.pasaporte);
END ObtenerPasaporteCliente;



PROCEDURE ObtenerPuntosCliente (c: Cliente): INTEGER;
BEGIN
	RETURN(c^.puntos);
END ObtenerPuntosCliente;



PROCEDURE ObtenerNombreCliente (c: Cliente): TNomCliente;
BEGIN
	RETURN(c^.nombre);
END ObtenerNombreCliente;



PROCEDURE ObtenerApellCliente (c: Cliente): TApellCliente;
BEGIN
	RETURN(c^.apell);
END ObtenerApellCliente;



PROCEDURE ObtenerHistorialCliente (c: Cliente): Historial;
BEGIN
	RETURN(c^.historial);
END ObtenerHistorialCliente;



PROCEDURE ImprimirInfoCliente (c: Cliente);
BEGIN
	WriteString('Cliente: ');
	WriteString(c^.nombre);
	WriteString('-');
	WriteString(c^.apell);
	WriteString('-');
	WriteString(c^.pasaporte);
	WriteString('-');
	WriteString(c^.pais);
	WriteString('-');
	WriteInt(c^.puntos,1);
	WriteString('.');
	WriteLn();
	ImprimirHistorial(c^.historial);
END ImprimirInfoCliente;



PROCEDURE DestruirCliente (VAR c: Cliente);
BEGIN
	IF c <> NIL THEN
		DestruirHistorial(c^.historial);
		DISPOSE(c);
		c := NIL
	END
END DestruirCliente;


END Cliente.