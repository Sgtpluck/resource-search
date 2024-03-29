Project Resource Search
========================

<<TKTK: quick summary of project>>

## Development

If you're new to Rails, see the [Getting Started with Rails](https://guides.rubyonrails.org/getting_started.html)
guide for an introduction to the framework.

### Local Setup

* Install Ruby ruby-3.0.3
* Install NodeJS 14.18
* Install PostgreSQL: `brew install postgresql`
  * Add postgres to your PATH if it wasn't done automatically
  `echo 'export PATH="/usr/local/opt/postgresql/bin:$PATH"' >> ~/.zshrc`
  * Start the server
  `brew services start postgresql`
* Install Ruby dependencies: `bundle install`
* Install chromedriver for integration tests: `brew install --cask chromedriver`
  * Chromedriver must be allowed to run. You can either do that by:
    * The command line: `xattr -d com.apple.quarantine $(which chromedriver)` (this is the only option if you are on Big Sur)
    * Manually: clicking "allow" when you run the integration tests for the first time and a dialogue opens up
* Install JS dependencies: `yarn install`
* Create database: `bundle exec rake db:create`
* Run migrations: `bundle exec rake db:migrate`
* Run the server: `bundle exec rails s`
* Visit the site: http://localhost:3000

#### Setting up a local UAA server

You can set up a local UAA server. Instructions modified from [this cloud.gov repo](https://github.com/cloud-gov/cg-demos/blob/master/cg-identity/README.md#2-run-a-local-uaa-server-for-local-development)

[Install docker](https://docs.docker.com/desktop/install/mac-install/) if you haven't already

```bash
mkdir /tmp/uaa
cp local_uaa_server.yml /tmp/uaa/uaa.yml
docker run -d --name uaa-uaa -p 8080:8080 -v /tmp/uaa:/uaa:rw hortonworks/cloudbreak-uaa:3.6.3
```

Username: user1
Password: wombat


#### Local Configuration

Environment variables can be set in development using the [dotenv](https://github.com/bkeepers/dotenv) gem.

Consistent but sensitive credentials should be added to `config/credentials.yml.env` by using `$ rails credentials:edit`

Any changes to variables in `.env` that should not be checked into git should be set
in `.env.local`.

If you wish to override a config globally for the `test` Rails environment you can set it in `.env.test.local`.
However, any config that should be set on other machines should either go into `.env` or be explicitly set as part
of the test.

#### Authentication

TBD

### Inline `<script>` and `<style>` security

The system's Content-Security-Policy header prevents `<script>` and `<style>` tags from working without further
configuration. Use `<%= javascript_tag nonce: true %>` for inline javascript.

See the [CSP compliant script tag helpers](./doc/adr/0004-rails-csp-compliant-script-tag-helpers.md) ADR for
more information on setting these up successfully.


### Testing

#### Running tests

* Tests: `bundle exec rake spec`
* Ruby linter: `bundle exec rake standard`
* Accessibility scan: `./bin/pa11y-scan`
* Dynamic security scan: `./bin/owasp-scan`
* Ruby static security scan: `bundle exec rake brakeman`
* Ruby dependency checks: `bundle exec rake bundler:audit`
* JS dependency checks: `bundle exec rake yarn:audit`

Run everything: `bundle exec rake`

## CI/CD


GitHub actions are used to run all tests and scans as part of pull requests.

Security scans are also run on a scheduled basis. Weekly for static code scans, and daily for dependency scans.


### Deployment


Each environment has dependencies on a PostgreSQL RDS instance managed by cloud.gov.
See [cloud.gov docs](https://cloud.gov/docs/services/relational-database/) for information on RDS.

#### Staging

First time only: 

* Set security groups

Make sure the application is open to public and trusted local network egress so it can connect to the DB and UAA server
```
cf bind-security-group public_networks_egress sandbox-gsa --space davida.marion
cf bind-security-group trusted_local_networks_egress sandbox-gsa --space davida.marion
```

* create DB service: 

```bash
cf create-service aws-rds micro-psql project_resource_search-rds-stage
```

* Create/bind UAA service:

```bash
cf create-service cloud-gov-identity-provider oauth-client uaa-client
cf create-service-key \
    uaa-client \
    uaa-service-key \
    -c '{"redirect_uri": ["https://project_resource_search-stage.app.cloud.gov/auth", "https://project_resource_search-stage.app.cloud.gov/logout"]}'
cf service-key uaa-client uaa-service-key
```

Take the output and open the Rails credentials:
```bash
EDITOR="vim" rails credentials:edit
```

Copy the client id and client secret into your credentials using the keys:
```
uaa_client_id: $CLIENT_ID_HERE
uaa_client_secret: $CLIENT_SECRET_HERE
```

To deploy:

```bash
cf push --strategy rolling --vars-file config/deployment/stage.yml --var rails_master_key=$(cat config/master.key)
```

Once the deploy has finished, you have to run migrations.

To do this, ssh into the instance of the resource search, 
configure your session to match your application's environment
and then run the migrations.

```bash
cf ssh project_resource_search-stage
/tmp/lifecycle/shell
rake db:migrate
```

TODO: make the deployment steps into a script

#### Production

First time only: create DB service with `cf create-service aws-rds <<SERVICE_PLAN_NAME>> project_resource_search-rds-prod`

`cf push --strategy rolling --vars-file config/deployment/prod.yml --var rails_master_key=$(cat config/master.key)`

### Configuring ENV variables in cloud.gov

All configuration that needs to be added to the deployed application's ENV should be added to
the `env:` block in `manifest.yml`

Items that are both **public** and **consistent** across staging and production can be set directly there.

Otherwise, they are set as a `((variable))` within `manifest.yml` and the variable is defined depending on sensitivity:

#### Credentials and other Secrets


1. Store variables that must be secret using [GitHub Environment Secrets](https://docs.github.com/en/actions/reference/encrypted-secrets#creating-encrypted-secrets-for-an-environment)
1. Add the secret to the `env:` block of the deploy action [as in this example](https://github.com/OHS-Hosting-Infrastructure/complaint-tracker/blob/a9e8d22aae2023a0afb631a6182251c04f597f7e/.github/workflows/deploy-stage.yml#L20)
1. Add the appropriate `--var` addition to the `push_arguments` line on the deploy action [as in this example](https://github.com/OHS-Hosting-Infrastructure/complaint-tracker/blob/a9e8d22aae2023a0afb631a6182251c04f597f7e/.github/workflows/deploy-stage.yml#L27)


#### Non-secrets

Configuration that changes from staging to production, but is public, should be added to `config/deployment/stage.yml` and `config/deployment/prod.yml`



## Documentation

Architectural Decision Records (ADR) are stored in `doc/adr`
To create a new ADR, first install [ADR-tools](https://github.com/npryce/adr-tools) if you don't
already have it installed.
* `brew install adr-tools`

Then create the ADR:
*  `adr new Title Of Architectural Decision`

This will create a new, numbered ADR in the `doc/adr` directory.


## Contributing

*This will continue to evolve as the project moves forward.*

* Pull down the most recent main before checking out a branch
* Write your code
* If a big architectural decision was made, add an ADR
* Submit a PR
  * If you added functionality, please add tests.
  * All tests must pass!
* Ping the other engineers for a review.
* At least one approving review is required for merge.
* Rebase against main before merge to ensure your code is up-to-date!
* Merge after review.
  * Squash commits into meaningful chunks of work and ensure that your commit messages convey meaning.

## Story Acceptance

TBD
