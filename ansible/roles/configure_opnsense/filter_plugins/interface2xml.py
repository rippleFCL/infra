from typing import Any
from ansible.errors import AnsibleFilterError
import ipaddress


class FilterModule:
    """Gens da args"""

    def filters(self):
        return {"interface2xml": self.interface2xml, "interface_constructor": self.interface_constructor}

    def interface_constructor(
        self, interfaces_conf: dict[str, Any], interface_overides, network_conf: dict[str, dict[str, dict[str, str]]]
    ):
        compiled_interfaces = []
        for interface_name, interface in interfaces_conf.items():
            compiled_interface = {
                "config": interface_overides.get(interface_name, {}).copy(),
                "identifier": interface["identifier"],
            }
            compiled_interface["config"]["descr"] = interface_name
            compiled_interface["config"]["enable"] = "1"

            compiled_interface["config"].update(interface.get("config", {}))
            print(compiled_interface)
            if "vlan" in interface:
                vlan_info = network_conf["vlan"][interface["vlan"]]
                try:
                    vlan_id = vlan_info["vlan_id"]
                except KeyError:
                    raise AnsibleFilterError(f"vlan net config for {interface['vlan']} has no attrebute vlan_id")
                try:
                    network = vlan_info["network"]
                except KeyError:
                    raise AnsibleFilterError(f"vlan net config for {interface['vlan']} has no attrebute network")

                if "if" not in compiled_interface["config"]:
                    compiled_interface["config"]["if"] = f"vlan0.{vlan_id}"
                ip_network = ipaddress.ip_network(network)
                try:
                    ip_address = ipaddress.ip_address(compiled_interface["config"]["ipaddr"])
                except KeyError:
                    raise AnsibleFilterError(f"ipaddr not found for interface {interface_name}")
                if ip_address not in ip_network:
                    raise AnsibleFilterError(
                        f"interface {interface_name} ipaddr {compiled_interface['config']['ipaddr']} not in vlan {interface["vlan"]}'s network: {vlan_info['network']}"
                    )
                if "subnet" not in compiled_interface["config"]:
                    compiled_interface["config"]["subnet"] = str(ip_network.prefixlen)

            compiled_interfaces.append(compiled_interface)
        return compiled_interfaces

    def interface2xml(self, interface_definition: list[dict[str, Any]]) -> list:
        """takes an interface dict and makes it compliant with the xml module"""
        interface_dict = []
        for interface_conf in interface_definition:
            interface_dict.append(
                {interface_conf["identifier"]: {"_": [{key: value} for key, value in interface_conf["config"].items()]}}
            )
        return interface_dict
