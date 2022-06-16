============
Recoll WebUI
============

This (https://framagit.org/medoc92/recollwebui) is an updated clone of
Koniu's original version on GitHub (https://github.com/koniu/recoll-webui),
which has not been updated lately, and is now slightly obsolete.

As compared to the original, this version has an additional dependancy when
running the webui-standalone.py server (i.e. not with apache): it uses the
python3-waitress module which must be installed. This makes
webui-standalone quite suitable for moderate multiaccess loads with no
authentication needs.

An updated version of the original doc follows.


**Recoll WebUI** is a Python-based web interface for the **Recoll** text search
tool for Unix/Linux.

.. image:: http://i.imgur.com/n8qTnBg.png

* WebUI homepage: https://framagit.org/medoc92/recollwebui
* Recoll homepage: http://www.lesbonscomptes.com/recoll
* Original WebUI homepage: https://github.com/koniu/recoll-webui

Requirements
============

All you need to use the WebUI is:

* Python 3. On Windows you currently need Python 3.7 because this is what
  the Recoll extension module is built with.
* The Python waitress package. You can remove this dependance and run with
  the internal bottle server by editing webui-standalone.py
* Recoll 1.20+ and the Recoll Python3 extension (e.g. the python3-recoll package on Debian-derived
  systems).
* A WEB browser


Usage
=====

**Recoll WebUI** can be used as a standalone application or through a web server via
WSGI/CGI. Regardless of the mode of operation you need Recoll to be configured on your system as the
WebUI only provides a front-end for searching and does not handle index configuration etc.

Run standalone
--------------

Run ``webui-standalone.py`` and connect to ``http://localhost:8080``.

There's some optional command-line arguments available::

    -h, --help            show this help message and exit
    -a ADDR, --addr ADDR  address to bind to [127.0.0.1]
    -p PORT, --port PORT  port to listen on [8080]
    -c CONFDIR, --config CONFDIR Recoll configuration directory to use

The standalone application can be configured to run automatically using systemd. See the file
`README-systemd.rst <README-systemd.rst>`_.

Environment variables:

- `RECOLL_CONFDIR` the recoll configuration directory. This is overriden by a -c option.
- `RECOLL_EXTRACONFDIRS` a space-separated list of external indexes to query in addition to the main
  one.


Run as WSGI/CGI
---------------

See the following link for a complete run-through:

https://www.lesbonscomptes.com/recoll/pages/recoll-webui-install-wsgi.html

Example WSGI/Apache2 config, assuming that the code is in /var/recoll-webui-master::

        WSGIDaemonProcess recoll user=recoll group=recoll threads=5 display-name=%{GROUP} python-path=/var/recoll-webui-master
        WSGIScriptAlias /recoll /var/recoll-webui-master/webui-wsgi.py
        <Directory /var/recoll-webui-master>
                WSGIProcessGroup recoll
                Order allow,deny
                allow from all
        </Directory>

Remarks:

* Without "python-path=" you might see errors that it can't import webui 
* Run the WSGIDaemonProcess run under the username (user=xyz) of the user
  that you want to have exposed via web.


User configuration defaults
---------------------------

New on 2022-06-15.

There are a number of parameters with initial defaults which the user can change through a Web
interface page (by clicking the `Settings` button), and which are persisted in a cookie.

Some of the initial defaults may not be appropriate for your configuration. For example the default
depth of 2 for building the directory selection tree may be too much on a big data set (and cause
initialisation errors).

The initial defaults can be changed by setting values in the main recoll configuration file
($RECOLL_CONFDIR/recoll.conf):

- webui_context (30) the size of the abstract snippets in words.
- webui_maxchars (500) total maximum size for the abstract shown with each result.
- webui_stem (1) queries will use stemming (or not).
- webui_timefmt (%c) format of the time display.
- webui_dirdepth (2) depth of the directory selection tree. Beware if your data set has many
  directories.
- webui_maxresults (0) limit the number of results (0 means no limit).
- webui_perpage (25) number of results per page.
- webui_csvfields (filename title author size time mtype url) fields extracted in CSV or JSON dumps.
- webui_title_link (download) action performed if you click the result title (or 'open', 'preview').


Running the indexer
-------------------

Example user Crontab entry to have the indexer at least once a day::

        22 5    * * *   /usr/bin/recollindex



Issues
======

Can't open files when Recoll WebUI is running on a server
---------------------------------------------------------
By default links to files in the result list correspond to the file's
physical location on the server. If you have access to the file tree
via a local mountpoint or eg. ftp/http you can provide replacement
URLs in the WebUI settings. If in doubt, ask your network administrator.

Opening files via local links
-----------------------------
For security reasons modern browsers prevent linking to local content from
'remote' pages. As a result URLs starting with file:// will not, by default,
be opened when linked from anything else than pages in file:// or when
accessed directly from the address bar. Here's ways of working around it:

Firefox
~~~~~~~
1. Insert contents of ``examples/firefox-user.js`` into
   ``~/.mozilla/firefox/<profile>/user.js``
2. Restart Firefox

Chrom{e,ium}
~~~~~~~~~~~~
Install *LocalLinks* extension:

* http://code.google.com/p/locallinks/
* https://chrome.google.com/webstore/detail/locallinks/jllpkdkcdjndhggodimiphkghogcpida

Opera
~~~~~
1. Copy ``examples/opera-open.sh`` into your PATH (eg. ``/usr/local/bin``)
2. Go to ``Tools > Preferences > Advanced > Programs > Add``
3. In ``Protocol`` field enter ``local-file``
4. Select ``Open with other application`` and enter ``opera-open.sh``
5. In WebUI settings replace all ``file://`` with ``local-file://``
