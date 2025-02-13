from uuid import uuid5, UUID


class FilterModule:
    """Gens da args"""

    def filters(self):
        return {"dhcprelay2xml": self.dhcprelay_to_xml}

    def dhcprelay_to_xml(self, dhcp_relay_config, interface_config):
        namespace = UUID("3f348a97-6f37-47e9-a37e-080353092a07")
        relay_destinatons, relays = dhcp_relay_config["destinations"], dhcp_relay_config["relays"]
        xml_data = []
        destination_mapping = {}
        for destination in relay_destinatons:
            destination_uuid = str(uuid5(namespace, f"{destination['server']}:{destination['name']}"))
            destination_mapping[destination["name"]] = destination_uuid
            xml_child = {
                "destinations": {
                    "uuid": destination_uuid,
                    "_": [{key: value} for key, value in destination.items()],
                }
            }
            xml_data.append(xml_child)
        for relay in relays:
            xml_child = {
                "relays": {
                    "uuid": str(uuid5(namespace, f"{relay['interface']}:{relay['destination']}")),
                    "_": [
                        {key: str(value)} for key, value in relay.items() if key not in ["destination", "interface"]
                    ],
                }
            }

            xml_child["relays"]["_"].append({"destination": destination_mapping[relay["destination"]]})
            xml_child["relays"]["_"].append({"interface": interface_config[relay["interface"]]["identifier"]})
            xml_data.append(xml_child)
        return xml_data
