package com;

import java.io.File;

import org.alicebot.ab.Bot;
import org.alicebot.ab.Chat;
import org.alicebot.ab.History;
import org.alicebot.ab.MagicBooleans;
import org.alicebot.ab.MagicStrings;
import org.alicebot.ab.utils.IOUtils;

public class AiChatBotApp {
	private static final boolean TRACE_MODE = false;
	static String ChatBotName = "ALEXA";

	public static void main(String[] args) {
		try {

			String appresourcesPath = getResourcesPath();
			System.out.println(appresourcesPath);
			MagicBooleans.trace_mode = TRACE_MODE;
			Bot AiBot = new Bot("super", appresourcesPath);
			Chat chat = new Chat(AiBot);
			AiBot.brain.nodeStats();
			String ip = "";

			while(true) {
				System.out.print("Person: ");
				ip = IOUtils.readInputTextLine();
				if ((ip == null) || (ip.length() < 1))
					ip = MagicStrings.null_input;
				if (ip.equals("q")) {
					System.exit(0);
				} else if (ip.equals("wq")) {
					AiBot.writeQuit();
					System.exit(0);
				} else {
					String request = ip;
					if (MagicBooleans.trace_mode)
						System.out.println("STATE=" + request + ":THAT=" + ((History) chat.thatHistory.get(0)).get(0) + ":TOPIC=" + chat.predicates.get("topic"));
					String response = chat.multisentenceRespond(request);
					while (response.contains("&lt;"))
						response = response.replace("&lt;", "<");
					while (response.contains("&gt;"))
						response = response.replace("&gt;", ">");
					System.out.println("Bot : " + response);
				}
			}
		} catch (Exception exception) {
			exception.printStackTrace();
		}
	}

	private static String getResourcesPath() {
		File directory = new File(".");
		String filepath = directory.getAbsolutePath();
		filepath = filepath.substring(0, filepath.length() - 2);
		System.out.println(filepath);
		String resourcesPath = filepath + File.separator + "src" + File.separator + "main" + File.separator + "resources";
		return resourcesPath;
	}

}
