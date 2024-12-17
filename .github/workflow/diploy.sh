name: Deploy Angular to GitHub Pages

on:
  push:
    branches:
      - main

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up Docker
        uses: docker/setup-buildx-action@v2

      - name: Build Docker image
        run: docker build -t Amharic_DBpedia_Chapter .

      - name: Run Docker container and extract files
        id: build-app
        run: |
          docker run --name angular-container Amharic_DBpedia_Chapter
          docker cp angular-container:/app/dist/DBpedia-Amharic-Chapter ./dist
          docker rm -f angular-container

      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: .doc/dist/DBpedia-Amharic-Chapter
