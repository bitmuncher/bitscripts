#!/usr/bin/env python

import sys
import logging
import re

log_level = "INFO"

def find_iban(check_string):
    country2length = {
        "FO":18, "FI":18, "FR":27, "GE":22, "DE":22, "GI":23, "GR":27, "GL":18,
        "AL":28, "AD":24, "AT":20, "AZ":28, "BE":16, "BH":22, "BA":20, "BR":29,
        "BG":22, "CR":21, "HR":21, "CY":28, "CZ":24, "DK":18, "DO":28, "EE":20,
        "GT":28, "HU":28, "IS":26, "IE":22, "IL":23, "IT":27, "KZ":20, "KW":30,
        "LV":21, "LB":28, "LI":21, "LT":20, "LU":20, "MK":19, "MT":31, "MR":27,
        "MU":30, "MC":27, "MD":24, "ME":22, "NL":18, "NO":15, "PK":24, "PS":29,
        "PL":28, "PT":25, "RO":24, "SM":27, "SA":24, "RS":22, "SK":24, "SI":19,
        "ES":24, "SE":24, "CH":21, "TN":24, "TR":26, "AE":23, "GB":22, "VG":24,
        "DZ":26, "AO":25, "BJ":28, "BF":28, "BI":16, "CM":27, "CV":25, "CF":27,
        "TD":27, "KM":27, "CG":27, "DJ":27, "GQ":27, "GA":27, "GW":25, "HN":28,
        "IR":26, "CI":28, "MG":27, "ML":28, "MA":28, "MZ":25, "NI":32, "NE":28,
        "SN":28, "TG":28 }

    logging.debug("Checking for IBAN. Input: " + check_string)

    # first let's see if we have 2 characters followed by at least 2 digits
    match = re.search('[a-zA-Z]{2}\d{2,}', check_string)
    if not match:
        logging.debug("Seems not to contain an IBAN ...")
        return False
    else:
        logging.debug("Could contain an IBAN: " + match.group(0))

    # now let's see if the first 2 characters are a country code from our dictionary above 
    country = "None"
    if match.group(0)[:2] in country2length:
        country = match.group(0)[:2]
    if country == "None":
        logging.debug("No valid country code found for IBAN.")
        return False
    else:
        logging.debug("Found a country code: " + country)

    # and finally let's see if the number of digits correlates with the length of the IBAN that we expect for the country
    if len(match.group(0)) != country2length[country]:
        logging.debug("Length of the string doesn't match the expected length for the country.")
        return False
    return True

def main(argv):
  format = "%(asctime)s: %(message)s"
  logging.basicConfig(format=format, level=log_level, datefmt="%H:%M:%S")

  if find_iban(' '.join(sys.argv[1:])) == True:
      print("IBAN found!")
  else:
      print("No IBAN.")

if __name__ == '__main__':
    main(sys.argv[1:])
