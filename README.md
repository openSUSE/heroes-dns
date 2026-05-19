## What

This repository manages DNS zones.

In scope are zones for all domains using the openSUSE community managed nameservers (ns{1,2,3,4}.opensuse.org), which includes zones for all internet domains available to the openSUSE community and reverse domains for networks in the openSUSE community infrastructure.

Authoritative source of this repository is https://git.infra.opensuse.org/infra/dns. Merge requests can be filed there, but access requires the openSUSE Heroes VPN.

Read-only mirrors are available at:
  * https://github.com/openSUSE/heroes-dns
  * https://code.opensuse.org/heroes/dns

If you would like changes but don't have access to the openSUSE Heroes infrastructure, please reach out through an issue in our [tracker](https://progress.opensuse.org/projects/opensuse-admin/issues).

Other parts of our infrastructure, including the DNS server configuration, are managed through Salt in a different repository.

## How

The zone definitions are written in a subset of JavaScript. Common patterns are stored in variables to avoid code duplication and to make bulk changes easier.

A pipeline runs [dnscontrol](https://docs.dnscontrol.org) to parse and deploy the data to our primary PowerDNS server, which then replicates it to all others. We are using dnscontrol only for management of DNS zones and not for management of domain registrars.

## Rules

- openSUSE Heroes team members use merge requests in git.i.o.o to submit changes
  * submitters should review at least the "preview" stage output of the merge request pipeline to
    confirm their change has the desired effect
  * changes should follow the common formatting style
- merge requests may only be merged if
  * there is at least one approval from another team member or
  * there have not been any approvals or review comments within one week or
  * the change is critical to repair something already broken and no one else is available
- upon merges to the production branch, a deployment pipeline will run and ask for confirmation in case of changes
  * the output of the "preview" stage (now run on the production branch) should be reviewed once more and
  * if there are changes and they are as expected, execution of the "deploy" stage must be confirmed
