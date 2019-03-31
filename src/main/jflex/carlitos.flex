/* Especificación léxica JFlex del lenguaje Carlitos. */
package juanico.proyecto;

import java.io.IOException;
import java.io.Reader;
import java.util.ArrayList;
import java.util.List;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ComplexSymbolFactory.Location;
import java_cup.runtime.Symbol;

/**
 *
 * @author jlopezg8
 */
%%

%public
%class AnalizadorLexico
%unicode
%cup
%char
%line
%column

%{
    ComplexSymbolFactory csf;
    StringBuilder s = new StringBuilder();
    List<String> tokens = new ArrayList<>();

    public AnalizadorLexico(Reader in, ComplexSymbolFactory csf) {
	this(in);
	this.csf = csf;
    }

    private Symbol sim(int tipo) {
        tokens.add(sym.terminalNames[tipo]);
        return csf.newSymbol(
            sym.terminalNames[tipo], tipo,
            new Location(yyline + 1, yycolumn + 1, yychar),
            new Location(
                yyline + 1, yycolumn + yylength(), yychar + yylength()
            )
        );
    }

    private Symbol sim(int tipo, Object valor) {
        tokens.add(sym.terminalNames[tipo] + ": " + valor);
        return csf.newSymbol(
            sym.terminalNames[tipo], tipo,
            new Location(yyline + 1, yycolumn + 1, yychar),
            new Location(
                yyline + 1, yycolumn + yylength(), yylength() + yychar
            ), valor
        );
    }

    public List<String> getTokens() {
        return tokens;
    }
%}

%eofval{
    return sim(sym.EOF);
%eofval}


EspacioEnBlanco = [\r\n \t\f]
Id = [:jletter:][:jletterdigit:]*

%state ER, CADENA

%%

<YYINITIAL> {
    {EspacioEnBlanco} {}

    "Inicio" { return sim(sym.Inicio); }
    "AutomataFinito" { return sim(sym.AutomataFinito); }
    "AutomataPila" { return sim(sym.AutomataPila); }
    "MaquinaTuring" { return sim(sym.MaquinaTuring); }
    "agregar_estado" { return sim(sym.agregar_estado); }
    "editar_estado" { return sim(sym.editar_estado); }
    "eliminar_estado" { return sim(sym.eliminar_estado); }
    "agregar_sim_entrada" { return sim(sym.agregar_sim_entrada); }
    "editar_sim_entrada" { return sim(sym.editar_sim_entrada); }
    "eliminar_sim_entrada" { return sim(sym.eliminar_sim_entrada); }
    "agregar_trans_af" { return sim(sym.agregar_trans_af); }
    "eliminar_trans_af" { return sim(sym.eliminar_trans_af); }
    "establecer_estado_ini" { return sim(sym.establecer_estado_ini); }
    "agregar_estado_acept" { return sim(sym.agregar_estado_acept); }
    "eliminar_estado_acept" { return sim(sym.eliminar_estado_acept); }
    "agregar_sim_pila" { return sim(sym.agregar_sim_pila); }
    "eliminar_sim_pila" { return sim(sym.eliminar_sim_pila); }
    "agregar_trans_ap" { return sim(sym.agregar_trans_ap); }
    "eliminar_trans_ap" { return sim(sym.eliminar_trans_ap); }
    "establecer_sim_ini_pila" { return sim(sym.establecer_sim_ini_pila); }
    "agregar_sim_cinta" { return sim(sym.agregar_sim_cinta); }
    "eliminar_sim_cinta" { return sim(sym.eliminar_sim_cinta); }
    "establecer_sim_blanco" { return sim(sym.establecer_sim_blanco); }
    "agregar_trans_mt" { return sim(sym.agregar_trans_mt); }
    "eliminar_trans_mt" { return sim(sym.eliminar_trans_mt); }
    "er_a_af" { return sim(sym.er_a_af); }
    "no_det_a_det" { return sim(sym.no_det_a_det); }
    "minimizar_af" { return sim(sym.minimizar_af); }
    "union" { return sim(sym.union); }
    "interseccion" { return sim(sym.interseccion); }
    "complemento" { return sim(sym.complemento); }
    "diferencia" { return sim(sym.diferencia); }
    "reverso" { return sim(sym.reverso); }
    "graficar" { return sim(sym.graficar); }
    "probar" { return sim(sym.probar); }
    "Fin" { return sim(sym.Fin); }

    "=" { return sim(sym.OP_ASIGN); }
    "/" { yybegin(ER); return sim(sym.INICIO_ER); }
    ";" { return sim(sym.FIN_SENTENCIA); }
    "(" { return sim(sym.INICIO_ARGS); }
    ")" { return sim(sym.FIN_ARGS); }
    "[" { return sim(sym.INICIO_LISTA); }
    "]" { return sim(sym.FIN_LISTA); }
    \" { s.setLength(0); yybegin(CADENA); }
    "," { return sim(sym.COMA); }
    "e" { return sim(sym.EPSILON); }
    "I" { return sim(sym.MOV_IZQ); }
    "D" { return sim(sym.MOV_DER); }
    {Id} { return sim(sym.Id, yytext()); }
}

<ER> {
    "/" { yybegin(YYINITIAL); return sim(sym.FIN_ER); }
    [:jletterdigit:] { return sim(sym.ALFANUM, yytext()); }
    \| { return sim(sym.OP_UNION_ER); }
    \? { return sim(sym.CUANTIFICADOR_01_ER); }
    \* { return sim(sym.CUANTIFICADOR_0M_ER); }
    \+ { return sim(sym.CUANTIFICADOR_1M_ER); }
    "(" { return sim(sym.PAREN_IZQ); }
    ")" { return sim(sym.PAREN_DER); }
}

<CADENA> {
    \" { yybegin(YYINITIAL); return sim(sym.CADENA, s.toString()); }
    [^\"]+ { s.append(yytext()); }
}

[^] {
    throw new IOException(
        "Caracter ilegal <" + yytext() + "> en " + (yyline + 1) + ":"
            + (yycolumn + 1)
    );
}
