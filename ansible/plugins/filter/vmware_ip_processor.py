from ipaddress import ip_network, ip_address

class FilterModule:
    """Gens da args"""

    def filters(self):
        return {
            "vmware_ip_filter": self.vmware_ip_filter,
        }


    @staticmethod
    def vmware_ip_filter(net_config, *netfilters):
        out_ip = ""
        for netfilter in netfilters:
            network = ip_network(netfilter)
            for nic in net_config:
                for ip in nic.get("ipAddress", []):
                    address = ip_address(ip)
                    if address in network:
                        out_ip = ip
                        break
                else:
                    continue
                break
            else:
                continue
            break

        return out_ip

