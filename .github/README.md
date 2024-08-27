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

   1. In the "Git Checkout" step, ensure the submodules are included so the action can use the theme submodule we will download in step 8.

      ```yml
      name: Git Checkout
        uses: actions/checkout@v2
          with:
            submodules: true
      ```

   2. external_repository: is set to repo02.
   3. personal_token: is set to:

      ```yml
      ${{ secrets.<name_of_the_secret_created_in_step_4> }}
      ```

   4. destination_dir: I set this to /docs so that README.md in /root is not removed.
   5. keep_files: I set this to true so that the CNAME file in /docs is not removed. When using the CNAME option in the action, the CNAME file is created in /root, so it doesn't work.

7. Clone the Hugo source content repository, repo01, to your local machine.
8. Install Hugo.
9. Choose a theme and install as a git submodule in the same directory. **TIP** Fork the theme repo so you can make changes to things like colours and fonts.

   ```zsh
   git submodule add <forked_theme_repo> themes/<theme_name>
   ```

10. Update config.toml with theme, title, author, other parameters, paths to avatars and social links. See hugo and theme documentation for details. I tried a few themes and there are some differences.
11. Create a new post.

    ```zsh
    hugo new posts/<name_of_your_post>.md
    ```

12. Add a 'summary' to the front matter section of the Markdown file created in step 5.
13. Write the blog post in Markdown.
14. Commit everything to save all the changes to your local repository.
15. Preview your blog using the local hugo server.

    ```zsh
    hugo server -D
    ```

    open the URL in a browser.

16. Push the changes to repo01 and watch the GitHub Action do it's thing.
17. Check the content is created in repo02 and check your site via the CNAME.

### The Good News

The gruntwork is done. Next time I want to create a blog post, it's steps 10-15. Create posts, write Markdown, commit and push. The Github Action takes care of the rest.

### Theme dependant steps

In my case I am using the [Introduction](https://github.com/victoriadrake/hugo-theme-introduction) theme, so a few additional steps are required to set this up. This isn't necessary for all themes.

1. Install the packages required by the theme in local repository. This automatically generates the packages-lock.json file used by npm to define dependencies.

   ```zsh
   npm i <package> <package> <package> <etc>
   ```

2. Create packages.json file, which lists packages required.

   ```zsh
   npm init --yes
   ```

3. Update the Github Action to use extended hugo and npm. Extended Hugo is required for PostCSS processing.

   ```yml
   steps:
     # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
     - name: Git Checkout
       uses: actions/checkout@v2
       with:
         submodules: true

     - name: Setup Hugo
       uses: peaceiris/actions-hugo@v2
       with:
         hugo-version: "0.82.0"
         extended: true # enable extended version.

     - name: Setup Node
       uses: actions/setup-node@v2
       with:
         node-version: "15.13"

     - name: Cache dependencies
       uses: actions/cache@v1
       with:
         path: ~/.npm
         key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
         restore-keys: |
           ${{ runner.os }}-node-

     - run: npm ci # this reads the packages-lock.json and packages-json files
     - run: hugo
   ```

4. Commit and push the changes to remote repo and watch the GitHub action go.
