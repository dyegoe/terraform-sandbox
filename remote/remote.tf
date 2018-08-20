terraform {
  backend "consul" {
    address = "demo.consul.io"
    path    = "cust1w69oylco8qy"
    lock    = false
    scheme  = "https"
  }
}