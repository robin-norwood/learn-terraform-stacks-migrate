## Introduction
## Prerequisites

1. Set up variable set.

## Clone example repository
## Deploy workspace

1. Edit `terraform.tf`, org name.
1. `terraform init`.
1. Apply variable set to workspace.
1. `terraform apply`.

## Migrate workspace to stack

```
$ tf-migrate modules create
```

(Respond with `yes`)

```
$ cd modularized_config
```

```
$ terraform init
```

```
$ tf-migrate stacks prepare
```

```
$ tf-migrate stacks execute
```



## Decommission workspace
## Clean up your infrastructure
