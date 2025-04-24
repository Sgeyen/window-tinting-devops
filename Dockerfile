# Build stage
FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /app

COPY MarvinIOTPOC.csproj ./
RUN dotnet restore

COPY . ./
RUN dotnet publish -c Release -o out

RUN echo "Window Tinting Web App | Deployed via EKS | April 2025" > out/wizexercise.txt

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:3.1
WORKDIR /app
COPY --from=build /app/out ./

ENTRYPOINT ["dotnet", "MarvinIOTPOC.dll"]

