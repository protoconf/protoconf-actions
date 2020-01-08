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
    name: insert
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
        with:
          fetch-depth: 0
      - name: Insert changes
        uses: protoconf/protoconf-actions@master
        with:
          store_type: consul
          store_address: ${{secrets.CONSUL_ADDR}}
          prefix: production
          before_commit: ${{ github.event.before }}
          after_commit: ${{ github.event.after }}
```

## When updating a branch

```yaml
# file: .github/workflows/protoconf-branch.yml
on:
  push:
    branches-ignore:
      - master

name: Protoconf insert to branch
jobs:
  checks:
    name: insert
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - name: Insert changes
      uses: protoconf/protoconf-actions@master
      with:
        store_type: consul
        store_address: ${{secrets.CONSUL_ADDR}}
        prefix: ${{ github.ref }}
        changes_only: false
```
