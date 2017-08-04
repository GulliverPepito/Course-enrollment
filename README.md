# Course register app

Simple Rails app to enroll students with their own repository in a GitHub organization.

### Authentication

This application uses OmniAuth to handle authentication using different strategies. Adding more strategies is possible ([List of strategies](https://github.com/omniauth/omniauth/wiki/List-of-Strategies)), but this app uses GitHub and Google. To use them you must generate an OAuth2 application ID and secret in each service:

##### GitHub

Register your new application [here](https://github.com/settings/applications/new). Then, place your Client ID and Client Secret as environment variables (`GITHUB_CLIENT_ID` and `GITHUB_CLIENT_SECRET`) to be loaded in out `secrets.yml` file. [Go to omniauth-github gem repo](https://github.com/intridea/omniauth-github).

##### Google

Get your API key [here](https://code.google.com/apis/console/) and save your Client ID and Client Secret as environment variables (`GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET`) to be loaded in out `secrets.yml` file. [Go to omniauth-google-oauth2 gem repo](https://github.com/zquestz/omniauth-google-oauth2).

### GitHub usage

This app assumes that you are using an organization (but in you're not... just change the GitHub API urls in `app/helpers/application_helper.rb`). Once an user has signed in using his Google account (only "uc.cl" allowed, but you can change it) and his GitHub account, a form will appear to ask some more information and then the repository will be created. This repository will be created in your organization and will use a template repository. After that, the new member will be added as collaborator to your new repository.

*You'll need a GitHub OAuth token to create repositories in your organization. Save it in your environment (`GITHUB_OAUTH_TOKEN`).*

All of this values are customizable, just keep reading.

### Configuration

What can you customize here? Using `config/customizations.yml` file, you can control:

* **Template:** To create new repositories, this app uses a template to give our students some guidelines about their folder structure. The template **must be a public repository** (mine is [here](https://github.com/aaossa/IIC2233-student-template)).
* **New repositories:** We use our students username in their repository, so you can add a prefix and/or a suffix to ir. Also, you can choose the description using the member fullname and customizing a prefix and a suffix. Projects, Wiki and privacy are available options too.
* **Home content:** This is a simple application, so just fill the title, the course description and explain the process to your future members. It will make everything easier.

### More

##### ReCaptcha

In our form we use ReCaptcha, thanks to [this project](https://github.com/ambethia/recaptcha). Just generate a ReCaptcha Site Key and a Site Secret as explained [here](https://www.google.com/recaptcha/admin) and save them as environment variables (`RECAPTCHA_SITE_KEY` and `RECAPTCHA_SITE_SECRET`).

---

# Happy users :heart:

* [IIC2233](github.com/IIC2233): IIC2233 Programación Avanzada @ Pontificia Universidad Católica de Chile. (2017-2)
