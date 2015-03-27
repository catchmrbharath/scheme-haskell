module Main where

import Text.ParserCombinators.Parsec hiding (spaces)
import System.Environment

symbol :: Parser Char
symbol = oneOf "!@$%|*+-/:<=>?@^_~"

readExpr:: String -> String
readExpr input = case parse parseExpr "lisp" input of
                    Left err -> "No match: " ++ show err
                    Right _ -> "Found value"


spaces:: Parser ()
spaces = skipMany1 space

data LispVal = Atom String
             | List [LispVal]
             | DottedList [LispVal] LispVal
             | Number Integer
             | String String
             | Bool Bool

parseString:: Parser LispVal
parseString = do
  _ <- char '"'
  x <- many (noneOf "\"")
  _ <- char '"'
  return $ String x



parseAtom:: Parser LispVal
parseAtom = do
  first <- letter <|> symbol
  rest <- many (letter <|> digit <|> symbol)
  let atom = first:rest
  return $ case atom of 
    "#t" -> Bool True
    "#f" -> Bool False
    _    -> Atom atom

parseNumber :: Parser LispVal
parseNumber = do
  t <- many1 digit
  return  ((Number . read) t)

parseExpr :: Parser LispVal
parseExpr = parseAtom
        <|> parseString
        <|> parseNumber



main::IO ()
main = do
  args <- getArgs
  putStrLn (readExpr (head args))
