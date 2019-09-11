FROM mcr.microsoft.com/windows/servercore:1903

SHELL [ "powershell" ]

# See https://github.com/AdoptOpenJDK/openjdk-installer/tree/master/wix for
# OpenJDK installer options.
RUN wget \
    https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u222-b10/OpenJDK8U-jre_x64_windows_hotspot_8u222b10.msi \
    -O $env:TEMP\openjre.msi
RUN if ((Get-FileHash $env:TEMP\openjre.msi -Algorithm SHA256).Hash -ne \
    '54A97F9065C3C741C0D816425BCFC31A69042001BDFD30F8B16B9369441A61B6') { exit 1 }
RUN Start-Process -FilePath msiexec.exe \
    -ArgumentList \
        '/i', $env:TEMP\openjre.msi, \
        '/L*V', $env:TEMP\openjre-msi.log, \
        '/quiet', \
        'ADDLOCAL=FeatureEnvironment,FeatureJarFileRunWith,FeatureJavaHome' \
    -Wait \
    -Passthru

RUN Remove-Item $env:TEMP\openjre.msi
RUN Remove-Item $env:TEMP\openjre-msi.log
