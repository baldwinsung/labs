# aws_route53_record.origin:
resource "aws_route53_record" "origin" {
    name    = "example.com"
    records = [
        "1.1.1.1",
        "2.2.2.2",
        "3.3.3.3",
    ]
    ttl     = 300
    type    = "A"
    zone_id = "XXX"
}

# aws_route53_record.www:
resource "aws_route53_record" "www" {
    name    = "www.example.com"
    records = [
        "1.1.1.1",
        "2.2.2.2",
        "3.3.3.3",
    ]
    ttl     = 300
    type    = "A"
    zone_id = "XXX"
}

