# GREP Command Cheat Sheet

```bash
# -v : Invert match, shows lines that do NOT contain the keyword
grep -v "keyword" filename

# -i : Case-insensitive search
grep -i "cindy" filename

# -c : Count the number of lines that match the keyword
grep -c "keyword" filename

# -w : Search for exact whole word match
grep -w "keyword" filename

# -n : Show line numbers of matching lines
grep -n "keyword" filename

# -B 2 -A 2 : Show 2 lines Before and After the matching line
grep -B 2 -A 2 "keyword" filename

# seach a keyword in multiple files
grep "keyword" file1 file2

# -h : Suppress filename in output when searching multiple files
grep -h "keyword" file1 file2

# Using egrep (or grep -E) with multiple patterns
egrep "AAA|BBB|CCC" filename

# OR using grep -e
grep -e "AAA|BBB|CCC" filename

# -l : Only print the filenames that contain the keyword
grep -l "keyword" filename

# Compare keyword in one file and match with another
grep -f keywords.txt targetfile.txt

# ^keyword : Match lines that start with keyword
grep "^keyword" filename

# keyword$ : Match lines that end with keyword
grep "keyword$" filename

# -R : Recursive search in all files under directory
grep -R "IMF" directory/

# -q : Quiet mode, suppress output, search but dont print (used in scripting to check if match exists)
grep -q "keyword" filename

# -s : Suppress error messages for nonexistent or unreadable files
grep -s "keyword" filename

# pgrep : Search for running processes (used to find process ID by name)
pgrep process_name

# fgrep : Search for fixed string (no regex, treats metacharacters as normal text)
fgrep "AA*BB?CC" filename

# zgrep : Search within compressed .gz files
zgrep "keyword" compressedfile.gz

# pdfgrep : Search inside PDF files
pdfgrep "keyword" filename.pdfq
