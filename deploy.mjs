#!/usr/bin/env zx
function escapeShell(cmd) {
  return '"' + cmd.replace(/(["'$`\\])/g, "\\$1") + '"';
}

function parseForgeDeploy(output) {
  const parsed = output.split("\n");
  const lineWithAddress = parsed.find((line) =>
    line.startsWith("Contract Address:")
  );
  const address =
    lineWithAddress.split(" ")[lineWithAddress.split(" ").length - 1];
  return address;
}

const PRIVATE_KEY = process.env.PRIVATE_KEY;
const RPC_URL = process.env.RPC_URL;

let deployments = {};

const { stdout: deploymentOutput } =
  await $`forge script script/Registry.s.sol:DeployRegistry --rpc-url ${RPC_URL} --private-key ${PRIVATE_KEY} --legacy --broadcast`;
const registryAddress = parseForgeDeploy(deploymentOutput);
const DEPLOYMENT = {
  registry: registryAddress,
};

fs.writeFileSync("deployment.json", JSON.stringify(DEPLOYMENT));
