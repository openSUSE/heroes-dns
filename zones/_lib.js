function CNAME_BULK(domain, records) {
    for (target in records) {
        for (ttl in records[target]) {
            _.each(
                records[target][ttl],
                function (name) {
                    D_EXTEND(domain,
                      CNAME(name, target, TTL(ttl))
                    )
                }
            )
        }
    }
};

function AAAA_AND_PTR(domain, name, addrs) {
    var fqdn = name + "." + domain + "."
    D_EXTEND(domain, AAAA(fqdn, addrs[0]));
    _.each(
        addrs,
        function(addr) {
            D_EXTEND(REV(addr), PTR(addr, fqdn));
        }
    );
};

function AAAA_AND_PTR_BULK(domain, records) {
    _.each(
        records,
        function(address, name) {
            AAAA_AND_PTR(domain, name, [address]);
        }
    );
};

function HOSTS(domain, hostmap) {
    _.each(
        hostmap,
        function(addresses, name) {
            AAAA_AND_PTR(domain, name, addresses);
        }
    );
};

function REVERSE_ZONES_FOR_PREFIXES(soa, ttl, prefixes) {
    DEFAULTS(
        DEFAULT_BASE,
        DefaultTTL(ttl),
    );
    _.each(
        prefixes,
        function(prefix) {
            D(REV(prefix), REG_OPENSUSE,
                AUTODNSSEC_ON,
                soa
            );
        }
    );
    DEFAULTS(DEFAULT_ALL);
};
