output "buckets" {
  value = {
    assets    = module.assets.bucket
    video_in  = module.video_in.bucket
    video_out = module.video_out.bucket
  }
}
