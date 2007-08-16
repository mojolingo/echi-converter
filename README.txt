README for echi_converter
==========================
ECHI Converter - The Binary to ASCII converter for Avaya CMS External Call History files

--- background ---

See more info on the Avaya ECHI format here (note, these overviews are version specific):

http://support.avaya.com/elmodocs2/cms/R12/ECHI.pdf

--- command ---

Usage: 

# echi-converter create myproject - create the local project to run the ECHI converter from
# echi-converter upgrade myproject - location of project to upgrade after a new gem is installed

# echi-converter run myproject - Run the ECHI converter interactively from the location given
# echi-converter start myproject - Start the ECHI converter in daemon mode from the location given
# echi-converter stop myproject - Stop the ECHI converter daemon
# echi-converter restart myproject - Restart the ECHI converter 
# echi-converter zap myrpoject - If there has been an unexpected close and the system still thinks the converter is running, clean up the pid files

--- overview ---

More to come...