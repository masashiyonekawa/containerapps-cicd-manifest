// Parameters
param location string
param name string
param userAssignedManagedIdentityId string
param environmentId string
param acrName string
param image string
param containerName string
param cpu string
param memory string
param volumeMounts array = []

// Resources
resource containerApp 'Microsoft.App/containerApps@2023-05-02-preview' = {
  name: name
  location: location
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedManagedIdentityId}': {}
    }
  }
  properties: {
    configuration: {
      ingress: {
        external: true
        targetPort: 80
        exposedPort: 0
        traffic: [
          {
            latestRevision: true
            weight: 100
          }
        ]
      }
      registries: [
        {
          server: '${acrName}.azurecr.io'
          identity: userAssignedManagedIdentityId
        }
      ]
    }
    environmentId: environmentId
    template: {
      containers: [
        {
          image: image
          name: containerName
          resources: {
            cpu: json(cpu)
            memory: memory
          }
          volumeMounts: volumeMounts
        }
      ]
      scale: {
        maxReplicas: 10
        minReplicas: 0
      }
    }
  }
}
