/*! © 2022 imaoki | MIT License | https://github.com/imaoki */
(
  -- clearListener()

  local nowTime = (DotNetClass "System.DateTime").Now.ToString "HH:mm:ss"
  local sw = DotNetObject "System.Diagnostics.Stopwatch"

  local currentFile = getSourceFileName()
  local pathUtility = ::PathUtilityStruct currentFile

  local actual
  local expected
  local testDef
  local testObj

  format "[run %]@\"%\"\n" nowTime currentFile
  /* Setup Start ------------------------------------------------------------ */
  testDef = fileIn (pathUtility.GetFullPath @"..\StartupScriptLoader.ms")
  testObj = testDef "testLoader"
  /* Setup End -------------------------------------------------------------- */
  sw.Start()
  /* Test Start ------------------------------------------------------------- */
  /* GetGlobalVarName */
  actual = ::TestValueStruct (testObj.GetGlobalVarName())
  expected = ::TestValueStruct "testLoader"
  assert (actual.Equals expected == true)
  -- グローバル変数の存在を確認
  actual = ::TestValueStruct (GlobalVars.IsGlobal "testLoader")
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- グローバル変数の値を確認
  actual = ::TestValueStruct (GlobalVars.Get "testLoader")
  expected = ::TestValueStruct testObj
  assert (actual.Equals expected == true)

  /* GetScriptFiles */
  actual = ::TestValueStruct (testObj.GetScriptFiles())
  expected = ::TestValueStruct #()
  assert (actual.Equals expected == true)

  /* GetStartupFileName */
  actual = ::TestValueStruct (testObj.GetStartupFileName())
  expected = ::TestValueStruct "StartupScriptLoader"
  assert (actual.Equals expected == true)

  /* GetStartupFilePath */
  actual = ::TestValueStruct (testObj.GetStartupFilePath())
  expected = ::TestValueStruct (SymbolicPaths.GetPathValue "$UserStartupScripts" + @"\StartupScriptLoader.ms")
  assert (actual.Equals expected == true)

  /* OnPreSystemShutdown */

  /* RegisterScript */

  /* Save */

  /* Uninstall */
  actual = ::TestValueStruct (testObj.Uninstall())
  expected = ::TestValueStruct ok
  assert (actual.Equals expected == true)
  -- グローバル変数の存在を確認
  actual = ::TestValueStruct (GlobalVars.IsGlobal "testLoader")
  expected = ::TestValueStruct true
  assert (actual.Equals expected == true)
  -- グローバル変数の値を確認
  actual = ::TestValueStruct (GlobalVars.Get "testLoader")
  expected = ::TestValueStruct undefined
  assert (actual.Equals expected == true)

  /* UnregisterScript */

  /* Test End --------------------------------------------------------------- */
  sw.Stop()
  /* Teardown Start --------------------------------------------------------- */
  /* Teardown End ----------------------------------------------------------- */
  format "[end %]%ms\n" nowTime (sw.Elapsed.Milliseconds)
  ok
)