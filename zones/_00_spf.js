// SPF for domains not used for email
var SPF_OPENSUSE_NO_MAIL = SPF_BUILDER({
    label: "@",
    ttl: 300,
    parts: [
        "v=spf1",
        "-all",
    ],
})

// SPF specific for .mx (used for email testing)
var SPF_OPENSUSE_TEST = [
    SPF_BUILDER({
        label: "@",
        ttl: 300,
        parts: [
            "v=spf1",
            "include:_spf.opensuse.mx",
            "+all",
        ],
    }),
    SPF_BUILDER({
        label: "_spf",
        ttl: 300,
        parts: [
            "v=spf1",
            "ip4:195.135.220.0/23",
            "ip6:2001:67c:2178:8::/64",
            "mx",
            "-all",
        ],
    }),
]

// SPF specific for .co.in/.pk (TODO: is this still needed?)
var SPF_OPENSUSE_MISC = [
    SPF_BUILDER({
        label: "@",
        ttl: 86400,
        parts: [
            "v=spf1",
            "ip4:143.186.213.0/24",
            "ip4:147.2.0.0/16",
            "ip4:149.44.0.0/16",
            "ip4:195.135.220.0/23",
            "ip4:91.193.113.64/27",
            "ip6:2001:67c:2178::/48",
            "ip6:2620:113:8044::/48",
            "ip6:2a01:138:a004::/48",
            "ip6:2a07:de40:401::/48",
            "mx",
            "~all",
        ],
    })
]
