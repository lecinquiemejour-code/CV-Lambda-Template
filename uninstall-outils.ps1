# ============================================================
# Script de DÉSINSTALLATION des outils pour le CV Interactif IA
# ============================================================
# Ce script désinstalle les 4 outils installés par install-outils.ps1 :
# Git, Node.js (+ npm), GitHub CLI (gh) et Poppler (pdftotext)
#
# POURQUOI : remettre la machine dans l'état "débutant zéro"
# pour pouvoir suivre le tutoriel vidéo dans les mêmes conditions.
#
# COMMENT L'UTILISER :
# 1. Clic droit sur ce fichier → "Exécuter avec PowerShell"
#    OU ouvre un PowerShell normal et tape : .\uninstall-outils.ps1
# 2. Après la désinstallation, FERME et ROUVRE Antigravity + tout terminal.
# ============================================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Désinstallation des outils CV IA" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Ce script va retirer les 4 outils du tutoriel" -ForegroundColor Yellow
Write-Host "pour te remettre dans les conditions du debutant." -ForegroundColor Yellow
Write-Host ""

# Vérifie que winget est disponible
$wingetOk = $false
try {
    $null = Get-Command winget -ErrorAction Stop
    $wingetOk = $true
    Write-Host "[OK] winget est disponible." -ForegroundColor Green
} catch {
    Write-Host "[ERREUR] winget n'est pas disponible sur ce PC." -ForegroundColor Red
    Write-Host "         Tu devras desinstaller les outils manuellement" -ForegroundColor Yellow
    Write-Host "         via Parametres > Applications > Applications installees." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Appuie sur Entree pour fermer"
    exit 1
}

# Liste des outils : mêmes identifiants que install-outils.ps1
$outils = @(
    @{ Nom = "Git";                 WingetId = "Git.Git";               Commande = "git" },
    @{ Nom = "Node.js (+ npm)";     WingetId = "OpenJS.NodeJS.LTS";     Commande = "node" },
    @{ Nom = "GitHub CLI (gh)";     WingetId = "GitHub.cli";             Commande = "gh" },
    @{ Nom = "Poppler (pdftotext)"; WingetId = "oschwartz10612.Poppler"; Commande = "pdftotext" }
)

$uninstallCount = 0

foreach ($outil in $outils) {
    Write-Host ""
    Write-Host "--- $($outil.Nom) ---" -ForegroundColor Yellow

    # Vérifie si l'outil est actuellement installé
    $estInstalle = $false
    try {
        $null = Get-Command $outil.Commande -ErrorAction Stop
        $estInstalle = $true
    } catch {}

    if (-not $estInstalle) {
        Write-Host "[OK] $($outil.Nom) n'est pas installe (rien a faire)." -ForegroundColor Green
    } else {
        Write-Host "     Desinstallation de $($outil.Nom) via winget..." -ForegroundColor Cyan
        winget uninstall --id $outil.WingetId --silent
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[OK] $($outil.Nom) desinstalle avec succes !" -ForegroundColor Green
            $uninstallCount++
        } else {
            Write-Host "[ERREUR] Echec de la desinstallation de $($outil.Nom)." -ForegroundColor Red
            Write-Host "         Desinstalle-le manuellement via Parametres > Applications." -ForegroundColor Yellow
        }
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
if ($uninstallCount -gt 0) {
    Write-Host "  $uninstallCount outil(s) desinstalle(s)." -ForegroundColor Green
    Write-Host "  IMPORTANT : ferme et rouvre Antigravity" -ForegroundColor Yellow
    Write-Host "  et tout terminal PowerShell !" -ForegroundColor Yellow
} else {
    Write-Host "  Aucun outil n'etait installe." -ForegroundColor Green
}
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Read-Host "Appuie sur Entree pour fermer"
