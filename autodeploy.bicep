@description('Type of authentication to use on the Virtual Machine. SSH key is recommended.')
@allowed([
  'sshPublicKey'
  'password'
])
param AuthenticationType string = 'password'

@description('Name of the Availability Set')
param AvailabilitySetName string = 'CSR-8000-AVSET'

@description('SSH Key or password for the Virtual Machine. SSH key is recommended.')
@secure()
param LocalAdministratorPasswordOrKey string

@description('Administrative Account')
param LocalAdministratorUsername string = 'csr8000admin'

@description('Location for the deployed Azure resources.')
param Location string = resourceGroup().location

@description('Name of the Network Secuity Group')
param NetworkSecurityGroupName string = 'CSR8000-NSG'

@description('Performance of OS Disk drive, Standard vs Premium')
@allowed([
  'Standard_LRS'
  'StandardSSD_LRS'
  'Premium_LRS'
])
param OSDiskPerformance string = 'Premium_LRS'

@description('Name of the Route Table')
param RouteTableName string = 'CSR8000-RouteTable'

@description('Subnet you want to deploy your WAN network cards  ')
param Subnet1Name string

@description('Subnet you want to deploy your private network cards  ')
param Subnet2Name string

@description('Number of Cisco CSR\'s to deploy')
param VirtualMachineInstances int = 2

@description('Basic Name Pattern of VM Not More than 15 Characters we are appending the Ordinal Number at end of the name')
param VirtualMachineName string = 'CSR-8000v'

@description('VM Offer for the virtual machine')
@allowed([
  'Cisco Catalyst 8000V-PAYG-DNA Advantage-17.11.01a - x64 Gen1'
  'Cisco Catalyst 8000V-PAYG-DNA Essentials-17.11.01a - x64 Gen1'
  'Cisco Catalyst 8000V Edge Software-BYOL-17.12.01a - x64 Gen1'
])
param VirtualMachineSKU string

