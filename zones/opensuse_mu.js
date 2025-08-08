D("opensuse.mu", REG_OPENSUSE,
    SOA        ("@", "ns1.opensuse.org.", "admin.opensuse.org.", 7200, 7200, 1209600, 86400, TTL(43200)),

    DefaultTTL (86400),

    AAAA       ("@",                              "2c0f:e8f8:2000:233::125d:530a"                         ),
    A          ("@",                              "102.222.106.230",                            TTL(43200)),
    AAAA       ("*",                              "2c0f:e8f8:2000:233::125d:530a"                         ),
    A          ("*",                              "102.222.106.230"                                       ),

    A          ("mirror.kaldera",                 "169.255.161.244"                                       ),
    A          ("mirror.rcts",                    "196.46.61.247"                                         ),

    TXT        ("@",                              "v=spf1 -all",                                TTL(300)  ),
);
