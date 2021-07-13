param(
    [string]$ServerPath,
    [string]$ServerRepoPath
)

Copy-Item -Path "$ServerRepoPath\*" -Destination $ServerPath -Force -Recurse -Verbose