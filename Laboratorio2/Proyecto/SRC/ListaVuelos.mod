(*4317743 4585215*)
IMPLEMENTATION MODULE ListaVuelos;

FROM Storage    IMPORT ALLOCATE,DEALLOCATE;
FROM Fecha      IMPORT Fecha,EsMenorFecha,IgualesFecha;
FROM Linea      IMPORT TIdLinea,ObtenerHoraSalidaLinea,ObtenerIdLinea;
FROM Vuelo      IMPORT Vuelo,ObtenerFechaVuelo,ObtenerLineaVuelo,DestruirVuelo;
FROM Strings    IMPORT Equal;


TYPE
	ListaVuelos = POINTER TO NodoListaVuelos;
	NodoListaVuelos = RECORD
		v   : Vuelo;
		sig : ListaVuelos
	END;


	
PROCEDURE CrearListaVuelos (): ListaVuelos;
BEGIN
	RETURN NIL
END CrearListaVuelos;



PROCEDURE InsertarVueloListaVuelos (v: Vuelo; VAR l: ListaVuelos);
VAR
	fchVue : Fecha;
	lvaux        : ListaVuelos;
	hsVue,hsLVue : CARDINAL;
	
BEGIN
	fchVue := ObtenerFechaVuelo(v);
	hsVue  := ObtenerHoraSalidaLinea(ObtenerLineaVuelo(v));
	NEW(lvaux);
	lvaux^.v := v;
	IF (l = NIL) OR (EsMenorFecha(fchVue,ObtenerFechaVuelo(l^.v))) THEN
		lvaux^.sig := l;
		l := lvaux
	ELSIF IgualesFecha(fchVue,ObtenerFechaVuelo(l^.v)) THEN
		hsLVue := ObtenerHoraSalidaLinea(ObtenerLineaVuelo(l^.v));
		IF hsVue < hsLVue THEN
			lvaux^.sig := l;
			l := lvaux
		ELSE
			InsertarVueloListaVuelos (v,l^.sig)
		END
	ELSE
		InsertarVueloListaVuelos (v,l^.sig)
	END
END InsertarVueloListaVuelos;


PROCEDURE EsVaciaListaVuelos (l: ListaVuelos): BOOLEAN;
BEGIN
	RETURN (l = NIL)
END EsVaciaListaVuelos;


PROCEDURE PerteneceVueloListaVuelos (linea : TIdLinea; f: Fecha;
                                     l: ListaVuelos): BOOLEAN;
VAR
	idlinLVue : TIdLinea;
	fchlv     : Fecha;
BEGIN
	IF l = NIL THEN
		RETURN FALSE
	ELSE
		idlinLVue := ObtenerIdLinea(ObtenerLineaVuelo(l^.v));
		fchlv  := ObtenerFechaVuelo(l^.v);
		IF (Equal(linea,idlinLVue)) AND (IgualesFecha(f,fchlv)) THEN
			RETURN TRUE
		ELSE
			RETURN (PerteneceVueloListaVuelos(linea,f,l^.sig))
		END
	END
END PerteneceVueloListaVuelos;


PROCEDURE ObtenerVueloListaVuelos (linea: TIdLinea; f: Fecha;
                                   l: ListaVuelos): Vuelo;
VAR
        idlinLVue : TIdLinea;
	fchlv     : Fecha;
BEGIN
	idlinLVue := ObtenerIdLinea(ObtenerLineaVuelo(l^.v));
	fchlv  := ObtenerFechaVuelo(l^.v);
	WHILE NOT ((Equal(linea,idlinLVue)) AND (IgualesFecha(f,fchlv))) DO
		l := l^.sig;
		idlinLVue := ObtenerIdLinea(ObtenerLineaVuelo(l^.v));
		fchlv  := ObtenerFechaVuelo(l^.v)
	END;
	RETURN l^.v
END ObtenerVueloListaVuelos;


PROCEDURE ObtenerPrimerVueloListaVuelos (l: ListaVuelos): Vuelo;
BEGIN
	RETURN l^.v
END ObtenerPrimerVueloListaVuelos;


PROCEDURE ObtenerRestoListaVuelos (l: ListaVuelos): ListaVuelos;
BEGIN
	RETURN l^.sig
END ObtenerRestoListaVuelos;


PROCEDURE EliminarVueloListaVuelos (linea: TIdLinea; f: Fecha;
                                    VAR l: ListaVuelos);
VAR
        idlinLVue : TIdLinea;
	fchlv     : Fecha;
BEGIN
	idlinLVue := ObtenerIdLinea(ObtenerLineaVuelo(l^.v));
	fchlv  := ObtenerFechaVuelo(l^.v);
	IF (Equal(linea,idlinLVue) AND (IgualesFecha(f,fchlv))) THEN
		l := l^.sig
	ELSE
		EliminarVueloListaVuelos(linea,f,l^.sig)
	END
END EliminarVueloListaVuelos;


PROCEDURE DestruirListaVuelos (VAR l: ListaVuelos);
VAR
	laux : ListaVuelos;
BEGIN
	WHILE l <> NIL DO
		laux := l;
		l := l^.sig;
		DestruirVuelo(laux^.v);
		DISPOSE(laux)
	END
END DestruirListaVuelos;


END ListaVuelos.	
