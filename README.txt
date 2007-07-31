README for echi_converter
==========================
ECHI Converter - The Binary to ASCII converter for Avaya CMS External Call History files

--- background ---

See more info on the Avaya ECHI format here (note, these overviews are version specific):

http://support.avaya.com/elmodocs2/cms/R12/ECHI.pdf

--- command ---

Usage: ruby echi-converter-daemon.rb <command> <options> -- <application options>

* where <command> is one of:
  start         start an instance of the application
  stop          stop all instances of the application
  restart       stop all instances and restart them afterwards
  run           start the application and stay on top
  zap           set the application to a stopped state

* and where <options> may contain several of the following:

    -t, --ontop                      Stay on top (does not daemonize)
    -f, --force                      Force operation

Common options:
    -h, --help                       Show this message
        --version                    Show version

--- overview ---

Blah, blah here