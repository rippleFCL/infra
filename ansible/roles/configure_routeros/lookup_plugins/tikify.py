from __future__ import absolute_import, division, print_function

from dataclasses import dataclass
from typing import List, Union

from ansible.errors import AnsibleLookupError
from ansible.module_utils.common.text.converters import to_native
from ansible.plugins.lookup import LookupBase
from ansible.utils.display import Display

display = Display()


@dataclass
class TikBridgePort:
    bridge: str
    interface: str
    comment: str
    pvid: int = 1
    disabled: bool = False
    frame_types: str = "admit-all"
    hw: bool = True
    ingress_filtering: bool = False

    def to_dict(self):
        return {key.replace("_", "-"): value for key, value in self.__dict__.items()}


@dataclass
class TikBridgeVlan:
    bridge: str
    comment: str
    disabled: bool = False
    tagged: str = ""
    untagged: str = ""
    vlan_ids: Union[int, str] = ""

    def to_dict(self):
        return {key.replace("_", "-"): value for key, value in self.__dict__.items()}


def mangle_ports(ports: List[dict]) -> List[dict]:
    if not ports:
        raise AnsibleLookupError("Bridge ports not found")

    return [
        TikBridgePort(
            bridge=port["bridge"],
            interface=port["interface"],
            comment=port["comment"],
            pvid=port.get("untagged", 1),
        ).to_dict()
        for port in ports
    ]


def mangle_vlans(
    vlans: List[dict], ports: List[dict], vlan_extra_interfaces: List[dict]
) -> List[dict]:
    if not vlans:
        raise AnsibleLookupError("Bridge VLANs not found")
    if not ports:
        raise AnsibleLookupError("Bridge ports not found")

    tik_vlans = []

    for vlan in vlans:
        vlan_id = vlan["vlan_id"]

        tagged_ports = [
            port.get("interface")
            for port in ports
            if port.get("tagged") and vlan_id in port.get("tagged")
        ]

        untagged_ports = [
            port.get("interface")
            for port in ports
            if port.get("untagged") and vlan_id == port.get("untagged")
        ]

        if vlan_extra_interfaces:
            extra_tagged_ports = [
                port.get("interface")
                for port in vlan_extra_interfaces
                if port["type"] == "tagged"
                and vlan_id == port["vlan_id"]
                and vlan["bridge"] == port["bridge"]
            ]
            extra_untagged_ports = [
                port.get("interface")
                for port in vlan_extra_interfaces
                if port["type"] == "untagged"
                and vlan_id == port["vlan_id"]
                and vlan["bridge"] == port["bridge"]
            ]
            tagged_ports = extra_tagged_ports + tagged_ports
            untagged_ports = extra_untagged_ports + untagged_ports

        tik_vlans.append(
            TikBridgeVlan(
                bridge=vlan["bridge"],
                comment=vlan["name"],
                tagged=",".join(tagged_ports),
                untagged=",".join(untagged_ports),
                vlan_ids=vlan_id,
            ).to_dict()
        )

    return tik_vlans


class LookupModule(LookupBase):
    def run(
        self,
        terms: List[str] = [],
        variables=None,
        bridge_ports_var: str = "mt_bridge_ports",
        bridge_vlans_var: str = "mt_bridge_vlans",
        bridge_vlan_extra_interfaces_var: str = "mt_bridge_vlan_extra_interfaces",
    ) -> List[dict]:
        templar = self._templar

        assert len(terms) <= 1, "Too many terms"
        requested_data = terms[0] if terms else "all"
        assert requested_data in ["all", "ports", "vlans"], (
            "Unknown term '%s'" % to_native(requested_data)
        )

        try:
            cfg_ports = templar.template(variables.get(bridge_ports_var, []))
            cfg_vlans = templar.template(variables.get(bridge_vlans_var, []))
            cfg_vlan_extra_interfaces = templar.template(
                variables.get(bridge_vlan_extra_interfaces_var, [])
            )
        except Exception as exc:
            raise AnsibleLookupError(
                "Error accessing or templating bridge config variables"
            ) from exc

        if requested_data == "all":
            return [
                {
                    "ports": mangle_ports(cfg_ports),
                    "vlans": mangle_vlans(
                        cfg_vlans, cfg_ports, cfg_vlan_extra_interfaces
                    ),
                }
            ]

        if requested_data == "ports":
            return mangle_ports(cfg_ports)

        if requested_data == "vlans":
            return mangle_vlans(cfg_vlans, cfg_ports, cfg_vlan_extra_interfaces)
