import { execFile } from "node:child_process";
import { promisify } from "node:util";

const sh = promisify(execFile);

export default function (pi) {
	const IDLE = "";
	const SPINNER = "";
	const ERROR = "";

	const pane = process.env.TMUX_PANE;

	let lastState = "";
	let chain = Promise.resolve();
	let sawError = false;

	const setState = (state) => {
		if (state === lastState) return chain;
		lastState = state;

		chain = chain.then(async () => {
			if (!pane) return;

			try {
				if (state) {
					await sh("tmux", ["set", "-w", "-t", pane, "@agent_state", state]);
				} else {
					await sh("tmux", ["set", "-w", "-t", pane, "-u", "@agent_state"]);
				}
			} catch {
				// tmux gone
			}
		});

		return chain;
	};

	pi.on("agent_start", () => {
		sawError = false;
		void setState(SPINNER);
	});

	pi.on("agent_end", (event) => {
		sawError = event.messages?.some((message) => message.role === "assistant" && message.stopReason === "error") ?? false;

		void setState(sawError ? ERROR : IDLE);
	});

	pi.on("session_shutdown", () => {
		void setState("");
	});
}
