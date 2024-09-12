Set-Alias g git
Set-Alias p pnpm

# To be compatible with @antfu/ni
Remove-Item Alias:ni -Force -ErrorAction Ignore

# gp => git push
Remove-Item Alias:gp -Force -ErrorAction Ignore

# Shows navigable menu of all options when hitting Tab
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Only need to set https proxy in general
# $Env:https_proxy = "socks5://127.0.0.1:7890"

# Manually set all proxy
function proxy { $Env:all_proxy = "socks5://127.0.0.1:7890" }

function bootstrap {
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

  # install pnpm and node
  Invoke-WebRequest https://get.pnpm.io/install.ps1 -UseBasicParsing | Invoke-Expression
  pnpm env use --global lts
  pnpm install --global @antfu/ni nrm
  nrm use taobao

  # install scoop
  Invoke-RestMethod get.scoop.sh -outfile 'install.ps1'
  .\install.ps1 -ScoopDir 'D:\Applications\Scoop' -ScoopGlobalDir 'D:\Applications\GlobalScoopApps'

  scoop install git
  git config --global core.autocrlf input
  git config --global https.proxy "socks5://127.0.0.1:7890"
  git config --global alias.sclone "clone --depth 1"

  scoop bucket add extras
  scoop install posh-git psreadline zlocation
  scoop install https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/oh-my-posh.json

  scoop bucket add nerd-fonts
  scoop install nerd-fonts/FiraCode nerd-fonts/Meslo-NF
}

function Reload-Profile {
  @(
    $Profile.AllUsersAllHosts,
    $Profile.AllUsersCurrentHost,
    $Profile.CurrentUserAllHosts,
    $Profile.CurrentUserCurrentHost
  ) | ForEach-Object {

    if(Test-Path $_){
      Write-Host ("Running $_") -foregroundcolor Magenta
      . $_
    }
  }
}
function nio { ni --prefer-offline }
function st { nr start }
function s { nr serve }
function d { nr dev }
function b { nr build }
function t { nr test }
function tu { nr test -u }
function lint { nr lint }
function lintfix { nr lint --fix }
function gl { g pull }
function gpl { g pull }
function gp { g push }
function gb { g branch }

function ofd { Invoke-Item . }

function i {
  param(
    [switch]$a
  )

  $basePath = "D:\i"

  if (-not $null -eq $args[0]) {
    $projectPath = Join-Path -Path $basePath -ChildPath $args[0]

    if (Test-Path $projectPath) {
      Set-Location -Path $projectPath
    }
    else {
      Write-Host ($args[0] + " does not exist") -foregroundcolor Red

      if ($a -eq $true) {
        New-Item -Path $projectPath -ItemType Directory
      }
      else {
        $confirmation = Read-Host "Are you creating a new project? (Y/N)"
        if ($confirmation -eq 'Y') {
          New-Item -Path $projectPath -ItemType Directory
        }
      }
    }
  }
  else {
    Set-Location -Path $basePath
  }
}

function f {
  param(
    [switch]$a
  )

  $basePath = "D:\fork"

  if (-not $null -eq $args[0]) {
    $projectPath = Join-Path -Path $basePath -ChildPath $args[0]

    if (Test-Path $projectPath) {
      Set-Location -Path $projectPath
    }
    else {
      Write-Host ("$($args[0]) does not exist") -foregroundcolor Red

      if ($a -eq $true) {
        New-Item -Path $projectPath -ItemType Directory
      }
      else {
        $confirmation = Read-Host "Are you creating a new project? (Y/N)"
        if ($confirmation -eq 'Y') {
          New-Item -Path $projectPath -ItemType Directory
        }
      }
    }
  }
  else {
    Set-Location -Path $basePath
  }
}

function rmrf {
  if (-not $null -eq $args[0]) {
    Remove-Item -Recurse -Force $args[0]
  }
}

function clone {
  param(
    [switch]$s,
    [switch]$shallow
  )

  $cloneDepth = if ($s -eq $true -Or $shallow -eq $true) { "--depth=1" } else { $null }

  # Invoke-Expression "git clone $cloneDepth $($args[0]) $($args[1])"
  git clone $cloneDepth $args[0] $args[1]

  $repoName = if (-not $null -eq $args[1]) { $args[1] } else { $args[0] }
  Set-Location ($repoName -replace '^.*/([^/]+?)(\.git)?$', '$1')
}
