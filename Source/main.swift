import Foundation
import Glibc

var dir = "/home/guillermo/Escritorio/";
var archivo = "tokens.ori";
var ruta = dir.stringByAppendingPathComponent(archivo);

guard let archivoTokens = try? String(contentsOfFile: ruta, encoding: NSUTF8StringEncoding) else {
    // la condicion guard requiere una salida cuando la condicion no se satisface
    //Tambien puedes usar `return` si esta dentro de la funcion \t si no es por expresion
    fatalError("fallo al leer archivoTokens desde el archivo")
}

// ahora archivoTokens es un NSString normal no-nulo
//separa por salto de linea los tokens a ingresar
var lineasArchivoTokens:[String] = archivoTokens.componentsSeparatedByString("\n");

//arreglos de las propiedades del lexico
var TOKENS:[String] = [String]();
var PATRONES:[String] = [String]();
var NOMBRES:[String] = [String]();
var LEXEMAS:[String] = [String]()

var count = lineasArchivoTokens.count-1;
for index in 0..<count{
    var listmp:[String] = (lineasArchivoTokens[index]).componentsSeparatedByString(" ");
    PATRONES.append(listmp[1]);
    NOMBRES.append(listmp[0]);
}

archivo = "lexico.ori";
ruta = dir.stringByAppendingPathComponent(archivo);

guard var archivoCodigoFuente = try? String(contentsOfFile: ruta, encoding: NSUTF8StringEncoding) else {
	fatalError("falla al leer archivoCodigoFuente desde el archivo")
}

let sep = ["{","}","[","]","(",")","+","-","/","*","=","<",">","%","^","!","'","|","~","?","&",":","\\s","\\t"]
let sep2 = [" =  = "," <  = "," =  > "," !  = "," <  > "," '  ' "," &  & ", " (  ) "," {  } "," [  ] "]
for s in sep{
  archivoCodigoFuente = archivoCodigoFuente.stringByReplacingOccurrencesOfString(s, withString: " \(s) ", options: NSStringCompareOptions.LiteralSearch, range: nil)
}
for s in sep2{
  let a1=String(s.characters[s.startIndex.advancedBy(1)]) + String(s.characters[s.startIndex.advancedBy(4)])
  archivoCodigoFuente = archivoCodigoFuente.stringByReplacingOccurrencesOfString(s, withString: " \(a1) ", options: NSStringCompareOptions.LiteralSearch, range: nil)
}

var lineasArchivoCodigoFuente:[String] = archivoCodigoFuente.componentsSeparatedByString("\n");

count = lineasArchivoCodigoFuente.count-1;
for index in 0..<count{
    if lineasArchivoCodigoFuente[index] != "" {
        let listmp:[String] = (lineasArchivoCodigoFuente[index]).componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString:" \t"));
        for palabra in listmp {
            if palabra != " " {
                LEXEMAS.append(palabra);
            }
        }
    }
}

var countL = LEXEMAS.count;
var countP = PATRONES.count;
for indexL in 0..<countL {
    var input:NSString = NSString(string: LEXEMAS[indexL]);
    var range:NSRange = NSMakeRange(0, input.length)
    TOKENS.append("no existe");
    var matches:[NSTextCheckingResult]=[]

    for indexP in 0..<countP {
        var regex = try? NSRegularExpression(pattern: PATRONES[indexP], options: NSRegularExpressionOptions(rawValue: 0))
        matches = regex!.matchesInString(LEXEMAS[indexL], options: NSMatchingOptions(rawValue: 0), range: range)

        if matches.count > 0 {
            TOKENS[indexL] = NOMBRES[indexP];
            print("num Token:", indexP, "|Token: " + NOMBRES[indexP] + " |Nombre: " + String(input));
            break;
        }
    }
    if matches.count == 0{
      print("no existe", String(input))
    }
  }


class Syntax {
let tokens: [String]
	var currentToken: Int
	init (_ tokens:[String]) {
		self.tokens = tokens
		currentToken = 0
	}
  func Get_Next_Token(){
		currentToken++
		
		if currentToken == self.tokens.count {
			currentToken = 0
		}
	}
  func Constant_Declaration() {
  if tokens[currentToken] == "Identificador" {
    Get_Next_Token()
    if tokens[currentToken] == "llavesizq" {
      Get_Next_Token()
      if tokens[currentToken] == "tipo_de_dato" {
        Get_Next_Token()
       if tokens[currentToken] == "asignacion" {
         Get_Next_Token()
       if tokens[currentToken] == "digito" {
         Get_Next_Token()
         if tokens[currentToken] == "llavesder" {
           Get_Next_Token()
         }
         else {
           print ("Se esperaba digito")
         }
       }
       else {
         print ("Se esperaba =")
       }
    }
    else {
      print ("Se esperaba un dato")
    }
  }
  else {
    print ("Se esperaba llavesizq")
  }
}
else {
  print ("Se esperaba un Identificador")
}
}
else {
  print ("Se esperaba llave der")
}
}

func Variable_Declaration() -> Bool {
    if tokens[currentToken] == "Identificador" {
        Get_Next_Token()
        if tokens[currentToken] == "parizq" {
            Get_Next_Token()
            if tokens[currentToken] == "tipo_de_dato" {
                Get_Next_Token()
                if tokens[currentToken] == "parder" {
                    Get_Next_Token()
                    return true
                }
                else {
                    return false
                }
            }
            else {
                return false
            }
        }
        else {
            return false
        }
    }
    else {
        return false
    }
}
}

var synal = Syntax(TOKENS)
synal.Constant_Declaration()
