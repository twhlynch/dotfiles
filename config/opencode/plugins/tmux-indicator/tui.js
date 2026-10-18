import { execFile } from "node:child_process";
import { promisify } from "node:util";

const sh = promisify(execFile);

export default {
	id: "tmux-indicator",
	async setup(ctx) {
		const IDLE = "";
		const SPINNER = "";
		const ASK = "";
		const ERROR = "";

		const pane = process.env.TMUX_PANE;
		let lastState = "";
		let busy = false;
		let chain = Promise.resolve();

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

		const myIds = () => {
			const ids = new Set();
			try {
				if (ctx.ui.tabs.enabled()) {
					for (const t of ctx.ui.tabs.list()) ids.add(t.sessionID);
				}
			} catch {
				// tabs unavailable
			}
			try {
				const route = ctx.ui.router.current();
				if (route && route.type === "session") ids.add(route.sessionID);
			} catch {
				// no route yet
			}
			return ids;
		};
		const sid = (event) => {
			const d = event?.data ?? event?.properties ?? {};
			return d.sessionID ?? d.form?.sessionID;
		};
		const mine = (id) => {
			if (!id) return false;
			const ids = myIds();
			if (ids.has(id)) return true;
			try {
				return ids.has(ctx.data.session.root(id));
			} catch {
				return false;
			}
		};

		let sawError = false;
		let forceAsk = false;

		const recompute = () => {
			const ids = myIds();
			let running = false;
			let pending = forceAsk;
			try {
				if (ctx.ui.tabs.enabled()) running = ctx.ui.tabs.list().some((t) => t.busy);
			} catch {}
			for (const id of ids) {
				try {
					if (ctx.data.session.status(id) === "running") running = true;
				} catch {}
				if (!pending) {
					try {
						pending = (ctx.data.session.permission.list(id) || []).length > 0 || (ctx.data.session.form.list(id) || []).length > 0;
					} catch {}
				}
			}
			busy = busy || running;
			if (pending) return setState(ASK);
			if (busy) return setState(SPINNER);
			if (sawError) return setState(ERROR);
			return setState(IDLE);
		};

		await ctx.data.session.sync().catch(() => {});
		await recompute();

		const unsubs = [];
		const on = (type, handler) =>
			unsubs.push(
				ctx.data.on(type, (event) => {
					try {
						handler(event);
					} catch {
						// silent
					}
				}),
			);

		const exec = (fn) => (event) => {
			if (mine(sid(event))) fn();
			else recompute();
		};

		on(
			"session.execution.started",
			exec(() => {
				busy = true;
				sawError = false;
				forceAsk = false;
				void setState(SPINNER);
			}),
		);
		on(
			"session.execution.succeeded",
			exec(() => {
				busy = false;
				sawError = false;
				forceAsk = false;
				void setState(IDLE);
			}),
		);
		on(
			"session.execution.interrupted",
			exec(() => {
				busy = false;
				sawError = false;
				forceAsk = false;
				void setState(IDLE);
			}),
		);
		on(
			"session.execution.failed",
			exec(() => {
				busy = false;
				sawError = true;
				forceAsk = false;
				void setState(ERROR);
			}),
		);
		on("permission.asked", (event) => {
			if (!mine(sid(event))) return recompute();
			forceAsk = true;
			void setState(ASK);
		});
		on("permission.replied", (event) => {
			if (!mine(sid(event))) return recompute();
			forceAsk = false;
			void setState(busy ? SPINNER : IDLE);
		});
		on("form.created", (event) => {
			if (!mine(sid(event))) return recompute();
			forceAsk = true;
			void setState(ASK);
		});
		on("form.replied", (event) => {
			if (!mine(sid(event))) return recompute();
			forceAsk = false;
			void setState(busy ? SPINNER : IDLE);
		});
		on("form.cancelled", (event) => {
			if (!mine(sid(event))) return recompute();
			forceAsk = false;
			void setState(busy ? SPINNER : IDLE);
		});
		on("session.tool.input.started", (event) => {
			const data = event?.data ?? event?.properties;
			if (data?.name !== "question" || !mine(data?.sessionID)) return;
			forceAsk = true;
			void setState(ASK);
		});

		const tick = setInterval(() => recompute(), 2000);

		return () => {
			clearInterval(tick);
			for (const unsubscribe of unsubs) {
				try {
					unsubscribe();
				} catch {}
			}
			void setState("");
		};
	},
};
