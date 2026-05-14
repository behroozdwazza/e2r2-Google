$ErrorActionPreference = "Stop"
Set-Location -LiteralPath $PSScriptRoot

$BundledPython = "C:\Users\davazdab\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe"
$KnimePython = "C:\Users\davazdab\.conda\envs\knime_python\python.exe"

if (Test-Path $BundledPython) {
    $Python = $BundledPython
} elseif (Test-Path $KnimePython) {
    $Python = $KnimePython
} else {
    $Python = "python"
}

& $Python "$PSScriptRoot\MISQ_tests.py"
