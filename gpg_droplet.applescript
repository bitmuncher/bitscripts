-- add this script to your Applescript Editor and export it as an Application

property type_list : {"ASC", "GPG"}
property extension_list : {"ASC", "GPG"}

property post_alert : "Yes"
property passphrase : ""

on run
	return "done"
end run

on open these_items
	repeat with i from 1 to the count of these_items
		set this_item to item i of these_items
		set the item_info to info for this_item
		set this_name to the name of the item_info
		set this_file to POSIX path of this_item
		try
			set this_extension to the name extension of item_info
		on error
			set this_extension to ""
		end try
		try
			set this_filetype to the file type of item_info
		on error
			set this_filetype to ""
		end try
		if (folder of the item_info is false) and (alias of the item_info is false) and ((this_filetype is in the type_list) or (this_extension is in the extension_list)) then
			process_item(this_file)
		else if post_alert is "Yes" then
			display alert "PROCESSING ALERT" message "The item “" & this_name & "” is not a file that this droplet can process." buttons {"Cancel", "Continue"} default button 2 cancel button "Cancel" as warning
		end if
	end repeat
end open

on process_item(this_item)
	display dialog "Please enter your passphrase:" default answer passphrase with hidden answer
	set the passphrase to text returned of the result
	do shell script ("echo " & passphrase & " | /usr/local/bin/gpg --batch --passphrase-fd -d " & this_item)
end process_item
