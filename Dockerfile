FROM microsoft/windowsservercore:1803 AS Core
LABEL maintainer="A.Nishida <nisida@ouk.jp>"

ENV NPM_CONFIG_LOGLEVEL info
ENV NODE_VERSION 10.7.0
ENV NODE_SHA256 62cf806d164cf6bd57c1ec2cac991c573bc956ff3e674be68115eaf4aac4fea4  

RUN powershell -Command \
    wget -Uri https://nodejs.org/dist/v%NODE_VERSION%/node-v%NODE_VERSION%-x64.msi -OutFile node.msi -UseBasicParsing ; \
    if ((Get-FileHash node.msi -Algorithm sha256).Hash -ne $env:NODE_SHA256) {exit 1} ; \
    Start-Process -FilePath msiexec -ArgumentList /q, /i, node.msi -Wait ; \
    Remove-Item -Path node.msi

FROM microsoft/nanoserver:1803
COPY --from=Core [ "/Program Files/nodejs", "/windows/system32" ]
CMD [ "node.exe" ]