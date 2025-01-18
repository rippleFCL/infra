class FilterModule:
    ''' Gens da args '''

    def filters(self):
        return {
            'zfs_zvol_preprocessor': self.zfs_zvol_preprocessor
        }

    def recursive_walker(self, config, zvols, path):
        for item in config:
            if "parent" in item:
                self.recursive_walker(item.get("zvols", []), zvols, f"{path}/{item['parent']}")
            else:
                item["path"] = f"{path}/{item['path']}"
                item["name"] = item["path"].split("/")[-1]
                zvols.append(item)
        return zvols

    def zfs_zvol_preprocessor(self, config):
        return self.recursive_walker(config.get("zvols", []), [], config["pool"])
