(*4317743 4585215*)
IMPLEMENTATION MODULE OrdenLinea;


FROM Storage IMPORT ALLOCATE,DEALLOCATE;


TYPE
	OrdenLinea = POINTER TO TOrdenLinea;
	TOrdenLinea = RECORD
		atributo : TOrdenarPor;
		forma : TOrdenForma;
	END;



PROCEDURE CrearOrdenLinea (por: TOrdenarPor; forma: TOrdenForma): OrdenLinea;
VAR
	OrdLin : OrdenLinea;
BEGIN
	NEW(OrdLin);
	OrdLin^.atributo := por;
	OrdLin^.forma := forma;
	RETURN(OrdLin);
END CrearOrdenLinea;



PROCEDURE ObtenerPorOrdenLinea (o: OrdenLinea): TOrdenarPor;
BEGIN
	RETURN(o^.atributo);
END ObtenerPorOrdenLinea;



PROCEDURE ObtenerFormaOrdenLinea (o: OrdenLinea): TOrdenForma;
BEGIN
	RETURN(o^.forma);
END ObtenerFormaOrdenLinea;



PROCEDURE DestruirOrdenLinea (VAR o: OrdenLinea);
BEGIN
	DISPOSE(o);
	o := NIL;
END DestruirOrdenLinea;



END OrdenLinea.