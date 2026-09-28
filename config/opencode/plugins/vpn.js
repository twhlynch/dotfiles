export const Caffeinate = async ({ $ }) => {
	async function restart() {
		// spawn a process that wont die with opencode
		// have it kill (SIGINT) opencode
		// then use applescript to swap proton vpn servers (optionally start proton, and connect or if runninng, just "change server")
		// then restart opencode with -c and send a "continue" message
	}

	return {
		event: async ({ event }) => {
			if (
				event.type == "session.status" && //
				event.properties?.status?.type == "retry" &&
				event.properties.status.attempt == 2 &&
				event.properties.status.message == "Free usage exceeded, subscribe to Go"
			) {
				restart();
			}
		},
	};
};
