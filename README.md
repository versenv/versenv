# versenv

`versenv` is a wrapper scripts to simplify version control of executable files such as kubectl, Terraform, and Packer.

Each wrapper script automatically downloads the executable file that the version specified by the environment variable and executes, and behaves like each command.

## HOW TO USE

Download any wrapper script:

```console
$ curl -#LR https://github.com/newtstat/versenv/releases/latest/download/kubectl -o ./kubectl && chmod +x ./kubectl
########################################################################################## 100.0%
```

Set the environment variable `COMMAND_VERSION` (e.g. `KUBECTL_VERSION`, `TERRAFORM_VERSION`) and run the script.

```console
$ # Automatically downloads and executes the specified version of the executable file.
$ KUBECTL_VERSION=1.23.5 kubectl version --client
2022-04-10T11:19:21+09:00 [   NOTICE] Download https://storage.googleapis.com/kubernetes-release/release/v1.23.5/bin/darwin/amd64/kubectl
2022-04-10T11:19:21+09:00 [     INFO] $ curl -#fLR https://storage.googleapis.com/kubernetes-release/release/v1.23.5/bin/darwin/amd64/kubectl -o /Users/dummy/.cache/versenv/tmp/kubectl
########################################################################################## 100.0%
2022-04-10T11:19:24+09:00 [   NOTICE] Install kubectl to /Users/dummy/.cache/versenv/tmp/kubectl
2022-04-10T11:19:24+09:00 [     INFO] $ chmod +x /Users/dummy/.cache/versenv/tmp/kubectl
2022-04-10T11:19:24+09:00 [     INFO] $ mv -f /Users/dummy/.cache/versenv/tmp/kubectl /Users/dummy/.cache/versenv/kubectl/v1.23.5/bin/kubectl
Client Version: version.Info{Major:"1", Minor:"23", GitVersion:"v1.23.5", GitCommit:"c285e781331a3785a7f436042c65c5641ce8a9e9", GitTreeState:"clean", BuildDate:"2022-03-16T15:58:47Z", GoVersion:"go1.17.8", Compiler:"gc", Platform:"darwin/amd64"}

$ # From the second time on, the downloaded executable file is used.
$ KUBECTL_VERSION=1.23.5 kubectl version --client
Client Version: version.Info{Major:"1", Minor:"23", GitVersion:"v1.23.5", GitCommit:"c285e781331a3785a7f436042c65c5641ce8a9e9", GitTreeState:"clean", BuildDate:"2022-03-16T15:58:47Z", GoVersion:"go1.17.8", Compiler:"gc", Platform:"darwin/amd64"}
```

## Best Practices

I recommend using `versenv` with [`direnv`](https://github.com/direnv/direnv).

Specify the versions of each command in the `.envrc` file and git commit it in the DevOps repository. This will ensure that the same version of the command is executed in the DevOps repository.

```console
$ # Create a bin directory in the root of the DevOps repository and install the scripts there.
$ cd "$(git rev-parse --show-toplevel)"
$ mkdir -p ./bin
$ curl -#LR https://github.com/newtstat/versenv/releases/latest/download/kubectl -o ./bin/kubectl && chmod +x ./bin/kubectl
$ curl -#LR https://github.com/newtstat/versenv/releases/latest/download/terraform -o ./bin/terraform && chmod +x ./bin/terraform

$ # Specify the versions of each command in .envrc
$ cat <<'EOF' > .envrc
export PATH="$(git rev-parse --show-toplevel)/bin:$PATH"
export KUBECTL_VERSION=1.23.5
export TERRAFORM_VERSION=1.1.8
EOF
$ direnv allow .
direnv: loading ~/go/src/github.com/dummy/devops/.envrc
direnv: export +KUBECTL_VERSION +TERRAFORM_VERSION ~PATH

$ # Verify that each command is executed with the specified version.
$ kubectl version --client
Client Version: version.Info{Major: "1", Minor: "23", GitVersion: "v1.23.5", GitCommit: "c285e781331a3785a7f436042c65c5641ce8a9e9", GitTreeState: "clean", BuildDate: "2022-03-16T15:58:47Z", GoVersion: "go1.17.8", Compiler: "gc", Platform: "darwin/amd64"}
$ terraform version
Terraform v1.1.8
on darwin_amd64
```

## Features

### common features

- Each wrapper script automatically downloads the executable file that the version specified by the environment variable and executes, and behaves like each command.
  - e.g.

    ```console
    $ # Use v1.23.5
    $ KUBECTL_VERSION=1.23.5 kubectl version --client
    Client Version: version.Info{Major:"1", Minor:"23", GitVersion:"v1.23.5", GitCommit:"c285e781331a3785a7f436042c65c5641ce8a9e9", GitTreeState:"clean", BuildDate:"2022-03-16T15:58:47Z", GoVersion:"go1.17.8", Compiler:"gc", Platform:"darwin/amd64"}

    $ # Use v1.22.8
    $ KUBECTL_VERSION=1.22.8 kubectl version --client
    Client Version: version.Info{Major:"1", Minor:"22", GitVersion:"v1.22.8", GitCommit:"7061dbbf75f9f82e8ab21f9be7e8ffcaae8e0d44", GitTreeState:"clean", BuildDate:"2022-03-16T14:10:06Z", GoVersion:"go1.16.15", Compiler:"gc", Platform:"darwin/amd64"}
    ```

### kubectl

- Enables switching of kubectl context with the environment variable `KUBECTL_CONTEXT`.
  - e.g.

    ```console
    $ # Use context gke_dummy_us-central1_alpha
    $ KUBECTL_CONTEXT=gke_dummy_us-central1_alpha kubectl get pods
    2022-04-10T16:01:24+09:00 [     INFO] $ kubectl --context=gke_dummy_us-central1_alpha get pods
    NAME                    READY   STATUS    RESTARTS   AGE
    alpha-ffffffffff-fffff  1/1     Running   0          11m

    $ # Use context gke_dummy_us-central1_bravo
    $ KUBECTL_CONTEXT=gke_dummy_us-central1_bravo kubectl get pods
    2022-04-10T16:01:45+09:00 [     INFO] $ kubectl --context=gke_dummy_us-central1_bravo get pods
    NAME                    READY   STATUS    RESTARTS   AGE
    bravo-ffffffffff-fffff  1/1     Running   0          2m
    ```
