variable "ec2-key" {
  type = "map"
  default = {
    prefix = "docker-cluster-instance"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC6Nb3KkpRNeyg2pSJpyuOVQQhhXhvCx7gDDOrQRws0VWWF4SsbbW/8j+QiYJz+ufmCeFEvT6Uxmy6NUuu51nCQ45VbJUJoAgKzwx9imc6QuOTD0EUqn8D75zUE1tDJvPDon9keSsDjlz19c5FVx/si5CxTStZB0RXw3lJ07ta4rThM8DV1zrXHDCDzZomnFMneFrEefX/mDImJITYXEWjrQ1rsOlhxJcOq4NelAiEtqlaGp+OtS+8nQagXQpoFtPRVFK41Y6WobFpSPWLFTLKWOuexXr/cN7wIZvoP2tUS254O+31Nw3OSJTWM2VdE/MRzB82AXEplWJoLQBu34QvMMXRRWy9aUFF6jvhr9Hu67qOZEM22aSOpoQ9e8SB2YaWCO51tsJsU7xglg5RKHI7dIPeoELqOKIpEkU2mA/5c39nLivNufiSr/y9dePUS9Hz9ot89zrb2+ciCwMIPsH7MKpZQovuc/sbFDdl5dzEu9cOIeXgGT9lpfgrPI6wQiDXc3N35N4MuMPpFbxHwIGnz+rsBD7Go9eSVmA0wWcYGrHwQipFFX+4pS11RWkRKTgaIt/RjlvYBOsDvP6OGztexGmA3E25Czk62eAPGLWz7v3gwZQa+RrliK3UoMbA4C6vjOSd/yT3mNfIxo+bGoCi+3Q7+XemaWbfzl0ePPc93qQ=="
  }
}

resource "aws_key_pair" "db_service" {
  key_name_prefix = "${var.ec2-key["prefix"]}"
  public_key = "${var.ec2-key["public_key"]}"
}