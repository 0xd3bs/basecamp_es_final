# Starknet Basecamp ES

Fue clonado Repo clonado de https://github.com/smartcontractkit/chainlink-starknet/blob/cf9c32a828bc30a023cb6dfef0c6f1d08c401467/contracts/src/libraries/token/erc20.cairo para el despliegue de esta versión personalizada de un ERC20. Realizado como parte de la actividad final del Basecamp ES Pioneros

## Adicionales.
Incluye pruebas unitartias y de integración.

## Declaración & Despliegue
starknet declare --contract target/dev/basecamp_es_final_ERC20.sierra.json --account version_1077_test

starknet deploy --class_hash 0x58459a6da6313f3e62be4a86ba977cc6f2b6bf9d673678541d77ceadd32f164 --inputs 1522211063044079066910695810296106137330468179 4473411 1000000 0 0x0375f61E4F51Ef9Ab60cb2873e59774839743C7447e0F68A1464F2B1AE3E71E6 --account version_1077_test

### Despliegue adicional
starknet deploy --class_hash 0x58459a6da6313f3e62be4a86ba977cc6f2b6bf9d673678541d77ceadd32f164 --inputs 1522211063044079066910695810296106137330468179 1145197640 1000000 0 0x0375f61E4F51Ef9Ab60cb2873e59774839743C7447e0F68A1464F2B1AE3E71E6 --account version_1077_test

### Despliegue adicional 30-May-2023
(cairo_venv) debs@DESKTOP-KE6H27M:~/starknet/basecamp_es_final$ starknet deploy --class_hash 0x5987fdb527f92bca68e87deb5cfdad870b8848824c06eff2075190948d78ff1 --inputs 1522211063044079066910695810296106137330468179 1145197640 1000000 0 0x0375f61E4F51Ef9Ab60cb2873e59774839743C7447e0F68A1464F2B1AE3E71E6 --account version_1077_test

#### Contract address: 0x04e145f982a34800a64cf301e20e6a29ea38f759abc93247622209dce82edf81
#### Transaction hash: 0x3f58e47463b0e84b9108e3e45578397266cb1ba2e739398feb41b4f295c9ba0