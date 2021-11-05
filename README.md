# dev-platform-package

This package provides a development platform on top of Kubernetes. This is a special package as it provides an opinionated flavor of a ready to use set of packages.

## Packages

* [cert-manager](https://github.com/failk8s-packages/cert-manager-package)
* [MetalLB](https://github.com/failk8s-packages/metallb-package)
* [external-dns](https://github.com/failk8s-packages/external-dns-package)
* [contour](https://github.com/failk8s-packages/contour-package)
* [docker registry](https://github.com/failk8s-packages/registry-package)
* [TLS certificates support](https://github.com/failk8s-packages/certs-package)
* [Secret Copier Operator](https://github.com/failk8s-packages/secretcopier-operator-package)
* [Knative Serving](https://github.com/failk8s-packages/knative-serving-package)
* [Test Application (Kuar)](https://github.com/failk8s-packages/testapp-package)
* [Test KNative Application (Kuar)](https://github.com/failk8s-packages/testknativeapp-package)

## Configuration

The following configuration values can be set to customize the dev-platform installation.

Configuration can be found in [values](./src/bundle/config/values.yaml) file. These are provided as `--data-values-file` so not need for ytt annotations.

## Usage Example

This walkthrough guides you through using dev-platform...

__NOTE__: `develop` version of the package needs to comply with semver, hence the package will be versioned as `0.0.0+develop`

## Test in minikube

Start minikube:
```
minikube start
```

Install kapp-controller 0.20+
```
kubectl apply -f https://github.com/vmware-tanzu/carvel-kapp-controller/releases/latest/download/release.yml
```

Install the Package Metadata:
```
kubectl apply -f target/k8s
```

Install the Required RBAC for the package install (create the control NS):
```
kubectl apply -f target/test/packageinstall-ns-rbac.yaml
```

Create the configuration file for your cluster:
```
kubectl create secret generic dev-platform -n dev-platform-package --from-file=values.yaml=./profiles/minikube.yaml -o yaml --dry-run=client | kubectl apply -f -
```

Create the package:
```
kubectl apply -f target/test/packageinstall.yaml
```

Verify the installation:
```
watch kubectl get packageinstall -A
```

If there's an issue, you can verify the problem with:

```
kubectl get packageinstall dev-platform -n dev-platform-package -o yaml
```

## Test in TMC Provided cluster (using Tanzu CLI)

Install kapp-controller 0.20+
```
kubectl apply -f https://raw.githubusercontent.com/failk8s-packages/kapp-controller-package/develop/release.yaml
```

Install the Package Repository:
```
tanzu package repository add failk8s --url quay.io/failk8s/failk8s-repo:develop --namespace tanzu-package-repo-global
```
__NOTE__: Namespaces can be `tanzu-package-repo-global` when TMC/TKG/TCE or `kapp-controller-packaging-global` when upstream

List available packages:
```
tanzu package available list
```

Crate package control namespace:
```
kubectl create ns dev-platform-package
```

Create the package:
```
tanzu package install dev-platform -p dev-platform.dev.failk8s.com -v 0.0.0+develop -f profiles/minikube.yaml -n dev-platform-package 
```

Verify the installation:
```
watch kubectl get packageinstall -n dev-platform-package
```

If there's an issue, you can verify the problem with:

```
kubectl get packageinstall dev-platform -n dev-platform-package -o yaml
```

To update the package:
```
tanzu package installed update dev-platform [-v 0.0.0+develop] [-f profiles/minikube.yaml] -n dev-platform-package
```

To delete the package:
```
tanzu package installed delete dev-platform -n dev-platform-package
```


## Develop checklist

1. Update your [config.json](./config.json) with the package info
2. Add [overlays](./src/bundle/config/overlays/) and [values](./src/bundle/config/values.yaml)
3. Test your bundle: `ytt --data-values-file src/example-values/minikube.yaml  -f target/bundle/config` providing a sample values file from [example-values](./src/examples-values/)
4. Build your bundle `./hack/build.sh`
5. Add it to the [failk8s-repo](https://github.com/failk8s-packages/failk8s-repo) and publish the new repo and test the package from there, or [test with local files](./target/test)

**NOTE**: `develop` versions will not be image locked and will have a version of 0.0.0+develop to comply with semver.