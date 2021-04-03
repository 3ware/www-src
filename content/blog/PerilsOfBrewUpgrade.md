---
title: "The Perils of Brew Upgrade"
summary: "Yesterday, my terraform modules worked, Today, none of my terraform modules work. Yesterday I also ran 'brew upgrade' to update node, could these things be related? Let's find out."
date: 2021-04-03T07:17:42+01:00
draft: false
---

#### Intro

Yesterday, my terraform modules worked, Today, none of my terraform modules work. Yesterday I also ran `brew upgrade` to update node, (so I could install [commitizen](https://commitizen-tools.github.io/commitizen/), with a view to using [sematic-release](https://semantic-release.gitbook.io/semantic-release/) for versioning of my terraform modules. But that's another story and probably another blog post when I've figured it out), could these things be related? Let's find out.

#### TL;DR

**Yes, they are related. 'brew upgrade' upgraded terraform from version 0.13.6 to 0.14.9 and broke everything. Lessons learned: use 'brew pin' to prevent things being upgraded. Use more stringent 'required_versions' for terraform within terraform modules.**

#### The nitty gritty

Today I returned to my terraform studies. To my surprise `terraform plan` did not look pretty at all. The last git commit message I wrote said "everything works (yay!)" - so why didn't it?  

I retraced my steps to the day before, where I'd run `brew upgrade`, among other things, so I checked my terraform version. Again, to my surprise, I was running version 0.14.9. I'm sure I was on 0.13.something before. So, how to downgrade and, more importantly, how to make sure this didn't happen again?  

I found some useful info on [apple.stackexchange.com](https://apple.stackexchange.com/questions/171530/how-do-i-downgrade-node-or-install-a-specific-previous-version-using-homebrew#answer-262119) about downgrading node via brew, so I just applied the same logic to terraform.  

`brew search terraform`  reveals the different versions available.  

`brew unlink terraform` removes the symlinks brew creates in /usr/local

`brew install terraform@0.13` installs the required version

`brew link terraform@0.13` adds the symlinks for /usr/local

And now for the really important part:

`brew pin terraform` will prevent terraform from being upgraded next time I run `brew upgrade`.  

Running `terraform version` displays **Terraform v0.13.6** and `terraform plan` looks good once more.  
