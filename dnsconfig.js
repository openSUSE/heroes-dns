var DSP_OPENSUSE = NewDnsProvider("ioo-powerdns");
var REG_OPENSUSE = NewRegistrar("none"); // we cannot control MarkMonitor

require("common/defaults.js");
require("common/lib.js");
require("common/infra.js");
require_glob("zones");
