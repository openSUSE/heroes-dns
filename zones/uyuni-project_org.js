D("uyuni-project.org", REG_OPENSUSE,

    SPF_OPENSUSE_NO_MAIL,

    AAAA       ("@",                              "2606:50c0:8000::153"                                   ),
    AAAA       ("@",                              "2606:50c0:8001::153"                                   ),
    AAAA       ("@",                              "2606:50c0:8002::153"                                   ),
    AAAA       ("@",                              "2606:50c0:8003::153"                                   ),
    AAAA       ("lists",                          "2a07:de40:b27e:1204::10",                              ),

    A          ("@",                              "185.199.108.153",                                      ),
    A          ("@",                              "185.199.109.153",                                      ),
    A          ("@",                              "185.199.110.153",                                      ),
    A          ("@",                              "185.199.111.153",                                      ),
    A          ("lists",                          "195.135.223.50",                                       ),

    CNAME      ("www",                            "uyuni-project.org.",                                   ),

    SPF_BUILDER ({
        label: "lists",
        ttl: "3h",
        parts: [
            "v=spf1",
            "+include:lists.opensuse.org",
            "+mx",
            "?all",
        ],
    }),

    DMARC_BUILDER ({
        label: "lists",
        ttl: "3h",
        policy: "none",
    }),
);
