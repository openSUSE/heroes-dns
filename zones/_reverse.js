REVERSE_ZONES_FOR_PREFIXES(
    SOA ("@", "ns1.opensuse.org.", "admin.opensuse.org.", 7200, 7200, 1209600, 86400),
    "24h", [
        "2a07:de40:617e::/48",  // SLC1
        "2a07:de40:b27e::/48",  // PRG2
    ],
);
