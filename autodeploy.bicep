@description('The type of authentication to use on the virtual machine. SSH key is recommended.')
@allowed([
  'sshPublicKey'
  'password'
])
param AuthenticationType string = 'password'

@description('The name of the availability set.')
param AvailabilitySetName string = 'CSR-8000-AVSET'

@description('The performance SKU of the OS disk drives.')
@allowed([
  'Standard_LRS'
  'StandardSSD_LRS'
  'Premium_LRS'
])
param DiskSKU string = 'Premium_LRS'

@description('The marketplace image that will be used on the virtual machine.')
@allowed([
  'Cisco Catalyst 8000V-PAYG-DNA Advantage-17.11.01a - x64 Gen1'
  'Cisco Catalyst 8000V-PAYG-DNA Essentials-17.11.01a - x64 Gen1'
  'Cisco Catalyst 8000V Edge Software-BYOL-17.12.01a - x64 Gen1'
])
param Image string

@description('The SSH key or password for the virtual machine. SSH key is recommended.')
@secure()
param LocalAdministratorPasswordOrKey string

@description('The username for the local administrator account.')
param LocalAdministratorUsername string = 'csr8000admin'

@description('The location for the Azure resources deployed in this solution.')
param Location string = resourceGroup().location

@minValue(1)
@maxValue(2)
@description('The number of network interfaces to put on each virtual machine.')
param NetworkInterfacesCount int = 2

@description('The name of the network secuity group.')
param NetworkSecurityGroupName string = 'CSR8000-NSG'

@description('The name of the route table.')
param RouteTableName string = 'CSR8000-RouteTable'

@description('The name of the subnet for the WAN network interfaces.')
param Subnet1Name string

@description('The name of the subnet for the LAN network interfaces.')
param Subnet2Name string

@description('The metadata for the Azure resources deployed in this solution.')
param Tags object

@description('The number of Cisco CSR\'s deployed in this solution.')
param VirtualMachineInstances int = 2

@description('Basic Name Pattern of VM Not More than 15 Characters we are appending the Ordinal Number at end of the name')
param VirtualMachineNamePrefix string = 'CSR-8000v'

@description('Select the size for your virtual machine')
@allowed([
  'Standard_D2_v2'
  'Standard_D3_v2'
  'Standard_D4_v2'
  'Standard_DS2_v2'
  'Standard_DS3_v2'
  'Standard_DS4_v2'
  'Standard_F16s_v2'
  'Standard_F32s_v2'
])
param VirtualMachineSize string = 'Standard_DS3_v2'

@description('The resource ID of the existing virtual network provisioned for the workload deployment.')
param VirtualNetworkResourceId string

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
  name: split(VirtualNetworkResourceId, '/')[8]
  scope: resourceGroup(split(VirtualNetworkResourceId, '/')[4])
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
  tags: contains(Tags, 'Microsoft.Compute/availabilitySets') ? Tags['Microsoft.Compute/availabilitySets'] : {}
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
  tags: contains(Tags, 'Microsoft.Network/routeTables') ? Tags['Microsoft.Network/routeTables'] : {}
  properties: {
    routes: []
    disableBgpRoutePropagation: true
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: NetworkSecurityGroupName
  location: Location
  tags: contains(Tags, 'Microsoft.Network/networkSecurityGroups') ? Tags['Microsoft.Network/networkSecurityGroups'] : {}
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
  name: '${VirtualMachineNamePrefix}-WAN-NIC${(i + 1)}'
  location: Location
  tags: contains(Tags, 'Microsoft.Network/networkInterfaces') ? Tags['Microsoft.Network/networkInterfaces'] : {}
  properties: {
    enableAcceleratedNetworking: true
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

resource networkInterfaces_LAN 'Microsoft.Network/networkInterfaces@2023-04-01' = [for i in range(0, VirtualMachineInstances): if (NetworkInterfacesCount > 1) {
  name: '${VirtualMachineNamePrefix}-LAN-NIC${(i + 1)}'
  location: Location
  tags: contains(Tags, 'Microsoft.Network/networkInterfaces') ? Tags['Microsoft.Network/networkInterfaces'] : {}
  properties: {
    enableAcceleratedNetworking: true
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
  name: '${VirtualMachineNamePrefix}-${(i + 1)}'
  location: Location
  tags: contains(Tags, 'Microsoft.Compute/virtualMachines') ? Tags['Microsoft.Compute/virtualMachines'] : {}
  identity: {
    type: 'SystemAssigned'
  }
  plan: {
    name: Products[Image].name
    product: Products[Image].product
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
      computerName: '${VirtualMachineNamePrefix}-${(i + 1)}'
      adminUsername: LocalAdministratorUsername
      adminPassword: LocalAdministratorPasswordOrKey
      linuxConfiguration: ((AuthenticationType == 'password') ? null : linuxConfiguration)
    }
    storageProfile: {
      imageReference: {
        offer: Products[Image].offer
        publisher: 'cisco'
        sku: Products[Image].sku
        version: 'latest'
      }
      osDisk: {
        name: '${VirtualMachineNamePrefix}${(i + 1)}-OSDISK'
        createOption: 'FromImage'
        deleteOption: 'Delete'
        managedDisk: {
          storageAccountType: DiskSKU
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

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for i in range(0, VirtualMachineInstances): {
  scope: routeTable
  name: guid(virtualMachines[i].id, '4d97b98b-1d4f-4787-a291-c67834d212e7', routeTable.id)
  properties: {
    principalId: virtualMachines[i].identity.principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', '4d97b98b-1d4f-4787-a291-c67834d212e7') // Network Contributor
  }
}]
