param(
    [string]$ServerPath,
    [bool]$FullClean = $false
)

$protectedFiles = @(
    "oxide.groups.data",
    "oxide.users.data",
    "Friends.json",
    "BetterChat.json",
    "BetterChatFilter.json",
    "BetterChatMute.json",
    "EnhancedHammer.json",
    "FriendlyFire.json",
    "FurnaceSplitter.json",
    "MagicPannel.json"
    )

if(-not $FullClean)
{
    $protectedFiles += @("ZLevelsRemastered.json")
}

$DataDirPath = Join-Path -Path $ServerPath -ChildPath "oxide/data"

$Files = Get-ChildItem -Path $DataDirPath | ?{$protectedFiles -notcontains $_.Name}

$Files | Remove-Item -Force -Recurse

if($FullClean)
{
    Get-ChildItem -Path $ServerPath -File | Remove-Item -Force -Recurse
}