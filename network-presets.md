### Bandwidth requirements Arma server
Rule of thumb is `Required Bandwidth [Mbit] = Player amount * 0.5`.
Above value should roughly be peak upload.

### Values gotten through trial and error
Thanks to Karmakut and his arma group for patiently waiting out server crashes.
```
MaxBandwidth = 2147483647; // 2.1 gbit
MinBandwidth = 25600000; // 250 mbit
MaxMsgSend = 48;
MaxSizeGuaranteed = 512;
MaxSizeNonguaranteed = 1024;
MinErrorToSend = 0.001;
MinErrorToSendNear = 0.01;
```
**Tested By**
Karmakut, 100 players, 1Gbit
Frenki#3671, armasrbija.rs, ~50 players
Crowdedlight@Slack, 92 players
16AA, 65 players, 1Gbit
Let me know if it worked for you and I'll add you to this list.

### Arma Default Values
```
MinBandwidth=131072; //0.131072 Megabit
//MaxBandwidth=2e9; //2 gbit

MaxMsgSend = 128;
MaxSizeGuaranteed = 512;
MaxSizeNonguaranteed = 256;

MinErrorToSend = 0.001;
MinErrorToSendNear = 0.01;

MaxCustomFileSize = 0; //not mentioned so set to 0
class sockets{maxPacketSize = 1400;};
```