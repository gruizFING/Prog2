(*4317743 4585215*)
IMPLEMENTATION MODULE Fecha;
(*******************************************************************************
Modulo de implementacion de Fecha.

Laboratorio de Programacion 2.
InCo-FI-UDELAR
*******************************************************************************)

FROM Storage IMPORT ALLOCATE,DEALLOCATE;



TYPE
	Fecha = POINTER TO TFecha;
	TFecha = RECORD
		dia,mes,anio: CARDINAL;
	END;
		
PROCEDURE CrearFechaNula (): Fecha;
BEGIN
	RETURN NIL
END CrearFechaNula;



PROCEDURE CrearFecha (s: ARRAY OF CHAR): Fecha;
VAR
	f: Fecha;
	anio,mes,dia: CARDINAL;
BEGIN
	anio := (ORD(s[0]) - ORD('0')) * 1000;
	anio := anio + ((ORD(s[1]) - ORD('0')) * 100 );
	anio := anio + ((ORD(s[2]) - ORD('0')) * 10);
	anio := anio + (ORD(s[3]) - ORD('0'));
	
	mes := (ORD(s[4]) - ORD('0')) * 10;
	mes := mes + (ORD(s[5]) - ORD('0'));
	
	dia := (ORD(s[6]) - ORD('0')) * 10;
	dia := dia + (ORD(s[7]) - ORD('0'));
	
	NEW(f);
	f^.dia := dia;
	f^.mes := mes;
	f^.anio := anio;
	
	RETURN(f);
END CrearFecha;



PROCEDURE IncFecha (VAR f: Fecha);
TYPE
      TMes     = [0 .. 12];
      TDia     = [1 .. 31];
VAR
      mes: TMes;
      dia: TDia;
      anio : CARDINAL;
BEGIN
	dia := ObtenerDiaFecha(f);
	mes := ObtenerMesFecha(f);
	anio := ObtenerAnioFecha(f);
	IF (dia = 31) THEN
		CASE mes OF
			1,3,5,7,8,10 : dia := 1;
			               mes := mes + 1 |
			12 : dia := 1;
			     mes := 1;
			     anio := anio + 1
		END;
	ELSIF (dia = 30) THEN
		CASE mes OF
			4,6,9,11 : dia := 1;
			           mes := mes + 1 |
		        1,3,5,7,8,10,12 : dia := 31
		END;
	ELSIF (dia = 29) THEN
		IF (mes = 2) THEN
			dia := 1;
			mes := 3
		ELSE
			dia := 30
		END;
	ELSIF (dia = 28) AND (mes = 2) THEN
		IF (EsBisiestoAnioFecha(f)) THEN
			dia := 29;
		ELSE
			dia := 1;
			mes := 3;
		END;
	ELSE
		dia := dia + 1;
	END;
	f^.dia := dia;
	f^.mes := mes;
	f^.anio := anio
END IncFecha;




PROCEDURE DecFecha (VAR f: Fecha);
TYPE
      TMes     = [0 .. 12];
      TDia     = [1 .. 31];
VAR
      mes: TMes;
      dia: TDia;
      anio : CARDINAL;
BEGIN
	dia := ObtenerDiaFecha(f);
	mes := ObtenerMesFecha(f);
	anio := ObtenerAnioFecha(f);
	IF dia = 1 THEN
		CASE mes OF
			1 : dia := 31;
			    mes := 12;
			    anio := anio - 1|
			2,4,6,8,10,12 : dia := 31;
					mes := mes - 1|
			3 : mes := 2;
			    IF EsBisiestoAnioFecha(f) THEN
			    	dia := 29
			    ELSE
			    	dia := 28
			    END|   	
		        5,7,9,11 : dia := 30;
				   mes := mes - 1
		END
	ELSE
		dia := dia - 1
	END;
	f^.dia := dia;
	f^.mes := mes;
	f^.anio := anio
END DecFecha;



