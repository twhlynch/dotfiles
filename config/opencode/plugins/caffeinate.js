export default {
	id: "caffeinate",
	async setup(ctx) {
		let proc;

		const running = new Set();
		const blocked = new Map();

		const sidOf = (event) => event.data?.sessionID ?? event.data?.form?.sessionID;
		const block = (sid) => blocked.set(sid, (blocked.get(sid) ?? 0) + 1);
		const unblock = (sid) => {
			const n = (blocked.get(sid) ?? 0) - 1;
			if (n > 0) blocked.set(sid, n);
			else blocked.delete(sid);
		};

		const caffeinate = (enable) => {
			if (enable) {
				if (proc) return;
				try {
					proc = Bun.spawn(["caffeinate", "-udim"]);
				} catch (e) {
					proc = undefined;
					console.error("caffeinate: spawn failed", String(e));
				}
				return;
			}

			if (!proc) return;
			proc.kill();
			proc = undefined;
		};

		const sync = () => {
			let want = false;
			for (const sid of running) {
				if (!blocked.has(sid)) {
					want = true;
					break;
				}
			}
			caffeinate(want);
		};

		const controller = new AbortController();
		void (async () => {
			for await (const event of ctx.event.subscribe({ signal: controller.signal })) {
				try {
					const type = event.type;
					if (type === "session.execution.started") {
						running.add(sidOf(event));
					} else if (type === "session.execution.succeeded") {
						running.delete(sidOf(event));
						blocked.delete(sidOf(event));
					} else if (type === "session.execution.interrupted") {
						running.delete(sidOf(event));
						blocked.delete(sidOf(event));
					} else if (type === "session.execution.failed") {
						running.delete(sidOf(event));
						blocked.delete(sidOf(event));
					} else if (type === "permission.asked") {
						block(sidOf(event));
					} else if (type === "permission.replied") {
						unblock(sidOf(event));
					} else if (type === "form.created") {
						block(sidOf(event));
					} else if (type === "form.replied") {
						unblock(sidOf(event));
					} else if (type === "form.cancelled") {
						unblock(sidOf(event));
					} else {
						continue;
					}
					sync();
				} catch (e) {
					console.error("caffeinate: event handler error", String(e));
				}
			}
		})().catch((e) => {
			console.error("caffeinate: event subscription failed", String(e));
		});

		return () => {
			controller.abort();
			if (proc) {
				proc.kill();
				proc = undefined;
			}
		};
	},
};
