export { useBrowserLocation, useHistoryState, useLocationProperty, usePathname, useSearch } from "wouter/use-browser-location";

import type { navigate as _navigateType } from "wouter/use-browser-location";
import { navigate as _navigate } from "wouter/use-browser-location";

const base = new URL(import.meta.env.BASE_URL, location.href);

export const navigate: typeof _navigateType = (to, opts) => {
	const resolved = new URL(String(to), base);
	_navigate(resolved.pathname + resolved.search + resolved.hash, opts);
};
