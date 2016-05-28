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

let separadores = NSCharacterSet(charactersInString: "\n")

var fileArray = archivoCodigoFuente.componentsSeparatedByCharactersInSet(separadores)
let nonempty = fileArray.filter { (x) -> Bool in !x.isEmpty}

/**let sep = ["{","}","[","]","(",")","+","-","/","*","=","<",">","%","^","!","|","~","?","&",":","\\s","\\t"]
let sep2 = [" =  = "," <  = "," =  > "," !  = "," <  > "," '  ' "," &  & ", " (  ) "," {  } "," [  ] "]
for s in sep{
  archivoCodigoFuente = archivoCodigoFuente.stringByReplacingOccurrencesOfString(s, withString: " \(s) ", options: NSStringCompareOptions.LiteralSearch, range: nil)
}
for s in sep2{
  let a1=String(s.characters[s.startIndex.advancedBy(1)]) + String(s.characters[s.startIndex.advancedBy(4)])
  archivoCodigoFuente = archivoCodigoFuente.stringByReplacingOccurrencesOfString(s, withString: " \(a1) ", options: NSStringCompareOptions.LiteralSearch, range: nil)
}**/

var lineasArchivoCodigoFuente:[String] = archivoCodigoFuente.componentsSeparatedByString("\n");

count = lineasArchivoCodigoFuente.count-1;
for index in 0..<count{
    if lineasArchivoCodigoFuente[index] != "" {
        let listmp:[String] = (lineasArchivoCodigoFuente[index]).componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString:" \t"));
        for palabra in listmp {
            if palabra != " " {
                LEXEMAS.append(palabra);
                /**sep = sep.filter(!$0.isEmpty) //referencia a cada uno de los strings que esta adentro ($0)
                sep2 = sep2.filter(!$0.isEmpty)**/
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
            //print("num Token:", indexP, "|Token: " + NOMBRES[indexP] + " |Nombre: " + String(input));
            break;
        }
    }
    //if matches.count == 0{
    //  print("no existe", String(input))
    //}
  }

class Syntax {
  let tokens: [String]
  	var currentToken: Int
  	init (_ tokens:[String]) {
  		self.tokens = tokens
  		currentToken = 0
  	}
    func Get_Next_Token() -> Bool {
  		currentToken++
  		if currentToken == self.tokens.count {
  			currentToken = 0
        return true
  		}
      return false
  	}
  func DeclararIprograma() -> Bool {
    if tokens[currentToken] == "IPrograma" {
      Get_Next_Token()
      return true
    }
    else{
      print("No se localiza el inicio del programa")
      return false
    }
  }
  func Declararimp() -> Bool{
    if tokens[currentToken] == "impresion"{
    Get_Next_Token()
      if tokens[currentToken] == "parizq"{
        Get_Next_Token()
          if tokens[currentToken] == "Identificador"{
            Get_Next_Token()
              if tokens[currentToken] == "parder"{
                Get_Next_Token()
                return true
              }
              else{
                print("Se esperaba )")
                return false
              }
            }
            else{
              print ("Se esperaba un Identificador")
              return false
            }
          }
          else{
            print ("Se esperaba (")
            return false
          }
        }
        else{
          print ("Se esperaba la palabra display")
          return false
        }
      }
  func Declaracion_Constante() -> Bool {
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
           return true
         }
         else {
           print ("Se esperaba llave derecha")
           return false
         }
       }
       else {
         print ("Se esperaba digito")
         return false
       }
    }
    else {
      print ("Se esperaba un =")
      return false
    }
  }
  else {
    print ("Se esperaba tipo de dato")
    return false
  }
}
else {
  print ("Se esperaba un llave izquierda")
  return false
}
}
else {
  print ("Se esperaba Identificador")
  return false
}
}

