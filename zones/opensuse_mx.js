D("opensuse.mx", REG_OPENSUSE,

    SPF_OPENSUSE_TEST,

    AAAA       ("@",                              "2001:67c:2178:8::16"                                   ),
    A          ("@",                              "195.135.221.140"                                       ),
    AAAA       ("*",                              "2001:67c:2178:8::16"                                   ),
    A          ("*",                              "195.135.221.140"                                       ),

    MX         ("@",                              42, "mx1.opensuse.org."                                 ),
    MX         ("@",                              42, "mx2.opensuse.org."                                 ),
);
