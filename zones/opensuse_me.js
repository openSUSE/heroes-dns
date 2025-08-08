D("opensuse.me", REG_OPENSUSE,
    SOA("@", "ns1.opensuse.org.", "admin.opensuse.org.", 7200, 7200, 1209600, 86400),
    AAAA("*", "2001:67c:2178:8::16"),
    A("*", "195.135.221.140"),
    AAAA("@", "2001:67c:2178:8::16"),
    TXT("@", "v=spf1 -all", TTL(300)),
    A("@", "195.135.221.140"),
);
