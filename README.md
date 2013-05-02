Foreman CLI design draft
========================

This is my attempt to create outline of CLI client for the Foreman. The Foreman project has Ruby as its main langauage, so I choosed to explore the options Ruby world is offering to complete this task.

My initial requirements are as follows:

 - [x] implemented in Ruby
 - [x] Git-like subcomands in CLI app
 - [x] system shell autocompletion of commands and options
 - [x] shell-like environment with autocompletion and history where the commands can be run directly
 - [x] commands extensible via plugins
 - [x] some way to wrap current Katello CLI commands and make it possible to have one CLI client for both
 - [x] simillar UX as from katello CLI

 All the requirements were addressed by the design. Though there is plenty of room for clean up and optimisation, the draft can serve as a proof of concept.


Design
------

![Design draft](design.png)

As the diagram shows, the CLI consist of almost generic framework (shell-like environment, autocompletion, command help text, option evaluation and command invocation) and set of plugins defining the actual commands. This setup is flexible and allows us to easily install different sets of commands for different products. The plugins are independant and can implement any action as an command, so that besides commands calling Foreman API you can have commands calling varius admin tasks on the server, etc.

For real implementation of the plugins there would need to be some decision taken on how to approach the development of the actual commands.

For *Katello* commands, there can be great deal of work done automatically (using Katello CLI autocompletion feature and templates). However calling Katello CLI via system call is not ideal solution and should be replaced by direct calls to Katello API in the future.

For *Foreman* Commands development I can see three options
 - generate and sync some generic CLI commands (apipie approach) with option to inherit and redefine individual commands
 - manually create everything (Katello CLI approach)
 - dynamic creation on the fly with option to exclude and manually define specific commands

