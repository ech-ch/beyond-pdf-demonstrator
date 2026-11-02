# Oeffnet ein DOCX schreibgeschuetzt in Word (COM, unsichtbar) und gibt fuer jede Ueberschrift
# (OutlineLevel 1-3) die von Word berechnete Listennummer (ListString) und den Text aus.
# Optional: -Pdf <pfad> exportiert zusaetzlich ein PDF. -Fields aktualisiert vorher alle Felder (in Kopie, ohne Speichern).
param([Parameter(Mandatory=$true)][string]$Docx, [string]$Pdf, [switch]$Fields, [switch]$Links)
$ErrorActionPreference = "Stop"
$word = New-Object -ComObject Word.Application
$word.Visible = $false
$word.DisplayAlerts = 0
try {
  $doc = $word.Documents.Open($Docx, $false, $true)   # ConfirmConversions=false, ReadOnly=true
  if ($Fields) { [void]$doc.Fields.Update() }
  foreach ($p in $doc.Paragraphs) {
    $lvl = $p.OutlineLevel
    if ($lvl -ge 1 -and $lvl -le 3) {
      $ls = $p.Range.ListFormat.ListString
      $t = $p.Range.Text.Trim()
      $st = $p.Style.NameLocal
      "{0,-14} | Liste='{1}' | Text='{2}'" -f $st, $ls, $t
    }
  }
  if ($Links) {
    "--- Hyperlinks ---"
    foreach ($h in $doc.Hyperlinks) { "'{0}' -> addr='{1}' sub='{2}'" -f $h.TextToDisplay, $h.Address, $h.SubAddress }
    "--- Felder ---"
    foreach ($f in $doc.Fields) { "{0} => '{1}'" -f $f.Code.Text.Trim(), $f.Result.Text }
  }
  if ($Pdf) { $doc.ExportAsFixedFormat($Pdf, 17); "PDF: $Pdf" }
  $doc.Close(0)
} finally {
  $word.Quit(0)
  [void][System.Runtime.InteropServices.Marshal]::ReleaseComObject($word)
}
