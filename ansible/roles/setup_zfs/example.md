```
zfs_pool_config:
  - name: "ssd-pool"
    options:
      compression: lz4
    vdevs:
      - type: mirror
        devices:
          - ata-CT1000BX500SSD1_2250E692B7EE
          - ata-CT1000BX500SSD1_2250E692B7F2
      - type: mirror
        devices:
          - ata-CT1000BX500SSD1_2250E692B802
          - ata-CT1000BX500SSD1_2250E692B863
      - type: mirror
        devices:
          - ata-CT1000BX500SSD1_2250E692B864
          - ata-CT1000BX500SSD1_2250E692B86D
      - type: mirror
        devices:
          - ata-CT1000BX500SSD1_2250E692B870
          - ata-CT1000BX500SSD1_2250E692B871
      - type: mirror
        devices:
          - ata-CT1000BX500SSD1_2250E692B874
          - ata-CT1000BX500SSD1_2250E6932C45
      - type: mirror
        devices:
          - ata-CT1000BX500SSD1_2250E69330F0
          - ata-CT1000BX500SSD1_2250E69330F1
      - type: mirror
        devices:
          - ata-CT1000BX500SSD1_2250E69330F9
          - ata-CT1000BX500SSD1_2250E69330FD

zfs_fs_config:
  - pool: "ssd-pool"
    options:
      compression: lz4
    mountpoint:
      owner: ripple
      group: ripple
      recurse: true
    datasets:
      - name: "zvols"
        datasets:
          - name: "test"
            mountpoint:
              owner: root
              group: root
            options:
              compression: gzip-9



zfs_zvol_config:
  - pool: ssd-pool
    zvols:
      - parent: zvols
        zvols:
          - parent: test
            zvols:
              - path: testing_zvol
                size: "10G"
                options:
                  compression: lz4
              - path: testing_zvol1
                size: "10G"
              - path: testing_zvol2
                size: "20G"
          - path: test1
            size: "10G"
          - path: test2
            size: "10G"
      - path: zvols/test/testing_zvol3
        size: "30G"
        options:
          compression: lz4

      - parent: zvols/test
        zvols:
          - path: testing_zvol4
            size: "40G"

zfs_performance_tuning:
  - param: zfs_arc_max
    value: "{{ (ansible_memtotal_mb | int * 1024 * 1024 * 0.9) | round | int }}"

zfs_pools_scrub_cron:
  - pool: ssd-pool
    minute: 0
    hour: 0
    day: "*"
    month: "*"
    weekday: sun

```yaml