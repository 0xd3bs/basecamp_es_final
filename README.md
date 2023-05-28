# Starknet Basecamp ES

Fue clonado Repo clonado de https://github.com/smartcontractkit/chainlink-starknet/blob/cf9c32a828bc30a023cb6dfef0c6f1d08c401467/contracts/src/libraries/token/erc20.cairo para el despliegue de esta versión personalizada de un ERC20. Realizado como parte de la actividad final del Basecamp ES Pioneros

## Adicionales.
Incluye pruebas unitartias y de integración.

## Declaración & Despliegue
starknet declare --contract target/dev/basecamp_es_final_ERC20.sierra.json --account version_1077_test

starknet deploy --class_hash 0x58459a6da6313f3e62be4a86ba977cc6f2b6bf9d673678541d77ceadd32f164 --inputs 1522211063044079066910695810296106137330468179 4473411 1000000 0 0x0375f61E4F51Ef9Ab60cb2873e59774839743C7447e0F68A1464F2B1AE3E71E6 --account version_1077_test

### Despliegue adicional
starknet deploy --class_hash 0x58459a6da6313f3e62be4a86ba977cc6f2b6bf9d673678541d77ceadd32f164 --inputs 1522211063044079066910695810296106137330468179 1145197640 1000000 0 0x0375f61E4F51Ef9Ab60cb2873e59774839743C7447e0F68A1464F2B1AE3E71E6 --account version_1077_test