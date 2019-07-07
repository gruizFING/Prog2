(*4317743 4585215*)
IMPLEMENTATION MODULE ListaLineas;
FROM Linea IMPORT Linea, TIdLinea,ObtenerIdLinea,DestruirLinea;
FROM Storage IMPORT ALLOCATE,DEALLOCATE;
FROM Strings IMPORT Compare,Equal,CompareResults;

TYPE
	ListaLineas = POINTER TO NodoListaLineas;
	NodoListaLineas = RECORD
		lin : Linea;
		sig : ListaLineas
	END;	
		
		
PROCEDURE CrearListaLineas (): ListaLineas;
BEGIN
	RETURN NIL
END CrearListaLineas;

PROCEDURE AgregarLineaListaLineas (lin: Linea; VAR l: ListaLineas);
VAR
	t : ListaLineas;
	lid1,lid2 : TIdLinea;
	compare : CompareResults;
BEGIN
	lid1 := ObtenerIdLinea(lin);
	IF l = NIL THEN
		NEW(t);
		t^.lin := lin;
		t^.sig := NIL;
		l := t
	ELSE
		lid2 := ObtenerIdLinea(l^.lin);
		compare := Compare(lid1,lid2);
		IF compare = less  THEN
			NEW(t);
			t^.lin := lin;
			t^.sig := l;
			l := t;
		ELSE
                        AgregarLineaListaLineas(lin,l^.sig);
		END
	END
END AgregarLineaListaLineas;

PROCEDURE EsVaciaListaLineas (l: ListaLineas): BOOLEAN;
BEGIN
	RETURN (l = NIL)
END EsVaciaListaLineas;
		
PROCEDURE PerteneceLineaListaLineas (id: TIdLinea; l: ListaLineas): BOOLEAN;	
BEGIN	
	IF l = NIL THEN
		RETURN FALSE
	ELSIF Equal(id,ObtenerIdLinea(l^.lin)) THEN
		RETURN TRUE
	ELSE
		RETURN (PerteneceLineaListaLineas(id,l^.sig))
	END
END PerteneceLineaListaLineas;

PROCEDURE ObtenerPrimerLineaListaLineas (l: ListaLineas): Linea;
BEGIN
	RETURN (l^.lin)
END ObtenerPrimerLineaListaLineas;

PROCEDURE ObtenerRestoListaLineas (l: ListaLineas): ListaLineas;
BEGIN
	RETURN (l^.sig)
END ObtenerRestoListaLineas;

PROCEDURE ObtenerLineaListaLineas (id: TIdLinea; l: ListaLineas): Linea;
BEGIN
	WHILE (NOT Equal(id,ObtenerIdLinea(l^.lin))) DO
		l := l^.sig
	END;
	RETURN (l^.lin)
END ObtenerLineaListaLineas;

PROCEDURE DestruirListaLineas (VAR l: ListaLineas);
VAR
	q : ListaLineas;
BEGIN
	WHILE l <> NIL DO
		q := l;
		l := l^.sig;
		DestruirLinea(q^.lin);
		DISPOSE(q)
	END	
END DestruirListaLineas; 		

	
END ListaLineas.				