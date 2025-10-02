
param(
    [string]$SolutionName = "test",
    [string]$Cnstr="Data Source=localhost,1433;Initial Catalog=Library;TrustServerCertificate=True;User ID=sa;Password=Pa$$w0rd",
    [string]$Provider="Microsoft.EntityFrameworkCore.SqlServer",
    [string]$ContextName="ScaffoldedDbContext",
    [string]$Tables=""
)

#Root Structure
$root="$PSScriptRoot\$SolutionName"
$src="$root\src"
$dbContextDir="Persistence\DbContexts"
$entitiesDir="Entities"

$DomainProjectName="$PSScriptRoot\$SolutionName\src\$SolutionName.Domain\$SolutionName.Domain.csproj"
$InfraStructureProjectPath="$PSScriptRoot\$SolutionName\src\$SolutionName.Infrastructure"
$ApiProjectPath="$PSScriptRoot\$SolutionName\src\$SolutionName.Api"
$DomainProjectPath="$PSScriptRoot\$SolutionName\src\$SolutionName.Domain"
$ApplicationProjectPath="$PSScriptRoot\$SolutionName\src\$SolutionName.Application"


$tableArray=$Tables.Split(",") | ForEach-Object {$_.Trim()}
$tableParams=$tableArray | ForEach-Object {"--table $_ "} | Out-String
$tableParams=$tableParams -replace "\r?\n",""

$command="dotnet ef dbcontext scaffold `"$Cnstr`" $Provider --context-dir $dbContextDir --output-dir $entitiesDir $tableParams --project `"$DomainProjectName`"  --force"




Write-Host $command
Invoke-Expression $command



foreach ($tablename in $tableArray){
$tablename=$tablename -replace "\r?\n",""

Set-Location $InfraStructureProjectPath
$repositoryClassName="${tablename}Repository"
dotnet new class -n $repositoryClassName -o ./Persistence/Repositories  --force

Set-Location $DomainProjectPath
$repositoryInterfaceName="I${tablename}Repository"
dotnet new interface -n $repositoryInterfaceName  -o ./Contracts/Repositories --force

$serviceInterfaceName="I${tablename}Service"
dotnet new interface -n $serviceInterfaceName  -o ./Contracts/Services --force

Set-Location $ApplicationProjectPath
$serviceClassName="${tablename}Service"
dotnet new class -n $serviceClassName  -o ./Services --force

Set-Location $ApiProjectPath
$controllerName="${tablename}Controller"
dotnet new apicontroller -n $controllerName -o ./Controllers  --force


}
Set-Location $PSScriptRoot




