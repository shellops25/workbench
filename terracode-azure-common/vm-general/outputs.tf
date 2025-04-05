output "vm_id" {
    value = azurerm_windows_virtual_machine.vm-windows.vm_id
}
output "vm_name" {
    value = azurerm_windows_virtual_machine.vm-windows.name
}
output "vm_private_ip" {
    value = azurerm_windows_virtual_machine.vm-windows.private_ip_address
}
output "vm_os_disk_id" {
    value = data.azurerm_managed_disk.os_disk_id
}
output "nic_id" {
    value = azurerm_network_interface.nic.id
}