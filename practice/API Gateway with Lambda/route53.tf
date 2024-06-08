data "aws_route53_zone" "aws_educate_systems_domain" {
  name         = "awseducate.systems"
  private_zone = false
}

resource "aws_route53_record" "api_domain_record" {
  name = "api.tpet"
  type = "CNAME"
  ttl  = "300"

  zone_id = data.aws_route53_zone.aws_educate_systems_domain.zone_id
  records = ["${aws_api_gateway_rest_api.my_api.id}.execute-api.us-east-1.amazonaws.com"]
}
