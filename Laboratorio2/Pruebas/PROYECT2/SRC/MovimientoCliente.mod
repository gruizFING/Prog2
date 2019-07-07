IMPLEMENTATION MODULE MovimientoCliente;

FROM Storage IMPORT ALLOCATE,DEALLOCATE;
FROM Avion IMPORT TAsiento,TClaseAsiento;
FROM Fecha IMPORT Fecha,FechaToString,DestruirFecha,CopiaFecha;
FROM Linea IMPORT TIdLinea, TDuracion;
FROM STextIO IMPORT WriteString,WriteLn;
FROM SWholeIO IMPORT WriteCard;


TYPE
	MovimientoCliente = POINTER TO Nodomovcliente;
		Nodomovcliente = RECORD	
			idlin: TIdLinea;
			fecha: Fecha;
			asiento: TAsiento;
			dur: TDuracion;
			estado: TEstadoMovimiento;
		END;
		
		
		

PROCEDURE CrearMovimientoCliente (idLin: TIdLinea; f: Fecha;
                                  asiento: TAsiento; dur: TDuracion;
                                  estado: TEstadoMovimiento):MovimientoCliente;
VAR
	movcliente: MovimientoCliente;
BEGIN
	NEW(movcliente);
	movcliente^.idlin := idLin;
	movcliente^.fecha := CopiaFecha(f);            (*********)
	movcliente^.asiento := asiento;
	movcliente^.dur := dur;
	movcliente^.estado := estado;
	RETURN(movcliente);
END CrearMovimientoCliente;



PROCEDURE CambiarEstadoMovimientoCliente (estado: TEstadoMovimiento;
                                          VAR m: MovimientoCliente);
BEGIN
	m^.estado := estado;
END CambiarEstadoMovimientoCliente;



PROCEDURE ObtenerIdLineaMovimientoCliente (m: MovimientoCliente): TIdLinea;
BEGIN
	RETURN(m^.idlin);
END ObtenerIdLineaMovimientoCliente;



PROCEDURE ObtenerFechaMovimientoCliente (m: MovimientoCliente): Fecha;
BEGIN
	RETURN(m^.fecha);
END ObtenerFechaMovimientoCliente;


PROCEDURE ObtenerDuracionMovimientoCliente (m: MovimientoCliente): TDuracion;
BEGIN
	RETURN (m^.dur)
END ObtenerDuracionMovimientoCliente;


PROCEDURE ObtenerAsientoMovimientoCliente (m: MovimientoCliente): TAsiento;
BEGIN
	RETURN(m^.asiento);
END ObtenerAsientoMovimientoCliente;



PROCEDURE ObtenerEstadoMovimientoCliente(m:MovimientoCliente):TEstadoMovimiento;
BEGIN
	RETURN(m^.estado);
END ObtenerEstadoMovimientoCliente;



PROCEDURE ImprimirMovimientoCliente(m: MovimientoCliente);
VAR
	fch : ARRAY [0..7] OF CHAR;                (**fecha**)
BEGIN
	WriteCard(m^.asiento.num,1);
	WriteString("-");
	IF (m^.asiento.clase = PRIMERA) THEN
		WriteString("PRIMERA");
	ELSE
		WriteString("TURISTA");
	END;
	WriteString("-");
	FechaToString(m^.fecha,fch);
	WriteString(fch);                             (**************)
	WriteString("-");
	WriteString(m^.idlin);
	WriteString("-");
	CASE m^.estado OF
		M_COMPRA: WriteString("COMPRA") |
		M_RESERVA: WriteString("RESERVA") |
		M_CANCELA: WriteString("CANCELA") |
		M_MULTA: WriteString("MULTA")
	END;
	WriteLn();
END ImprimirMovimientoCliente;



PROCEDURE DestruirMovimientoCliente (VAR m: MovimientoCliente);
BEGIN
	DestruirFecha(m^.fecha);
	DISPOSE(m);
	m := NIL
END DestruirMovimientoCliente;



END MovimientoCliente.
	