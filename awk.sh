# AWK Command Cheat Sheet

```bash
# Print the first column from mylog file
awk '{print $1}' mylog

# Print the 1st, 2nd, and 4th columns from mylog
awk '{print $1, $2, $4}' mylog

# Print 1st, 42nd, 43rd, and 5th fields from lines containing "INFO"
awk '/INFO/ {print $1, $42, $43, $5}' mylog > only_by_info.txt

# Count lines that contain "INFO"
awk '/INFO/ {count++} END {print count}' mylog

# Count and print number of lines with "INFO" and a custom message
awk '/INFO/ {count++} END {print "Count:", count}' mylog

# Print lines where second column (time) is between "08:53:00" and "08:53:59"
awk '$2 >= "08:53:00" && $2 <= "08:53:59" {print $2, $3, $4}' app.log

# Print lines between line numbers 2 and 10 (inclusive)
awk 'NR >= 2 && NR <= 10' mylog

# Format CSV: Print first and third columns
awk -F, '{print $1, $3}' file.csv

# Format TSV: Print second and fifth columns
awk -F'\t' '{print $2, $5}' file.tsv
