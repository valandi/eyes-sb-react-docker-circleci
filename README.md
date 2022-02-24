## To build and run locally 

```
https://github.com/valandi/eyes-sb-react-docker-circleci.git
cd eyes-sb-react-docker-circleci
npm install
docker-compose up
npx eyes-storybook http://localhost:8086/
```

## Objective
We want to expose a storybook server from a docker container, and run eyes-storybook against that server inside of our CircleCI script. 

## What I've found:
The difficulty here is accessing the server inside the remote docker container.
CircleCI has some documentation on working with docker containers in CircleCI:
https://circleci.com/docs/2.0/building-docker-images/

Building and starting a container locally isn't a problem. We can just run eyes-storybook inside of the container, or we can serve the static storybook files from the server, and test eyes-storybook against that server serving the static files. 
Either one of them works fine. 

The issue is that CircleCI won't let you access the exposed servers in the same way, as that would cause a ton of security issues for them. 
(https://discuss.circleci.com/t/how-to-communicate-with-a-docker-container-over-tcp/21308/3)

I've been spending a good amount of time trying to figure out how to actually securely access a remote server, but it's pretty difficult. 

## Repo

https://github.com/valandi/eyes-sb-react-docker-circleci

## Ways to run this locally

Easiest way to run this locally is with docker-compose:
docker-compose up --build
npx eyes-storybook -u http://localhost:8086

The rest of the methods listed below are also ways to run locally with a server in a docker container. 

## Ways I've tried to run this in circleci

### Method 1
With docker-compose:
```
docker-compose up --build
npx eyes-storybook -u http://172.24.0.1:8086/
```

Theoretically, 172.24.0.1 is the IP exposed by the CircleCI VM. Unfortunately, this isn't directly accessible and won't work

### Method 2
Start a Python server in the docker container
Run npm build-storybook
Serve the static files from static-storybook and run against those. 

Once again, this is something that works locally but doesn't seem to work on CircleCI

### Method 3: inject "npx eyes-storybook" into the named docker container
```
npx build-storybook
docker build -t app:$APPLITOOLS_BATCH_ID .
docker run -dp 8086:8086 app:$APPLITOOLS_BATCH_ID # Docker container theoretically has port 8086 exposed serving static storybook files 
docker exec -it app:$APPLITOOLS_BATCH_ID  "npx eyes-storybook"
```

This should theoretically work if we can figure out how to actually inject the cli execution into the docker shell. At this point I've been unable to do it. 

I tried troubleshooting by sshing directly into the CircleCI VM, and then sshing from there into the remote docker container. 
Inside there I WAS able to run npx eyes-storybook, so this should theoretically be possible. 
I just couldn't figure out how to configure the circleci config file correctly. 

## Conclusion
I would either just run eyes-storybook as you normally would inside the CircleCI VM environment, or continue to figure out how to pass the execution to the docker container shell. 
As I said before, when I sshed directly into the container (https://circleci.com/docs/2.0/ssh-access-jobs/), I was able to run eyes-storybook and have the tests show up on the dashboard. 
If I can ssh into the container, it should also be possible to somehow get the command into the docker container shell. 