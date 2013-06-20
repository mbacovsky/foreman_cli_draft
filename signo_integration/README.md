Signo integration
=================

![Design draft](oauth_sequence.png)



User stories
------------

* As a CLI user I would like to use Signo for authentication
* As a CLI user I would like to choose from multiple secrets to sign my request
* As a CLI user I would like to have set the last requested secret as a default
* As a CLI user I would like to set the default secret
* As a CLI user I would like to see list of my secrets with their expiration and issue dates
* As a CLI user I would like to set expiration in the request (e.g. longer for cron jobs)
* As a CLI user I would like to limit scope of actions the secret authorizes me to do
* As a CLI user I would like to be able to disable the secret
* As a CLI user I would like to be able to remove expired secrets
* As a Signo user I would like to see all my secrets via Web UI
* As a Signo user I would like to disable particular secret via Web UI
* As a Signo user I would like to create secret via WebUI
* As a CLI user I would like to use secret created in WebUI (sync/store?)


Things to solve
---------------

* How to handle attempt to auth with invalid cert? (error/try to get new secret)
* Shouldn't we disable passing passwords as a parameter on commandline? What use cases it could brake? UX?
* How to protect stored secrets on client?