PROCEDURE CopiaFecha (f: Fecha): Fecha;
VAR
	f2 : Fecha;
BEGIN
	NEW(f2);
	f2^.dia := f^.dia;
	f2^.mes := f^.mes;
	f2^.anio := f^.anio;
	RETURN f2
END CopiaFecha;

PROCEDURE ObtenerDiaFecha (f: Fecha): CARDINAL;
BEGIN
	RETURN (f^.dia)
END ObtenerDiaFecha;

PROCEDURE ObtenerMesFecha (f: Fecha): CARDINAL;
BEGIN
	RETURN (f^.mes)
END ObtenerMesFecha;

PROCEDURE ObtenerAnioFecha (f: Fecha): CARDINAL;
BEGIN
	RETURN (f^.anio)
END ObtenerAnioFecha;
	
	
(*************CODIGO IMPLEMENTADO POR LOS DOCENTES*************)

PROCEDURE DiaSemanaFecha (f: Fecha): TDiaSemana;   
CONST
      (* se asume que la fecha es posterior a 20001231 *)
      ANIO_UNO = 2001;  
      DIA_CERO = 0; (* dia de semana del 20001231, 0 = domingo *)
TYPE
      TMes     = [0 .. 12];
      TDia     = [1 .. 31];
      TDiaAnio = [0 .. 366];
VAR 
      diasMes: ARRAY TMes OF TDiaAnio; 
      anio, cantAnios, cantBisiestos: CARDINAL;
      mes: TMes;
      dia: TDia;
      diasDesdeAnio: TDiaAnio; 
      diasDesdeInicio: CARDINAL; 
      diaSemana: TDiaSemana; 
        
BEGIN
      dia  := ObtenerDiaFecha (f);
      mes  := ObtenerMesFecha (f);
      anio := ObtenerAnioFecha (f);

      (* cuantos dias del anio pasaron al terminar cada mes*)
      diasMes [0]  := 0;
      diasMes [1]  := diasMes [0]  + 31;
      diasMes [2]  := diasMes [1]  + 28; 
      diasMes [3]  := diasMes [2]  + 31;
      diasMes [4]  := diasMes [3]  + 30;
      diasMes [5]  := diasMes [4]  + 31;
      diasMes [6]  := diasMes [5]  + 30;
      diasMes [7]  := diasMes [6]  + 31;
      diasMes [8]  := diasMes [7]  + 31;
      diasMes [9]  := diasMes [8]  + 30;
      diasMes [10] := diasMes [9]  + 31;
      diasMes [11] := diasMes [10] + 30;
        

      (* cantidad de anios desde el inicio de la escala *)
      cantAnios := anio - ANIO_UNO;

      (* cantidad de bisiestos desde el inicio de la escala *)
      cantBisiestos := cantAnios DIV 4 - cantAnios DIV 100 + cantAnios DIV 400;                         

      (* cantidad de dias desde el inicio del anio *)
      diasDesdeAnio := diasMes [mes - 1] + dia;

      IF (EsBisiestoAnioFecha (f) AND (mes > 2) ) THEN
         INC (diasDesdeAnio)
      END;                  

      (* cantidad de dias desde el inicio de la escala *)
      diasDesdeInicio := cantAnios * 365 + cantBisiestos +  diasDesdeAnio;
                        

      (* pasar de numero a TDiaSemana *)
      CASE (diasDesdeInicio + DIA_CERO) MOD 7 OF 
              0: diaSemana := DOMINGO    |
              1: diaSemana := LUNES      |
              2: diaSemana := MARTES     |
              3: diaSemana := MIERCOLES  |
              4: diaSemana := JUEVES     |
              5: diaSemana := VIERNES    |
              6: diaSemana := SABADO
      END;
                        
      RETURN diaSemana
                          
END DiaSemanaFecha;
(*************FIN DEL CODIGO IMPLEMENTADO POR LOS DOCENTES*************)



