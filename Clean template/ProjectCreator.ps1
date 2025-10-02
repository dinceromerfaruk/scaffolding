param(
    [string]$SolutionName = "UAVT"
)

Write-Host " Creating Clean Architecture Solution: $SolutionName"

#Root Structure
$root="$PSScriptRoot\$SolutionName"
$src="$root\src"
New-Item -ItemType Directory -Path $src -Force | Out-Null
Set-Location $src


# Create solution
dotnet new sln -n $SolutionName
#cd $SolutionName

# Create projects
dotnet new webapi -n "$SolutionName.Api"
dotnet new classlib -n "$SolutionName.Application"
dotnet new classlib -n "$SolutionName.Domain"
dotnet new classlib -n "$SolutionName.Infrastructure"

Remove-Item "$SolutionName.Domain/Class1.cs"
Remove-Item "$SolutionName.Application/Class1.cs"
Remove-Item "$SolutionName.Infrastructure/Class1.cs"


# Add projects to solution
dotnet sln add "$SolutionName.Api/$SolutionName.Api.csproj"
dotnet sln add "$SolutionName.Application/$SolutionName.Application.csproj"
dotnet sln add "$SolutionName.Domain/$SolutionName.Domain.csproj"
dotnet sln add "$SolutionName.Infrastructure/$SolutionName.Infrastructure.csproj"


# Add references
dotnet add "$SolutionName.Api/$SolutionName.Api.csproj" reference "$SolutionName.Application/$SolutionName.Application.csproj"
dotnet add "$SolutionName.Application/$SolutionName.Application.csproj" reference "$SolutionName.Domain/$SolutionName.Domain.csproj"
dotnet add "$SolutionName.Infrastructure/$SolutionName.Infrastructure.csproj" reference "$SolutionName.Domain/$SolutionName.Domain.csproj"
dotnet add "$SolutionName.Infrastructure/$SolutionName.Infrastructure.csproj" reference "$SolutionName.Application/$SolutionName.Application.csproj"


# Create API folders and files
New-Item -ItemType Directory "$SolutionName.Api/Controllers" 
New-Item -ItemType Directory "$SolutionName.Api/Models" 
New-Item -ItemType Directory "$SolutionName.Api/Middlewares" 

dotnet add "$SolutionName.Api/$SolutionName.Api.csproj" package EGMCore.Common.Api --version 2.2510.1.1
dotnet add "$SolutionName.Api/$SolutionName.Api.csproj" package EGMCore.Common.ActionFilters --version 2.2510.1.1


#Set-Content "$SolutionName.Api/Controllers/OrdersController.cs" "public class OrdersController { }"
#Set-Content "$SolutionName.Api/Models/CreateOrderRequest.cs" "public class CreateOrderRequest { }"
#Set-Content "$SolutionName.Api/Models/OrderResponse.cs" "public class OrderResponse { }"


# Domain Layer
New-Item -ItemType Directory "$SolutionName.Domain/Entities" 
New-Item -ItemType Directory "$SolutionName.Domain/Contracts"
New-Item -ItemType Directory "$SolutionName.Domain/Contracts/Repositories"
New-Item -ItemType Directory "$SolutionName.Domain/Contracts/Services" 
New-Item -ItemType Directory "$SolutionName.Domain/Enums" 
dotnet add "$SolutionName.Domain/$SolutionName.Domain.csproj" package EGMCore.Common.Repository --version 2.2510.1.1
dotnet add "$SolutionName.Infrastructure/$SolutionName.Infrastructure.csproj" package Microsoft.EntityFrameworkCore.Design --version 9.0.7



#Set-Content "$SolutionName.Domain/Entities/Order.cs" "public class Order { }"
#Set-Content "$SolutionName.Domain/Entities/OrderItem.cs" "public class OrderItem { }"
#Set-Content "$SolutionName.Domain/ValueObjects/Address.cs" "public record Address(string Street, string City);"
#Set-Content "$SolutionName.Domain/ValueObjects/Money.cs" "public record Money(decimal Amount, string Currency);"
#Set-Content "$SolutionName.Domain/Aggregates/OrderAggregate.cs" "public class OrderAggregate { }"
#Set-Content "$SolutionName.Domain/Services/IOrderDomainService.cs" "public interface IOrderDomainService { }"
#Set-Content "$SolutionName.Domain/Services/OrderDomainService.cs" "public class OrderDomainService : IOrderDomainService { }"
#Set-Content "$SolutionName.Domain/Repositories/IOrderRepository.cs" "public interface IOrderRepository { }"
#Set-Content "$SolutionName.Domain/Events/OrderPlaced.cs" "public class OrderPlaced { }"


# Application Layer
New-Item -ItemType Directory "$SolutionName.Application/Interfaces" 
New-Item -ItemType Directory "$SolutionName.Application/Services" 
New-Item -ItemType Directory "$SolutionName.Application/Validators" 
New-Item -ItemType Directory "$SolutionName.Application/Mappers"
New-Item -ItemType Directory "$SolutionName.Application/Dtos" 

dotnet add "$SolutionName.Application/$SolutionName.Application.csproj" package AutoMapper --version 14.0.0
dotnet add "$SolutionName.Application/$SolutionName.Application.csproj" package EGMCore.Common.Service --version 2.2510.1.1

#Set-Content "$SolutionName.Application/Interfaces/IOrderService.cs" "public interface IOrderService { }"
#Set-Content "$SolutionName.Application/Services/OrderService.cs" "public class OrderService : IOrderService { }"
#Set-Content "$SolutionName.Application/Validators/OrderValidator.cs" "public class OrderValidator { }"
#Set-Content "$SolutionName.Application/Mappers/OrderMapper.cs" "public class OrderMapper { }"



# Infrastructure Layer
New-Item -ItemType Directory "$SolutionName.Infrastructure/Persistence" 
New-Item -ItemType Directory "$SolutionName.Infrastructure/Persistence/DbContexts"
New-Item -ItemType Directory "$SolutionName.Infrastructure/Persistence/Configurations" 
New-Item -ItemType Directory "$SolutionName.Infrastructure/Persistence/Repositories"
New-Item -ItemType Directory "$SolutionName.Infrastructure/Services" 
#Set-Content "$SolutionName.Infrastructure/Persistence/ECommerceDbContext.cs" "public class ECommerceDbContext { }"
#Set-Content "$SolutionName.Infrastructure/Persistence/Configurations/OrderConfiguration.cs" "public class OrderConfiguration { }"
#Set-Content "$SolutionName.Infrastructure/Persistence/Repositories/OrderRepository.cs" "public class OrderRepository { }"
Set-Content "$SolutionName.Infrastructure/Services/EmailService.cs" "public class EmailService { }"

dotnet add "$SolutionName.Infrastructure/$SolutionName.Infrastructure.csproj" package Microsoft.EntityFrameworkCore --version 9.0.7
dotnet add "$SolutionName.Infrastructure/$SolutionName.Infrastructure.csproj" package Microsoft.EntityFrameworkCore.Design --version 9.0.7
dotnet add "$SolutionName.Infrastructure/$SolutionName.Infrastructure.csproj" package Microsoft.EntityFrameworkCore.SqlServer --version 9.0.7


Write-Host "$SolutionName Clean Architecture solution created successfully!"
