D("opensuse.pk", REG_OPENSUSE,
    SOA        ("@", "a.misconfigured.dns.server.invalid.", "hostmaster.opensuse.pk.", 10800, 3600, 604800, 3600, TTL(3600)),

    DefaultTTL (86400),

    SPF_OPENSUSE_MISC,

    AAAA       ("@",                              "2001:67c:2178:8::16"                                   ),
    A          ("@",                              "195.135.221.140"                                       ),
    AAAA       ("*",                              "2001:67c:2178:8::16"                                   ),
    A          ("*",                              "195.135.221.140"                                       ),

    MX         ("@",                              42, "mx1.opensuse.org."                                 ),
    MX         ("@",                              42, "mx2.opensuse.org."                                 ),
);
