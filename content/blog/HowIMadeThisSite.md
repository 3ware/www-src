---
title: "How we made this site"
summary: "A quick overview of how we made this web site using Markdown, Hugo, Github Actions and GitHub Pages"
date: 2021-03-31T13:17:02+01:00
draft: false
---

### Overview

As the blog title says, I need to start writing things down to really understand what I am doing. It seems like I am constantly learning something new, which is great, but remembering it all is a challenge, so I created a blog to keep track of my thoughts.

I wanted to use [GitHub Pages](https://pages.github.com/) so I could keep practising my Git skills, write my blog in Markdown and ensure the content was version controlled.  

I also read that [Hugo](https://gohugo.io/) is a great framework to use for generating the necessary files for a static web page and that there are loads of [themes](https://themes.gohugo.io/) to choose from.

### Resources used

Credit where is it due, I read a number of tutorials for this, and tweaked things as I went to make them work for me.

[How to Set Up a Hugo Site on GitHub Pages - with Git Submodules](https://dev.to/aormsby/how-to-set-up-a-hugo-site-on-github-pages-with-git-submodules-106p)  
[Using Git Submodules for Hugo Themes](https://www.andrewhoog.com/post/git-submodule-for-hugo-themes/)  
[Hugo: Host on GitHub](https://gohugo.io/hosting-and-deployment/hosting-on-github/#put-it-into-a-script)  
[Hugo: Deploy Static Site using GitHub Actions](https://ruddra.com/hugo-deploy-static-page-using-github-actions/)  
[GitHub Actions for Hugo](https://github.com/marketplace/actions/hugo-setup)  

### Summary of steps to create a site from scratch

1. Create 2 GitHub repositories. 1 for Hugo source content (repo01), 1 for the static content Hugo generates (repo02).
2. Create GitHub pages in repo02, point it to /docs, set the Custom Domain and enforce HTTPS.
3. Create a personal access token with repo access in repo02.
4. Create a secret in repo01 using the token from step 3.
5. Create a GitHub Action in repo01 to publish the site to repo02 when the commit from local repository is pushed to repo01.
    1. In the "Git Checkout" step, ensure the submodules are included so the action can use the theme submodule we will download in step 8.  

        ```lang-yaml
        name: Git Checkout    
          uses: actions/checkout@v2   
            with:   
              submodules: true  
        ```  

    2. external_repository: is set to repo02.
    3. personal_token: is set to: `${{ secrets.<name_of_the_secret_created_in_step_4> }}`

    4. destination_dir: I set this to /docs so that README.md in /root is not removed.
    5. keep_files: I set this to true so that the CNAME file in /docs is not removed. When using the CNAME option in the action, the CNAME file is created in /root, so it doesn't work.
6. Clone the Hugo source content repository, repo01, to your local machine.
7. Install Hugo.
8. Choose a theme and install as a git submodule in the same directory. **TIP** Fork the theme repo so you can make changes to things like colours and fonts.
  
    `git submodule add <theme_repo> themes/<theme_name>`

9. Update config.toml with theme, title, author, other parameters, paths to avatars and social links. See hugo and theme documentation for details. I tried a few themes and there are some differences.
10. Create a new post.  

    `hugo new posts/<name_of_your_post>.md`

11. Add a 'summary' to the front matter section of the Markdown file created in step 5.
12. Write the blog post in Markdown.
13. Commit everything to save all the changes to your local repository.
14. Preview your blog using the local hugo server.

    `hugo server -D`

    open the URL in a browser.

15. Push the changes to repo01 and watch the GitHub Action do it's thing.
16. Check the content is created in repo02 and check your site via the CNAME.  

### The Good News

The gruntwork is done. Next time I want to create a blog post, it's steps 10-15. Create posts, write Markdown, commit and push. The Github Action takes care of the rest.
