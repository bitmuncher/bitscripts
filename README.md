# bitscripts

**Scripts, configurations and other stuff**

*bashrc*  
This is my bash configuration. It's intended to use on macOS and requires [Homebrew](https://brew.sh "Homebrew Homepage").

*ibancheck.py*  
Initially I wrote the function used here in a script for [Personio](https://www.personio.com "Personio's Homepage") that checks the content of log files for PII.  
You can pass a string as parameter to check if the string contains an IBAN. Or you pass only the IBAN to check if it's valid. Like this:  
`ibancheck.py "DE123456789012345678900"`  
`ibancheck.py "foobar DE123456789012345678900 blabla"`  
`ibancheck.py "foobarDE123456789012345678900blabla"`  
This ensured that any logged PII was quickly removed from the logs and, of course, we informed the responsible developers that they needed to adjust their logging.