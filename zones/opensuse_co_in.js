D("opensuse.co.in", REG_OPENSUSE,
    SOA        ("@", "a.misconfigured.dns.server.invalid.", "hostmaster.opensuse.co.in.", 10800, 3600, 604800, 3600, TTL(3600)),

    DefaultTTL (86400),

    MX         ("@",                              42, "mx1.opensuse.org."                                 ),
    MX         ("@",                              42, "mx2.opensuse.org."                                 ),

    TXT        ("@", "v=spf1 ip4:91.193.113.64/27 ip4:143.186.213.0/24 ip4:147.2.0.0/16 ip4:149.44.0.0/16 ip4:195.135.220.0/23 ip6:2001:67c:2178::/48 ip6:2620:113:8044::/48 ip6:2a01:138:a004::/48 ip6:2a07:de40:401::/48 mx ~all"),
);