Sample working implementation you can find in this repo.

 - [kartit] (https://github.com/mbacovsky/foreman_cli_draft/tree/master/kartit) gem contains generic CLI client
 - [kartit-foreman] (https://github.com/mbacovsky/foreman_cli_draft/tree/master/kartit-foreman) gem contains Foreman related commands definition
 - [kartit-katello] (https://github.com/mbacovsky/foreman_cli_draft/tree/master/kartit-katello) gem contains Katello related commands definition

Technologies
------------

### CLI Framework

There is plenty of CLI framework gems with varying features and quality on the Internet. I took into consideration [Thor][thor] for its wide spread, [Boson][boson] for its features being very close to our requirements and [Clamp][clamp] for its simplicity.

#### Thor
has well docummented features and good suport in the community. However the codebase was for me quite cryptic and really dificult to understand and extend. It seems good when you need what is built in. If you need something extra adding is time consuming or requires skills beyond mine.

#### Boson
has good documentation, nice set of plugins available, live upstream and what makes it special for us is built in shell with autocompletion.
What put it out of the game is lack of subcommands.

#### Clamp
besides similar features as Thor has it has minimalistic, clean and straghtforward codebase. It uses one class per command which can come handy if you need similar behavior for subset of commands. It was quite easy to add autocompletion and shell. And yes it is the winner for my CLI draft.


### Shell
For shell there is not so much options. There is IRB and similar like Ripl but I started with minimalistic and Readline. It went quite smooth so I  kept it and didn't tried the others


### Autocompletion
I wanted to have one solution for Bash and shell autocompletion and started with simple method recursively looking for endings in command tree. Simple bash wrapper call made it ready for use in bash. In shell-like env based on Readline I had dificulties with the fact that readline support autocompletion based on last word and there is no apparent way to take the context into account. I found some workaround but still looking for cleaner solution. Maybe Ripl + Bond are worth trying


### Input/Output
I didn't focus much on processing of input and output in the commands yet. For Foreman commands I'd like to keep it as similar to Katello output as possible. There are gems like highline and [table_print][table-p] that could make it easy.


Usage
-----
And here follows short demo of the features this CLI draft offers

### Help

    $ kartit -u admin -p admin -h
    Usage:
        kartit [OPTIONS] SUBCOMMAND [ARGS] ...

    Subcommands:
        shell                         Interactive Shell
        architecture                  Manipulate Foreman's architectures.
        environment                   Manipulate Katello's environments.
        ping                          Get the status of the katello server

    Options:
        -v, --verbose                 be verbose
        -u, --username USERNAME       username to access the remote system
        -p, --password PASSWORD       password to access the remote system
        --version                     show version
        --autocomplete LINE           Get list of possible endings
        -h, --help                    print help


    $ kartit -u admin -p admin architecture -h
    Usage:
        kartit architecture [OPTIONS] SUBCOMMAND [ARGS] ...

    Subcommands:
        list                          List foreman's architectures.

    Options:
        -h, --help                    print help


### Foreman call

As it was said above output formating for foreman commands is still missing and will be added later

    $ kartit -u admin -p admin architecture list
    [
        [0] {
            "architecture" => {
                               "name" => "i386",
                                 "id" => 5,
                         "created_at" => "2012-06-27T17:21:16Z",
                "operatingsystem_ids" => [],
                         "updated_at" => "2012-06-27T17:21:16Z"
            }
        },
        [1] {
            "architecture" => {
                               "name" => "ppc",
                                 "id" => 9,
                         "created_at" => "2012-07-31T12:19:26Z",
                "operatingsystem_ids" => [],
                         "updated_at" => "2012-07-31T12:19:26Z"
            }
        },
        [2] {
            "architecture" => {
                               "name" => "x86_64",
                                 "id" => 14,
                         "created_at" => "2012-08-06T15:51:21Z",
                "operatingsystem_ids" => [],
                         "updated_at" => "2012-08-06T15:51:21Z"
            }
        }
    ]


### Katello call

    $ kartit -u admin -p admin environment list --org ACME_Corporation
    katello -u admin -p admin environment list --org ACME_Corporation
    ------------------------------------------------------------------------------------------------------------
                                              Environment List

    ID Name    Label   Description Org              Prior Environment
    ------------------------------------------------------------------------------------------------------------
    1  Library Library None        ACME_Corporation None
    2  Dev     Dev     None        ACME_Corporation Library
    3  Prod    Prod    None        ACME_Corporation Dev

### Autocompletion

    $ kartit architecture
    -h      --help  list
    $ kartit architecture list -
    -h      --help

### Shell

    $ kartit -u admin -p admin shell
    kartit> -h
    Usage:
        kartit [OPTIONS] SUBCOMMAND [ARGS] ...

    Subcommands:
        shell                         Interactive Shell
        architecture                  Manipulate Foreman's architectures.
        environment                   Manipulate Katello's environments.
        ping                          Get the status of the katello server

    Options:
        -v, --verbose                 be verbose
        -u, --username USERNAME       username to access the remote system
        -p, --password PASSWORD       password to access the remote system
        --version                     show version
        --autocomplete LINE           Get list of possible endings
        -h, --help                    print help
    kartit> ping
    katello -u admin -p admin ping
    -----------------------------------------------------------------------------------------------------------
                                                  Katello Status

    Status Service        Result Duration Message
    -----------------------------------------------------------------------------------------------------------

    FAIL
    candlepin      ok     141ms
    candlepin_auth ok     225ms
    elasticsearch  ok     795ms
    katello_jobs   FAIL   katello-jobs service not running
    pulp           ok     1706ms
    pulp_auth      ok     618ms


[cli-gems]: http://www.awesomecommandlineapps.com/gems.html "CLI related gems"
[thor]:  https://github.com/wycats/thor "Thor homepage"
[boson]: https://github.com/cldwalker/boson "Boson homepage"
[clamp]: https://github.com/mdub/clamp "Clamp homepage"
[table-p]: https://github.com/arches/table_print "table-print homepage"
