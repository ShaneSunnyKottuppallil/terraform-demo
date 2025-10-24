provider "aws" {
  region = var.region
}



module "vpc" {
  source = "./vpc_module"
  aza    = var.aza
  azb    = var.azb
  azc    = var.azc
}

module "sg" {
  source = "./security_group_module"
  vpcid=module.vpc.vpcid
}

module "bast"{
    source="./basthost_module"
    pubsub=module.vpc.pubsub
    sgs=module.sg.sgs
    amiid=var.amiid
    path_to_prikey=var.path_to_prikey
}

module "db"{
    source="./database_module"
    prisub=module.vpc.prisub
    sgs=module.sg.sgs
    amiid=var.amiid
    chatbastpubip=module.bast.chatbastpubip
    path_to_prikey=var.path_to_prikey
}

module "app" {
  source="./app_module"
  prisub=module.vpc.prisub
  sgs=module.sg.sgs
  amiid=var.amiid
  chatbastpubip=module.bast.chatbastpubip
  path_to_prikey=var.path_to_prikey
}

module "web"{
  source="./web_module"
  pubsub=module.vpc.pubsub
  sgs=module.sg.sgs
  amiid=var.amiid
  chatbastpubip=module.bast.chatbastpubip
  path_to_prikey=var.path_to_prikey
}

module "intalb" {
  source="./alb_module"
  vpcid=module.vpc.vpcid
  chatappid=module.app.chatappid
  sgs=module.sg.sgs
  prisub=module.vpc.prisub
}