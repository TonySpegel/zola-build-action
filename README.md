# Zola Build Action
This GitHub Action builds a website with [Zola](https://www.getzola.org/).

## Usage
The following example builds your Zola website using the main branch on push. There are two [environment variables](#environment-variables) available.
```yml
# .github/workflow/main.yml
on: 
  push:
    branches:
      - main
name: Build a Zola website
jobs:
  build-bundle-deploy:
    runs-on: ubuntu-latest
    steps:
      # Check-out repository under $GITHUB_WORKSPACE
      - name: Checkout
        uses: actions/checkout@v2
      # Build static pages w/ Zola
      - name: Build 🏗️
        uses: TonySpegel/zola-build-action@v1
        env:
          CONFIG_FILE: "config.live.toml"
```
Usually you would like to deploy your page after that step, so the next example is about that and more. As this action is mostly meant for my own usage it also has to resolve/bundle node modules. You can skip that step if you are just interested in building and deploying your page.
```yml
# .github/workflow/main.yml
on: 
  push:
    branches:
      - main
name: Build, Bundle & Deploy
jobs:
  build-bundle-deploy:
    runs-on: ubuntu-latest
    steps:
      # Check-out repository under $GITHUB_WORKSPACE
      - name: Checkout
        uses: actions/checkout@v2
      # Build static pages w/ Zola
      - name: Build 🏗️
        uses: TonySpegel/zola-build-action@v1
        env:
          CONFIG_FILE: "config.live.toml"
      # Install NPM dependencies & bundle w/ Rollup
      - name: Bundle 🧶
        uses: actions/setup-node@v2
        with:
          node-version: '16'
      - run: npm install
      - run: sudo npm run build-rollup-live
      # Deploy to GitHub Pages
      - name: Deploy 🚀
        uses: JamesIves/github-pages-deploy-action@4.1.7
        with:
          branch: gh-pages # The branch the action should deploy to.
          folder: dist # The folder the action should deploy.          
```
If you don't want to use the bundling step just delete that one and if you want to learn more about my setup have a look at my personal website's [repository](https://github.com/TonySpegel/tsp-website)

This may suit your workflow or won't so feel free to build your own. Most of it is a shellscript where you define your own environment variables:
```bash
#!/bin/bash

# [ -z STRING ]: True if the length of "STRING" is zero.

set -e
set -o pipefail

if [[ -z "$BUILD_DIR" ]]; then
    BUILD_DIR="."
fi

if [[ -z "$CONFIG_FILE" ]]; then
    CONFIG_FILE="config.live.toml"
fi

main() {
    version=$(zola --version)

    echo "Using $version"

    echo "Building in $BUILD_DIR directory"
    cd $BUILD_DIR

    zola --config ${CONFIG_FILE} build
}

main "$@"
```
The Docker file downloads and installs the Zola binary and runs the shellscript.

## Environment variables
- `BUILD_DIR`: Where to run `zola build` from. Default is `.` (the current directory)
- `CONFIG_FILE`: Which config file to use to build with Zola. Default is `config.live.toml`
  
An example for a `config.live.toml` file could contain these keys
```toml
base_url = 'https://tony-spegel.com'
output_dir = 'dist'
# + more default keys
```