@description('Select the size for your virtual machine')
@allowed([
  'Standard_NC6'
  'Standard_NC12'
  'Standard_NC24'
  'Standard_NC24r'
  'Standard_NC6_Promo'
  'Standard_NC12_Promo'
  'Standard_NC24_Promo'
  'Standard_NC24r_Promo'
  'Standard_HB120rs_v2'
  'Standard_M64'
  'Standard_M64m'
  'Standard_M128'
  'Standard_M128m'
  'Standard_M8-2ms'
  'Standard_M8-4ms'
  'Standard_M8ms'
  'Standard_M16-4ms'
  'Standard_M16-8ms'
  'Standard_M16ms'
  'Standard_M32-8ms'
  'Standard_M32-16ms'
  'Standard_M32ls'
  'Standard_M32ms'
  'Standard_M32ts'
  'Standard_M64-16ms'
  'Standard_M64-32ms'
  'Standard_M64ls'
  'Standard_M64ms'
  'Standard_M64s'
  'Standard_M128-32ms'
  'Standard_M128-64ms'
  'Standard_M128ms'
  'Standard_M128s'
  'Standard_M32ms_v2'
  'Standard_M64ms_v2'
  'Standard_M64s_v2'
  'Standard_M128ms_v2'
  'Standard_M128s_v2'
  'Standard_M192ims_v2'
  'Standard_M192is_v2'
  'Standard_M32dms_v2'
  'Standard_M64dms_v2'
  'Standard_M64ds_v2'
  'Standard_M128dms_v2'
  'Standard_M128ds_v2'
  'Standard_M192idms_v2'
  'Standard_M192ids_v2'
  'Standard_B1ls'
  'Standard_B1ms'
  'Standard_B1s'
  'Standard_B2ms'
  'Standard_B2s'
  'Standard_B4ms'
  'Standard_B8ms'
  'Standard_B12ms'
  'Standard_B16ms'
  'Standard_B20ms'
  'Standard_E2_v4'
  'Standard_E4_v4'
  'Standard_E8_v4'
  'Standard_E16_v4'
  'Standard_E20_v4'
  'Standard_E32_v4'
  'Standard_E48_v4'
  'Standard_E64_v4'
  'Standard_E2d_v4'
  'Standard_E4d_v4'
  'Standard_E8d_v4'
  'Standard_E16d_v4'
  'Standard_E20d_v4'
  'Standard_E32d_v4'
  'Standard_E48d_v4'
  'Standard_E64d_v4'
  'Standard_E2s_v4'
  'Standard_E4-2s_v4'
  'Standard_E4s_v4'
  'Standard_E8-2s_v4'
  'Standard_E8-4s_v4'
  'Standard_E8s_v4'
  'Standard_E16-4s_v4'
  'Standard_E16-8s_v4'
  'Standard_E16s_v4'
  'Standard_E20s_v4'
  'Standard_E32-8s_v4'
  'Standard_E32-16s_v4'
  'Standard_E32s_v4'
  'Standard_E48s_v4'
  'Standard_E64-16s_v4'
  'Standard_E64-32s_v4'
  'Standard_E64s_v4'
  'Standard_E80is_v4'
  'Standard_E2ds_v4'
  'Standard_E4-2ds_v4'
  'Standard_E4ds_v4'
  'Standard_E8-2ds_v4'
  'Standard_E8-4ds_v4'
  'Standard_E8ds_v4'
  'Standard_E16-4ds_v4'
  'Standard_E16-8ds_v4'
  'Standard_E16ds_v4'
  'Standard_E20ds_v4'
  'Standard_E32-8ds_v4'
  'Standard_E32-16ds_v4'
  'Standard_E32ds_v4'
  'Standard_E48ds_v4'
  'Standard_E64-16ds_v4'
  'Standard_E64-32ds_v4'
  'Standard_E64ds_v4'
  'Standard_E80ids_v4'
  'Standard_D2d_v4'
  'Standard_D4d_v4'
  'Standard_D8d_v4'
  'Standard_D16d_v4'
  'Standard_D32d_v4'
  'Standard_D48d_v4'
  'Standard_D64d_v4'
  'Standard_D2_v4'
  'Standard_D4_v4'
  'Standard_D8_v4'
  'Standard_D16_v4'
  'Standard_D32_v4'
  'Standard_D48_v4'
  'Standard_D64_v4'
  'Standard_D2ds_v4'
  'Standard_D4ds_v4'
  'Standard_D8ds_v4'
  'Standard_D16ds_v4'
  'Standard_D32ds_v4'
  'Standard_D48ds_v4'
  'Standard_D64ds_v4'
  'Standard_D2s_v4'
  'Standard_D4s_v4'
  'Standard_D8s_v4'
  'Standard_D16s_v4'
  'Standard_D32s_v4'
  'Standard_D48s_v4'
  'Standard_D64s_v4'
  'Standard_D1_v2'
  'Standard_D2_v2'
  'Standard_D3_v2'
  'Standard_D4_v2'
  'Standard_D5_v2'
  'Standard_D11_v2'
  'Standard_D12_v2'
  'Standard_D13_v2'
  'Standard_D14_v2'
  'Standard_D15_v2'
  'Standard_D2_v2_Promo'
  'Standard_D3_v2_Promo'
  'Standard_D4_v2_Promo'
  'Standard_D5_v2_Promo'
  'Standard_D11_v2_Promo'
  'Standard_D12_v2_Promo'
  'Standard_D13_v2_Promo'
  'Standard_D14_v2_Promo'
  'Standard_F1'
  'Standard_F2'
  'Standard_F4'
  'Standard_F8'
  'Standard_F16'
  'Standard_DS1_v2'
  'Standard_DS2_v2'
  'Standard_DS3_v2'
  'Standard_DS4_v2'
  'Standard_DS5_v2'
  'Standard_DS11-1_v2'
  'Standard_DS11_v2'
  'Standard_DS12-1_v2'
  'Standard_DS12-2_v2'
  'Standard_DS12_v2'
  'Standard_DS13-2_v2'
  'Standard_DS13-4_v2'
  'Standard_DS13_v2'
  'Standard_DS14-4_v2'
  'Standard_DS14-8_v2'
  'Standard_DS14_v2'
  'Standard_DS15_v2'
  'Standard_DS2_v2_Promo'
  'Standard_DS3_v2_Promo'
  'Standard_DS4_v2_Promo'
  'Standard_DS5_v2_Promo'
  'Standard_DS11_v2_Promo'
  'Standard_DS12_v2_Promo'
  'Standard_DS13_v2_Promo'
  'Standard_DS14_v2_Promo'
  'Standard_F1s'
  'Standard_F2s'
  'Standard_F4s'
  'Standard_F8s'
  'Standard_F16s'
  'Standard_A1_v2'
  'Standard_A2m_v2'
  'Standard_A2_v2'
  'Standard_A4m_v2'
  'Standard_A4_v2'
  'Standard_A8m_v2'
  'Standard_A8_v2'
  'Standard_D2_v3'
  'Standard_D4_v3'
  'Standard_D8_v3'
  'Standard_D16_v3'
  'Standard_D32_v3'
  'Standard_D48_v3'
  'Standard_D64_v3'
  'Standard_D2s_v3'
  'Standard_D4s_v3'
  'Standard_D8s_v3'
  'Standard_D16s_v3'
  'Standard_D32s_v3'
  'Standard_D48s_v3'
  'Standard_D64s_v3'
  'Standard_E2_v3'
  'Standard_E4_v3'
  'Standard_E8_v3'
  'Standard_E16_v3'
  'Standard_E20_v3'
  'Standard_E32_v3'
  'Standard_E48_v3'
  'Standard_E64_v3'
  'Standard_E2s_v3'
  'Standard_E4-2s_v3'
  'Standard_E4s_v3'
  'Standard_E8-2s_v3'
  'Standard_E8-4s_v3'
  'Standard_E8s_v3'
  'Standard_E16-4s_v3'
  'Standard_E16-8s_v3'
  'Standard_E16s_v3'
  'Standard_E20s_v3'
  'Standard_E32-8s_v3'
  'Standard_E32-16s_v3'
  'Standard_E32s_v3'
  'Standard_E48s_v3'
  'Standard_E64-16s_v3'
  'Standard_E64-32s_v3'
  'Standard_E64s_v3'
  'Standard_F2s_v2'
  'Standard_F4s_v2'
  'Standard_F8s_v2'
  'Standard_F16s_v2'
  'Standard_F32s_v2'
  'Standard_F48s_v2'
  'Standard_F64s_v2'
  'Standard_F72s_v2'
  'Standard_A0'
  'Standard_A1'
  'Standard_A2'
  'Standard_A3'
  'Standard_A5'
  'Standard_A4'
  'Standard_A6'
  'Standard_A7'
  'Basic_A0'
  'Basic_A1'
  'Basic_A2'
  'Basic_A3'
  'Basic_A4'
  'Standard_E64i_v3'
  'Standard_E64is_v3'
  'Standard_D1'
  'Standard_D2'
  'Standard_D3'
  'Standard_D4'
  'Standard_D11'
  'Standard_D12'
  'Standard_D13'
  'Standard_D14'
  'Standard_DS1'
  'Standard_DS2'
  'Standard_DS3'
  'Standard_DS4'
  'Standard_DS11'
  'Standard_DS12'
  'Standard_DS13'
  'Standard_DS14'
  'Standard_ND96asr_v4'
  'Standard_G1'
  'Standard_G2'
  'Standard_G3'
  'Standard_G4'
  'Standard_G5'
  'Standard_GS1'
  'Standard_GS2'
  'Standard_GS3'
  'Standard_GS4'
  'Standard_GS4-4'
  'Standard_GS4-8'
  'Standard_GS5'
  'Standard_GS5-8'
  'Standard_GS5-16'
  'Standard_L4s'
  'Standard_L8s'
  'Standard_L16s'
  'Standard_L32s'
  'Standard_NC4as_T4_v3'
  'Standard_NC8as_T4_v3'
  'Standard_NC16as_T4_v3'
  'Standard_NC64as_T4_v3'
  'Standard_NV6'
  'Standard_NV12'
  'Standard_NV24'
  'Standard_NV6_Promo'
  'Standard_NV12_Promo'
  'Standard_NV24_Promo'
  'Standard_L8s_v2'
  'Standard_L16s_v2'
  'Standard_L32s_v2'
  'Standard_L48s_v2'
  'Standard_L64s_v2'
  'Standard_L80s_v2'
  'Standard_NC6s_v3'
  'Standard_NC12s_v3'
  'Standard_NC24rs_v3'
  'Standard_NC24s_v3'
  'Standard_DC8_v2'
  'Standard_DC1s_v2'
  'Standard_DC2s_v2'
  'Standard_DC4s_v2'
  'Standard_M208ms_v2'
  'Standard_M208s_v2'
  'Standard_M416-208s_v2'
  'Standard_M416s_v2'
  'Standard_M416-208ms_v2'
  'Standard_M416ms_v2'
  'Standard_NV6s_v2'
  'Standard_NV12s_v2'
  'Standard_NV24s_v2'
  'Standard_NV12s_v3'
  'Standard_NV24s_v3'
  'Standard_NV48s_v3'
  'Standard_NV4as_v4'
  'Standard_NV8as_v4'
  'Standard_NV16as_v4'
  'Standard_NV32as_v4'
  'Standard_HC44rs'
])
param VirtualMachineSize string = 'Standard_DS3_v2'

