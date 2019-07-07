(*4317743 4585215*)
IMPLEMENTATION MODULE ListaCombinacion;

FROM Storage     IMPORT ALLOCATE,DEALLOCATE;
FROM Combinacion IMPORT Combinacion,ObtenerPrecioCombinacion,ObtenerTramosCombinacion,
			DestruirCombinacion;
FROM Avion       IMPORT TClaseAsiento;
FROM STextIO     IMPORT WriteString,WriteLn;
FROM SWholeIO    IMPORT WriteCard;
FROM ListaTramo  IMPORT ListaTramo,EsVaciaListaTramo,ObtenerPrimeroListaTramo,
			ObtenerRestoListaTramo;
FROM Linea       IMPORT ObtenerIdLinea,ObtenerOrigenLinea,ObtenerDestinoLinea,
			TIdLinea,TIdAeropuerto;
FROM Tramo       IMPORT ObtenerLineaTramo,ObtenerFechaSalidaTramo,
			ObtenerHoraSalidaTramo,ObtenerFechaLlegadaTramo,
			ObtenerHoraLlegadaTramo;
FROM Fecha       IMPORT Fecha,FechaToString;
FROM Hora        IMPORT Hora,HoraToString;


TYPE
	ListaCombinacion = POINTER TO NLComb;
	NLComb = RECORD
		info : Combinacion;
		sig  : ListaCombinacion
	END;
	

PROCEDURE CrearListaCombinacion (): ListaCombinacion;
BEGIN
	RETURN NIL
END CrearListaCombinacion;


PROCEDURE AgregarListaCombinacion (c: Combinacion; VAR l: ListaCombinacion);
VAR
	nodo : ListaCombinacion;
BEGIN
	IF l = NIL THEN
		NEW(nodo);
		nodo^.info := c;
		nodo^.sig  := NIL;
		l := nodo
	ELSE
		AgregarListaCombinacion(c,l^.sig)
	END
END AgregarListaCombinacion;


PROCEDURE EsVaciaListaCombinacion (l: ListaCombinacion): BOOLEAN;
BEGIN
	RETURN (l = NIL)
END EsVaciaListaCombinacion;


PROCEDURE ObtenerPrimeroListaCombinacion (l: ListaCombinacion): Combinacion;
BEGIN
	RETURN l^.info
END ObtenerPrimeroListaCombinacion;


PROCEDURE ObtenerRestoListaCombinacion (l: ListaCombinacion): ListaCombinacion;
BEGIN
	RETURN l^.sig
END ObtenerRestoListaCombinacion;


PROCEDURE ImprimirListaCombinacion (l: ListaCombinacion; clase: TClaseAsiento);
VAR
	i,precio : CARDINAL;
	idlin    : TIdLinea;
	or,dest  : TIdAeropuerto;
	list     : ListaTramo;
	fecha    : Fecha;
	hora     : Hora;
	str      : ARRAY [0..7] OF CHAR;
	str2     : ARRAY [0..4] OF CHAR;
BEGIN	
	WriteString('Posibles combinaciones:');
	WriteLn();
	i := 0;
	WHILE l <> NIL DO
		i := i + 1;
		WriteString('Combinacion ');
		WriteCard(i,1);
		WriteString(': ');
		precio := ObtenerPrecioCombinacion(l^.info,clase);
		WriteCard(precio,1);
		WriteLn();
		list := ObtenerTramosCombinacion(l^.info);
		WHILE NOT EsVaciaListaTramo(list) DO
			idlin := ObtenerIdLinea(ObtenerLineaTramo(ObtenerPrimeroListaTramo(list)));
			WriteString(idlin);
			WriteString('-');
			or := ObtenerOrigenLinea(ObtenerLineaTramo(ObtenerPrimeroListaTramo(list)));
			WriteString(or);
			WriteString('-');
			fecha := ObtenerFechaSalidaTramo(ObtenerPrimeroListaTramo(list));
			FechaToString(fecha,str);
			WriteString(str);
			WriteString('-');
			hora := ObtenerHoraSalidaTramo(ObtenerPrimeroListaTramo(list));
			HoraToString(hora,str2);
			str2[4] := str2[3];
			str2[3] := str2[2];
			str2[2] := ':';
			WriteString(str2);
			WriteString('-');
			dest := ObtenerDestinoLinea(ObtenerLineaTramo(ObtenerPrimeroListaTramo(list)));
			WriteString(dest);
			WriteString('-');
			fecha := ObtenerFechaLlegadaTramo(ObtenerPrimeroListaTramo(list));
			FechaToString(fecha,str);
			WriteString(str);
			WriteString('-');
			hora := ObtenerHoraLlegadaTramo(ObtenerPrimeroListaTramo(list));
			HoraToString(hora,str2);
			str2[4] := str2[3];
			str2[3] := str2[2];
			str2[2] := ':';
			WriteString(str2);
			list := ObtenerRestoListaTramo(list);
			IF NOT EsVaciaListaTramo(list) THEN
				WriteLn
			END
		END;
		WriteLn();
		l := l^.sig;
	END;
END ImprimirListaCombinacion;


PROCEDURE DestruirListaCombinacion (VAR l: ListaCombinacion);
VAR
	aux : ListaCombinacion;
BEGIN
	aux := l;
	WHILE l <> NIL DO
		l := l^.sig;
		DestruirCombinacion(aux^.info);
		DISPOSE(aux);
		aux := l;
	END;
END DestruirListaCombinacion;


END ListaCombinacion.	