{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}

import Data.GI.Base
import qualified GI.Gtk as Gtk
import Control.Monad
import Data.Text (Text)
import qualified Data.Text as T
import Data.IORef
import Text.Read (readMaybe)

data Operator = Add | Subtract | Multiply | Divide
  deriving (Show, Eq)

data CalcState = CalcState
  { calcDisplay :: Text
  , firstOp :: Maybe Double
  , pendingOp :: Maybe Operator
  }

emptyState :: CalcState
emptyState = CalcState "" Nothing Nothing

executeOp :: Operator -> Double -> Double -> Double
executeOp Add      = (+)
executeOp Subtract = (-)
executeOp Multiply = (*)
executeOp Divide   = (/)

main :: IO ()
main = do
  Gtk.init Nothing

  win <- new Gtk.Window [#title := "Calculator", #resizable := False]
  on win #destroy Gtk.mainQuit

  box <- new Gtk.Box [#orientation := Gtk.OrientationVertical]
  #add win box

  entry <- Gtk.entryNew
  #packStart box entry True True 5

  grid <- Gtk.gridNew
  Gtk.gridSetRowSpacing grid 5
  Gtk.gridSetColumnSpacing grid 5
  #packStart box grid True True 5

  stVar <- newIORef emptyState

  let addButton lbl row col = do
        btn <- new Gtk.Button [#label := lbl]
        Gtk.gridAttach grid btn col row 1 1
        on btn #clicked $ handleInput entry stVar lbl

  let addOpButton lbl row col op = do
        btn <- new Gtk.Button [#label := lbl]
        Gtk.gridAttach grid btn col row 1 1
        on btn #clicked $ handleOp entry stVar op

  addButton "7" 0 0
  addButton "8" 0 1
  addButton "9" 0 2
  addOpButton "/" 0 3 Divide

  addButton "4" 1 0
  addButton "5" 1 1
  addButton "6" 1 2
  addOpButton "*" 1 3 Multiply
  addOpButton "-" 2 3 Subtract
  eqBtn <- new Gtk.Button [#label := "="]
  Gtk.gridAttach grid eqBtn 2 3 1 1
  on eqBtn #clicked $ handleEquals entry stVar
  addOpButton "+" 3 3 Add

  clearBtn <- new Gtk.Button [#label := "C"]
  Gtk.gridAttach grid clearBtn 0 4 4 1
  on clearBtn #clicked $ do
    writeIORef stVar emptyState
    Gtk.entrySetText entry ""

  #showAll win
  Gtk.main

handleInput :: Gtk.Entry -> IORef CalcState -> Text -> IO ()
handleInput display stRef input = do
  st <- readIORef stRef
  let currentText = calcDisplay st
  let newDisplay = case input of
        "." -> if T.isInfixOf "." currentText 
               then currentText 
               else if T.null currentText 
                    then "0." 
                    else T.append currentText input
        _   -> T.append currentText input
  writeIORef stRef st { calcDisplay = newDisplay }
  Gtk.entrySetText display newDisplay

handleOp :: Gtk.Entry -> IORef CalcState -> Operator -> IO ()
handleOp display stRef op = do
  st <- readIORef stRef
  let currentText = calcDisplay st
  let current = readMaybe (T.unpack currentText) :: Maybe Double
  case (firstOp st, pendingOp st, current) of
    (Nothing, _, Just n) -> do
      writeIORef stRef (st { firstOp = Just n, pendingOp = Just op, calcDisplay = "" })
      Gtk.entrySetText display ""
    (Just n, Just prevOp, Just m) -> do
      if prevOp == Divide && m == 0
        then do
          Gtk.entrySetText display "Error: division by zero"
          writeIORef stRef (st { firstOp = Nothing, pendingOp = Nothing, calcDisplay = "" })
        else do
          let result = executeOp prevOp n m
          Gtk.entrySetText display (T.pack (show result))
          writeIORef stRef (st { firstOp = Just result, pendingOp = Just op, calcDisplay = "" })
    _ -> return ()

handleEquals :: Gtk.Entry -> IORef CalcState -> IO ()
handleEquals display stRef = do
  st <- readIORef stRef
  let currentText = calcDisplay st
  let current = readMaybe (T.unpack currentText) :: Maybe Double
  case (firstOp st, pendingOp st, current) of
    (Just n, Just op, Just m) -> do
      if op == Divide && m == 0
        then do
          Gtk.entrySetText display "Error: division by zero"
          writeIORef stRef (st { firstOp = Nothing, pendingOp = Nothing, calcDisplay = "" })
        else do
          let result = executeOp op n m
          let resultText = T.pack (show result)
          Gtk.entrySetText display resultText
          writeIORef stRef (emptyState { calcDisplay = resultText })
    _ -> return ()
