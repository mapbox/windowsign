windowsign
==========
Sign a windows executable from linux. Requires a code signing certificate.

    sudo apt-get install -y mono-devel expect
    npm install -g https://github.com/mapbox/windowsign

    N=MyApp \
    I=https://www.mapbox.com \
    P=certpass \
    SPC=authenticode.spc \
    PVK=authenticode.pvk \
    windowsign file.exe
