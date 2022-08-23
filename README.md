
# Install

```
yarn add @dfdao/gp-registry
```

# Usage

```ts
import { abi } from "@dfdao/gp-registry/abi/Registry.json";
import { registry } from "@dfdao/gp-registry/deployment.json";

// assuming you're using wagmi.sh
const {
    data,
    isError,
    isLoading,
	} = useContractRead({
    addressOrName: registry,
    contractInterface: abi,
    functionName: "getAllGrandPrix",
    watch: true,
});
```

### How to run locally:

Make sure you have [Foundry](https://github.com/foundry-rs/foundry) installed.

In your terminal, run:

```
yarn start:node
```

In another tab:

```
yarn deploy-local
```