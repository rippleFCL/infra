class FilterModule:
    """Gens da args"""

    def filters(self):
        return {"dhcprelay2xml": self.dhcprelay_to_xml}

    def dhcprelay_to_xml(self, dhcp_relay_config, interface_config):
        relay_destinatons, relays = dhcp_relay_config["destinations"], dhcp_relay_config["relays"]
        xml_data = []
        destination_mapping = {}
        for destination in relay_destinatons:
            destination_mapping[destination["name"]] = destination["uuid"]
            xml_child = {
                "destinations": {
                    "uuid": destination["uuid"],
                    "_": [{key: value} for key, value in destination.items() if key != "uuid"],
                }
            }
            xml_data.append(xml_child)
        for relay in relays:
            xml_child = {
                "relays": {
                    "uuid": relay["uuid"],
                    "_": [
                        {key: str(value)} for key, value in relay.items() if key not in ["uuid", "destination", "interface"]
                    ],
                }
            }

            xml_child["relays"]["_"].append({"destination": destination_mapping[relay["destination"]]})
            xml_child["relays"]["_"].append({"interface": interface_config[relay["interface"]]["identifier"]})
            xml_data.append(xml_child)
        return xml_data
