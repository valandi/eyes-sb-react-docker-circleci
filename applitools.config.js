module.exports = {
  concurrency: 1,
  runInDocker: true,
  puppeteerOptions: {
    headless: true,
    timeout: 0
  },
  readStoriesTimeout: 5000000
}
