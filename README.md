## Tor Easy SetUp
This script is to help you setting up your Tor services on your Linux server. It provides 2 configurations at the moment. 
### OS
It supports Ubuntu/Debain only at the moment.
### Configurations
- Tor relay
The Exit node policy now is off. You can change it to ExitPolicy accept *:*
- Tor hidden service. 
Once it's done, it will show you your onion address
### Execution
```sh
sudo ./torsetup.sh
```
### Example Output
```sh
Please select which service you want 1) Tor Relay 2) Tor Hidden Service:2
Tor Hidden Service:
You onion URL: 7ic6huqdzijegjtc7kx2bntdvwyqcajaqmpiggxfplkfqe6v35zmmzqd.onion
```
