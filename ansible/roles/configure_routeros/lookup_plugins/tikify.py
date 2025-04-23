from collections import defaultdict
from dataclasses import dataclass
from enum import Enum
import ipaddress
from typing import Annotated, Any, List, Union

from ansible.errors import AnsibleLookupError
from ansible.module_utils.common.text.converters import to_native
from ansible.plugins.lookup import LookupBase
from ansible.utils.display import Display
from pydantic import BaseModel, Field, ValidationInfo, field_validator
from pydantic_core import PydanticCustomError
from ansible_pydantic_formatting import validate_model

display = Display()


def dc_to_dict(obj: object) -> dict[str, Any]:
    out_data = {}
    for key, value in obj.__dict__.items():
        if isinstance(value, Enum):
            out_data[key.replace("_", "-")] = value.value
        else:
            out_data[key.replace("_", "-")] = value
    return out_data


class NetworkInfo(BaseModel):
    address: str = ""
    network: Annotated[str, Field(validate_default=True)] = ""

    @field_validator("network", mode="after")
    @classmethod
    def validate_both_defined(cls, value: str, info: ValidationInfo):
        if bool(value) and not bool(info.data["address"]):
            raise PydanticCustomError("missing", "address must both be defined", {"skip_end": True})
        else:
            return value


class InterfaceConfig(NetworkInfo):
    interface: str
    comment: str = ""


class VlanMembership(BaseModel):
    untagged: str = ""
    tagged: list[str] = []


class BridgePort(VlanMembership):
    interface: str
    disabled: bool = False
    ingress_filtering: bool = True
    hw: bool = True


class BridgeConfig(NetworkInfo):
    interface: str
    vlan_filtering: bool = True
    admin_mac: str
    ports: list[BridgePort]
    pvid: int = 1


class VlanInterfaceConfig(NetworkInfo):
    interface: str = ""
    bridge: str = ""
    vlan: str

    @field_validator("bridge", mode="after")
    @classmethod
    def validate_both_defined(cls, value: str, info: ValidationInfo):
        if bool(value) and bool(info.data["interface"]):
            raise PydanticCustomError(
                "mutually_exclusive", "interface and bridge cannot be both be defined", {"skip_end": True}
            )
        if not (bool(value) or bool(info.data["interface"])):
            raise PydanticCustomError("missing", "interface or bridge must be defined", {"skip_end": True})
        else:
            return value


class NetworkVlanConfig(BaseModel):
    vlan_id: int
    network: str = ""


class FrameType(Enum):
    admit_all = "admit-all"
    untagged = "admit-only-untagged-and-priority-tagged"
    tagged = "admit-only-vlan-tagged"


@dataclass
class TikBridgePort:
    interface: str
    comment: str
    bridge: str
    pvid: int = 1
    frame_types: FrameType = FrameType.admit_all
    disabled: bool = False
    ingress_filtering: bool = True
    hw: bool = True


@dataclass
class TikBridgeVlan:
    bridge: str
    comment: str
    vlan_ids: Union[int, str]
    tagged: str = ""
    untagged: str = ""


@dataclass
class TikBridge:
    name: str
    admin_mac: str
    vlan_filtering: bool = True
    pvid: int = 1


@dataclass
class TikVlan:
    name: str
    vlan_id: int
    interface: str


@dataclass
class TikAddress:
    interface: str
    address: str
    network: str
    comment: str = ""

@dataclass
class TikInterface:
    name: str
    comment: str = ""

def get_bridges(
    cfg_bridges: dict[str, BridgeConfig],
    **_,
):
    bridges: list[dict[str, Any]] = []

    for bridge in cfg_bridges.values():
        bridges.append(dc_to_dict(TikBridge(name=bridge.interface, vlan_filtering=bridge.vlan_filtering, pvid=bridge.pvid, admin_mac=bridge.admin_mac)))

    return bridges


