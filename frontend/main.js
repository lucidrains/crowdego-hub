import "htmx.org";
import { createApp, h, ref } from "vue";

createApp({
	setup() {
		const count = ref(0);
		return () =>
			h(
				"button",
				{ type: "button", onClick: () => count.value++ },
				`Hello from Vue! Clicked ${count.value} times`,
			);
	},
}).mount("#vue-app");
