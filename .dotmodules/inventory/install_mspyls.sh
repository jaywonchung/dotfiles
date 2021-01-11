#!/bin/bash

# pyls_ms: https://github.com/microsoft/python-language-server/blob/master/CONTRIBUTING.md

# Get the Dotnet 3.1 SDK binary
cd "$HOME/Downloads"
curl -LO https://download.visualstudio.microsoft.com/download/pr/fadf4d6d-791a-4312-940b-bde9bd32d5e2/d7ebb3507851711d084075437ce62796/dotnet-sdk-3.1.404-osx-x64.pkg

echo Install the dotnet package and run the following:
echo    git clone --depth=1 https://github.com/microsoft/python-language-server.git ~/.local/python-language-server
echo    cd ~/.local/python-language-server/src/LanguageServer/Impl
echo    dotnet build
