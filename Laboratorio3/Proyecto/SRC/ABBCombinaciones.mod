(*4317743 4585215*)
IMPLEMENTATION MODULE ABBCombinaciones;

FROM Storage IMPORT ALLOCATE,DEALLOCATE;
FROM Avion                 IMPORT TClaseAsiento;
FROM Combinacion           IMPORT Combinacion,ObtenerPrecioCombinacion,ObtenerTramosCombinacion,DestruirCombinacion;
FROM ListaCombinacion      IMPORT ListaCombinacion,EsVaciaListaCombinacion,AgregarListaCombinacion,ObtenerPrimeroListaCombinacion,
                                  ObtenerRestoListaCombinacion;
FROM ListaTramo IMPORT ListaTramo,EsVaciaListaTramo,ObtenerPrimeroListaTramo,ObtenerRestoListaTramo;
FROM Linea IMPORT Linea,ObtenerIdLinea;
FROM Strings  IMPORT Compare,CompareResults;
FROM Tramo    IMPORT ObtenerLineaTramo;


TYPE
	ABBCombinaciones = POINTER TO NABBCombinaciones;
	NABBCombinaciones = RECORD
		raiz    : Combinacion;
		izq,der : ABBCombinaciones
	END;
	

PROCEDURE CrearABBCombinaciones(): ABBCombinaciones;
BEGIN
	RETURN NIL
END CrearABBCombinaciones;


PROCEDURE AgregarABBCombinaciones (c: Combinacion; clase: TClaseAsiento;
                                   VAR combs: ABBCombinaciones);
VAR
	precioC,precioR : CARDINAL;
	ListaTC,ListaTR : ListaTramo;
	LineaC,LineaR   : Linea;
	res             : CompareResults;
	Termino         : BOOLEAN;
BEGIN
	IF combs = NIL THEN
		NEW(combs);
		combs^.raiz := c;
		combs^.izq  := NIL;
		combs^.der  := NIL
	ELSE
		precioC := ObtenerPrecioCombinacion(c,clase);
		precioR := ObtenerPrecioCombinacion(combs^.raiz,clase);
		IF precioC < precioR THEN
			AgregarABBCombinaciones(c,clase,combs^.izq)
		ELSIF precioC > precioR THEN
			AgregarABBCombinaciones(c,clase,combs^.der)
		ELSE
			ListaTC := ObtenerTramosCombinacion(c);
			ListaTR := ObtenerTramosCombinacion(combs^.raiz);
			Termino := FALSE;
			WHILE (NOT EsVaciaListaTramo(ListaTC)) AND (NOT EsVaciaListaTramo(ListaTR)) AND (NOT Termino) DO
				LineaC := ObtenerLineaTramo(ObtenerPrimeroListaTramo(ListaTC));
				LineaR := ObtenerLineaTramo(ObtenerPrimeroListaTramo(ListaTR));
				res    := Compare(ObtenerIdLinea(LineaC),ObtenerIdLinea(LineaR));
				IF (res = less) THEN
					AgregarABBCombinaciones(c,clase,combs^.izq);
					Termino := TRUE
				ELSIF (res = greater) THEN
					AgregarABBCombinaciones(c,clase,combs^.der);
					Termino := TRUE
				ELSE
					ListaTC := ObtenerRestoListaTramo(ListaTC);
					ListaTR := ObtenerRestoListaTramo(ListaTR)
				END
			END
		END
	END
END AgregarABBCombinaciones;


PROCEDURE EnOrdenABBCombinaciones (combs: ABBCombinaciones): ListaCombinacion;

PROCEDURE AppendLC(l,p : ListaCombinacion) : ListaCombinacion;
VAR
	lpos : ListaCombinacion;
BEGIN
	lpos := p;
	WHILE NOT EsVaciaListaCombinacion(lpos) DO
		AgregarListaCombinacion(ObtenerPrimeroListaCombinacion(lpos),l);
		lpos := ObtenerRestoListaCombinacion(lpos)
	END;
	RETURN l
END AppendLC;
			
VAR
	lres : ListaCombinacion;
BEGIN
	IF combs = NIL THEN
		RETURN NIL
	ELSE
		lres := EnOrdenABBCombinaciones(combs^.izq);
		AgregarListaCombinacion(combs^.raiz,lres);
		RETURN (AppendLC(lres,EnOrdenABBCombinaciones(combs^.der)))
	END
END EnOrdenABBCombinaciones;


PROCEDURE DestruirABBCombinaciones (VAR combs: ABBCombinaciones);
BEGIN
	IF combs <> NIL THEN
		DestruirABBCombinaciones(combs^.izq);
		DestruirABBCombinaciones(combs^.der);
		DestruirCombinacion(combs^.raiz);
		DISPOSE(combs);
	        combs := NIL;
	END;
END DestruirABBCombinaciones;

END ABBCombinaciones.