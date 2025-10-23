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

module "chatbast"{
    source="./chat_basthost_module"
    pubsub=module.vpc.pubsub
    sgs=module.sg.sgs
    amiid=var.amiid
    path_to_prikey=var.path_to_prikey
}

module "chatdb"{
    source="./chat_database_module"
    prisub=module.vpc.prisub
    sgs=module.sg.sgs
    amiid=var.amiid
    chatbastpubip=module.chatbast.chatbastpubip
    path_to_prikey=var.path_to_prikey
}

module "chatapp" {
  source="./chat_app_module"
  prisub=module.vpc.prisub
  sgs=module.sg.sgs
  amiid=var.amiid
  chatbastpubip=module.chatbast.chatbastpubip
  path_to_prikey=var.path_to_prikey
}