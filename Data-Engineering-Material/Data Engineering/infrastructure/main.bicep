@description('The name of the resource group')
param resourceGroupName string

@description('The location for the resources')
param location string = resourceGroup().location

@description('Environment name (dev, test, prod)')
param environment string = 'dev'

@description('Storage account name')
param storageAccountName string = 'bankingdatalake${uniqueString(resourceGroup().id)}'

@description('Data Factory name')
param dataFactoryName string = 'banking-data-factory-${environment}'

@description('Databricks workspace name')
param databricksWorkspaceName string = 'banking-databricks-${environment}'

@description('Key Vault name')
param keyVaultName string = 'banking-kv-${environment}'

@description('Application Insights name')
param appInsightsName string = 'banking-appinsights-${environment}'

@description('Virtual network name')
param vnetName string = 'banking-vnet-${environment}'

@description('Subnet name for Databricks')
param databricksSubnetName string = 'databricks-subnet'

@description('Subnet name for private endpoints')
param privateEndpointSubnetName string = 'private-endpoint-subnet'

@description('Tags to apply to resources')
param tags object = {
  Environment: environment
  Project: 'BankingCustomerDataPipeline'
  Owner: 'DataEngineeringTeam'
}

// Variables
var databricksSubnetAddressPrefix = '10.0.1.0/24'
var privateEndpointSubnetAddressPrefix = '10.0.2.0/24'
var vnetAddressPrefix = '10.0.0.0/16'

// Virtual Network
resource vnet 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: vnetName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      {
        name: databricksSubnetName
        properties: {
          addressPrefix: databricksSubnetAddressPrefix
          delegations: [
            {
              name: 'databricks-delegation'
              properties: {
                serviceName: 'Microsoft.Databricks/workspaces'
              }
            }
          ]
        }
      }
      {
        name: privateEndpointSubnetName
        properties: {
          addressPrefix: privateEndpointSubnetAddressPrefix
          privateEndpointNetworkPolicies: 'Disabled'
        }
      }
    ]
  }
}

// Storage Account
resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  tags: tags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    supportsHttpsTrafficOnly: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    networkAcls: {
      defaultAction: 'Deny'
      ipRules: []
      virtualNetworkRules: []
    }
    isHnsEnabled: true
    largeFileSharesState: 'Enabled'
  }
}

// Storage Account Private Endpoint
resource storagePrivateEndpoint 'Microsoft.Network/privateEndpoints@2023-05-01' = {
  name: '${storageAccountName}-pe'
  location: location
  tags: tags
  properties: {
    subnet: {
      id: vnet.properties.subnets[1].id
    }
    privateLinkServiceConnections: [
      {
        name: 'storage-connection'
        properties: {
          privateLinkServiceId: storageAccount.id
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
}

// Storage Account Private DNS Zone
resource storagePrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.blob.core.windows.net'
  location: 'global'
  tags: tags
}

// Private DNS Zone Virtual Network Link
resource storagePrivateDnsZoneVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: storagePrivateDnsZone
  name: '${vnetName}-link'
  location: 'global'
  tags: tags
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}

// Private DNS Zone Group
resource storagePrivateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-05-01' = {
  parent: storagePrivateEndpoint
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'storage-dns-config'
        properties: {
          privateDnsZoneId: storagePrivateDnsZone.id
        }
      }
    ]
  }
}

// Storage Containers
resource rawZoneContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: storageAccount
  name: 'raw-zone'
  properties: {
    publicAccess: 'None'
  }
}

resource validatedZoneContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: storageAccount
  name: 'validated-zone'
  properties: {
    publicAccess: 'None'
  }
}

resource enrichedZoneContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: storageAccount
  name: 'enriched-zone'
  properties: {
    publicAccess: 'None'
  }
}

resource curatedZoneContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: storageAccount
  name: 'curated-zone'
  properties: {
    publicAccess: 'None'
  }
}

resource errorZoneContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: storageAccount
  name: 'error-zone'
  properties: {
    publicAccess: 'None'
  }
}

// Key Vault
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: keyVaultName
  location: location
  tags: tags
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    networkAcls: {
      defaultAction: 'Deny'
      ipRules: []
      virtualNetworkRules: []
    }
  }
}

// Key Vault Private Endpoint
resource keyVaultPrivateEndpoint 'Microsoft.Network/privateEndpoints@2023-05-01' = {
  name: '${keyVaultName}-pe'
  location: location
  tags: tags
  properties: {
    subnet: {
      id: vnet.properties.subnets[1].id
    }
    privateLinkServiceConnections: [
      {
        name: 'keyvault-connection'
        properties: {
          privateLinkServiceId: keyVault.id
          groupIds: [
            'vault'
          ]
        }
      }
    ]
  }
}

// Key Vault Private DNS Zone
resource keyVaultPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.vaultcore.azure.net'
  location: 'global'
  tags: tags
}

// Key Vault Private DNS Zone Virtual Network Link
resource keyVaultPrivateDnsZoneVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: keyVaultPrivateDnsZone
  name: '${vnetName}-link'
  location: 'global'
  tags: tags
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}