@description('The name of the virtual network provisioned for the workload deployment')
param VirtualNetworkName string

@description('Name of the resource group for the existing virtual network')
param VirtualNetworkResourceGroupName string

var linuxConfiguration = {
  disablePasswordAuthentication: true
  ssh: {
    publicKeys: [
      {
        path: '/home/${LocalAdministratorUsername}/.ssh/authorized_keys'
        keyData: LocalAdministratorPasswordOrKey
      }
    ]
  }
}

var Products = {
  'Cisco Catalyst 8000V-PAYG-DNA Advantage-17.11.01a - x64 Gen1': {
    name: '17_11_01a-payg-advantage'
    offer: 'cisco-c8000v-payg'
    product: 'cisco-c8000v-payg'
    sku: '17_11_01a-payg-advantage'
  }
  'Cisco Catalyst 8000V-PAYG-DNA Essentials-17.11.01a - x64 Gen1': {
    name: '17_11_01a-payg-essentials'
    offer: 'cisco-c8000v-payg'
    product: 'cisco-c8000v-payg'
    sku: '17_11_01a-payg-essentials'
  }
  'Cisco Catalyst 8000V Edge Software-BYOL-17.12.01a - x64 Gen1': {
    name: '17_12_01a-byol'
    offer: 'cisco-c8000v'
    product: 'cisco-c8000v'
    sku: '17_12_01a-byol'
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-04-01' existing = {
  name: VirtualNetworkName
  scope: resourceGroup(VirtualNetworkResourceGroupName)
}

resource subnet1 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' existing = {
  parent: virtualNetwork
  name: Subnet1Name
}

