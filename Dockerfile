# Étape 1 : Utiliser l'image SDK de .NET 5.0 pour la compilation
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /app

# Copier le fichier .csproj et restaurer les dépendances
COPY *.csproj ./
RUN dotnet restore

# Copier les fichiers sources de l'application et les compiler
COPY . ./
RUN dotnet publish -c Release -o out

# Étape 2 : Utiliser l'image runtime de .NET 5.0 pour exécuter l'application
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS runtime
WORKDIR /app

# Copier les fichiers compilés depuis l'étape de build
COPY --from=build /app/out .

# Spécifier le port d'écoute de l'application dans le conteneur
EXPOSE 80

# Définir le point d'entrée pour lancer l'application .NET
ENTRYPOINT ["dotnet", "MyDotNetApp.dll"]