// Key Vault Private DNS Zone Group
resource keyVaultPrivateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-05-01' = {
  parent: keyVaultPrivateEndpoint
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'keyvault-dns-config'
        properties: {
          privateDnsZoneId: keyVaultPrivateDnsZone.id
        }
      }
    ]
  }
}

// Application Insights
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  tags: tags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: ''
  }
}

// Databricks Workspace
resource databricksWorkspace 'Microsoft.Databricks/workspaces@2023-02-01' = {
  name: databricksWorkspaceName
  location: location
  tags: tags
  sku: {
    name: 'standard'
  }
  properties: {
    managedResourceGroupId: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroupName}-databricks-rg'
    parameters: {
      enableNoPublicIp: {
        value: true
      }
      customVirtualNetworkId: {
        value: vnet.id
      }
      customPublicSubnetName: {
        value: databricksSubnetName
      }
      customPrivateSubnetName: {
        value: databricksSubnetName
      }
    }
  }
}

// Data Factory
resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: dataFactoryName
  location: location
  tags: tags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publicNetworkAccess: 'Disabled'
    encryption: {
      customerManagedKey: {
        keyName: 'datafactory-key'
        keyVersion: '1'
        keyVaultBaseUrl: keyVault.properties.vaultUri
      }
    }
  }
}

// Data Factory Private Endpoint
resource dataFactoryPrivateEndpoint 'Microsoft.Network/privateEndpoints@2023-05-01' = {
  name: '${dataFactoryName}-pe'
  location: location
  tags: tags
  properties: {
    subnet: {
      id: vnet.properties.subnets[1].id
    }
    privateLinkServiceConnections: [
      {
        name: 'datafactory-connection'
        properties: {
          privateLinkServiceId: dataFactory.id
          groupIds: [
            'dataFactory'
          ]
        }
      }
    ]
  }
}

// Data Factory Private DNS Zone
resource dataFactoryPrivateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.datafactory.azure.net'
  location: 'global'
  tags: tags
}

// Data Factory Private DNS Zone Virtual Network Link
resource dataFactoryPrivateDnsZoneVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: dataFactoryPrivateDnsZone
  name: '${vnetName}-link'
  location: 'global'
  tags: tags
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}

// Data Factory Private DNS Zone Group
resource dataFactoryPrivateDnsZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-05-01' = {
  parent: dataFactoryPrivateEndpoint
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'datafactory-dns-config'
        properties: {
          privateDnsZoneId: dataFactoryPrivateDnsZone.id
        }
      }
    ]
  }
}

// Managed Identity for Data Factory
resource dataFactoryIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: '${dataFactoryName}-identity'
  location: location
  tags: tags
}

// Role Assignments
resource storageBlobDataContributorRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(dataFactoryIdentity.id, storageAccount.id, 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
  scope: storageAccount
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
    principalId: dataFactoryIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

resource keyVaultSecretsUserRole 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(dataFactoryIdentity.id, keyVault.id, '4633458b-17de-408a-b874-0445c86b69e6')
  scope: keyVault
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4633458b-17de-408a-b874-0445c86b69e6')
    principalId: dataFactoryIdentity.properties.principalId
    principalType: 'ServicePrincipal'
  }
}

// Network Security Group for Databricks
resource databricksNsg 'Microsoft.Network/networkSecurityGroups@2023-05-01' = {
  name: '${databricksWorkspaceName}-nsg'
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'AllowDatabricksControlPlane'
        properties: {
          priority: 100
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: 'AzureDatabricks'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
        }
      }
      {
        name: 'AllowDatabricksWorkerNodes'
        properties: {
          priority: 200
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: 'VirtualNetwork'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '443'
        }
      }
    ]
  }
}

// Network Security Group Association
resource databricksSubnetNsgAssociation 'Microsoft.Network/virtualNetworks/subnets@2023-05-01' = {
  parent: vnet
  name: databricksSubnetName
  properties: {
    addressPrefix: databricksSubnetAddressPrefix
    delegations: [
      {
        name: 'databricks-delegation'
        properties: {
          serviceName: 'Microsoft.Databricks/workspaces'
        }
      }
    ]
    networkSecurityGroup: {
      id: databricksNsg.id
    }
  }
}

// Outputs
output storageAccountName string = storageAccount.name
output storageAccountId string = storageAccount.id
output dataFactoryName string = dataFactory.name
output dataFactoryId string = dataFactory.id
output databricksWorkspaceName string = databricksWorkspace.name
output databricksWorkspaceId string = databricksWorkspace.id
output keyVaultName string = keyVault.name
output keyVaultId string = keyVault.id
output appInsightsName string = appInsights.name
output appInsightsId string = appInsights.id
output vnetName string = vnet.name
output vnetId string = vnet.id
output dataFactoryIdentityId string = dataFactoryIdentity.id
output dataFactoryIdentityPrincipalId string = dataFactoryIdentity.properties.principalId 