PROCEDURE FechaToString (f: Fecha; VAR s: ARRAY OF CHAR);
TYPE
      TMes     = [1 .. 12];
      TDia     = [1 .. 31];
VAR
      mes: TMes;
      dia: TDia;
      anio,aux : CARDINAL;

BEGIN
	dia := ObtenerDiaFecha(f);
	mes := ObtenerMesFecha(f);
	anio := ObtenerAnioFecha(f);
	s[0] := CHR(anio DIV 1000 + ORD('0'));
	aux := anio DIV 100;
	aux := aux MOD 10;
	s[1] := CHR(aux + ORD('0'));
	aux := anio DIV 10;
	aux := aux MOD 10;
	s[2] := CHR(aux + ORD('0'));
	s[3] := CHR(anio MOD 10 + ORD('0'));
	IF mes >= 10 THEN
		s[4] := CHR(1 + ORD('0'));	
		s[5] := CHR(mes MOD 10 + ORD('0'))
	ELSE
		s[4] := CHR(ORD('0'));
		s[5] := CHR(mes + ORD('0'))
	END;
  	IF dia >= 10 THEN
		s[6] := CHR(dia DIV 10 + ORD('0'));	
		s[7] := CHR(dia MOD 10 + ORD('0'))
	ELSE
		s[6] := CHR(ORD('0'));
		s[7] := CHR(dia + ORD('0'))
	END
	
END FechaToString;




PROCEDURE EsNulaFecha (f: Fecha): BOOLEAN;
BEGIN
	RETURN (f = NIL);
END EsNulaFecha;



PROCEDURE IgualesFecha (fch1, fch2: Fecha): BOOLEAN;
BEGIN
	IF (fch1^.anio = fch2^.anio) THEN
		IF (fch1^.mes = fch2^.mes) THEN
			IF (fch1^.dia = fch2^.dia) THEN
				RETURN TRUE;
			ELSE
				RETURN FALSE
			END
		ELSE
			RETURN FALSE
		END
	ELSE
		RETURN FALSE
	END
END IgualesFecha;


PROCEDURE EsMayorFecha (fch1, fch2: Fecha): BOOLEAN;
BEGIN
	IF fch1^.anio > fch2^.anio THEN
		RETURN TRUE
	ELSIF fch1^.anio = fch2^.anio THEN
		IF fch1^.mes > fch2^.mes THEN
			RETURN TRUE
		ELSIF fch1^.mes = fch2^.mes THEN
			IF fch1^.dia > fch2^.dia THEN
				RETURN TRUE
			ELSE
				RETURN FALSE
			END
		ELSE
			RETURN FALSE
		END
	ELSE
		RETURN FALSE
	END	
END EsMayorFecha;
	
PROCEDURE EsMenorFecha (fch1, fch2: Fecha): BOOLEAN;
BEGIN
	
	IF fch1^.anio < fch2^.anio THEN
		RETURN TRUE
	ELSIF fch1^.anio = fch2^.anio THEN
		IF fch1^.mes < fch2^.mes THEN
			RETURN TRUE
		ELSIF fch1^.mes = fch2^.mes THEN
			IF fch1^.dia < fch2^.dia THEN
				RETURN TRUE
			ELSE
				RETURN FALSE
			END
		ELSE
			RETURN FALSE
		END
	ELSE
		RETURN FALSE
	END
END EsMenorFecha;



PROCEDURE EsBisiestoAnioFecha (f: Fecha): BOOLEAN;
BEGIN
	IF (f^.anio MOD 4 = 0) AND ((f^.anio MOD 100 <> 0) OR
	                             (f^.anio MOD 400 = 0)) THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END;
END EsBisiestoAnioFecha;


PROCEDURE DestruirFecha (VAR f: Fecha);
BEGIN
	IF f <> NIL THEN
		DISPOSE(f);
		f := NIL
	END
END DestruirFecha;


END Fecha.