resource subnet2 'Microsoft.Network/virtualNetworks/subnets@2023-04-01' existing = {
  parent: virtualNetwork
  name: Subnet2Name
}

resource availabilitySet 'Microsoft.Compute/availabilitySets@2023-03-01' = {
  name: AvailabilitySetName
  location: Location
  tags: {}
  properties: {
    platformFaultDomainCount: 2
    platformUpdateDomainCount: 5
  }
  sku: {
    name: 'Aligned'
  }
}

resource routeTable 'Microsoft.Network/routeTables@2023-04-01' = {
  name: RouteTableName
  location: Location
  tags: {}
  properties: {
    routes: []
    disableBgpRoutePropagation: true
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: NetworkSecurityGroupName
  location: Location
  tags: {}
  properties: {
    securityRules: [
      {
        name: 'SSHnsgRule'
        properties: {
          description: 'description'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 110
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource networkInterfaces_WAN 'Microsoft.Network/networkInterfaces@2023-04-01' = [for i in range(0, VirtualMachineInstances): {
  name: '${VirtualMachineName}-WAN-NIC${(i + 1)}'
  location: Location
  tags: {}
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnet1.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: networkSecurityGroup.id
    }
  }
}]

resource networkInterfaces_LAN 'Microsoft.Network/networkInterfaces@2023-04-01' = [for i in range(0, VirtualMachineInstances): {
  name: '${VirtualMachineName}-LAN-NIC${(i + 1)}'
  location: Location
  tags: {}
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfig2'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnet2.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: networkSecurityGroup.id
    }
  }
}]

resource virtualMachines 'Microsoft.Compute/virtualMachines@2023-03-01' = [for i in range(0, VirtualMachineInstances): {
  name: '${VirtualMachineName}-${(i + 1)}'
  location: Location
  tags: {}
  plan: {
    name: Products[VirtualMachineSKU].name
    product: Products[VirtualMachineSKU].product
    publisher: 'cisco'
  }
  properties: {
    availabilitySet: {
      id: availabilitySet.id
    }
    hardwareProfile: {
      vmSize: VirtualMachineSize
    }
    osProfile: {
      computerName: '${VirtualMachineName}-${(i + 1)}'
      adminUsername: LocalAdministratorUsername
      adminPassword: LocalAdministratorPasswordOrKey
      linuxConfiguration: ((AuthenticationType == 'password') ? null : linuxConfiguration)
    }
    storageProfile: {
      imageReference: {
        offer: Products[VirtualMachineSKU].offer
        publisher: 'cisco'
        sku: Products[VirtualMachineSKU].sku
        version: 'latest'
      }
      osDisk: {
        name: '${VirtualMachineName}${(i + 1)}-OSDISK'
        createOption: 'FromImage'
        deleteOption: 'Delete'
        managedDisk: {
          storageAccountType: OSDiskPerformance
        }
        diskSizeGB: 127
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_WAN[i].id
          properties: {
            deleteOption: 'Delete'
            primary: true
          }
        }
        {
          id: networkInterfaces_LAN[i].id
          properties: {
            deleteOption: 'Delete'
            primary: false
          }
        }
      ]
    }
  }
}]
