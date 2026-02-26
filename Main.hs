{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}

import Data.GI.Base
import qualified GI.Gtk as Gtk
import qualified GI.Gio as Gio
import Control.Monad (void)
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
  app <- new Gtk.Application [#applicationId := "com.example.Calculator"]
  on app #activate $ activateApp app
  void $ Gio.applicationRun app Nothing

activateApp :: Gtk.Application -> IO ()
activateApp app = do
  box <- new Gtk.Box 
    [ #orientation := Gtk.OrientationVertical
    , #marginTop := 12
    , #marginBottom := 12
    , #marginStart := 12
    , #marginEnd := 12
    ]

  entryBuf <- new Gtk.EntryBuffer []
  entry <- new Gtk.Entry [#buffer := entryBuf]
  #append box entry

  grid <- new Gtk.Grid [#rowSpacing := 6, #columnSpacing := 6]
  #append box grid

  win <- new Gtk.ApplicationWindow 
    [ #application := app
    , #title := "Calculator"
    , #defaultWidth := 320
    , #defaultHeight := 400
    , #child := box
    ]

  stVar <- newIORef emptyState

  let addButton lbl row col = do
        btn <- new Gtk.Button [#label := lbl]
        Gtk.gridAttach grid btn col row 1 1
        on btn #clicked $ handleInput entryBuf entry stVar lbl

  let addOpButton lbl row col op = do
        btn <- new Gtk.Button [#label := lbl]
        Gtk.gridAttach grid btn col row 1 1
        on btn #clicked $ handleOp entryBuf entry stVar op

  addButton "7" 0 0
  addButton "8" 0 1
  addButton "9" 0 2
  addOpButton "/" 0 3 Divide

  addButton "4" 1 0
  addButton "5" 1 1
  addButton "6" 1 2
  addOpButton "*" 1 3 Multiply

  addButton "1" 2 0
  addButton "2" 2 1
  addButton "3" 2 2
  addOpButton "-" 2 3 Subtract

  addButton "0" 3 0
  addButton "." 3 1
  addOpButton "+" 3 2 Add

  eqBtn <- new Gtk.Button [#label := "="]
  Gtk.gridAttach grid eqBtn 3 3 1 1
  on eqBtn #clicked $ handleEquals entryBuf entry stVar

  clearBtn <- new Gtk.Button [#label := "C"]
  Gtk.gridAttach grid clearBtn 0 4 4 1
  on clearBtn #clicked $ do
    writeIORef stVar emptyState
    Gtk.entryBufferSetText entryBuf "" (-1)

  #show win

handleInput :: Gtk.EntryBuffer -> Gtk.Entry -> IORef CalcState -> Text -> IO ()
handleInput entryBuf display stRef input = do
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
  Gtk.entryBufferSetText entryBuf newDisplay (-1)

handleOp :: Gtk.EntryBuffer -> Gtk.Entry -> IORef CalcState -> Operator -> IO ()
handleOp entryBuf display stRef op = do
  st <- readIORef stRef
  let currentText = calcDisplay st
  let current = readMaybe (T.unpack currentText) :: Maybe Double
  case (firstOp st, pendingOp st, current) of
    (Nothing, _, Just n) -> do
      writeIORef stRef (st { firstOp = Just n, pendingOp = Just op, calcDisplay = "" })
      Gtk.entryBufferSetText entryBuf "" (-1)
    (Just n, Just prevOp, Just m) -> do
      if prevOp == Divide && m == 0
        then do
          Gtk.entryBufferSetText entryBuf "Error: division by zero" (-1)
          writeIORef stRef (st { firstOp = Nothing, pendingOp = Nothing, calcDisplay = "" })
        else do
          let result = executeOp prevOp n m
          Gtk.entryBufferSetText entryBuf (T.pack (show result)) (-1)
          writeIORef stRef (st { firstOp = Just result, pendingOp = Just op, calcDisplay = "" })
    _ -> return ()

handleEquals :: Gtk.EntryBuffer -> Gtk.Entry -> IORef CalcState -> IO ()
handleEquals entryBuf display stRef = do
  st <- readIORef stRef
  let currentText = calcDisplay st
  let current = readMaybe (T.unpack currentText) :: Maybe Double
  case (firstOp st, pendingOp st, current) of
    (Just n, Just op, Just m) -> do
      if op == Divide && m == 0
        then do
          Gtk.entryBufferSetText entryBuf "Error: division by zero" (-1)
          writeIORef stRef (st { firstOp = Nothing, pendingOp = Nothing, calcDisplay = "" })
        else do
          let result = executeOp op n m
          let resultText = T.pack (show result)
          Gtk.entryBufferSetText entryBuf resultText (-1)
          writeIORef stRef (emptyState { calcDisplay = resultText })
    _ -> return ()
