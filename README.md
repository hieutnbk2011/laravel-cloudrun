### Dockerfile for Google Cloud Run
Laravel code should be put into www folder.
I already enabled a lot of useful php-extension, but if missing one, you can add to Dockerfile.
## Migrate command:
You can uncomment following command in config/cmd.sh, if you want the container to always try migrate database before start.
```bash
cd /var/www
runuser -u www-data -- php artisan migrate --force --no-interaction
```
## local test
You can use docker-compose to run the local deployment.
```bash
docker-compose up -d
```
Then you can access the app at http://localhost:8080
## Deploy to cloudrun.
Create .env with needed information, and put to www folder.
Build the docker image in local and push, or use Cloud Build
```bash
[root@test ~] gcloud auth configure-docker
[root@test ~] docker build -t gcr.io/<your project id>/laravel-app .
[root@test ~] docker push gcr.io/<your project id>/laravel-app
or you can push to Google Cloud Build to build the image (maybe time)
[root@test ~] gcloud builds submit --tag gcr.io/<your project id>/laravel-app
```
Final, create the Cloud Run service for your use:

```bash
gcloud beta run deploy laravel-app --image gcr.io/<your project id>/laravel-app --region us-central1 --platform managed
```
