## When updating master

```yaml
# file: .github/workflows/protoconf-master.yml
on:
  push:
    branches:
      - master

name: Protoconf insert to production
jobs:
  checks:
    name: production
    runs-on: self-hosted
    steps:
    - uses: actions/checkout@master
    - name: insert changes
      uses: protoconf/protoconf-actions@master
      with:
        store_type: consul
        store_address: ${{secrets.CONSUL_ADDR}}
        prefix: production
```

## When updating a branch

```yaml
# file: .github/workflows/protoconf-branch.yml
on:
  push:
    branches-ignore:
      - master

name: Protoconf insert to production
jobs:
  checks:
    name: production
    runs-on: self-hosted
    steps:
    - uses: actions/checkout@master
    - name: insert changes
      uses: protoconf/protoconf-actions@master
      with:
        store_type: consul
        store_address: ${{secrets.CONSUL_ADDR}}
        prefix: ${{ github.ref }}
        changes_only: false
```

## When deleting a branch

```yaml
# file: .github/workflows/protoconf-branch-delete.yml
on: delete

name: Protoconf insert to production
jobs:
  checks:
    name: production
    runs-on: self-hosted
    steps:
    - uses: actions/checkout@master
    - name: insert changes
      uses: protoconf/protoconf-actions@master
      with:
        store_type: consul
        store_address: ${{secrets.CONSUL_ADDR}}
        prefix: ${{ github.ref }}
        changes_only: false
        delete: true
```