func Declaracion_Variable() -> Bool{
    if tokens[currentToken] == "declaracion" {
        Get_Next_Token()
        if tokens[currentToken] == "parizq" {
            Get_Next_Token()
            if tokens[currentToken] == "Identificador" {
                Get_Next_Token()
                if tokens[currentToken] == "parder" {
                  Get_Next_Token()
                if tokens[currentToken] == "llamarvar" {
                    Get_Next_Token()
                    if tokens[currentToken] == "tipo_de_dato" {
                      Get_Next_Token()
                      return true
                }
                else {
                    print("Se esperaba un tipo de dato")
                    return false
                }
            }
            else {
                print("Se esperaba la llamada de la variable (:) ")
                return false
            }
        }
        else {
            print("Se esperaba parentesis derecho")
            return false
        }
    }
    else {
        print("Se esperaba Identificador")
        return false
    }
}
else {
  print("Se esperaba parentesis izquierdo")
  return false
}
}
else{
  print("Se esperaba declaracion")
  return false
}
}
func Declarar_Arreglo() -> Bool{
  if tokens[currentToken] == "arreglo"{
    Get_Next_Token()
      if tokens[currentToken] == "tipo_de_dato"{
        Get_Next_Token()
          if tokens[currentToken] == "Identificador"{
            Get_Next_Token()
              if tokens[currentToken] == "corchizq"{
                Get_Next_Token()
                  if tokens[currentToken] == "digito"{
                    Get_Next_Token()
                      if tokens[currentToken] == "corchder"{
                        Get_Next_Token()
                        return true
                      }
                      else {
                        print ("Se esperaba un ]")
                        return false
                      }
                    }
                    else {
                      print ("Se esperaba un digito")
                      return false
                    }
                  }
                  else{
                    print ("Se esperaba [")
                    return false
                  }
                }
                else{
                  print ("Se esperaba un Identificador")
                  return false
                }
              }
              else{
                print ("Se esperaba un tipo de dato")
                return false
              }
            }
            else{
              print ("Se esperaba la palabra args")
              return false
            }
          }

func OperMate() -> Bool{
  if tokens[currentToken] == "inimate"{
    Get_Next_Token()
    if tokens[currentToken] == "Identificador"{
      Get_Next_Token()
        if tokens[currentToken] == "op_ar"{
          Get_Next_Token()
            if tokens[currentToken] == "Identificador"{
              Get_Next_Token()
              return true
            }
            else {
              print ("Se esperaba Identificador")
              return false
            }
          }
            else {
              print ("Se esperaba un operador aritmetico")
              return false
            }
          }
            else {
              print ("Se esperaba un Identificador")
              return false
            }
          }
            else {
              print ("Se esperaba la palabra dm")
              return false
            }
          }

 func DeclararPila() -> Bool{
      if tokens[currentToken] == "apilar"{
        Get_Next_Token()
        if tokens[currentToken] == "corchizq"{
          Get_Next_Token()
          if tokens[currentToken] == "Identificador"{
            Get_Next_Token()
            if tokens[currentToken] == "corchder"{
              Get_Next_Token()
              return true
                }
                else {
                  print ("Se esperaba un ]")
                  return false
                }
              }
              else {
                print("Se esperaba un Identificador")
                return false
              }
            }
            else{
              print("Se esperaba [")
              return false
            }
          }
          else{
            print("Se esperaba la palabra reservada pileup")
            return false
          }
        }

func consWrt() -> Bool{
    if tokens[currentToken] == "escribir"{
      Get_Next_Token()
      if tokens[currentToken] == "parizq"{
        Get_Next_Token()
        if tokens[currentToken] == "Identificador"{
          Get_Next_Token()
          if tokens[currentToken] == "parder"{
            Get_Next_Token()
            if tokens[currentToken] == "terminal"{
              Get_Next_Token()
              return true
            }
            else {
              print ("Se esperaba la palabra term")
              return false
            }
          }
          else {
            print ("Se esperaba un )")
            return false
          }
        }
        else {
          print ("Se esperaba un Identificador")
          return false
        }
      }
      else {
        print ("Se esperaba un (")
        return false
      }
    }
    else {
      print ("Se esperaba la palabra writein")
      return false
    }
  }

  func consread() -> Bool{
      if tokens[currentToken] == "leer"{
        Get_Next_Token()
        if tokens[currentToken] == "parizq"{
          Get_Next_Token()
          if tokens[currentToken] == "Identificador"{
            Get_Next_Token()
            if tokens[currentToken] == "parder"{
              Get_Next_Token()
              if tokens[currentToken] == "terminal"{
                Get_Next_Token()
                return true
              }
              else {
                print ("Se esperaba la palabra term")
                return false
              }
            }
            else {
              print ("Se esperaba un )")
              return false
            }
          }
          else {
            print ("Se esperaba un Identificador")
            return false
          }
        }
        else {
          print ("Se esperaba un (")
          return false
        }
      }
      else {
        print ("Se esperaba la palabra readin")
        return false
      }
    }

