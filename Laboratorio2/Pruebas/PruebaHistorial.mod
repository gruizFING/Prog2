MODULE PruebaHistorial;
(*******************************************************************************
        Módulo PruebaHistorial.

        Laboratorio de Programación 2.
        InCo-FI-UDELAR
*******************************************************************************)

FROM Historial IMPORT Historial;
FROM STextIO IMPORT WriteString, WriteLn;

FROM Historial IMPORT CrearHistorial, AgregarMovimientoHistorial,
        EsVacioHistorial, ObtenerPrimerMovimientoHistorial,
        ObtenerRestoHistorial, ImprimirHistorial, DestruirHistorial;
FROM MovimientoCliente IMPORT MovimientoCliente, TEstadoMovimiento,
        CrearMovimientoCliente, ObtenerIdLineaMovimientoCliente;
FROM Avion IMPORT TClaseAsiento, TAsiento;
FROM Fecha IMPORT Fecha, CrearFecha;
FROM Strings IMPORT Equal;

PROCEDURE WriteStringLn(str: ARRAY OF CHAR);
BEGIN
        WriteString(str);WriteLn
END WriteStringLn;

PROCEDURE TamHistorial(h: Historial):INTEGER;
VAR tam:INTEGER;
BEGIN
        tam:=0;
        WHILE(NOT EsVacioHistorial(h)) DO
                h:=ObtenerRestoHistorial(h);
                tam:=tam+1
        END;
        RETURN tam
END TamHistorial;

PROCEDURE ObtenerMovimientoHistorial(ind:INTEGER; 
                                     h:Historial):MovimientoCliente;
(*PRE: el historial tiene al menos ind movimientos*)
VAR i:INTEGER;
BEGIN
        i:=1;
        WHILE(i < ind) DO
                h:=ObtenerRestoHistorial(h);
                i:=i+1
        END;
        RETURN ObtenerPrimerMovimientoHistorial(h)
END ObtenerMovimientoHistorial;

VAR
        h: Historial;
        m: MovimientoCliente;
        ta: TAsiento;
        f: Fecha;
        i, j: INTEGER;
BEGIN

        WriteStringLn("*************************************");
        WriteStringLn("**********Prueba Historial***********");
        WriteStringLn("*************************************");

        WriteStringLn("Nro. Control - Resultado");
        WriteStringLn("------------------------");

        h:=CrearHistorial();
        IF(TamHistorial(h) = 0)
        THEN WriteStringLn("1 - [OK]")
        ELSE WriteStringLn("1 - [ERROR:tam historial incorrecto]")
        END;
        
        f:=CrearFecha("20100408");
        ta.num:=1;ta.clase:=PRIMERA;
        m:=CrearMovimientoCliente("linea1", f, ta, 1, M_COMPRA);
        AgregarMovimientoHistorial(m, h);
        IF(TamHistorial(h) = 1)
        THEN WriteStringLn("2 - [OK]")
        ELSE WriteStringLn("2 - [ERROR:tam historial incorrecto]")
        END;
        
        ta.num:=2;ta.clase:=TURISTA;
        m:=CrearMovimientoCliente("linea2", f, ta, 2, M_RESERVA);
        AgregarMovimientoHistorial(m, h);
        IF(TamHistorial(h) = 2)
        THEN WriteStringLn("3 - [OK]")
        ELSE WriteStringLn("3 - [ERROR:tam historial incorrecto]")
        END;
        
        ta.num:=3;ta.clase:=PRIMERA;
        m:=CrearMovimientoCliente("linea3", f, ta, 3, M_CANCELA);
        AgregarMovimientoHistorial(m, h);
        IF(TamHistorial(h) = 3)
        THEN WriteStringLn("4 - [OK]")
        ELSE WriteStringLn("4 - [ERROR:tam historial incorrecto]")
        END;
        
        ta.num:=4;ta.clase:=TURISTA;
        m:=CrearMovimientoCliente("linea4", f, ta, 4, M_MULTA);
        AgregarMovimientoHistorial(m, h);
        IF(TamHistorial(h) = 4)
        THEN WriteStringLn("5 - [OK]")
        ELSE WriteStringLn("5 - [ERROR:tam historial incorrecto]")
        END;

        m:=ObtenerMovimientoHistorial(4,h);
        IF(Equal(ObtenerIdLineaMovimientoCliente(m), "linea4"))
        THEN WriteStringLn("6 - [OK]")
        ELSE WriteStringLn("6 - [ERROR:orden historial incorrecto]")
        END;
 
        m:=ObtenerMovimientoHistorial(2,h);
        IF(Equal(ObtenerIdLineaMovimientoCliente(m), "linea2"))
        THEN WriteStringLn("7 - [OK]")
        ELSE WriteStringLn("7 - [ERROR:orden historial incorrecto]")
        END;

        m:=ObtenerMovimientoHistorial(1,h);
        IF(Equal(ObtenerIdLineaMovimientoCliente(m), "linea1"))
        THEN WriteStringLn("8 - [OK]")
        ELSE WriteStringLn("8 - [ERROR:orden historial incorrecto]")
        END;

        m:=ObtenerMovimientoHistorial(3,h);
        IF(Equal(ObtenerIdLineaMovimientoCliente(m), "linea3"))
        THEN WriteStringLn("9 - [OK]")
        ELSE WriteStringLn("9 - [ERROR:orden historial incorrecto]")
        END;
        
        WriteLn;
        WriteStringLn("ImprimirHistorial: ");
        ImprimirHistorial(h);
        WriteLn;

        DestruirHistorial(h);


        WriteString("Manejo de Memoria (puede demorar algunos minutos) ... ");
        FOR i:=1 TO 100000 DO
                h:=CrearHistorial();
                FOR j:= 1 TO 100 DO
                        m:=CrearMovimientoCliente("linea", f, ta, 1, M_COMPRA);
                        AgregarMovimientoHistorial(m, h)
                END;
                DestruirHistorial(h)
        END;
        WriteStringLn("[OK]")

END PruebaHistorial.
