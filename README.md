# <#PACKAGE-NAME>-package

This package provides <#PACKAGE> functionality using [<#PACKAGE-NAME>](<#PACKAGE-NAME-DOCS-URL>).

## Components

* <#PACKAGE-NAME>

## Configuration

The following configuration values can be set to customize the <#PACKAGE-NAME> installation.

### Global

| Value | Required/Optional | Description |
|-------|-------------------|-------------|
| `namespace` | Optional | The namespace in which to deploy <#PACKAGE-NAME>. |

## Usage Example

This walkthrough guides you through using <#PACKAGE-NAME>...

## Develop checklist

1. Update your [config.json](./config.json) with the package info
2. Update your [vendir.yml](./src/bundle/vendir.yml) with your upstreams
3. `vendir sync` in `src/bundle` to fetch your new upstream files
4. Add [overlays](./src/bundle/config/overlays/) and [values](./src/bundle/config/values.yaml)
5. Update your [bundle.yml](./src/bundle/.imgpkg/bundle.yml) file
6. Test your bundle: `ytt -f config`
7. Lock images used: `kbld -f . --imgpkg-lock-output .imgpkg/images.yml`
8. Publish your bundle: `imgpkg push --bundle quay.io/failk8s/<#PACKAGE-NAME>-package:<VERSION> --file .`. These steps can be done via [hack/build-package.sh](./hack/build-package.sh)
9. Package up your k8s manifests and test in k8s [hack/package-manifests.sh](./hack/package-manifests.sh). The files will be in `target` folder.