def get_interface(cfg_interfaces: dict[str, InterfaceConfig], name):
    try:
        return cfg_interfaces[name]
    except KeyError:
        raise AnsibleLookupError(f"Interface {name} not found")


def get_bridge_vlans(
    cfg_interfaces: dict[str, InterfaceConfig],
    cfg_bridges: dict[str, BridgeConfig],
    cfg_vlans: dict[str, VlanInterfaceConfig],
    cfg_network_info: dict[str, NetworkVlanConfig],
):
    tik_brigde_vlans: list[dict[str, Any]] = []
    for bridge_name, bridge in cfg_bridges.items():
        bridge_vlan_tagged = defaultdict(list)
        bridge_vlan_untagged = defaultdict(list)

        bridge_vlan_untagged[bridge.pvid].append(bridge.interface)

        for port in bridge.ports:
            # add untagged bridge port to bridge vlan
            if port.untagged:
                vlan_id = cfg_network_info[port.untagged].vlan_id
                port_interface = get_interface(cfg_interfaces, port.interface)
                bridge_vlan_untagged[vlan_id].append(port_interface.interface)
            # add tagged bridge port to bridge vlan
            for port_tag in port.tagged:
                vlan_id = cfg_network_info[port_tag].vlan_id
                port_interface = get_interface(cfg_interfaces, port.interface)
                bridge_vlan_tagged[vlan_id].append(port_interface.interface)

        # if bridge interface has a vlan interface on it add bridge interface to that bridge vlan
        for vlan in cfg_vlans.values():
            vlan_id = cfg_network_info[vlan.vlan].vlan_id
            if vlan.bridge and vlan.bridge == bridge_name:
                bridge_vlan_tagged[vlan_id].append(bridge.interface)

        for name, config in cfg_network_info.items():
            if config.vlan_id in bridge_vlan_tagged or config.vlan_id in bridge_vlan_untagged:
                tik_brigde_vlans.append(
                    dc_to_dict(
                        TikBridgeVlan(
                            bridge=bridge.interface,
                            comment=f"{name}",
                            vlan_ids=config.vlan_id,
                            untagged=",".join(bridge_vlan_untagged[config.vlan_id]),
                            tagged=",".join(bridge_vlan_tagged[config.vlan_id]),
                        )
                    )
                )

    return tik_brigde_vlans


def get_bridge_ports(
    cfg_interfaces: dict[str, InterfaceConfig],
    cfg_bridges: dict[str, BridgeConfig],
    cfg_network_info: dict[str, NetworkVlanConfig],
    **_,
):
    tik_bridge_ports: list[dict[str, Any]] = []
    for bridge in cfg_bridges.values():
        for port in bridge.ports:
            port_interface = get_interface(cfg_interfaces, port.interface)
            bridge_port = TikBridgePort(
                bridge=bridge.interface,
                interface=port_interface.interface,
                comment=port_interface.comment,
                disabled=port.disabled,
                hw=port.hw,
                ingress_filtering=port.ingress_filtering,
            )
            if port.untagged:
                bridge_port.pvid = int(cfg_network_info[port.untagged].vlan_id)
            if port.tagged and not port.untagged:
                bridge_port.frame_types = FrameType.tagged
            elif port.untagged and not port.tagged:
                bridge_port.frame_types = FrameType.untagged

            tik_bridge_ports.append(dc_to_dict(bridge_port))
    return tik_bridge_ports


def get_vlans(
    cfg_interfaces: dict[str, InterfaceConfig],
    cfg_vlans: dict[str, VlanInterfaceConfig],
    cfg_network_info: dict[str, NetworkVlanConfig],
    cfg_bridges: dict[str, BridgeConfig],
    **_,
):
    vlan_interfaces: list[dict[str, Any]] = []
    for name, vlan_interface in cfg_vlans.items():
        vlan_id = cfg_network_info[vlan_interface.vlan].vlan_id
        if vlan_interface.bridge:
            interface = cfg_bridges[vlan_interface.bridge].interface
        else:
            interface = get_interface(cfg_interfaces, vlan_interface.interface).interface
        vlan_interfaces.append(dc_to_dict(TikVlan(name=name, vlan_id=int(vlan_id), interface=interface)))

    return vlan_interfaces


