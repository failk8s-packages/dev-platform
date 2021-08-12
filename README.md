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

## Develop checklist

1. Update your [config.json](./config.json) with the package info
2. Add [overlays](./src/bundle/config/overlays/) and [values](./src/bundle/config/values.yaml)
3. Test your bundle: `ytt --data-values-file src/examples-values/override-minikube.yaml  -f target/bundle/config` providing a sample values file from [example-values](./src/examples-values/)
4. Build your bundle `./hack/build.sh`
5. Publish your bundle: `./hack/push.sh`
6. Add it to the [tkgdev-repo](https://github.com/failk8s-packages/tkgdev-repo) and publish the new repo and test the package from there, or [test with local files](./target/test)