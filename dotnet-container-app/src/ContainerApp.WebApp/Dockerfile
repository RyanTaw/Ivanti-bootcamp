FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

COPY . .

RUN dotnet restore ContainerApp.WebApp/ContainerApp.WebApp.csproj
RUN dotnet publish ContainerApp.WebApp/ContainerApp.WebApp.csproj -c Release -o /app/out --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app

COPY --from=build /app/out .

ENTRYPOINT ["dotnet", "ContainerApp.WebApp.dll"]