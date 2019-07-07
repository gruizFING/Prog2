MODULE PruebaMovimientoCliente;
(*******************************************************************************
        Módulo PruebaMovimientoCliente.

        Laboratorio de Programación 2.
        InCo-FI-UDELAR
*******************************************************************************)

FROM MovimientoCliente IMPORT MovimientoCliente, TEstadoMovimiento,
        CrearMovimientoCliente, CambiarEstadoMovimientoCliente,
        ObtenerIdLineaMovimientoCliente, ObtenerFechaMovimientoCliente,
        ObtenerAsientoMovimientoCliente, ObtenerEstadoMovimientoCliente,
        ImprimirMovimientoCliente, DestruirMovimientoCliente;
FROM Avion IMPORT TRangoAsiento, TClaseAsiento,        TAsiento;
FROM Linea IMPORT TIdLinea, TDuracion;
FROM Fecha IMPORT Fecha, CrearFecha, FechaToString;
FROM Strings IMPORT Equal;
FROM STextIO IMPORT WriteString, WriteLn;

PROCEDURE WriteStringLn(str: ARRAY OF CHAR);
BEGIN
        WriteString(str);WriteLn
END WriteStringLn;

VAR
        m: MovimientoCliente;
        ta: TAsiento;
        rasiento:TRangoAsiento;
        casiento:TClaseAsiento;
        f: Fecha;
        fstr: ARRAY[1..8] OF CHAR;
        idlinea: TIdLinea;
        dur: TDuracion;
        estado: TEstadoMovimiento;
BEGIN
        WriteStringLn("*************************************");
        WriteStringLn("****Prueba Movimiento Cliente********");
        WriteStringLn("*************************************");

        f:=CrearFecha("20100407");
        ta.num:=1;
        ta.clase:=PRIMERA;
        idlinea:="LineaPrimera";
        dur:=1;
        estado:=M_COMPRA;
        m:=CrearMovimientoCliente(idlinea, f, ta, dur, estado);

        WriteLn;
        WriteStringLn("Nro. Control - Resultado");
        WriteStringLn("------------------------");

        ta:=ObtenerAsientoMovimientoCliente(m);
        rasiento:=ta.num;
        casiento:=ta.clase;
        IF(casiento = PRIMERA)
        THEN WriteStringLn("1 - [OK]")
        ELSE WriteStringLn("1 - [ERROR:clase asiento incorrecta]")
        END;

        IF(rasiento = 1)
        THEN WriteStringLn("2 - [OK]")
        ELSE WriteStringLn("2 - [ERROR:numero asiento incorrecta]")
        END;

        FechaToString(ObtenerFechaMovimientoCliente(m), fstr);
        IF(Equal(fstr, "20100407"))
        THEN WriteStringLn("3 - [OK]")
        ELSE WriteStringLn("3 - [ERROR:fecha incorrecta]")
        END;

        IF(Equal(ObtenerIdLineaMovimientoCliente(m), "LineaPrimera"))
        THEN WriteStringLn("4 - [OK]")
        ELSE WriteStringLn("4 - [ERROR:idLinea incorrecta]")
        END;

        IF(ObtenerEstadoMovimientoCliente(m) = M_COMPRA)
        THEN WriteStringLn("5 - [OK]")
        ELSE WriteStringLn("5 - [ERROR:estado incorrecto]");
        END;

        CambiarEstadoMovimientoCliente(M_MULTA, m);
        IF(ObtenerEstadoMovimientoCliente(m) = M_MULTA)
        THEN WriteStringLn("6 - [OK]")
        ELSE WriteStringLn("6 - [ERROR:estado incorrecto]")
        END;

        CambiarEstadoMovimientoCliente(M_RESERVA, m);
        IF(ObtenerEstadoMovimientoCliente(m) = M_RESERVA)
        THEN WriteStringLn("7 - [OK]")
        ELSE WriteStringLn("7 - [ERROR:estado incorrecto]")
        END;

        CambiarEstadoMovimientoCliente(M_CANCELA, m);
        IF(ObtenerEstadoMovimientoCliente(m) = M_CANCELA)
        THEN WriteStringLn("8 - [OK]")
        ELSE WriteStringLn("8 - [ERROR:estado incorrecto]")
        END;
        WriteLn;

        WriteStringLn("ImprimirMovimientoCliente: ");
        ImprimirMovimientoCliente(m);
        WriteLn;
        DestruirMovimientoCliente(m);



        f:=CrearFecha("20110508");
        ta.num:=55;
        ta.clase:=TURISTA;
        idlinea:="LineaTurista";
        dur:=10;
        estado:=M_MULTA;
        m:=CrearMovimientoCliente(idlinea, f, ta, dur, estado);

        ta:=ObtenerAsientoMovimientoCliente(m);
        rasiento:=ta.num;
        casiento:=ta.clase;

        IF(casiento = TURISTA)
        THEN WriteStringLn("9 - [OK]")
        ELSE WriteStringLn("9 - [ERROR:clase asiento incorrecta]")
        END;

        IF(rasiento = 55)
        THEN WriteStringLn("10 - [OK]")
        ELSE WriteStringLn("10 - [ERROR:numero asiento incorrecta]")
        END;

        FechaToString(ObtenerFechaMovimientoCliente(m), fstr);
        IF(Equal(fstr, "20110508"))
        THEN WriteStringLn("11 - [OK]")
        ELSE WriteStringLn("11 - [ERROR:fecha incorrecta]")
        END;

        IF(Equal(ObtenerIdLineaMovimientoCliente(m), "LineaTurista"))
        THEN WriteStringLn("12 - [OK]")
        ELSE WriteStringLn("12 - [ERROR:idLinea incorrecta]")
        END;

        IF(ObtenerEstadoMovimientoCliente(m) = M_MULTA)
        THEN WriteStringLn("13 - [OK]")
        ELSE WriteStringLn("13 - [ERROR:estado incorrecto]")
        END;

        CambiarEstadoMovimientoCliente(M_MULTA, m);
        IF(ObtenerEstadoMovimientoCliente(m) = M_MULTA)
        THEN WriteStringLn("14 - [OK]")
        ELSE WriteStringLn("14 - [ERROR:estado incorrecto]")
        END;

        CambiarEstadoMovimientoCliente(M_RESERVA, m);
        IF(ObtenerEstadoMovimientoCliente(m) = M_RESERVA)
        THEN WriteStringLn("15 - [OK]")
        ELSE WriteStringLn("15 - [ERROR:estado incorrecto]")
        END;

        CambiarEstadoMovimientoCliente(M_CANCELA, m);
        IF(ObtenerEstadoMovimientoCliente(m) = M_CANCELA)
        THEN WriteStringLn("16 - [OK]")
        ELSE WriteStringLn("16 - [ERROR:estado incorrecto]")
        END;
        WriteLn;

        WriteStringLn("ImprimirMovimientoCliente: ");
        ImprimirMovimientoCliente(m);
        WriteLn;

        DestruirMovimientoCliente(m);

END PruebaMovimientoCliente.
