from typing import Any
from ansible.errors import AnsibleFilterError


class FilterModule:
    """Gens da args"""

    def filters(self):
        return {
            "rule_processor": self.rule_processor,
            "rule_purge_indexes": self.rule_purge_indexes,
        }


    @staticmethod
    def _format_match_value(match_value: dict[str, Any], interface_id: str, interface_config: dict[str, Any], prefix: str = ""):
        if match_value in interface_config:
            source_interface = interface_config[match_value]["identifier"]
            match_str = f"{source_interface}{prefix}"
        elif match_value == "self":
            match_str = f"{interface_id}{prefix}"
        else:
            match_str = match_value
        return match_str

    def _format_match(self, match: dict[str, Any], interface_id: str, interface_config: dict[str, Any], match_type: str = ""):
        prefix_map = {"ip": "ip", "network": "", "alias": ""}
        match_block = {}
        for translators in ["ip", "network", "alias"]:
            if translators in match:
                if f"{match_type}_net" in match_block:
                    raise AnsibleFilterError("ip, network, alias are mutually exclusive")

                match_block[f"{match_type}_net"] = self._format_match_value(
                    match[translators], interface_id, interface_config, prefix_map[translators]
                )


        if "port" in match:
            match_block[f"{match_type}_port"] = match["port"]
        if "invert" in match:
            match_block[f"{match_type}_invert"] = match["invert"]

        return match_block

    def _format_rule(self, rule: dict[str, Any], interface_id: str, interface_config: dict[str, Any]):
        interface_identifier = interface_config[interface_id]["identifier"]
        processed_rule = {
            "interface": interface_identifier
        }
        for key, value in rule.items():
            if key == "source":
                processed_rule.update(self._format_match(value, interface_identifier, interface_config, "source"))
            elif key == "destination":
                processed_rule.update(self._format_match(value, interface_identifier, interface_config, "destination"))
            else:
                processed_rule[key] = value
        return processed_rule

    def rule_processor(
        self, rule_config: list[dict[str, Any]], rule_blocks: dict[str, Any], interface_config: dict[str, Any]
    ):
        rules = []
        for interface in rule_config:
            index = 1
            for rule_block_id in interface['rule_blocks']:
                local_rule_blocks = rule_blocks.copy()
                local_rule_blocks.update(interface.get("local_rule_blocks", {}))
                if rule_block_id in local_rule_blocks:
                    for rule_templates in local_rule_blocks[rule_block_id]:
                        rule = self._format_rule(rule_templates, interface["interface"], interface_config)
                        rule["index"] = index
                        rules.append(rule)
                        index += 1
                else:
                    raise AnsibleFilterError(f"rule block {rule_block_id} not found")
        return rules

    def rule_purge_indexes(
        self, rule_config: list[dict[str, Any]], rule_blocks: dict[str, Any], interface_config: dict[str, Any]
    ):
        rule_purge_indexs = {interface["identifier"]: 0 for interface in interface_config.values()}
        for interface in rule_config:
            index = 0
            for rule_block_id in interface["rule_blocks"]:
                local_rule_blocks = rule_blocks.copy()
                local_rule_blocks.update(interface.get("local_rule_blocks", {}))
                index += len(local_rule_blocks.get(rule_block_id, []))
            rule_purge_indexs[interface_config[interface["interface"]]["identifier"]] = index
        return rule_purge_indexs

