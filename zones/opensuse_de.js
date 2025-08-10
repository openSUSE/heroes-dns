D("opensuse.de", REG_OPENSUSE,
    SOA        ("@", "ns1.opensuse.org.", "admin.opensuse.org.", 7200, 7200, 1209600, 86400),

    OPENSUSE_PARKING,

    AAAA       ("@",                              "2001:67c:2178:8::16"                                   ),
    A          ("@",                              "195.135.221.140"                                       ),
    AAAA       ("*",                              "2001:67c:2178:8::16"                                   ),
    A          ("*",                              "195.135.221.140"                                       ),

    A          ("test",                           "195.135.221.140"                                       ),

    MX         ("@",                              42, "mx1.opensuse.org."                                 ),
    MX         ("@",                              42, "mx2.opensuse.org."                                 ),

    TXT        ("_dmarc", "v=DMARC1; p=none; pct=100; rua=mailto:admin-auto@opensuse.org!5m; ruf=mailto:admin-auto@opensuse.org!5m", TTL(1800)),
);
