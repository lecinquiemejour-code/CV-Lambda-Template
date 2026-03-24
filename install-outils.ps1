# ============================================================
# Script d'installation des outils pour le CV Interactif IA
# ============================================================
# Ce script installe les 4 outils nécessaires au tutoriel :
# Git, Node.js (+ npm), GitHub CLI (gh) et Poppler (pdftotext)
#
# COMMENT L'UTILISER :
# 1. Clic droit sur ce fichier → "Exécuter avec PowerShell"
#    OU ouvre un PowerShell normal et tape : .\install-outils.ps1
# 2. Après l'installation, FERME et ROUVRE Antigravity.
# ============================================================

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Installation des outils CV IA" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Vérifie que winget est disponible
$wingetOk = $false
try {
    $null = Get-Command winget -ErrorAction Stop
    $wingetOk = $true
    Write-Host "[OK] winget est disponible." -ForegroundColor Green
} catch {
    Write-Host "[ERREUR] winget n'est pas disponible sur ce PC." -ForegroundColor Red
    Write-Host "         Tu devras installer les outils manuellement." -ForegroundColor Yellow
    Write-Host "         Consulte le tableau des liens dans TUTORIAL.md (Etape 4)." -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Appuie sur Entree pour fermer"
    exit 1
}

# Liste des outils : nom affiché, identifiant winget, commande de vérification
$outils = @(
    @{ Nom = "Git";             WingetId = "Git.Git";                       Commande = "git" },
    @{ Nom = "Node.js (+ npm)"; WingetId = "OpenJS.NodeJS.LTS";             Commande = "node" },
    @{ Nom = "GitHub CLI (gh)"; WingetId = "GitHub.cli";                     Commande = "gh" },
    @{ Nom = "Poppler (pdftotext)"; WingetId = "oschwartz10612.Poppler"; Commande = "pdftotext" }
)

$installCount = 0

foreach ($outil in $outils) {
    Write-Host ""
    Write-Host "--- $($outil.Nom) ---" -ForegroundColor Yellow

    # Vérifie si l'outil est déjà installé
    $dejaInstalle = $false
    try {
        $null = Get-Command $outil.Commande -ErrorAction Stop
        $dejaInstalle = $true
    } catch {}

    if ($dejaInstalle) {
        Write-Host "[OK] $($outil.Nom) est deja installe." -ForegroundColor Green
    } else {
        Write-Host "     Installation de $($outil.Nom) via winget..." -ForegroundColor Cyan
        winget install --id $outil.WingetId --accept-source-agreements --accept-package-agreements --silent
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[OK] $($outil.Nom) installe avec succes !" -ForegroundColor Green
            $installCount++
        } else {
            Write-Host "[ERREUR] Echec de l'installation de $($outil.Nom)." -ForegroundColor Red
            Write-Host "         Installe-le manuellement (voir TUTORIAL.md, Etape 4)." -ForegroundColor Yellow
        }
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
if ($installCount -gt 0) {
    Write-Host "  $installCount outil(s) installe(s)." -ForegroundColor Green
    Write-Host "  IMPORTANT : ferme et rouvre Antigravity !" -ForegroundColor Yellow
} else {
    Write-Host "  Tous les outils etaient deja installes !" -ForegroundColor Green
}
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Read-Host "Appuie sur Entree pour fermer"
