- Make sure your GOPATH env variable is set

```
export GOPATH=~/go
```

- Build the stacks-migration-dev branch of the CLI with make dev

```
cd ~/code
git clone git@github.com:hashicorp/tf-migrate.git
cd tf-migrate
#git switch -c stacks-migration-dev origin/stacks-migration-dev
#2nd time:
# git fetch
# git switch stacks-migration-dev
# git merge
make dev
```

- Build the stacks-migration-dev branch of the provider with make build

```
cd ~/code
git clone git@github.com:hashicorp/terraform-provider-tfmigrate.git
cd terraform-provider-tfmigrate
git switch -c stacks-migration-dev origin/stacks-migration-dev
#2nd time:
# git fetch
# git switch stacks-migration-dev
# git merge
make build
```

- Add the provider to your dev_overrides in ~/.terraformrc

```
provider_installation {

  dev_overrides {
     "tfmigrate" = "/Users/rnorwood/go/bin"
     "hashicorp/tfmigrate" = "/Users/rnorwood/go/bin"
  }
}
```


```
$ terraform init
```

```
$ terraform apply
```

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
