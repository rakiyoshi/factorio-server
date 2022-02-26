import {
  createBot,
  startBot,
  getUser
} from "https://deno.land/x/discordeno@13.0.0-rc22/mod.ts";

const bot = createBot({
  token: Deno.env.get("DISCORD_TOKEN")!,
  intents: ["GuildMessages"],
  botId: BigInt(Deno.env.get("BOT_ID")!),
  events: {
    ready() {
      console.log("Successfully connected to gateway");
    },
    async messageCreate(bot, message) {
      console.log(message.content)
      if (message.channelId === BigInt(Deno.env.get("CHANNEL_ID")!)) {
        if (message.content === "bye") {
          const user = await getUser(bot, message.authorId)
          console.log(user)
          bot.helpers.sendMessage(
            message.channelId,
            {
              content: `die ${user.username} :-1:`,
            },
          );
        } else if (!message.isBot) {
          bot.helpers.sendMessage(
            message.channelId,
            {
              content: ":middle_finger:",
            },
          );
        }
      }
    },
  },
});

await startBot(bot);
