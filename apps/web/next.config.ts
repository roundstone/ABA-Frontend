import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: "export",
  sassOptions: {
    silenceDeprecations: ["import", "global-builtin", "color-functions", "slash-div", "legacy-js-api"],
  },
};

export default nextConfig;
