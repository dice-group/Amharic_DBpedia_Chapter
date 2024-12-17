name: Deploy Angular to GitHub Pages

on:
  push:
    branches:
      - main  # Trigger on pushes to the 'main' branch

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
      # Step 1: Checkout code
      - name: Checkout code
        uses: actions/checkout@v3

      # Step 2: Set up Docker
      - name: Set up Docker
        uses: docker/setup-buildx-action@v2

      # Step 3: Build Docker image
      - name: Build Docker image
        run: docker build -t amharic_dbpedia_chapter .

      # Step 4: Run Docker container and extract files
      - name: Run Docker container and extract files
        id: build-app
        run: |
          docker run --name angular-container amharic_dbpedia_chapter
          docker cp angular-container:/app/docs/dist/DBpedia-Amharic-Chapter ./docs/dist/DBpedia-Amharic-Chapter
          docker rm -f angular-container

      # Step 5: Deploy to GitHub Pages
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./docs/dist/DBpedia-Amharic-Chapter
