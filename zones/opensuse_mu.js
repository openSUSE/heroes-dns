D("opensuse.mu", REG_OPENSUSE,

    DefaultTTL (86400),

    SPF_OPENSUSE_NO_MAIL,

    A          ("@",                              "102.222.106.230",                            TTL(43200)),
    A          ("*",                              "102.222.106.230"                                       ),

    A          ("mirror.kaldera",                 "169.255.161.244"                                       ),
    A          ("mirror.rcts",                    "196.46.61.247"                                         ),
);
