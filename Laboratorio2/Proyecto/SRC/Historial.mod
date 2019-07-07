(*4317743 4585215*)
IMPLEMENTATION MODULE Historial;

FROM STextIO IMPORT WriteString,WriteLn;
FROM Storage IMPORT ALLOCATE,DEALLOCATE;
FROM MovimientoCliente IMPORT MovimientoCliente,ImprimirMovimientoCliente,
		              DestruirMovimientoCliente;



TYPE
	Historial = POINTER TO NodoHistorial;
	NodoHistorial = RECORD
		mov: MovimientoCliente;
		sig: Historial;
	END;


PROCEDURE CrearHistorial (): Historial;
BEGIN
	RETURN(NIL);
END CrearHistorial;



PROCEDURE AgregarMovimientoHistorial (mov: MovimientoCliente; VAR h: Historial);
VAR
	haux1,haux2: Historial;
BEGIN
	NEW(haux2);
	haux2^.mov := mov;
	haux2^.sig := NIL;
	IF h = NIL THEN
		h := haux2
	ELSE
		haux1 := h;
		WHILE haux1^.sig <> NIL DO
			haux1 := haux1^.sig
		END;
		haux1^.sig := haux2
	END
END AgregarMovimientoHistorial;



PROCEDURE EsVacioHistorial (h: Historial): BOOLEAN;
BEGIN
	RETURN(h = NIL);
END EsVacioHistorial;



PROCEDURE ObtenerPrimerMovimientoHistorial (h: Historial): MovimientoCliente;
BEGIN
	RETURN (h^.mov);
END ObtenerPrimerMovimientoHistorial;



PROCEDURE ObtenerRestoHistorial (h: Historial): Historial;
BEGIN
	RETURN (h^.sig);
END ObtenerRestoHistorial;



PROCEDURE ImprimirHistorial (h: Historial);
BEGIN
	WriteString('Movimientos:');
	WriteLn();
	WHILE h <> NIL DO
		ImprimirMovimientoCliente(h^.mov);
		h := h^.sig
	END
END ImprimirHistorial;



PROCEDURE DestruirHistorial (VAR h: Historial);
VAR
	haux: Historial;
BEGIN
	WHILE (h <> NIL) DO
		haux := h;
		h := h^.sig;
		DestruirMovimientoCliente(haux^.mov);
		DISPOSE(haux);
	END;
END DestruirHistorial;


END Historial.