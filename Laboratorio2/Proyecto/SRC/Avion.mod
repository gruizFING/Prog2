(*4317743 4585215*)
IMPLEMENTATION MODULE Avion;
FROM Storage IMPORT ALLOCATE,DEALLOCATE;

TYPE
	Avion = POINTER TO TAviones;
	TAviones = RECORD
		id : TRangoIdAvion;
		cantAsientosPrimera, cantAsientosTurista: TRangoAsiento;
		dsc : TDscAvion;
	END;
	
PROCEDURE CrearAvion (id: TRangoIdAvion;
                      cantAsientosPrimera, cantAsientosTurista: TRangoAsiento;
                     dsc: TDscAvion): Avion;
VAR
	a : Avion;		
BEGIN
	NEW(a);
	a^.id := id;
	a^.cantAsientosPrimera := cantAsientosPrimera;
	a^.cantAsientosTurista := cantAsientosTurista;
	a^.dsc := dsc;
	RETURN a
END CrearAvion;

PROCEDURE ObtenerIdAvion (a: Avion): TRangoIdAvion;
BEGIN
	RETURN (a^.id)
END ObtenerIdAvion;

PROCEDURE ObtenerAsientosAvion (a: Avion;
                                claseAsiento : TClaseAsiento): TRangoAsiento;
BEGIN
	IF (claseAsiento = PRIMERA) THEN
		RETURN (a^.cantAsientosPrimera)
	ELSE
		RETURN (a^.cantAsientosTurista)
	END
END ObtenerAsientosAvion;

PROCEDURE ObtenerDescripcionAvion (a: Avion): TDscAvion;
BEGIN
	RETURN (a^.dsc)
END ObtenerDescripcionAvion;

PROCEDURE DestruirAvion (VAR a: Avion);
BEGIN
	IF a <> NIL THEN
		DISPOSE(a);
		a := NIL
	END
END DestruirAvion;

END Avion.		