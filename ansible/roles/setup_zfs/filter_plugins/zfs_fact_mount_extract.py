from ansible.errors import AnsibleAssertionError, AnsibleFilterTypeError


class FilterModule:
    ''' Gens da args '''

    def filters(self):
        return {
            'zfs_fact_mount_extract': self.zfs_fact_mount_extract
        }

    def zfs_fact_mount_extract(self, config: dict[str, dict[str, list[dict[str, str]]]], path: str) -> str:
        ''' takes a zfs_facts result and returns the zpool path and filesystem mountpoint'''
        if isinstance(config, dict):
            facts = config.get("ansible_facts", dict()).get("ansible_zfs_datasets", None)
            if facts is None:
                raise AnsibleAssertionError("|zfs_fact_mount_extract expects a output from zfs_facts")
            return {item["name"]:item["mountpoint"] for item in facts if 'mountpoint' in item}[path]

        raise AnsibleFilterTypeError("|zfs_fact_mount_extract expects dict, got %s instead." % type(config))
