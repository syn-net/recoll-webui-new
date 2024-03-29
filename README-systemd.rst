===================================================
Using the standalone Recoll WebUI with systemd
===================================================

This README describes how to configure systemd so that the standalone **Recoll WebUI** application
can run automatically as a systemd service.

Before doing this, ensure that the standalone application runs OK when run from the command line,
and that it is *not* configured to be run as part of an existing web service, e.g. Apache.

Systemd configuration script
============================

A sample systemd unit file for the WebUI application is in examples/recoll-webui.service. This
assumes the following configuration:

- The **Recoll WebUI** application runs as user 'recoll',  with the WebUI source located
  in /home/recoll/recoll-webui.
- The application should listen on the default IP address for the system.
- The application uses port 8080.

If any of these are different for your installation, change the unit file accordingly.

Installing the unit file
===================================

The unit file must be copied to the systemd directory and given the correct
ownership/access. This can be done using: ::

   $ sudo cp examples/recoll-webui.service /etc/systemd/system/recoll-webui.service
   $ sudo chown root /etc/systemd/system/recoll-webui.service
   $ sudo chmod 644 /etc/systemd/system/recoll-webui.service


Starting the WebUI service
==========================

To start the WebUI service do: ::

  $ sudo systemctl start recoll-webui

This does a one-time start of the service. If you want to automatically start the  
service at boot, also do: ::

  $ sudo systemctl enable recoll-webui


Checking the status of the WebUI service
========================================

Check the status of the WebUI service with: ::

  $ sudo systemctl status recoll-webui

If it is running you should see output similar to this: ::

    recoll-webui.service - Recoll Search WebUI
       Loaded: loaded (/etc/systemd/system/recoll-webui.service; enabled; vendor preset: disabled)
       Active: active (running) since Fri 2016-10-07 08:46:00 EDT; 1 day 12h ago
      Process: 16278 ExecStop=/bin/kill -SIGINT $MAINPID (code=exited, status=0/SUCCESS)
     Main PID: 16281 (python)
       CGroup: /system.slice/recoll-webui.service
               └─16281 python /home/recoll/recoll-webui/webui-standalone.py -a myhost -p 8080

This shows the status of the standalone application, along with the command line that
was used. 


Stopping the WebUI service
==========================

To stop the WebUI service do: ::

    $ sudo systemctl stop recoll-webui

To disable the service so it does not run at boot time do: ::

    $ sudo systemctl disable recoll-webui


Restarting the WebUI service
============================

The WebUI configuration script is set to automatically restart the 
standalone application if it fails. You can also manually restart it using: ::

    $ sudo systemctl restart recoll-webui
