{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  mitigationFlags =
    [
      "noibrs"
      "noibpb"
      "nospectre_v1"
      "nospectre_v2"
      "l1tf=off"
      "nospec_store_bypass_disable"
      "no_stf_barrier"
      "mds=off"
    ]
    ++ [
      "mitigations=off"
    ];

  cfg = config.configs.modules.security;
in {
  options.configs.modules.security = {
    mitigations = {
      disable = mkOption {
        type = types.bool;
        default = false;
      };

      acceptRisk = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };

  config = {
    assertions = optionals cfg.mitigations.disable [
      {
        assertion = cfg.mitigations.acceptRisk;
        message = ''
          You disabled mitigations!

          Hopefully you understand how stupid this can be!

          Set 'config.modules.security.mitigations.acceptRisk' to 'true'
          only if you know what you are doing!
        '';
      }
    ];

    security = {
      protectKernelImage = true;
      forcePageTableIsolation = true;
      allowUserNamespaces = true;
      apparmor = {
        enable = true;
        killUnconfinedConfinables = true;
        packages = [pkgs.apparmor-profiles];
      };
    };

    boot = {
      kernel = {
        sysctl = {
          "kernel.sysrq" = 0;
          "kernel.kptr_restrict" = 2;
          "net.core.bfp_jit_enable" = false;
          "kernel.ftrace_enabled" = false;
          "kernel.dmesg_restrict" = 1;
          "fs.protected_fifos" = 2;
          "fs.protected_regular" = 2;
          "fs.suid_dumpable" = 0;
          "kernel.perf_event_paranoid" = 3;
          "kernel.unprvileged_bpf_disabled" = 1;
        };
      };

      kernelParams =
        [
          "rootflags=noatime"
        ]
        ++ optionals cfg.mitigations.disable mitigationFlags;

      blacklistedKernelModules = lib.concatLists [
        [
          "dccp" # Datagram Congestion Control Protocol
          "sctp" # Stream Control Transmission Protocol
          "rds" # Reliable Datagram Sockets
          "tipc" # Transparent Inter-Process Communication
          "n-hdlc" # High-level Data Link Control
          "netrom" # NetRom
          "x25" # X.25
          "ax25" # Amatuer X.25
          "rose" # ROSE
          "decnet" # DECnet
          "econet" # Econet
          "af_802154" # IEEE 802.15.4
          "ipx" # Internetwork Packet Exchange
          "appletalk" # Appletalk
          "psnap" # SubnetworkAccess Protocol
          "p8022" # IEEE 802.3
          "p8023" # Novell raw IEEE 802.3
          "can" # Controller Area Network
          "atm" # ATM
        ]

        [
          "adfs" # Active Directory Federation Services
          "affs" # Amiga Fast File System
          "befs" # "Be File System"
          "bfs" # BFS, used by SCO UnixWare OS for the /stand slice
          "cifs" # Common Internet File System
          "cramfs" # compressed ROM/RAM file system
          "efs" # Extent File System
          "erofs" # Enhanced Read-Only File System
          "exofs" # EXtended Object File System
          "freevxfs" # Veritas filesystem driver
          "f2fs" # Flash-Friendly File System
          "vivid" # Virtual Video Test Driver (unnecessary)
          "gfs2" # Global File System 2
          "hpfs" # High Performance File System (used by OS/2)
          "hfs" # Hierarchical File System (Macintosh)
          "hfsplus" # " same as above, but with extended attributes
          "jffs2" # Journalling Flash File System (v2)
          "jfs" # Journaled File System - only useful for VMWare sessions
          "ksmbd" # SMB3 Kernel Server
          "minix" # minix fs - used by the minix OS
          "nfsv3" # " (v3)
          "nfsv4" # Network File System (v4)
          "nfs" # Network File System
          "nilfs2" # New Implementation of a Log-structured File System
          "omfs" # Optimized MPEG Filesystem
          "qnx4" #  extent-based file system used by the QNX4 and QNX6 OSes
          "qnx6" # "
          "squashfs" # compressed read-only file system (used by live CDs)
          "sysv" # implements all of Xenix FS, SystemV/386 FS and Coherent FS.
          "udf" # https://docs.kernel.org/5.15/filesystems/udf.html
        ]

        [
          "thunderbolt"
          "firewire-core"
        ]
      ];
    };
  };
}

