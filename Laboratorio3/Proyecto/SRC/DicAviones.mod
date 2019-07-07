(*4317743 4585215*)
IMPLEMENTATION MODULE DicAviones;
FROM Avion IMPORT Avion, TRangoIdAvion,ObtenerIdAvion,DestruirAvion;
FROM Storage IMPORT ALLOCATE,DEALLOCATE;

TYPE
	DicAviones = POINTER TO NodoDicAviones;
	NodoDicAviones = RECORD
		av  : Avion;
		sig : DicAviones
	END;


PROCEDURE CrearDicAviones(): DicAviones;
BEGIN
	RETURN NIL
END CrearDicAviones;


PROCEDURE InsertarAvionDicAviones (a: Avion; VAR dic: DicAviones);
VAR
	d,q : DicAviones;
BEGIN
	NEW(d);
	d^.av := a;
	d^.sig := NIL;
	IF dic = NIL THEN
		dic := d
	ELSE
		q := dic;
		WHILE q^.sig <> NIL DO
			q := q^.sig
		END;
		q^.sig := d
	END
END InsertarAvionDicAviones;


PROCEDURE EsVacioDicAviones (dic: DicAviones): BOOLEAN;
BEGIN
	RETURN (dic = NIL)
END EsVacioDicAviones;


PROCEDURE ObtenerTamanioDicAviones (dic: DicAviones): TRangoCantAviones;
BEGIN
	IF dic = NIL THEN
		RETURN 0
	ELSE
		RETURN (1 + ObtenerTamanioDicAviones (dic^.sig))
	END
END ObtenerTamanioDicAviones;


PROCEDURE ObtenerAvionDicAviones (id: TRangoIdAvion; dic: DicAviones): Avion;
BEGIN
	WHILE (id <> (ObtenerIdAvion(dic^.av))) DO
		dic := dic^.sig
	END;
	RETURN (dic^.av)
END ObtenerAvionDicAviones;


PROCEDURE PerteneceAvionDicAviones (id: TRangoIdAvion;
                                    dic: DicAviones): BOOLEAN;
BEGIN
	IF dic = NIL THEN
		RETURN FALSE
	ELSIF (id = (ObtenerIdAvion(dic^.av))) THEN
		RETURN TRUE
	ELSE
		RETURN (PerteneceAvionDicAviones(id,dic^.sig))
	END
END PerteneceAvionDicAviones;


PROCEDURE DestruirDicAviones (VAR dic: DicAviones);
VAR
	d : DicAviones;
BEGIN
	WHILE dic <> NIL DO
		d := dic;
		dic := dic^.sig;
		DestruirAvion(d^.av);
		DISPOSE(d)
	END
END DestruirDicAviones;


END DicAviones.