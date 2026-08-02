let config = {};

// WhiteNoise serves config.json from STATIC_ROOT under STATIC_URL, matching Vite's `base`
// (`/` in dev, `/static/` in the production build) — see vite.config.js.
const configReady = fetch(`${import.meta.env.BASE_URL}config.json`)
    .then((res) => (res.ok ? res.json() : {}))
    .then((data) => { config = data; })
    .catch(() => {});

export const getAppConfig = () => config;
export const appConfigReady = configReady;
