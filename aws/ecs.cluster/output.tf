output "cluster_id" {
  description = "The Amazon Resource Name (ARN) that identifies the cluster"
  value       = aws_ecs_cluster.default.id
}
