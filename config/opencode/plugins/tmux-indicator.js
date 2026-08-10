export const TmuxIndicator = async ({ $ }) => {
	let lastState = "";

	const setState = async (state) => {
		if (state === lastState) return;
		lastState = state;

		const pane = process.env.TMUX_PANE;
		if (!pane) return;

		try {
			if (state) {
				await $`tmux set -w -t ${pane} @agent_state "${state}"`;
			} else {
				await $`tmux set -w -t ${pane} -u @agent_state`;
			}
		} catch {}
	};

	await setState("");

	return {
		event: async ({ event }) => {
			if (event.type === "permission.updated") await setState("");
			if (event.type === "permission.asked") await setState("");
			if (event.type === "session.idle") await setState("");
			if (event.type === "session.error") await setState("");
			if (event.type === "session.status" && event.properties.status.type === "busy") await setState("");
		},
		"permission.ask": async () => await setState(""),
		"tool.execute.before": async (input) => {
			if (input.tool === "question") await setState("");
		},
		dispose: async () => await setState(),
	};
};
