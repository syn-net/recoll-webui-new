#!/usr/bin/python3

import os

#
# Possibly adjust the PATH (e.g. add /usr/local/bin on bsd)
#os.environ['PATH'] = os.environ['PATH'] + ':' + '/usr/local/bin'

#
# Possibly designate the recoll configuration directory, for the case
# where tilde expansion does not work in the web server context. Make
# sure that the location and files are readable by the web server user
#os.environ['RECOLL_CONFDIR'] = '/path/to/recoll/configdir'

# change to webui's directory and set up
os.chdir(os.path.dirname(__file__))
import webui
application = webui.bottle.default_app()
