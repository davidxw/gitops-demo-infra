param location string = resourceGroup().location

resource managedCluster 'Microsoft.ContainerService/managedClusters@2021-08-01' = {
  name: 'gitops-demo'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: 'gitops-demo'
    agentPoolProfiles: [
      {
        name: 'agentpool1'
        count: 2
        vmSize: 'Standard_D2_v2'
        osType: 'Linux'
        type: 'VirtualMachineScaleSets'
        mode: 'System'
      }
    ]
  }
}

resource fluxExtension 'Microsoft.KubernetesConfiguration/extensions@2022-03-01' =  {
  name: 'flux'
  properties: {
    extensionType: 'microsoft.flux'
  }
  scope: managedCluster
}

resource fluxConfigInfra 'Microsoft.KubernetesConfiguration/fluxConfigurations@2022-03-01' =  {
  name: 'infra-fluxconfig'
  properties: {
    scope: 'cluster'
    namespace: 'cluster-config'
    sourceKind: 'GitRepository'
    gitRepository: {
      url: 'https://github.com/davidxw/gitops-demo-infra'
      repositoryRef: {
        branch: 'main'
      }
      syncIntervalInSeconds: 30
    }
    kustomizations: {
      'infra': {
        path: './manifests'
        syncIntervalInSeconds: 30
        prune: 'true'
      }
    }
  }
  dependsOn: [
    fluxExtension
  ]
  scope: managedCluster
}

resource fluxConfigApp1 'Microsoft.KubernetesConfiguration/fluxConfigurations@2022-03-01' =  {
  name: 'app1-fluxconfig'
  properties: {
    scope: 'namespace'
    namespace: 'app1'
    sourceKind: 'GitRepository'
    gitRepository: {
      url: 'https://github.com/davidxw/gitops-demo-app1'
      repositoryRef: {
        branch: 'main'
      }
      syncIntervalInSeconds: 30
    }
    kustomizations: {
      'app1': {
        path: './manifests'
        syncIntervalInSeconds: 30
        prune: 'true'
      }
    }
  }
  dependsOn: [
    fluxExtension
  ]
  scope: managedCluster
}
