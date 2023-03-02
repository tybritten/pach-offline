# Installing Pachyderm Offline

This repo will help you install pachyderm without an internet connection.

## Prerequisites

- A container repository that your offline kubernetes cluster will have access to.
- A computer that has access to the internet and the container registry that has docker installed and logged into the container registry, and has helm installed.
- A computer that has access to the kubernetes cluster with `kubectl` and `helm` installed.

## Helm Values

You'll need to create a helm values file for installing pachyderm based on [the default pachyderm values file](https://github.com/pachyderm/pachyderm/blob/master/etc/helm/pachyderm/values.yaml).

## Steps to install Pachyderm Offline

### On your internet connected computer

- Download/clone this repository
- Edit `settings.sh` to set the repository and Pachyderm version
- Configure a pachyderm helm `values.yaml` file
- Download the proper pachyderm helm chart by running `./get_chart.sh`. It will create a folder called `pachyderm/` in this repo
- Get your images and push those images to the new repo by running `./get_images.sh -f <values_file>`
- Copy this entire folder (including the values file and downloaded chart) to the computer that has access to the kubernetes cluster with helm/kubectl installed.

### On your computer with access to the cluster

- Make sure you can access the cluster with `kubectl get all`
- Go into this folder that you've copied onto this computer.
- run your helm install command with `--no hooks` and `--post-renderer ./post-renderer.sh` included. For example: `helm install pachyderm pachyderm/ --no-hooks -f <values file> --post-renderer ./post-renderer.sh`

After this you should have pachyderm installed with your settings. Check that it successfully installed by running `kubectl get pods`
