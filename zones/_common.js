var NS_OPENSUSE = [
    NAMESERVER_TTL("12h"),
    NAMESERVER("ns1.opensuse.org."), // NUE-IPX
    NAMESERVER("ns2.opensuse.org."), // PRG2
    NAMESERVER("ns3.opensuse.org."), // SLC1
    NAMESERVER("ns4.opensuse.org."), // PRG2
];

var OPENSUSE_PARKING = [
    SPF_OPENSUSE_NO_MAIL,

    AAAA       ("@",                              "2001:67c:2178:8::16"                                   ),
    A          ("@",                              "195.135.221.140"                                       ),
    AAAA       ("*",                              "2001:67c:2178:8::16"                                   ),
    A          ("*",                              "195.135.221.140"                                       ),

    MX         ("@",                              42, "mx1.opensuse.org."                                 ),
    MX         ("@",                              42, "mx2.opensuse.org."                                 ),
]

DEFAULTS(
    DnsProvider(DSP_OPENSUSE),
    NS_OPENSUSE,
    DefaultTTL(43200),
    IGNORE("_acme-challenge{,.*}", "TXT"),

    SOA        ("@", "ns1.opensuse.org.", "admin.opensuse.org.", 7200, 7200, 1209600, 86400),
);
