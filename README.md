# XOJO JQAssistant Plugin

## Overview

JQAssistant Plugin for parsing XOJO:
- [request for XOJOs grammar](https://forum.xojo.com/t/need-official-xojo-grammar-specification/65549)to parse it properly (and don't reverse engineer )
 
### Possible use cases:
- understand XOJO projects better
- measure XOJO_Project to find shortcomings in code quality
- learn a lot about grammars / parsing / interpreting programming languages along the way

### What is JQAssistant
A helpful tool to create a database from all software artifacts like files, source code, etc.
[See here](https://github.com/jQAssistant/awesome-jqassistant)

### What is ANTLR

A parser generator using language like specifications, so called "grammars".

## Getting Started

### Prerequisites

#### Programming Languages Tools

- [Java (17)](https://openjdk.java.net/)
- [Maven](https://maven.apache.org/download.cgi)11
- [Antlr4](https://www.antlr.org/)

Later: 

- [JQAssistant](https://jqassistant.org/)

#### Build the project
This project is built with maven. You should install maven on your operating system to be able to build the project. 
Use 'mvn -install' in the root directory of the project (the project's POM file is located there). This will install a jar of this project in your local maven repository.
After a successful building process it will generate a jar file in the "target" folder, containing the compiled classes.

## Software architecture

TBA

## Usage 

Currently, there is only a small class called ArrayInit which is a java main class.
It will start a JVM, reading in text using STDIN, trying to parse anf if successful showing the AST in List-like syntax ([postfix notation](https://en.wikipedia.org/wiki/Polish_notation)).
		
## Developer info

The project is just setup. Contribution will be walcomed! 

## Colophon		

### License 

The project is licensed under terms of the [Apache License 2.0](http://www.apache.org/licenses/LICENSE-2.0.html).