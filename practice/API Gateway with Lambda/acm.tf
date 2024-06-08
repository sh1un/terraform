resource "aws_acm_certificate" "my_api_cert" {
  domain_name               = "api.tpet.awseducate.systems"
  provider                  = aws.us_east_1
  subject_alternative_names = ["api.tpet.awseducate.systems"]
  validation_method         = "DNS"
}
