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
