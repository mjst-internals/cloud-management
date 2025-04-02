# current user's path environment
$userPath = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::User)
Write-Output "User-Path  : $userPath"
# powershell-script paths
$scriptPath = Split-Path -Path $MyInvocation.MyCommand.Path -Parent
# adds path to user's path environment, if not already contained
if (!$userPath.Contains($scriptPath)) {
    $userPath += $scriptPath
    # Rewrite USER 'path' environment variable
    [Environment]::SetEnvironmentVariable('Path', $userPath, [EnvironmentVariableTarget]::User)
    $testPath = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::User)
    Write-Output "New Path   : $testPath"
}
