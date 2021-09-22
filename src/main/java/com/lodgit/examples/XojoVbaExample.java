package com.lodgit.examples;

/***
 * Excerpted from "The Definitive ANTLR 4 Reference",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/tpantlr2 for more book information.
***/
// import ANTLR's runtime libraries
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;

public class XojoVbaExample {
    public static void main(String[] args) throws Exception {
        // create a CharStream that reads from standard input
        ANTLRInputStream input = new ANTLRInputStream(XojoVbaExample.class.getResourceAsStream("/mJsonSupport/cJsonSupport.xojo_code"));

        // create a lexer that feeds off of input CharStream
        vbaLexer lexer = new vbaLexer(input);

        // create a buffer of tokens pulled from the lexer
        CommonTokenStream tokens = new CommonTokenStream(lexer);

        // create a parser that feeds off the tokens buffer
        vbaParser parser = new vbaParser(tokens);

        ParseTree tree = parser.startRule(); // begin parsing at init rule
        System.out.println(tree.toStringTree(parser)); // print LISP-style tree
        
   
    }
}
