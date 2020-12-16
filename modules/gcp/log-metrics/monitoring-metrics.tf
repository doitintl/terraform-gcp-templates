resource "google_logging_metric" "log_metric_route" {
  project = var.google_project_id
  name    = "route_monitoring/metric"
  filter  = "resource.type=\"gce_route\" AND jsonPayload.event_subtype=\"compute.routes.delete\" OR jsonPayload.event_subtype=\"compute.routes.insert\""
  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    unit         = "1"
    display_name = "Route Monitoring"
  }
}

resource "google_logging_metric" "log_metric_sql_instance" {
  project = var.google_project_id
  name    = "sql_instance_monitoring/metric"
  filter  = "protoPayload.methodName=\"cloudsql.instances.update\""
  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    unit         = "1"
    display_name = "SQL Instance Monitoring"
  }
}

resource "google_logging_metric" "log_metric_network" {
  project = var.google_project_id
  name    = "network_monitoring/metric"
  filter  = "resource.type=gce_network AND jsonPayload.event_subtype=\"compute.networks.insert\" OR jsonPayload.event_subtype=\"compute.networks.patch\" OR jsonPayload.event_subtype=\"compute.networks.delete\" OR jsonPayload.event_subtype=\"compute.networks.removePeering\" OR jsonPayload.event_subtype=\"compute.networks.addPeering\""
  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    unit         = "1"
    display_name = "Network Monitoring"
  }
}

resource "google_logging_metric" "log_metric_firewall" {
  project = var.google_project_id
  name    = "firewall_monitoring/metric"
  filter  = "resource.type=\"gce_firewall_rule\" AND jsonPayload.event_subtype=\"compute.firewalls.patch\" OR jsonPayload.event_subtype=\"compute.firewalls.insert\""
  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    unit         = "1"
    display_name = "Firewall Monitoring"
  }
}

resource "google_logging_metric" "log_metric_project_ownership" {
  project = var.google_project_id
  name    = "project_ownership_monitoring/metric"
  filter  = "(protoPayload.serviceName=\"cloudresourcemanager.googleapis.com\") AND (ProjectOwnership OR projectOwnerInvitee) OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"REMOVE\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\") OR (protoPayload.serviceData.policyDelta.bindingDeltas.action=\"ADD\" AND protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\")"
  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    unit         = "1"
    display_name = "Project Ownership Monitoring"
  }
}

resource "google_logging_metric" "log_metric_bucket_iam" {
  project = var.google_project_id
  name    = "bucket_iam_monitoring/metric"
  filter  = "resource.type=gcs_bucket AND protoPayload.methodName=\"storage.setIamPermissions\""
  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    unit         = "1"
    display_name = "Bucket IAM Monitoring"
  }
}

resource "google_logging_metric" "log_metric_audit_config" {
  project = var.google_project_id
  name    = "audit_config_monitoring/metric"
  filter  = "protoPayload.methodName=\"SetIamPolicy\" AND protoPayload.serviceData.policyDelta.auditConfigDeltas:*"
  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    unit         = "1"
    display_name = "Audit Config Monitoring"
  }
}

resource "google_logging_metric" "log_metric_custom_role" {
  project = var.google_project_id
  name    = "custom_role_monitoring/metric"
  filter  = "resource.type=\"iam_role\" AND protoPayload.methodName=\"google.iam.admin.v1.CreateRole\" OR protoPayload.methodName=\"google.iam.admin.v1.DeleteRole\" OR protoPayload.methodName=\"google.iam.admin.v1.UpdateRole\""
  metric_descriptor {
    metric_kind  = "DELTA"
    value_type   = "INT64"
    unit         = "1"
    display_name = "Custom Role Monitoring"
  }
}
