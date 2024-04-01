output "cluster" {
  value = data.nutanix_clusters.clusters.entities.0.metadata.uuid
}
