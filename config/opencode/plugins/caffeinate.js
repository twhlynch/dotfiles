export const Caffeinate = async ({ $ }) => {
	let process;

	const caffeinate = async (enable) => {
		if (enable) {
			if (process) return;

			process = Bun.spawn(["caffeinate"]);

			return;
		}

		if (!process) return;

		process.kill();
		process = undefined;
	};

	return {
		event: async ({ event }) => {
			if (event.type === "permission.updated") await caffeinate(false);
			if (event.type === "permission.asked") await caffeinate(false);
			if (event.type === "session.idle") await caffeinate(false);
			if (event.type === "session.error") await caffeinate(false);
			if (event.type === "session.status" && event.properties.status.type === "busy") await caffeinate(true);
		},
		"permission.ask": async () => await caffeinate(false),
		"tool.execute.before": async (input) => {
			if (input.tool === "question") await caffeinate(false);
		},
		dispose: async () => await caffeinate(false),
	};
};
