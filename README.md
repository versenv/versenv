<!-- markdownlint-disable MD013 -->
# [`versenv`](https://github.com/versenv/versenv) - Environment variable oriented version control tool

[![license](https://img.shields.io/github/license/versenv/versenv)](LICENSE)
[![workflow](https://github.com/versenv/versenv/workflows/sh-test/badge.svg)](https://github.com/versenv/versenv/tree/main)
[![workflow](https://github.com/versenv/versenv/workflows/shellcheck/badge.svg)](https://github.com/versenv/versenv/tree/main)

`versenv` is a set of wrapper scripts to simplify the installation and versioning of executables such as kubectl, Terraform and Packer.

Are you suffering from any of these problems?

- Different versions of kubectl should be used for each participating project.
- Different team members have different versions of kubectl installed in their environment.
- You have to explain to each person how to install the correct version of kubectl.
- Even if you explain it, they don't always install the correct version of kubectl.
- You have the same problems with terraform, packer, etc.

If so, `versenv` solves them.

Each wrapper script provided by `versenv` automatically downloads the executable file that the version specified by the environment variable and executes, and behaves like each command.

`versenv` supports the following:

<!-- markdownlint-disable MD033 MD034 -->
| `versenv` file                | target                                        | download `versenv` file one-liner                                                                                                                        |
|:------------------------------|:----------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------|
| [`awscliv2`](/bin/aws)        | https://github.com/aws/aws-cli/tree/v2        | <pre><code>curl --tlsv1.2 -#fLR https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/aws -o ./aws && chmod +x ./aws</pre></code>                   |
| [`buf`](/bin/buf)             | https://github.com/bufbuild/buf               | <pre><code>curl --tlsv1.2 -#fLR https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/buf -o ./buf && chmod +x ./buf</pre></code>                   |
| [`gitleaks`](/bin/gitleaks)   | https://github.com/gitleaks/gitleaks          | <pre><code>curl --tlsv1.2 -#fLR https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/gitleaks -o ./gitleaks && chmod +x ./gitleaks</pre></code>    |
| [`helm`](/bin/helm)           | https://github.com/helm/helm                  | <pre><code>curl --tlsv1.2 -#fLR https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/helm -o ./helm && chmod +x ./helm</pre></code>                |
| [`kubectl`](/bin/kubectl)     | https://kubernetes.io/docs/reference/kubectl/ | <pre><code>curl --tlsv1.2 -#fLR https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/kubectl -o ./kubectl && chmod +x ./kubectl</pre></code>       |
| [`packer`](/bin/packer)       | https://www.packer.io/                        | <pre><code>curl --tlsv1.2 -#fLR https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/packer -o ./packer && chmod +x ./packer</pre></code>          |
| [`protoc`](/bin/protoc)       | https://github.com/protocolbuffers/protobuf   | <pre><code>curl --tlsv1.2 -#fLR https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/protoc -o ./protoc && chmod +x ./protoc</pre></code>          |
| [`sops`](/bin/sops)           | https://github.com/getsops/sops               | <pre><code>curl --tlsv1.2 -#fLR https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/sops -o ./sops && chmod +x ./sops</pre></code>                |
| [`terraform`](/bin/terraform) | https://www.terraform.io/                     | <pre><code>curl --tlsv1.2 -#fLR https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/terraform -o ./terraform && chmod +x ./terraform</pre></code> |
| [`tflint`](/bin/tflint)       | https://github.com/terraform-linters/tflint   | <pre><code>curl --tlsv1.2 -#fLR https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/tflint -o ./tflint && chmod +x ./tflint</pre></code>          |

<details><summary>Other</summary>

| `versenv` file                        | target                                    | download `versenv` file one-liner                                                                                                                                    |
|:--------------------------------------|:------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [`arcgen`](/bin/arcgen)               | https://github.com/kunitsucom/arcgen      | <pre><code>curl --tlsv1.2 -#fLR https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/arcgen -o ./arcgen && chmod +x ./arcgen</pre></code>                      |
| [`ddlctl`](/bin/ddlctl)               | https://github.com/hakadoriya/ddlctl      | <pre><code>curl --tlsv1.2 -#fLR https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/ddlctl -o ./ddlctl && chmod +x ./ddlctl</pre></code>                      |
| [`direnv`](/bin/direnv)               | https://github.com/direnv/direnv          | <pre><code>curl --tlsv1.2 -#fLR https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/direnv -o ./direnv && chmod +x ./direnv</pre></code>                      |
| [`eksctl`](/bin/eksctl)               | https://github.com/weaveworks/eksctl      | <pre><code>curl --tlsv1.2 -#fLR https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/eksctl -o ./eksctl && chmod +x ./eksctl</pre></code>                      |
| [`fzf`](/bin/fzf)                     | https://github.com/junegunn/fzf           | <pre><code>curl --tlsv1.2 -#fLR https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/fzf -o ./fzf && chmod +x ./fzf</pre></code>                               |
| [`ghq`](/bin/ghq)                     | https://github.com/x-motemen/ghq          | <pre><code>curl --tlsv1.2 -#fLR https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/ghq -o ./ghq && chmod +x ./ghq</pre></code>                               |
| [`golangci-lint`](/bin/golangci-lint) | https://github.com/golangci/golangci-lint | <pre><code>curl --tlsv1.2 -#fLR https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/golangci-lint -o ./golangci-lint && chmod +x ./golangci-lint</pre></code> |
| [`goreleaser`](/bin/goreleaser)       | https://github.com/goreleaser/goreleaser  | <pre><code>curl --tlsv1.2 -#fLR https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/goreleaser -o ./goreleaser && chmod +x ./goreleaser</pre></code>          |
| [`hammer`](/bin/hammer)               | https://github.com/daichirata/hammer      | <pre><code>curl --tlsv1.2 -#fLR https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/hammer -o ./hammer && chmod +x ./hammer</pre></code>                      |
| [`migrate`](/bin/migrate)             | https://github.com/golang-migrate/migrate | <pre><code>curl --tlsv1.2 -#fLR https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/migrate -o ./migrate && chmod +x ./migrate</pre></code>                   |
| [`sccache`](/bin/sccache)             | https://github.com/mozilla/sccache        | <pre><code>curl --tlsv1.2 -#fLR https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/sccache -o ./sccache && chmod +x ./sccache</pre></code>                   |
| [`stern`](/bin/stern)                 | https://github.com/stern/stern            | <pre><code>curl --tlsv1.2 -#fLR https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/stern -o ./stern && chmod +x ./stern</pre></code>                         |
| [`typos`](/bin/typos)                 | https://github.com/crate-ci/typos         | <pre><code>curl --tlsv1.2 -#fLR https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/typos -o ./typos && chmod +x ./typos</pre></code>                         |

</details>
<!-- markdownlint-enable -->
<!-- markdownlint-disable MD013 -->

## HOW TO USE

Download any wrapper script provided by `versenv`:

```console
$ curl --tlsv1.2 -#fLR https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/kubectl -o ./kubectl && chmod +x ./kubectl
########################################################################################## 100.0%
```

Set the environment variable `COMMAND_VERSION` (e.g. `KUBECTL_VERSION`, `TERRAFORM_VERSION`) and run the script.

```console
$ # Automatically downloads and executes the specified version of the executable file.
$ KUBECTL_VERSION=1.23.5 ./kubectl version --client
2022-04-10T11:19:21+09:00 [   NOTICE] Download https://storage.googleapis.com/kubernetes-release/release/v1.23.5/bin/darwin/amd64/kubectl
2022-04-10T11:19:21+09:00 [     INFO] $ curl --tlsv1.2 --connect-timeout 2 --progress-bar -fLR https://storage.googleapis.com/kubernetes-release/release/v1.23.5/bin/darwin/amd64/kubectl -o /Users/dummy/.cache/versenv/tmp/kubectl
########################################################################################## 100.0%
2022-04-10T11:19:24+09:00 [   NOTICE] Install kubectl to /Users/dummy/.cache/versenv/tmp/kubectl
2022-04-10T11:19:24+09:00 [     INFO] $ chmod +x /Users/dummy/.cache/versenv/tmp/kubectl
2022-04-10T11:19:24+09:00 [     INFO] $ mv -f /Users/dummy/.cache/versenv/tmp/kubectl /Users/dummy/.cache/versenv/kubectl/v1.23.5/bin/kubectl
Client Version: version.Info{Major:"1", Minor:"23", GitVersion:"v1.23.5", GitCommit:"c285e781331a3785a7f436042c65c5641ce8a9e9", GitTreeState:"clean", BuildDate:"2022-03-16T15:58:47Z", GoVersion:"go1.17.8", Compiler:"gc", Platform:"darwin/amd64"}

$ # From the second time on, the downloaded executable file is used.
$ KUBECTL_VERSION=1.23.5 ./kubectl version --client
Client Version: version.Info{Major:"1", Minor:"23", GitVersion:"v1.23.5", GitCommit:"c285e781331a3785a7f436042c65c5641ce8a9e9", GitTreeState:"clean", BuildDate:"2022-03-16T15:58:47Z", GoVersion:"go1.17.8", Compiler:"gc", Platform:"darwin/amd64"}
```

## Best Practices

I recommend using `versenv` with [`direnv`](https://github.com/direnv/direnv).

Specify the versions of each command in the `.envrc` file and git commit it in the DevOps repository. This will ensure that the same version of the command is executed in the DevOps repository.

```console
$ # Create a bin directory in the root of the DevOps repository and install the scripts there.
$ cd "$(git rev-parse --show-toplevel)"
$ curl --tlsv1.2 -fLRSs https://raw.githubusercontent.com/versenv/versenv/HEAD/install.sh | VERSENV_SCRIPTS=kubectl,terraform VERSENV_PATH=./bin bash

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

### `kubectl`, `helm`, `stern`

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

## Other

### `install.sh`

- You can run `install.sh` to install a set of versenv scripts to `VERSENV_PATH` directory at once:

  ```bash
  curl --tlsv1.2 -fLRSs https://raw.githubusercontent.com/versenv/versenv/HEAD/install.sh | VERSENV_PATH=./bin bash
  ```

- If you set `VERSENV_SCRIPTS`, you can install only the scripts you choose.

  - e.g.

    ```console
    $ curl --tlsv1.2 -fLRSs https://raw.githubusercontent.com/versenv/versenv/HEAD/install.sh | VERSENV_SCRIPTS=kubectl,terraform VERSENV_PATH=./bin bash
    2022-04-18T10:32:36+09:00 [   NOTICE] Start downloading versenv scripts (kubectl terraform) to ./bin
    2022-04-18T10:32:36+09:00 [     INFO] $ mkdir -p ./bin
    2022-04-18T10:32:37+09:00 [     INFO] $ curl --tlsv1.2 --connect-timeout 2 --progress-bar -fLR https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/terraform -o ./bin/terraform
    ########################################################################################## 100.0%
    2022-04-18T10:32:36+09:00 [     INFO] $ curl --tlsv1.2 --connect-timeout 2 --progress-bar -fLR https://raw.githubusercontent.com/versenv/versenv/HEAD/bin/kubectl -o ./bin/kubectl
    ########################################################################################## 100.0%
    2022-04-11T04:03:01+09:00 [   NOTICE] Complete!
    ```
