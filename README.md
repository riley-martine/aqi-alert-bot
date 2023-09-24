# aqi-alert-bot

Discord bot to alert when AQI passes a specified threshold.

## Running

1. Get a [token][aqi-token] to get air quality data, and add it to a `.env` file

   ```shell
   AQI_API_TOKEN=some-token
   ```

1. [Create a webhook][create-webhook] in your Discord server
   1. Create a new channel, if needed
   1. Server settings -> Integrations -> Create Webhook (or "View webhooks -> New
     Webhook)
   1. Expand the new webhook
   1. Rename to "AQI bot" or similar, switch to correct channel, and save
   1. Copy webhook URL and add to the `.env` file:

      ```shell
      DISCORD_WEBHOOK_URL="https://example.com"
      ```

1. [Get latitude and longitude][latlong], and add to `.env` in the format
   `lat;long`, e.g. `33.6772973;-106.477862` (notice the semicolon as the
   delimiter, not a comma)

   ```shell
   LAT_LONG="33.6772973;-106.477862"
   ```

1. Add additional configuration variables to `.env`:

   * `AQI_THRESHOLD` - U.S. AQI threshold you want to monitor the crossing of,
     see <https://www.airnow.gov/aqi/aqi-basics/> for more details
   * `MAX_ERRORS` - max number of consecutive errors before the bot sends an
     error message to the designated discord chat, no tuning done here no idea
     what a good number is (I'm using 5)
   * `POLL_INTERVAL` - number of seconds between API requests, minimum of 60 is
     likely best due to frequency of station updates

   There should now be a `.env` file that looks like this:

   ```shell
   AQI_API_TOKEN=some-token
   DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/some-stuff"
   LAT_LONG="33.6772973;-106.477862"
   AQI_THRESHOLD=50
   MAX_ERRORS=5
   POLL_INTERVAL=600
   ```

1. Source the `.env` file

   1. Option 1: install [`direnv`][direnv-install], install [shell
      hooks][direnv-hooks], and run `direnv allow`. This will automatically load
      the environment variables when inside the directory, and reload them if
      they're changed.

   1. Option 2: manually run a command like `set -a; source .env; set +a` (if
      using a POSIX-compliant shell like `bash` or `zsh`)

1. Run the bot: `cargo run`

[aqi-token]: https://aqicn.org/data-platform/token/
[create-webhook]: https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks
[latlong]: https://www.latlong.net/convert-address-to-lat-long.html
[direnv-install]: https://direnv.net/docs/installation.html
[direnv-hooks]: https://direnv.net/docs/hook.html
[shuttle]: https://github.com/shuttle-hq/shuttle
