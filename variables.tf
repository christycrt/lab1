variable "CLIENT_SECRET" {
  type = string
  default = "qXCnjYwIaWq9dYOrhJED2fCtfL~c34x7vh"
}

variable "resource" {
    type = "map"

    default = {
        resource_group_name = "INT493"
        location = "southeastasia"
    }
}