# resource "proxmox_vm_qemu" "tf-test-0" {
#   name        = "tf-test-0"
#   target_node = "pve0"

#   clone = "debian-13-template"
#   tags  = "cloudinit;debian-13;debian-template"

#   agent = 1
#   bios  = "ovmf"

#   scsihw = "virtio-scsi-pci"

#   memory = 1024
#   cpu {
#     cores = 1
#     type  = "x86-64-v2-AES"
#     numa  = true
#   }

#   serial {
#     id   = 0
#     type = "socket"
#   }

#   disks {
#     scsi {
#       scsi1 {
#         cloudinit {
#           storage = "data"
#         }
#       }
#     }
#     virtio {
#       virtio0 {
#         disk {
#           backup    = true
#           discard   = true
#           replicate = true
#           size      = "10G"
#           storage   = "data"
#         }
#       }
#     }
#   }

#   network {
#     id     = 0
#     model  = "virtio"
#     bridge = "vmbr0"
#     queues = 0
#     mtu    = 1
#   }

#   ciupgrade = true
#   ipconfig0 = "ip=dhcp"
#   ciuser    = "riley"
#   sshkeys   = <<-EOT
# ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDJq9M1p4an8+85e+bn+65xqhXn6in9rAAcstC1ykZfFsJTW2cSuZYMntdaTrTcA70g8QQLN5aF92xbnhy4J0Qw7ZdWJoJgdGCvSLRJL6vTNnNSoKsil/UtGihmB8n2nlSrB9AqCjcgyVZ31fldcV5QZhKWPccOiLsGGr2EhhlM7pvXXzqiaEmt/OhDp+GvgI0rTT/L28/ElCdEjahqtaxzazb3bdSAr/Ap9CHMB738RdFHgMrMghtaswx47F5C9DbxuKjhiTncOMqIWEU002g8H454Ruvdb/tMk4AXydQ8Z+ByN6Bijb5OdNsBbY3UMfpiE2ZvqMJ3zVuPn2X9jqsdOVJaHcYvmcQ3JLravOuQDIpiEanJxEAZ7O8eYgNf1f3LvPPuX3qS1iyFl9R6LFSeHgXLC2vtLBa5cpgOEh66B23VM/cdRFrBhv2TAnrkCAsMsYbFp+V+GQJCkh8J274LScZJ9H8G+1Yd5X9v0NLyH7rSnWqvJ7DH48uEDCTZ2hlkIcBrHhpJGg1m0p6/GuDc+F45xSd7izik/lP+fIvFUtsQedlx9UVBbIa8cT2xY1HN5OIBrBbt2UsNz90xtBt+Eaa3oCgAiuuBXfYqnxgYuIJOC/2/CqSDDeMf5QuVUfSUV+KIJSeT/uZXV1cMBv7YyL5YpNDxR4KcvZsWO4IvyQ== root@pve0
# ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC0eYIj1qScmuGmXxYgu54r7s99s5chsjqFwZ/Vwamu5HLb0AmcgCdDaUkHX7YpGTcbafVTHJXVx/V8JKzu2jiztoXZy52JbIpYbkZNgo+aLwB9Sj3XZXFEjarG+P6/iqNNMPIGhLvGOH61keyYoA8cUOhcBUODZWMssK8L2mQxcTNATzC5mv67H6IDiowcFnRV3CKe2VvsVdOLjAjJzQ1xBUpVENyIFohyV+7kmFI5dODct6UdhHjYfW9YA1qlQYfV+S8vU20jcmXcHF+M6x4i1D6kDb5Ig8/5B/Ym1dHFIjcFnBezF2CIT5tsUc4vqfY0DtdVqt9rHFS/swiNZl3GaG4pMF5ooG4RIkb16oFTwBhsEHMzjzG+Pqaqt8UAHC7MXbY6fQxUts8SZUSal7ydoMw3mOKFCtOog517PkqgGUJt2UNsur0R204Vgxlqx3xTkYbW7VKdglr4MrLjglCM1bT6+cnrP+h2FiWAlXpMXmS4ymsWlrkucmyX0hmLWAk= riley@hurley
# ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDQSyGaeiYK125ztfnOgysPCXj7k4VhuoMpmgzU28P7Y rileysnyder@protonmail.ch
# EOT
# }

resource "proxmox_virtual_environment_cloned_vm" "tftest" {
  node_name = "pve0"
  name      = "tftest"

  clone = {
    source_vm_id = 703  # Template VM ID
    full         = true # Perform full clone (not linked)
  }

  disk = {
    scsi0 = {
      # Resize the cloned boot disk
      datastore_id = "data"
      size_gb      = 32
      discard      = "on"
      ssd          = true
    }

    # scsi1 = {
    #   datastore_id = "data"
    #   size_gb      = 64
    #   backup       = false
    # }
  }

  # Only manage CPU, inherit everything else from template
  cpu = {
    cores = 4
  }
}

resource "proxmox_virtual_environment_role" "ccm" {
  role_id = "CCM"

  privileges = [
    "Sys.Audit",
    "VM.Audit",
    "VM.GuestAgent.Audit",
  ]
}

resource "proxmox_virtual_environment_user" "kubernetes" {
  acl {
    path      = "/"
    propagate = true
    role_id   = proxmox_virtual_environment_role.ccm.role_id
  }

  comment = "Kubernetes"
  user_id = "kubernetes@pve"
}

resource "proxmox_virtual_environment_user_token" "ccm" {
  comment    = "Kubernetes CCM"
  token_name = "ccm"
  user_id    = proxmox_virtual_environment_user.kubernetes.user_id
}

resource "proxmox_virtual_environment_acl" "ccm" {
  token_id = proxmox_virtual_environment_user_token.ccm.id
  role_id  = proxmox_virtual_environment_role.ccm.role_id

  path      = "/"
  propagate = true
}