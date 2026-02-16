{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}

import Data.GI.Base
import qualified GI.Gtk as Gtk
import Control.Monad
import Data.Text (Text)
import qualified Data.Text as T
import Data.IORef
import Text.Read (readMaybe)

data CalcState = CalcState
  { calcDisplay :: Text
  , firstOp :: Maybe Double
  , pendingOp :: Maybe (Double -> Double -> Maybe Double)
  }

emptyState :: CalcState
emptyState = CalcState "" Nothing Nothing

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
  addOpButton "/" 0 3 (\a b -> if b == 0 then Nothing else Just (a / b))

  addButton "4" 1 0
  addButton "5" 1 1
  addButton "6" 1 2
  addOpButton "*" 1 3 (\a b -> Just (a * b))
  addOpButton "-" 2 3 (\a b -> Just (a - b))
  eqBtn <- new Gtk.Button [#label := "="]
  Gtk.gridAttach grid eqBtn 2 3 1 1
  on eqBtn #clicked $ handleEquals entry stVar
  addOpButton "+" 3 3 (\a b -> Just (a + b))

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

handleOp :: Gtk.Entry -> IORef CalcState -> (Double -> Double -> Maybe Double) -> IO ()
handleOp display stRef op = do
  st <- readIORef stRef
  let currentText = calcDisplay st
  let current = readMaybe (T.unpack currentText) :: Maybe Double
  case (firstOp st, current) of
    (Nothing, Just n) -> do
      writeIORef stRef st { firstOp = Just n, pendingOp = Just op, calcDisplay = "" }
      Gtk.entrySetText display ""
    (Just n, Just m) -> case pendingOp st of
      Just storedOp -> case storedOp n m of
        Just result -> do
          Gtk.entrySetText display (T.pack (show result))
          writeIORef stRef st { firstOp = Just result, pendingOp = Just op, calcDisplay = "" }
        Nothing -> do
          Gtk.entrySetText display "Error: division by zero"
          writeIORef stRef st { firstOp = Nothing, pendingOp = Nothing, calcDisplay = "" }
      Nothing -> return ()
    _ -> return ()

handleEquals :: Gtk.Entry -> IORef CalcState -> IO ()
handleEquals display stRef = do
  st <- readIORef stRef
  let currentText = calcDisplay st
  let current = readMaybe (T.unpack currentText) :: Maybe Double
  case (firstOp st, current, pendingOp st) of
    (Just n, Just m, Just op) -> case op n m of
      Just result -> do
        Gtk.entrySetText display (T.pack (show result))
        writeIORef stRef st { firstOp = Just result, calcDisplay = "" }
      Nothing -> do
        Gtk.entrySetText display "Error: division by zero"
        writeIORef stRef st { firstOp = Nothing, pendingOp = Nothing, calcDisplay = "" }
    _ -> return ()
