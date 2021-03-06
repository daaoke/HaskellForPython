{-# OPTIONS_GHC -fno-warn-unused-do-bind #-}
{-
module NanoParsec where

import Data.Char
import Control.Monad
import Control.Applicative

newtype Parser a = Parser { parse :: String -> [(a,String)] }

runParser :: Parser a -> String -> a
runParser m s = case parse m s of
                    [(res,[])]  -> res
                    [(_,rs)]    -> error "Parser did not consume entire"
                    _           -> error "Parser error"

item :: Parser Char
item = Parser $ \s -> case s of
                        []      -> []
                        (c:cs)  -> [(c,cs)]
bind :: Parser a -> (a -> Parser b) -> Parser b
bind p f = Parser $ \s -> concatMap (\(a,s') -> parse (f a) s') $ parse p s

unit :: a -> Parser a
unit a = Parser (\s -> [(a,s)])

instance Functor Parser where
    fmap f (Parser cs) = Parser (\s -> [(f a ,b ) | (a,b) <- cs s])

instance Applicative Parser where
    pure = return
    (Parser cs1) <*> (Parser cs2) = Parser (\s -> [(f a,s2)| (f,s1) <- cs1 s, (a,s2) <- cs2 s1])

instance Monad Parser where
    return = unit
    (>>=) = bind

-}