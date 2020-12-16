# monitoring
locals {
  monitoring_alert_channels_security = [google_monitoring_notification_channel.monitoring_notification_channels_email["security"].name]

  # Monitoring email notification channels
  monitoring_notification_channels_emails = {
    billing = {
      display_name  = "Billing Notification Channel"
      email_address = var.group_billing_admins
    },
    developers = {
      display_name  = "Developers Notification Channel"
      email_address = var.group_developers
    },
    devops = {
      display_name  = "DevOps Notification Channel"
      email_address = var.group_devops
    },
    security = {
      display_name  = "Security Notification Channel"
      email_address = var.group_security_admins
    },
  }

  # Monitoring alert policies created in the security GCP project
  monitoring_alert_policies = {
    route = {
      notification_channels = local.monitoring_alert_channels_security
      display_name          = "Route Monitoring"
      filter                = "metric.type=\"logging.googleapis.com/user/route_monitoring/metric\" AND resource.type=\"global\""
    }
    sql_instance = {
      notification_channels = local.monitoring_alert_channels_security
      display_name          = "SQL Instance Monitoring"
      filter                = "metric.type=\"logging.googleapis.com/user/sql_instance_monitoring/metric\" AND resource.type=\"global\""
    }
    network = {
      notification_channels = local.monitoring_alert_channels_security
      display_name          = "Network Monitoring"
      filter                = "metric.type=\"logging.googleapis.com/user/network_monitoring/metric\" AND resource.type=\"global\""
    }
    firewall = {
      notification_channels = local.monitoring_alert_channels_security
      display_name          = "Firewall Monitoring"
      filter                = "metric.type=\"logging.googleapis.com/user/firewall_monitoring/metric\" AND resource.type=\"global\""
    }
    project_ownership = {
      notification_channels = local.monitoring_alert_channels_security
      display_name          = "Project Ownership Monitoring"
      filter                = "metric.type=\"logging.googleapis.com/user/project_ownership_monitoring/metric\" AND resource.type=\"global\""
    }
    bucket_iam = {
      notification_channels = local.monitoring_alert_channels_security
      display_name          = "Bucket IAM Monitoring"
      filter                = "metric.type=\"logging.googleapis.com/user/bucket_iam_monitoring/metric\" AND resource.type=\"global\""
    }
    audit_config = {
      notification_channels = local.monitoring_alert_channels_security
      display_name          = "Audit Config Monitoring"
      filter                = "metric.type=\"logging.googleapis.com/user/audit_config_monitoring/metric\" AND resource.type=\"global\""
    }
    custom_role = {
      notification_channels = local.monitoring_alert_channels_security
      display_name          = "Custom Role Monitoring"
      filter                = "metric.type=\"logging.googleapis.com/user/custom_role_monitoring/metric\" AND resource.type=\"global\""
    }
  }
}

resource "google_monitoring_notification_channel" "monitoring_notification_channels_email" {
  for_each     = local.monitoring_notification_channels_emails
  project      = data.google_project.monitoring.project_id
  display_name = each.value.display_name
  type         = "email"
  labels = {
    email_address = each.value.email_address
  }
}

resource "google_monitoring_alert_policy" "policies" {
  for_each              = local.monitoring_alert_policies
  project               = data.google_project.monitoring.project_id
  display_name          = each.value.display_name
  combiner              = "OR"
  notification_channels = each.value.notification_channels
  conditions {
    display_name = format(
      "logging/user/%s",
      upper(replace(each.value.display_name, " ", "_")),
    )
    condition_threshold {
      filter     = each.value.filter
      duration   = "60s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_COUNT"
      }
      trigger {
        count   = 1
        percent = 0
      }
    }
  }
}

module "projects_log_metrics" {
  for_each = toset([
    data.google_project.production.project_id,
    data.google_project.staging.project_id,
    data.google_project.billing.project_id,
    data.google_project.development.project_id,
    data.google_project.monitoring.project_id,
    data.google_project.shared_network_production.project_id,
    data.google_project.shared_network_non_production.project_id,
    data.google_project.security.project_id,
  ])
  source            = "../modules/gcp/log-metrics"
  google_project_id = each.value
}
