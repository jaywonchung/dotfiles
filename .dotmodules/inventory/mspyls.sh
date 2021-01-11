#!/bin/bash

# pyls_ms: https://github.com/microsoft/python-language-server/blob/master/CONTRIBUTING.md

# Get the Dotnet 3.1 SDK binary
cd /tmp
curl -LO https://download.visualstudio.microsoft.com/download/pr/f01e3d97-c1c3-4635-bc77-0c893be36820/6ec6acabc22468c6cc68b61625b14a7d/dotnet-sdk-3.1.402-linux-x64.tar.gz
mkdir -p ~/.local/dotnet
tar xvzf dotnet-sdk-3.1.402-linux-x64.tar.gz -C ~/.local/dotnet
ln -s ~/.local/dotnet/dotnet ~/.local/bin/dotnet

# Build mypyls
git clone --depth=1 https://github.com/microsoft/python-language-server.git ~/.local/python-language-server
cd ~/.local/python-language-server/src/LanguageServer/Impl
dotnet build
