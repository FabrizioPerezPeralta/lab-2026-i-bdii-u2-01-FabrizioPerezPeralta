FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["App.Redis.Api/App.Redis.Api.csproj", "App.Redis.Api/"]
RUN dotnet restore "App.Redis.Api/App.Redis.Api.csproj"
COPY . .
WORKDIR "/src/App.Redis.Api"
RUN dotnet build "App.Redis.Api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "App.Redis.Api.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
EXPOSE 80
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "App.Redis.Api.dll"]
