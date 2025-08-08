var NS_OPENSUSE = [
    NAMESERVER_TTL("12h"),
    NAMESERVER("ns1.opensuse.org."), // NUE-IPX
    NAMESERVER("ns2.opensuse.org."), // PRG2
    NAMESERVER("ns3.opensuse.org."), // SLC1
    NAMESERVER("ns4.opensuse.org."), // PRG2
];

DEFAULTS(
    DnsProvider(DSP_OPENSUSE),
    NS_OPENSUSE,
    DefaultTTL(43200),
    IGNORE("_acme-challenge{,.*}", "TXT"),
);
