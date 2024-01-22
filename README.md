# bitscripts

**Scripts, configurations and other stuff**

*bashrc*  

This is my bash configuration. It's intended to use on macOS and requires [Homebrew](https://brew.sh "Homebrew Homepage").

*gpt-cli.py*

A very simple script to query ChatGPT via API using the model 'gpt-3.5-turbo-1106'. It asks for a context and a question and prints out the response from ChatGPT. You must specify your API key in environment variable 'GPT_API_KEY' if your shell environment (for example in Bash via `export GPT_API_key=sk-<yourkey>`. You can get additional output for debugging by using `-d` or `--debug` as a parameter for the script.

*ibancheck.py*  

Initially I wrote the function used here in a script for [Personio](https://www.personio.com "Personio's Homepage") that checks the content of log files for PII.  
You can pass a string as parameter to check if the string contains an IBAN. Or you pass only the IBAN to check if it's valid. Like this:  
`ibancheck.py "DE123456789012345678900"`  
`ibancheck.py "foobar DE123456789012345678900 blabla"`  
`ibancheck.py "foobarDE123456789012345678900blabla"`  
This ensured that any logged PII was quickly removed from the logs and, of course, we informed the responsible developers that they needed to adjust their logging.

*gpg_droplet.applescript*  

This droplet was used on a dedicated machine by a newspaper publisher to decrypt whistleblower leaks that were encrypted using GPG to protect them while transport.

*Default.bttpreset*  

My configuration for [BetterTouchTool](https://folivora.ai "Homepage of BetterTouchTool") to modify the touchbar on my Mac. It contains nice colored buttons to switch the connections of my AirPods to my MacBook if they are currently connected to my iPhone or iPad, to open the Launchpad, the control center and the screenshot tool and to adjust monitor brightness and volume settings. 

*git_pull_all_branches.sh*  

A simple Bash script to fetch all remote branches for a Git repository.

*curses_color_codes.py*

Print color codes used by (n)curses in a 256-color terminal.