def get_network_address(data: NetworkInfo):
    if data.network:
        return data.network
    address = ipaddress.ip_network(data.address, strict=False)
    return str(address.network_address)


def get_addresses(
    cfg_interfaces: dict[str, InterfaceConfig],
    cfg_vlans: dict[str, VlanInterfaceConfig],
    cfg_bridges: dict[str, BridgeConfig],
    **_,
) -> list[dict[str, Any]]:
    tik_interfaces: list[dict[str, Any]] = []
    for interface in cfg_interfaces.values():
        if interface.address:
            tik_interfaces.append(
                dc_to_dict(
                    TikAddress(interface=interface.interface, address=interface.address, network=get_network_address(interface))
                )
            )
    for bridge in cfg_bridges.values():
        if bridge.address:
            tik_interfaces.append(
                dc_to_dict(TikAddress(interface=bridge.interface, address=bridge.address, network=get_network_address(bridge)))
            )
    for vlan_name, vlan in cfg_vlans.items():
        if vlan.address:
            tik_interfaces.append(
                dc_to_dict(TikAddress(interface=vlan_name, address=vlan.address, network=get_network_address(vlan)))
            )

    return tik_interfaces

def get_interfaces(cfg_interfaces: dict[str, InterfaceConfig], **_):
    tik_interfaces: list[dict[str, Any]] = []
    for interface in cfg_interfaces.values():
        if interface.comment:
            tik_interfaces.append(dc_to_dict(TikInterface(name=interface.interface, comment=interface.comment)))

    return tik_interfaces

class LookupModule(LookupBase):
    def run(  # type: ignore
        self,
        terms: List[str] = [],
        variables=None,
        interfaces_var: str = "configure_switch_interfaces",
        bridges_var: str = "configure_switch_bridges",
        vlans_var: str = "configure_switch_vlan_interfaces",
        networking_info_var: str = "network_spec",
    ) -> List[dict]:  # type: ignore
        templar = self._templar

        if templar is None:
            raise AnsibleLookupError("templar is not available")
        if variables is None:
            raise AnsibleLookupError("variables is not available")
        if len(terms) != 1:
            raise AnsibleLookupError("Only one term is allowed and must be supplied")
        requested_data, *_ = terms
        if requested_data not in ["bridges", "bridge_ports", "bridge_vlans", "vlans", "addresses", "interfaces"]:
            raise AnsibleLookupError("Unknown term '%s'" % to_native(requested_data))

        try:
            cfg_interfaces: dict[str, Any] = templar.template(variables[interfaces_var])
            cfg_bridges: dict[str, Any] = templar.template(variables[bridges_var])
            cfg_vlans: dict[str, Any] = templar.template(variables[vlans_var])
            cfg_network_info: dict[str, Any] = templar.template(variables[networking_info_var]).get("vlan", {})
        except Exception as exc:
            raise AnsibleLookupError(f"Error accessing or templating config variables '{exc}'") from exc
        interfaces = validate_model(InterfaceConfig, cfg_interfaces, interfaces_var)
        bridges = validate_model(BridgeConfig, cfg_bridges, bridges_var)
        vlans = validate_model(VlanInterfaceConfig, cfg_vlans, vlans_var)
        network_info = validate_model(NetworkVlanConfig, cfg_network_info, networking_info_var)

        dispatch = {
            "bridges": get_bridges,
            "bridge_ports": get_bridge_ports,
            "bridge_vlans": get_bridge_vlans,
            "vlans": get_vlans,
            "addresses": get_addresses,
            "interfaces": get_interfaces,
        }
        executor = dispatch.get(requested_data, lambda x, y, z, a: [])
        return executor(cfg_interfaces=interfaces, cfg_bridges=bridges, cfg_vlans=vlans, cfg_network_info=network_info)
