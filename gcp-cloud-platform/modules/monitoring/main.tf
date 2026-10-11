resource "google_monitoring_dashboard" "gke_dashboard" {
  project = var.project_id
  dashboard_json = jsonencode({
    displayName = "ACE GKE Application Dashboard"

    mosaicLayout = {
      columns = 12

      tiles = [
        {
          xPos   = 0
          yPos   = 0
          width  = 6
          height = 4

          widget = {
            title = "GKE Pod Count"

            scorecard = {
              timeSeriesQuery = {
                timeSeriesFilter = {
                  filter = "resource.type = \"k8s_pod\" AND metric.type = \"kubernetes.io/pod/volume/total_bytes\""

                  aggregation = {
                    alignmentPeriod    = "60s"
                    perSeriesAligner   = "ALIGN_MEAN"
                    crossSeriesReducer = "REDUCE_COUNT"
                  }
                }
              }
            }
          }
        },
        {
          xPos   = 6
          yPos   = 0
          width  = 6
          height = 4

          widget = {
            title = "GKE Container CPU Usage"

            xyChart = {
              dataSets = [
                {
                  timeSeriesQuery = {
                    timeSeriesFilter = {
                      filter = "resource.type = \"k8s_container\" AND metric.type = \"kubernetes.io/container/cpu/core_usage_time\""

                      aggregation = {
                        alignmentPeriod    = "60s"
                        perSeriesAligner   = "ALIGN_RATE"
                        crossSeriesReducer = "REDUCE_SUM"
                        groupByFields      = ["resource.label.namespace_name"]
                      }
                    }
                  }

                  plotType = "LINE"
                }
              ]

              yAxis = {
                label = "CPU cores"
                scale = "LINEAR"
              }
            }
          }
        }
      ]
    }
  })
}

resource "google_monitoring_notification_channel" "email" {
  project      = var.project_id
  display_name = "ACE Platform Email Alerts"
  type         = "email"

  labels = {
    email_address = var.alert_email
  }
}

resource "google_monitoring_alert_policy" "high_cpu" {
  project      = var.project_id
  display_name = "ACE - High GKE Container CPU"
  combiner     = "OR"

  conditions {
    display_name = "GKE container CPU above threshold"

    condition_threshold {
      filter = "resource.type = \"k8s_container\" AND metric.type = \"kubernetes.io/container/cpu/core_usage_time\""

      comparison      = "COMPARISON_GT"
      threshold_value = 0.8
      duration        = "300s"

      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields      = ["resource.label.namespace_name"]
      }

      trigger {
        count = 1
      }
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.email.name
  ]

  documentation {
    content   = "Investigate sustained CPU usage by GKE containers. Check Pod resource requests, limits, and application workload."
    mime_type = "text/markdown"
  }

  user_labels = {
    environment = "dev"
    managed_by  = "terraform"
  }
}

resource "google_monitoring_alert_policy" "nginx_availability" {
  project      = var.project_id
  display_name = "ACE - Nginx Replicas Unavailable"
  combiner     = "OR"

  conditions {
    display_name = "Fewer than two Nginx replicas available"

    condition_prometheus_query_language {
      query = <<-EOT
        kube_deployment_status_replicas_available{
          deployment="nginx-app",
          namespace="default"
        } < 2
      EOT

      duration            = "120s"
      evaluation_interval = "30s"
      rule_group          = "nginx-availability"
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.email.name
  ]

  documentation {
    content   = "The nginx-app Deployment has fewer than two available replicas. Check Pod status, scheduling, image pulls, resource limits, and application logs."
    mime_type = "text/markdown"
  }

  user_labels = {
    environment = "dev"
    managed_by  = "terraform"
  }
}