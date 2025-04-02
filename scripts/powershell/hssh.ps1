# powershell-script to configure SSH-Firewall rules for Hetzner before connecting via ssh
param(
    # Hetzner project name
    [Parameter(Mandatory=$true)]
    [string]$project,
    # destination server name or url
    [Parameter(Mandatory=$true)]
    [string]$destination,
    # user to connect ssh with
    [string]$user
)

# defaults
Set-Variable -Name "DEFAULT_FIREWALL_NAME" -Value "firewall-ssh" -Option Constant -Scope Local
Set-Variable -Name "DEFAULT_USER" -Value "mjs" -Option Constant -Scope Local

# get's local IP
function Get-LocalIp
{
    return Invoke-RestMethod -Uri "https://api.ipify.org";
}

# replaces firewall rules
function Set-FirewallConfiguration
{
    param(
        [string]$project,
        [string]$firewall_name,
        [string]$source_ip
    )
    if (!$project) { throw "project is null"; }
    if (!$firewall_name) { throw "firewall_name is null"; }
    if (!$source_ip) { throw "source_ip is null"; }

    Write-Output "Updating $firewall_name in $project to allow SSH from $source_ip ...";
    # set context (project) to use
    hcloud context use $project;
    # pipe the json to replace into the hcloud command
    "[{""direction"": ""in"",""protocol"": ""tcp"",""port"": ""22"",""source_ips"": [""$source_ip/32""]}]"
        | hcloud firewall replace-rules --rules-file - $firewall_name;
}

# establish the ssh-conection
function Connect-Ssh
{
    param(
        [string]$user,
        [string]$destination
    )
    if (!$user) { throw "user is null"; }
    if (!$destination) { throw "destination is null"; }

    ssh "$user@$destination";
}

# MAIN
try
{
    # update firewall rule
    Set-FirewallConfiguration -project $project -firewall_name $DEFAULT_FIREWALL_NAME -source_ip (Get-LocalIp);
    # establish connection
    if (!$user) { $user = $DEFAULT_USER; }
    Connect-Ssh -user $user -destination $destination;
}
catch
{
    Write-Error $_.Exception.Message;
    EXIT 1
}
