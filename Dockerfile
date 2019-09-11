FROM mcr.microsoft.com/windows/servercore:1903

SHELL [ "powershell" ]

RUN wget \
    https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u222-b10/OpenJDK8U-jre_x64_windows_hotspot_8u222b10.msi \
    -O $env:TEMP\openjre.msi
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
