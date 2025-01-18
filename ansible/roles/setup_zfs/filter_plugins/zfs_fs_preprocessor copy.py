class FilterModule:
    ''' Gens da args '''

    def filters(self):
        return {
            'zfs_fs_preprocessor': self.zfs_fs_preprocessor
        }

    def recursive_walker(self, config, recursed_mountpoint, path, result):
        name = config.get("name", "")
        name = f"/{name}" if name else ""

        options = config.get("options", None)
        mountpoint = config.get("mountpoint", None)
        mountpoint = mountpoint if mountpoint else recursed_mountpoint
        datasets = config.get("datasets", list())
        datasets_conf = {"name": f"{path}{name}"}
        if mountpoint:
            datasets_conf["mountpoint"] = mountpoint
        if options:
            datasets_conf["options"] = options
        result.append(datasets_conf)
        for dataset in datasets:
            if mountpoint and mountpoint.get("recurse", False):
                self.recursive_walker(dataset, mountpoint, datasets_conf["name"], result)
            else:
                self.recursive_walker(dataset, None, datasets_conf["name"], result)

        return result

    def zfs_fs_preprocessor(self, config):

        result = []
        return self.recursive_walker(config, None, config["pool"], result)
