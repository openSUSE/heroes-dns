D("opensuse.co.in", REG_OPENSUSE,
    SOA        ("@", "a.misconfigured.dns.server.invalid.", "hostmaster.opensuse.co.in.", 10800, 3600, 604800, 3600, TTL(3600)),

    DefaultTTL (86400),

    SPF_OPENSUSE_MISC,

    MX         ("@",                              42, "mx1.opensuse.org."                                 ),
    MX         ("@",                              42, "mx2.opensuse.org."                                 ),
);
