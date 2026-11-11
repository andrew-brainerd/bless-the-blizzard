# Renders assets/logo.png (512x512) for the CurseForge project page.
# Usage: powershell -NoProfile -ExecutionPolicy Bypass -File assets/logo.ps1
Add-Type -AssemblyName System.Drawing

$size = 512
$out = Join-Path $PSScriptRoot "logo.png"

function Color($hex, $alpha = 255) {
    $c = [System.Drawing.ColorTranslator]::FromHtml($hex)
    return [System.Drawing.Color]::FromArgb($alpha, $c.R, $c.G, $c.B)
}

function RoundRect($x, $y, $w, $h, $r) {
    $p = New-Object System.Drawing.Drawing2D.GraphicsPath
    $d = $r * 2
    $p.AddArc($x, $y, $d, $d, 180, 90)
    $p.AddArc($x + $w - $d, $y, $d, $d, 270, 90)
    $p.AddArc($x + $w - $d, $y + $h - $d, $d, $d, 0, 90)
    $p.AddArc($x, $y + $h - $d, $d, $d, 90, 90)
    $p.CloseFigure()
    return $p
}

function Point($x, $y) { return New-Object System.Drawing.PointF $x, $y }

function Glow($cx, $cy, $r, $hex, $alpha) {
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddEllipse($cx - $r, $cy - $r, $r * 2, $r * 2)
    $brush = New-Object System.Drawing.Drawing2D.PathGradientBrush $path
    $brush.CenterColor = Color $hex $alpha
    $brush.SurroundColors = @((Color $hex 0))
    $g.FillPath($brush, $path)
}

$bmp = New-Object System.Drawing.Bitmap $size, $size
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAlias
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

# Dark background with a faint vignette
$full = New-Object System.Drawing.Rectangle 0, 0, $size, $size
$bgPath = New-Object System.Drawing.Drawing2D.GraphicsPath
$bgPath.AddEllipse(-120, -140, 752, 752)
$bg = New-Object System.Drawing.Drawing2D.PathGradientBrush $bgPath
$bg.CenterColor = Color "#1c3458"
$bg.SurroundColors = @((Color "#070d1c"))
$g.FillRectangle((New-Object System.Drawing.SolidBrush (Color "#070d1c")), $full)
$g.FillPath($bg, $bgPath)

$center = New-Object System.Drawing.StringFormat
$center.Alignment = [System.Drawing.StringAlignment]::Center
$serif = New-Object System.Drawing.FontFamily "Georgia"

# A snowflake against a sunset, with music notes
$cx = 256; $cy = 180
Glow $cx ($cy + 10) 210 "#ff8a2c" 170
Glow $cx $cy 120 "#ffd38a" 70
$g.TranslateTransform($cx, $cy)
$edge = New-Object System.Drawing.Pen (Color "#0e2a48"), 22
$edge.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
$edge.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
$ice = New-Object System.Drawing.Pen (Color "#e8f6ff"), 12
$ice.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
$ice.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
foreach ($pen in @($edge, $ice)) {
    for ($i = 0; $i -lt 6; $i++) {
        $g.RotateTransform(60)
        $g.DrawLine($pen, 0, 0, 0, (-106))
        foreach ($b in @(@(44, 27), @(76, 20))) {
            $g.DrawLine($pen, 0, (-$b[0]), (-$b[1]), (-$b[0] - $b[1]))
            $g.DrawLine($pen, 0, (-$b[0]), $b[1], (-$b[0] - $b[1]))
        }
    }
}
$g.FillEllipse((New-Object System.Drawing.SolidBrush (Color "#9fd8ff")), (-16), (-16), 32, 32)
$g.DrawEllipse((New-Object System.Drawing.Pen (Color "#0e2a48"), 4), (-16), (-16), 32, 32)
$g.ResetTransform()

function Note($x, $y, $s) {
    $noteEdge = New-Object System.Drawing.Pen (Color "#3a2008"), 4
    $gold = New-Object System.Drawing.SolidBrush (Color "#ffd35a")
    $g.TranslateTransform($x, $y)
    $g.RotateTransform(-20)
    $g.FillEllipse($gold, (-14 * $s), (-9 * $s), (28 * $s), (18 * $s))
    $g.DrawEllipse($noteEdge, (-14 * $s), (-9 * $s), (28 * $s), (18 * $s))
    $g.ResetTransform()
    $stem = New-Object System.Drawing.Pen (Color "#3a2008"), (9 * $s)
    $g.DrawLine($stem, ($x + 11 * $s), ($y - 4 * $s), ($x + 11 * $s), ($y - 58 * $s))
    $stemFill = New-Object System.Drawing.Pen (Color "#ffd35a"), (4 * $s)
    $g.DrawLine($stemFill, ($x + 11 * $s), ($y - 4 * $s), ($x + 11 * $s), ($y - 57 * $s))
    $flag = [System.Drawing.PointF[]]@((Point ($x + 11 * $s) ($y - 58 * $s)), (Point ($x + 32 * $s) ($y - 40 * $s)), (Point ($x + 28 * $s) ($y - 30 * $s)), (Point ($x + 13 * $s) ($y - 42 * $s)))
    $g.FillPolygon($gold, $flag)
    $g.DrawPolygon($noteEdge, $flag)
}
Note 108 150 1.1
Note 400 120 0.9
Note 392 268 0.75

# Gold frame, matching the sister addons
$framePen = New-Object System.Drawing.Pen (Color "#c9a13b"), 10
$g.DrawPath($framePen, (RoundRect 14 14 ($size - 28) ($size - 28) 36))
$innerPen = New-Object System.Drawing.Pen (Color "#f5d77a" 90), 2
$g.DrawPath($innerPen, (RoundRect 26 26 ($size - 52) ($size - 52) 28))

# Wordmark
$shadow = New-Object System.Drawing.SolidBrush (Color "#000000" 110)
$title = New-Object System.Drawing.Drawing2D.GraphicsPath
$title.AddString("BLESS THE BLIZZARD", $serif, [int][System.Drawing.FontStyle]::Bold, 34, (Point 256 330), $center)
$g.TranslateTransform(3, 4)
$g.FillPath($shadow, $title)
$g.ResetTransform()
$titleRect = New-Object System.Drawing.Rectangle 0, 336, $size, 60
$titleBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush $titleRect, (Color "#fff1c2"), (Color "#e8b43a"), 90
$titleEdge = New-Object System.Drawing.Pen (Color "#5a3a08"), 4
$g.DrawPath($titleEdge, $title)
$g.FillPath($titleBrush, $title)

# "FOR MAGES", letter-spaced by hand
$subFont = New-Object System.Drawing.Font "Georgia", 25, ([System.Drawing.FontStyle]::Bold), ([System.Drawing.GraphicsUnit]::Pixel)
$subBrush = New-Object System.Drawing.SolidBrush (Color "#cfe6ff")
$letters = "FOR MAGES".ToCharArray()
$spacing = 13
$widths = @()
foreach ($ch in $letters) { $widths += $g.MeasureString([string]$ch, $subFont, 100, [System.Drawing.StringFormat]::GenericTypographic).Width }
$total = ($widths | Measure-Object -Sum).Sum + $spacing * ($letters.Count - 1)
$x = 256 - $total / 2
for ($i = 0; $i -lt $letters.Count; $i++) {
    $g.DrawString([string]$letters[$i], $subFont, $subBrush, $x, 412, [System.Drawing.StringFormat]::GenericTypographic)
    $x += $widths[$i] + $spacing
}

$g.Dispose()
$bmp.Save($out, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
Write-Output "Wrote $out"
