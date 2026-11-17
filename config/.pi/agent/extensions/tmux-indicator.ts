import { execFile } from "node:child_process";
import { promisify } from "node:util";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const sh = promisify(execFile);

export default function (pi: ExtensionAPI) {
	const IDLE = "";
	const SPINNER = "";
	const ASK = "";
	const ERROR = "";

	const pane = process.env.TMUX_PANE;

	let lastState = "";
	let chain = Promise.resolve();
	let sawError = false;
	let waitingForUser = false;
	let sandboxAttention = false;

	const setState = (state: string) => {
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

	const updateState = (ctx: ExtensionContext) => setState(waitingForUser || sandboxAttention ? ASK : !ctx.isIdle() ? SPINNER : sawError ? ERROR : IDLE);

	pi.on("session_start", (_event, ctx) => {
		void updateState(ctx);
	});

	pi.on("agent_start", () => {
		sawError = false;
		void setState(waitingForUser || sandboxAttention ? ASK : SPINNER);
	});

	pi.on("agent_end", (event) => {
		sawError = event.messages?.some((message) => message.role === "assistant" && message.stopReason === "error") ?? false;
	});

	pi.on("agent_settled", (_event, ctx) => {
		sandboxAttention = false;
		void updateState(ctx);
	});

	const unsubscribeAttention = pi.events.on("request-attention", (event?: { message?: string }) => {
		if (event?.message !== "Sandbox permission required") return;
		sandboxAttention = true;
		void setState(ASK);
	});

	pi.on("tool_execution_end", (_event, ctx) => {
		if (!sandboxAttention) return;
		sandboxAttention = false;
		void updateState(ctx);
	});

	pi.on("ui_prompt_start", () => {
		waitingForUser = true;
		void setState(ASK);
	});

	pi.on("ui_prompt_end", (_event, ctx) => {
		waitingForUser = false;
		void updateState(ctx);
	});

	pi.on("session_shutdown", () => {
		unsubscribeAttention();
		waitingForUser = false;
		sandboxAttention = false;
		return setState("");
	});
}
