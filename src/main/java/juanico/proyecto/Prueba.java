/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package juanico.proyecto;

/**
 *
 * @author jlopezg8
 */
public class Prueba {
    public static void main(String[] args) throws Exception {
        AnalizadorSintactico as = AnalizadorSintactico.newInstance(
            "ejemplo/fuente.txt"
        );
        System.out.println(as.getTokens());
        as.generarXML("ejemplo/arbol.xml");
    }
}
