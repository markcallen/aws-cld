resource "cloudflare_record" "aws-ns-record" {
  zone_id  = var.zone_id
  count    = length(var.name_servers)
  name     = var.environment
  value    = element(var.name_servers, count.index)
  type     = "NS"
  priority = 1
}
