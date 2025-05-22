Source: glass
Section: net
Priority: optional
Maintainer: open-trade <glass@qompass.ai>
Build-Depends: debhelper (>= 10), pkg-config
Standards-Version: 4.5.0
Homepage: https://qompass.ai/glass

Package: glass-hbbs
Architecture: {{ ARCH }}
Depends: systemd ${misc:Depends}
Description: Qompass AI Glass Server
 Self-host your own Qompass AI Glass server, it is free and open source.

Package: glass-hbbr
Architecture: {{ ARCH }}
Depends: systemd ${misc:Depends}
Description: Qompass AI Glass Server
 Self-host your own Qompass AI Glass Server. 
 This package contains the Qompass AI Glass relay server.

Package: glass-utils
Architecture: {{ ARCH }}
Depends: ${misc:Depends}
Description: Qompass AI Glass server
 Self-host your own Qompass AI Glass server.
 This package contains the glass-utils binary.
