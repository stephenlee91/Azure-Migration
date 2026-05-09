// monitoring.bicep — Phase 9
param location string = resourceGroup().location
param appInsightsName string = 'appi-stephenlab'
param logAnalyticsName string = 'log-stephenlab'
param appServiceName string = 'app-stephenlab'

// Log Analytics Workspace
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

// Application Insights
resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalytics.id
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

// Connect App Insights to App Service
resource appServiceAppSettings 'Microsoft.Web/sites/config@2023-01-01' = {
  name: '${appServiceName}/appsettings'
  properties: {
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsights.properties.InstrumentationKey
    APPLICATIONINSIGHTS_CONNECTION_STRING: appInsights.properties.ConnectionString
    ApplicationInsightsAgent_EXTENSION_VERSION: '~3'
    ASPNETCORE_ENVIRONMENT: 'Production'
  }
}

// Alert rule — App Service HTTP 5xx errors
resource alertHttp5xx 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: 'alert-http5xx-stephenlab'
  location: 'global'
  properties: {
    description: 'Alert when App Service returns HTTP 5xx errors'
    severity: 2
    enabled: true
    scopes: [resourceId('Microsoft.Web/sites', appServiceName)]
    evaluationFrequency: 'PT5M'
    windowSize: 'PT15M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          name: 'Http5xx'
          metricName: 'Http5xx'
          operator: 'GreaterThan'
          threshold: 5
          timeAggregation: 'Total'
          criterionType: 'StaticThresholdCriterion'
        }
      ]
    }
    autoMitigate: true
  }
}

// Alert rule — VM CPU threshold
resource alertVmCpu 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: 'alert-cpu-sql01'
  location: 'global'
  properties: {
    description: 'Alert when VM-SQL01 CPU exceeds 80%'
    severity: 2
    enabled: true
    scopes: [resourceId('Microsoft.Compute/virtualMachines', 'VM-SQL01')]
    evaluationFrequency: 'PT5M'
    windowSize: 'PT15M'
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          name: 'HighCPU'
          metricName: 'Percentage CPU'
          operator: 'GreaterThan'
          threshold: 80
          timeAggregation: 'Average'
          criterionType: 'StaticThresholdCriterion'
        }
      ]
    }
    autoMitigate: true
  }
}

output appInsightsKey string = appInsights.properties.InstrumentationKey
output appInsightsConnectionString string = appInsights.properties.ConnectionString