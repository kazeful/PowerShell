Set-Alias g git
Set-Alias p pnpm

# To be compatible with @antfu/ni
Remove-Item Alias:ni -Force -ErrorAction Ignore

# gp => git push
Remove-Item Alias:gp -Force -ErrorAction Ignore

# Shows navigable menu of all options when hitting Tab
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Only need to set https proxy in general
$Env:https_proxy = "socks5://127.0.0.1:7890"

# Manually set all proxy
function proxy { $Env:all_proxy = "socks5://127.0.0.1:7890" }

function bootstrap {
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  Invoke-RestMethod get.scoop.sh -outfile 'install.ps1'
  .\install.ps1 -ScoopDir 'D:\Applications\Scoop' -ScoopGlobalDir 'D:\Applications\GlobalScoopApps'

  scoop install git nvm pnpm
  g config --global core.autocrlf input
  g config --global https.proxy "socks5://127.0.0.1:7890"
  nvm install lts
  nvm use lts
  npm install --global @antfu/ni yarn nrm
  nrm use taobao

  scoop bucket add extras
  scoop install posh-git psreadline zlocation

  scoop bucket add nerd-fonts
  scoop install nerd-fonts/FiraCode
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

# function ofd { Invoke-Item . }
function ofd {
  Start-Process explorer.exe -ArgumentList (Get-Location).Path
}

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
      Write-Host ($args[0] + " does not exist")

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
      Write-Host ($args[0] + " does not exist")

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
