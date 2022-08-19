#!/usr/bin/env zx
function escapeShell(cmd) {
  return '"' + cmd.replace(/(["'$`\\])/g, "\\$1") + '"';
}

function parseForgeDeploy(output) {
  const lines = output.split("\n");
  const lineWithAddress = lines.find((line) =>
    line.startsWith("Contract Address:")
  );
  const address =
    lineWithAddress.split(" ")[lineWithAddress.split(" ").length - 1];
  return address;
}

const PRIVATE_KEY = process.env.PRIVATE_KEY;

let deployments = {};

const { stdout: deploymentOutput } =
  await $`forge script script/Registry.s.sol:DeployRegistry --rpc-url http://localhost:8545  --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast`;
const registryAddress = parseForgeDeploy(deploymentOutput);

const DEPLOYMENT = {
  registry: registryAddress,
};

fs.writeFileSync("deployment.json", JSON.stringify(DEPLOYMENT));
