# 3ware Ltd Website

[![semantic-release: conventionalcommits](https://img.shields.io/badge/semantic--release-conventionalcommits-blue?logo=semantic-release)](https://github.com/semantic-release/semantic-release) [![GitHub release](https://img.shields.io/github/release/3ware/www-src?include_prereleases=&sort=semver&color=yellow)](https://github.com/3ware/www-src/releases/) [![issues - workflows](https://img.shields.io/github/issues/3ware/www-src)](https://github.com/3ware/www-src/issues) [![CI](https://img.shields.io/github/actions/workflow/status/3ware/www-src/lint-and-test.yaml?label=CI&logo=githubactions&logoColor=white)](https://github.com/3ware/www-src/actions/workflows/lint-and-test.yaml)

This repository contains the code necessary to create and deploy the 3ware Ltd company website.

## Overview

3ware's website is hosted on [GitHub Pages](https://pages.github.com/) using [Hugo](https://gohugo.io/) to generate the static content from Markdown files.

## Resources used

The following resources were used to create this website:

- [Hugo Quick Start guide](https://gohugo.io/getting-started/quick-start/)
- [Ananke theme tutorial](https://themes.gohugo.io/themes/gohugo-theme-ananke/)
- [Ananke example site](https://github.com/theNewDynamic/gohugo-theme-ananke/tree/master/exampleSite)
- [Hugo: Host on GitHub](https://gohugo.io/hosting-and-deployment/hosting-on-github/#put-it-into-a-script)
- [GitHub Actions for Hugo](https://github.com/marketplace/actions/hugo-setup)

## Summary of steps to create a site from scratch

1. Create 2 GitHub repositories. 1 for Hugo source content (www-src) and 1 for the static content Hugo generates (www-public).
2. Follow the Hugo Quick Start guide to initialise the site and add the theme.
3. Create GitHub pages in www-public, point it to /docs, set the Custom Domain and enforce HTTPS.
4. Create a [deploy key](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/managing-deploy-keys#set-up-deploy-keys) and add the public key to www-public.
5. Create a GitHub Action repository secret in www-src using the private key from step 3.
6. Create a GitHub Action in www-src to publish the site to www-public when a release is created www-src.
