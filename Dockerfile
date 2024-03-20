name: CICD

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Source
        uses: actions/checkout@v3
      - name: Login to Docker Hub
        run: docker login -u ${{ secrets.DOCKER_USERNAME }} -p ${{ secrets.DOCKER_PASSWORD }}
      - name: Build Docker Image
        run: docker build -t parmanandpatelsynsoft679/react-app .
      - name: Publish image to docker hub
        run: docker push parmanandpatelsynsoft679/react-app:latest   

  deploy: 
    needs: build
    runs-on: aws-ec2    
    steps:
      - name: Pull image from docker hub
        run: docker pull parmanandpatelsynsoft679/react-app:latest 
      - name: Delete Old Container
        run: docker rm -f reactContainer
      - name: Run docker container
        run: docker run -d -p 3000:80 --name reactContainer parmanandpatelsynsoft679/react-app   
