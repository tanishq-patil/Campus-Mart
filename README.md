# Campus Mart

Campus Mart is a Rails application. It can be deployed to Railway using the
included Dockerfile.

## Deploy to Railway

1. Push this repository to GitHub and create a Railway project from the
   repository's `main` branch. `railway.json` selects the included `Dockerfile`
   and configures the `/up` healthcheck.
2. Add a Railway volume to the service, mounted at `/rails/storage`. This is
   required to keep the SQLite databases and uploaded files between deploys.
3. Add these service variables in Railway:
   - `SECRET_KEY_BASE`: generate a value with `bundle exec rails secret`.
   - `SOLID_QUEUE_IN_PUMA`: set to `true` to run the job worker in the web
     process.
4. Generate a public domain for the service.

Railway provides the `PORT` variable; the included Puma configuration uses it.
The container prepares the database when it starts. Keep this service to one
replica because SQLite databases on a Railway volume are not shared across
replicas. Deployments using a volume can briefly interrupt traffic.
