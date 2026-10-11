resource "kubernetes_deployment_v1" "nginx_app" {
  metadata {
    name      = "nginx-app"
    namespace = "default"

    labels = {
      app = "nginx-app"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "nginx-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx-app"
        }
      }
      spec {
        container {
          name  = "nginx"
          image = "nginx:stable"

          port {
            container_port = 80
            protocol       = "TCP"
          }
        }
        automount_service_account_token = false
        enable_service_links            = false
      }
    }
  }
}

resource "kubernetes_service_v1" "nginx_app" {
  metadata {
    name      = "nginx-app"
    namespace = "default"
    labels = {
      app = "nginx-app"
    }
    annotations = {
      "cloud.google.com/neg" = jsonencode({
        ingress = true
      })
    }
  }

  spec {
    selector = {
      app = "nginx-app"
    }
    port {
      port        = 80
      target_port = "80"
    }
    type = "ClusterIP"
  }
}