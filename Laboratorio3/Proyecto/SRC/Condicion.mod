(*4317743 4585215*)
IMPLEMENTATION MODULE Condicion;

FROM Storage IMPORT ALLOCATE,DEALLOCATE;

TYPE
	Condicion = POINTER TO TCondicion;
	TCondicion = RECORD		
		CASE operLog : BOOLEAN OF
			TRUE  : CASE oplog : TCondOperLog OF
					OP_AND, OP_OR : izq,der : Condicion|
					OP_NOT : abajo : Condicion|
				END|
			FALSE :	oper  : TCondOperador;
				nom   : TCondPor;
				val   : TValor|		
		END
	END;

	
PROCEDURE CrearCondicionVacia (): Condicion;
BEGIN
	RETURN NIL
END CrearCondicionVacia;


PROCEDURE CrearCondicionSimple (por: TCondPor; op: TCondOperador;
                                v: TValor): Condicion;
VAR
	c : Condicion;
BEGIN
	NEW(c);
	WITH c^ DO
		operLog := FALSE;
		oper := op;
		nom  := por;
		val  := v
	END;
	RETURN c
END CrearCondicionSimple;


PROCEDURE CrearCondicionUnaria (c: Condicion): Condicion;
VAR
	h : Condicion;	
BEGIN
	NEW(h);
	h^.operLog := TRUE;
	h^.oplog   := OP_NOT;
	h^.abajo   := c;
	RETURN(h);
END CrearCondicionUnaria;


PROCEDURE CrearCondicionBinaria (op: TCondOperLog;
                                 izq, der: Condicion): Condicion;
VAR
	c : Condicion;
BEGIN
	NEW(c);
	c^.operLog := TRUE;
	c^.oplog   := op;
	c^.izq     := izq;
	c^.der     := der;
	RETURN c
END CrearCondicionBinaria;


PROCEDURE EsVaciaCondicion (cond: Condicion): BOOLEAN;
BEGIN
	RETURN(cond = NIL);
END EsVaciaCondicion;


PROCEDURE EsOperadorCondicion (cond : Condicion): BOOLEAN;
BEGIN
	RETURN(NOT(cond^.operLog));
END EsOperadorCondicion;


PROCEDURE EsOperLogCondicion (cond : Condicion): BOOLEAN;
BEGIN
	RETURN cond^.operLog
END EsOperLogCondicion;

PROCEDURE ObtenerOperadorCondicion (c: Condicion): TCondOperador;
BEGIN
	RETURN(c^.oper);
END ObtenerOperadorCondicion;


PROCEDURE ObtenerPorCondicion (c: Condicion): TCondPor;
BEGIN
	RETURN c^.nom
END ObtenerPorCondicion;


PROCEDURE ObtenerValorCondicion (c: Condicion): TValor;
BEGIN
	RETURN(c^.val);
END ObtenerValorCondicion;


PROCEDURE ObtenerOperLogCondicion (c : Condicion): TCondOperLog;
BEGIN
	RETURN(c^.oplog);
END ObtenerOperLogCondicion;


PROCEDURE ObtenerIzqCondicion (c : Condicion): Condicion;
BEGIN
	RETURN(c^.izq);
END ObtenerIzqCondicion;


PROCEDURE ObtenerDerCondicion (c : Condicion): Condicion;
BEGIN
	RETURN c^.der
END ObtenerDerCondicion;


PROCEDURE ObtenerSubCondicion (c : Condicion): Condicion;
BEGIN
	RETURN c^.abajo
END ObtenerSubCondicion;


PROCEDURE DestruirCondicion (VAR c: Condicion);
BEGIN
	IF c <> NIL THEN
		IF c^.operLog = FALSE THEN
			DISPOSE(c)
		ELSE
			IF c^.oplog = OP_NOT THEN
				DestruirCondicion(c^.abajo);
				DISPOSE(c)
			ELSE
				DestruirCondicion(c^.izq);
				DestruirCondicion(c^.der);
				DISPOSE(c)
			END
		END;
		c := NIL
	END
END DestruirCondicion;

END Condicion.