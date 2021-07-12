param(
    [string]$SteamCmdPath = "C:\SteamCmd",
    [string]$ServerPath = "G:\Rust"
)

& $SteamCmdPath\steamcmd.exe +login anonymous +force_install_dir $ServerPath +app_update 258550 validate