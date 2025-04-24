ASCII_PATTERN_FILE_VERSION = 2;


SETUP = 

    declare input bus "PI" = "/a", "/b", "/c", "/d", "/e";

    declare output bus "PO" = "/z";

end;

SCAN_TEST =

    pattern = 0;
    force   "PI" "00110" 0;
    measure "PO" "1" 1;

end;

