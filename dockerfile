FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 8000

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["SampleService.Docker.Lnx/SampleService.Docker.Lnx.csproj", "SampleService.Docker.Lnx/"]
RUN dotnet restore "SampleService.Docker.Lnx/SampleService.Docker.Lnx.csproj"
COPY . .
WORKDIR "/src/SampleService.Docker.Lnx"
RUN dotnet build "SampleService.Docker.Lnx.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "SampleService.Docker.Lnx.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SampleService.Docker.Lnx.dll"]