func DeclararTry() -> Bool{
  if tokens[currentToken] == "intento"{
    Get_Next_Token()
    if tokens[currentToken] == "llavesizq"{
      Get_Next_Token()
      if tokens[currentToken] == "llavesder"{
        Get_Next_Token()
        return true
      }
      else{
        print("Se esperaba }")
        return false
      }
    }
      else{
        print("Se esperaba {")
        return false
      }
    }
      else{
        print ("Se esperaba la palabra intento")
        return false
      }
}

func DeclararCatch() -> Bool{
  if tokens[currentToken] == "capturar_excepcion" {
    Get_Next_Token()
      if tokens[currentToken] == "imperror"{
        Get_Next_Token()
          if tokens[currentToken] == "fin_excepcion"{
            Get_Next_Token()
            return true
          }
          else{
            print("Se esperaba la palabra pass")
            return false
          }
        }
          else{
            print("Se esperaba la palabra ImportError")
            return false
          }
        }
          else{
            print("Se esperaba la palabra except")
            return false
          }
        }


func DeclararCola() -> Bool{
  if tokens[currentToken] == "colas"{
    Get_Next_Token()
    if tokens[currentToken] == "corchizq"{
      Get_Next_Token()
      if tokens[currentToken] == "Identificador"{
        Get_Next_Token()
          if tokens[currentToken] == "corchder"{
            Get_Next_Token()
            return true
          }
          else {
            print ("Se esperaba un ]")
            return false
          }
        }
        else {
          print("Se esperaba un Identificador")
          return false
        }
      }
      else{
        print("Se esperaba [")
        return false
      }
    }
    else{
      print("Se esperaba la palabra qv")
      return false
    }
  }
/**  func CicloForeach() -> Bool {
    if tokens[currentToken] == "ciclo" {
      Get_Next_Token()
      if tokens[currentToken] == "Identificador"{
        Get_Next_Token()
        if tokens[currentToken] == "foreach"{
          Get_Next_Token()
          if tokens[currentToken] == "llavesizq"{
            Get_Next_Token()

  }
**/
  func DeclararLib() -> Bool {
    if tokens[currentToken] == "IPrograma"{
      Get_Next_Token()
      if tokens[currentToken] == "libreria"{
        Get_Next_Token()
        if tokens[currentToken] == "Identificador"{
          Get_Next_Token()
          return true
        }
      else{
        print("Se esperaba Identificador")
        return false
      }
    }
    else{
      print("Se esperaba la palabra lib")
      return false
    }
  }
  else{
    print("No se encuentra i@")
    return false
  }
}

func DeclararLista() -> Bool{
  if tokens[currentToken] == "lista"{
    Get_Next_Token()
    if tokens[currentToken] == "tipo_de_dato"{
      Get_Next_Token()
      if tokens[currentToken] == "Identificador"{
        Get_Next_Token()
        return true
      }
      else{
        print("Se esperaba un Identificador")
        return false
      }
    }
    else{
      print("Se esperaba tipo de dato")
      return false
    }
  }
  else{
    print("Se esperaba la palabra table")
    return false
  }
}
func DeclararConvert() -> Bool{
  if tokens[currentToken] == "conversiones"{
    Get_Next_Token()
    if tokens[currentToken] == "Identificador"{
      Get_Next_Token()
      if tokens[currentToken] == "convertidor"{
        Get_Next_Token()
        return true
      }
      else{
        print("Se esperaba la palabra converse")
        return false
      }
    }
    else{
      print("Se esperaba un Identificador")
      return false
    }
  }
  else{
    print("Se esperaba un tipo de conversion")
    return false
  }
}

  func DeclararFprograma() -> Bool{
    if tokens[currentToken] == "FPrograma" {
      Get_Next_Token()
      return true
    }
    else{
      print("No se localiza el fin del programa")
      return false
    }
  }
}

var synal = Syntax(TOKENS)
synal.DeclararIprograma() //1
synal.DeclararLib() //2
synal.Declaracion_Constante() //3
synal.Declaracion_Variable() //4
synal.DeclararCola() //5
synal.consread() //6
synal.consWrt() //7
synal.DeclararPila() //8
synal.OperMate() //9
synal.Declarar_Arreglo() //10
synal.Declararimp() //11
synal.DeclararTry() //12
synal.DeclararCatch() //13
synal.DeclararLista()//14
synal.DeclararFprograma() //15


//cada metodo tiene que llamar al otro requerido dentro de la funcion
