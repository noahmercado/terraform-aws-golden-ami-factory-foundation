# /*
#   Terraform Module properties

#   ---
#   Declares TF required versions, provider required versions, as well as dynamically determines
#   module name and version (git ref).
# */

# locals {

#   /*
#         Determine the module name by parsing the directory name
#   */
#   moduleName = basename(path.module)

#   moduleSources = {
#     /*
#         Load the cached modules.json file as an object and loop through all imported modules 
#     */
#     for m in jsondecode(file(format("%s/.terraform/modules/modules.json", path.root)))["Modules"] :

#     /*
#         Filter the module structs and extract the module's source attribute
#         if the source URI contains the module name local
#     */
#     local.moduleName => m["Source"]...
#     if replace(lower(m["Source"]), lower(local.moduleName), "") != lower(m["Source"])
#   }

#   /*
#       Parse the module's source URI for the ref to determine which moduleVersion is deployed
#   */
#   moduleVersion = replace(lookup(local.moduleSources, local.moduleName, [""])[0], "/^(.+ref=)(.+)$/", "$2")
# }

# terraform {
#   required_providers {
#     aws = ">= 2.7.0"
#   }

#   required_version = ">= 0.12.0"
# }