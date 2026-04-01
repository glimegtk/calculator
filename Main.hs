{-# LANGUAGE OverloadedLabels #-}
{-# LANGUAGE OverloadedStrings #-}

import Data.GI.Base
import qualified GI.Gtk as Gtk
import qualified GI.Gio as Gio
import qualified GI.Gdk as Gdk
import Control.Exception (SomeException, try)
import Control.Monad (filterM, void)
import Data.Text (Text)
import qualified Data.Text as T
import Data.IORef
import Data.Version (showVersion)
import System.Directory (doesFileExist)
import System.Environment (getExecutablePath)
import System.FilePath ((</>), takeDirectory)
import Text.Read (readMaybe)
import qualified Paths_hello_gtk as Paths

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
  app <- new Gtk.Application 
    [ #applicationId := "io.github.bniladridas.calculator"
    , #registerSession := True
    ]
  installAppActions app
  on app #activate $ activateApp app
  void $ Gio.applicationRun app Nothing

installAppActions :: Gtk.Application -> IO ()
installAppActions app = do
  aboutAction <- Gio.simpleActionNew "about" Nothing
  Gio.onSimpleActionActivate aboutAction $ \_ -> showAboutDialog app
  Gio.actionMapAddAction app aboutAction

  preferencesAction <- Gio.simpleActionNew "preferences" Nothing
  Gio.onSimpleActionActivate preferencesAction $ \_ -> showPreferencesWindow app
  Gio.actionMapAddAction app preferencesAction

  quitAction <- Gio.simpleActionNew "quit" Nothing
  Gio.onSimpleActionActivate quitAction $ \_ -> #quit app
  Gio.actionMapAddAction app quitAction

  Gtk.applicationSetAccelsForAction app "app.preferences" ["<Primary>comma"]
  Gtk.applicationSetAccelsForAction app "app.quit" ["<Primary>q"]

activateApp :: Gtk.Application -> IO ()
activateApp app = do
  box <- new Gtk.Box 
    [ #orientation := Gtk.OrientationVertical
    , #marginTop := 16
    , #marginBottom := 16
    , #marginStart := 16
    , #marginEnd := 16
    , #spacing := 12
    ]

  displayBox <- new Gtk.Box
    [ #orientation := Gtk.OrientationVertical
    , #valign := Gtk.AlignEnd
    , #halign := Gtk.AlignFill
    ]

  displayLabel <- new Gtk.Label [#label := "0"]
  #setHalign displayLabel Gtk.AlignEnd
  #setValign displayLabel Gtk.AlignCenter
  #setHexpand displayLabel True
  #setSizeRequest displayLabel (-1) 60

  #append displayBox displayLabel
  #append box displayBox

  sep <- new Gtk.Separator [#marginTop := 8, #marginBottom := 8]
  #append box sep

  grid <- new Gtk.Grid [#rowSpacing := 8, #columnSpacing := 8]
  #append box grid

  win <- new Gtk.ApplicationWindow 
    [ #application := app
    , #title := "Calculator"
    , #defaultWidth := 350
    , #defaultHeight := 500
    , #child := box
    ]

  #present win

  stVar <- newIORef emptyState

  let addNumButton lbl row col = do
        btn <- new Gtk.Button 
          [ #label := lbl
          , #hexpand := True
          , #vexpand := True
          ]
        on btn #clicked $ handleInput displayLabel stVar lbl
        Gtk.gridAttach grid btn col row 1 1

  let addOpButton lbl row col op = do
        btn <- new Gtk.Button 
          [ #label := lbl
          , #hexpand := True
          , #vexpand := True
          ]
        on btn #clicked $ handleOp displayLabel stVar op
        Gtk.gridAttach grid btn col row 1 1

  addNumButton "7" 0 0
  addNumButton "8" 0 1
  addNumButton "9" 0 2
  addOpButton "÷" 0 3 Divide

  addNumButton "4" 1 0
  addNumButton "5" 1 1
  addNumButton "6" 1 2
  addOpButton "×" 1 3 Multiply

  addNumButton "1" 2 0
  addNumButton "2" 2 1
  addNumButton "3" 2 2
  addOpButton "−" 2 3 Subtract

  addNumButton "0" 3 0
  addNumButton "." 3 1
  addOpButton "+" 3 2 Add

  eqBtn <- new Gtk.Button 
    [ #label := "="
    , #hexpand := True
    , #vexpand := True
    ]
  Gtk.gridAttach grid eqBtn 3 3 1 1
  on eqBtn #clicked $ handleEquals displayLabel stVar

  clearBtn <- new Gtk.Button 
    [ #label := "C"
    , #hexpand := True
    , #vexpand := True
    ]
  Gtk.gridAttach grid clearBtn 0 4 4 1
  on clearBtn #clicked $ do
    writeIORef stVar emptyState
    #setLabel displayLabel "0"

  #show win

showAboutDialog :: Gtk.Application -> IO ()
showAboutDialog app = do
  activeWindow <- Gtk.applicationGetActiveWindow app
  aboutDialog <- new Gtk.AboutDialog
    [ #programName := "Calculator"
    , #version := T.pack (showVersion Paths.version)
    , #authors := ["Niladri Das"]
    , #website := "https://github.com/bniladridas/calculator"
    , #websiteLabel := "GitHub Repository"
    , #modal := True
    ]

  case activeWindow of
    Just window -> #setTransientFor aboutDialog (Just window)
    Nothing -> return ()

  maybeLogo <- loadAboutLogo
  case maybeLogo of
    Just logo -> set aboutDialog [#logo := logo]
    Nothing -> return ()

  #present aboutDialog

loadAboutLogo :: IO (Maybe Gdk.Texture)
loadAboutLogo = do
  iconPaths <- candidateIconPaths
  existingPaths <- filterM doesFileExist iconPaths
  loadFirst existingPaths
  where
    loadFirst [] = return Nothing
    loadFirst (path:rest) = do
      result <- try (Gdk.textureNewFromFilename path) :: IO (Either SomeException Gdk.Texture)
      case result of
        Right texture -> return (Just texture)
        Left _ -> loadFirst rest

candidateIconPaths :: IO [FilePath]
candidateIconPaths = do
  executablePath <- getExecutablePath
  let macOSDir = takeDirectory executablePath
  let contentsDir = takeDirectory macOSDir
  return
    [ contentsDir </> "Resources" </> "icon.png"
    , "GUI" </> "app-icon.png"
    , "GUI" </> "hello-gtk.png"
    ]

showPreferencesWindow :: Gtk.Application -> IO ()
showPreferencesWindow app = do
  content <- new Gtk.Box
    [ #orientation := Gtk.OrientationVertical
    , #spacing := 12
    , #marginTop := 20
    , #marginBottom := 20
    , #marginStart := 20
    , #marginEnd := 20
    ]

  title <- new Gtk.Label [#label := "Settings"]
  #setHalign title Gtk.AlignStart

  message <- new Gtk.Label [#label := "No configurable settings are available yet."]
  #setHalign message Gtk.AlignStart
  #setWrap message True

  #append content title
  #append content message

  prefsWindow <- new Gtk.ApplicationWindow
    [ #application := app
    , #title := "Settings"
    , #defaultWidth := 360
    , #defaultHeight := 160
    , #resizable := False
    , #child := content
    ]

  #present prefsWindow

handleInput :: Gtk.Label -> IORef CalcState -> Text -> IO ()
handleInput display stRef input = do
  st <- readIORef stRef
  let currentText = calcDisplay st
  let newDisplay = case input of
        "." -> if T.isInfixOf "." currentText 
               then currentText 
               else if T.null currentText 
                    then "0." 
                    else T.append currentText input
        "0" | currentText == "0" -> "0"
        _   -> if currentText == "0" then input else T.append currentText input
  writeIORef stRef st { calcDisplay = newDisplay }
  #setLabel display newDisplay

handleOp :: Gtk.Label -> IORef CalcState -> Operator -> IO ()
handleOp display stRef op = do
  st <- readIORef stRef
  let currentText = calcDisplay st
  let current = readMaybe (T.unpack currentText) :: Maybe Double
  case (firstOp st, pendingOp st, current) of
    (Nothing, _, Just n) -> do
      writeIORef stRef (st { firstOp = Just n, pendingOp = Just op, calcDisplay = "" })
      #setLabel display ""
    (Just n, Just prevOp, Just m) -> do
      if prevOp == Divide && m == 0
        then do
          #setLabel display "Error: divide by zero"
          writeIORef stRef (st { firstOp = Nothing, pendingOp = Nothing, calcDisplay = "" })
        else do
          let result = executeOp prevOp n m
          #setLabel display (T.pack (show result))
          writeIORef stRef (st { firstOp = Just result, pendingOp = Just op, calcDisplay = "" })
    (Just _, Just _, Nothing) -> do
      writeIORef stRef (st { pendingOp = Just op })
    _ -> return ()

handleEquals :: Gtk.Label -> IORef CalcState -> IO ()
handleEquals display stRef = do
  st <- readIORef stRef
  let currentText = calcDisplay st
  let current = readMaybe (T.unpack currentText) :: Maybe Double
  case (firstOp st, pendingOp st, current) of
    (Just n, Just op, Just m) -> do
      if op == Divide && m == 0
        then do
          #setLabel display "Error: divide by zero"
          writeIORef stRef (st { firstOp = Nothing, pendingOp = Nothing, calcDisplay = "" })
        else do
          let result = executeOp op n m
          let resultText = T.pack (show result)
          #setLabel display resultText
          writeIORef stRef (emptyState { calcDisplay = resultText })
    _ -> return ()
