// Scope
targetScope = 'subscription'

// Parameters
param resourceGroupName string
param location string = 'japaneast'
param name string
param userAssignedManagedIdentityId string
param environmentId string
param acrName string
param image string
param imageTag string
param containerName string
param cpu string
param memory string
param volumeMounts array = []

// Resources
resource resourceGroup 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: location
}

module containerApp '../../modules/containerApp.bicep' = {
  scope: resourceGroup
  name: name
  params: {
    name: name
    location: location
    userAssignedManagedIdentityId: userAssignedManagedIdentityId
    environmentId: environmentId
    acrName: acrName
    image: '${image}:${imageTag}'
    containerName: containerName
    cpu: cpu
    memory: memory
    volumeMounts: volumeMounts
  }
}
