var NS_OPENSUSE = [
    NAMESERVER_TTL("12h"),
    NAMESERVER("ns1.opensuse.org."), // NUE-IPX
    NAMESERVER("ns2.opensuse.org."), // PRG2
    NAMESERVER("ns3.opensuse.org."), // SLC1
    NAMESERVER("ns4.opensuse.org."), // PRG2
];

var OPENSUSE_PARKING_EXCEPT_SPF = [
    AAAA       ("@",                              "2a07:de40:b27e:1204::10"                               ),
    A          ("@",                              "195.135.223.50"                                        ),

    CNAME      ("*",                              "redirector.opensuse.org."                              ),

    MX         ("@",                              42, "mx1.opensuse.org."                                 ),
    MX         ("@",                              42, "mx2.opensuse.org."                                 ),
]

var OPENSUSE_PARKING = [
    OPENSUSE_PARKING_EXCEPT_SPF,

    SPF_OPENSUSE_NO_MAIL,
]

DEFAULTS(
    DnsProvider(DSP_OPENSUSE),
    NS_OPENSUSE,
    DefaultTTL(43200),
    IGNORE("_acme-challenge{,.*}", "TXT"),

    SOA        ("@", "ns1.opensuse.org.", "admin.opensuse.org.", 7200, 7200, 1209600, 86400),
);
