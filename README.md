# api-platform-iot
![Image of our project](https://www.imageupload.net/upload-image/2020/01/24/icon.jpg)

This project has been done by ElMehdi BELHADRI, Alexandre LORIER, Rémi MASSENYA and Valentin STOCKMAN.

The project is like a car parking : the car parks are symbolized by buttons. When you push one, it's like there's a car on it.

This IOT system permitt to see wich place of a car park is taken.
When a car is on a place, a red light on the ceilling overhead the place lights and, in the app, we can exactly saw wich place is taken.


IF YOU ARE ON WINDOWS 10 Familly or Entreprise :
You must install docker toolbox : https://github.com/docker/toolbox/releases

FOR THE OTHERS :
You must install docker : https://hub.docker.com/?overlay=onboarding

- You must install nodejs (for the socket) : https://nodejs.org/en/download/
- You must install npm (for the packages) : https://www.npmjs.com/get-npm
- You must install webstorm (IDE nodejs) : https://www.jetbrains.com/webstorm/download/#section=windows
- You must install flutter (framework for Dart langage) : https://flutter.dev/docs/get-started/install
- You must install android studio (IDE for flutter and device simulator) : https://developer.android.com/studio

After all the installations, open the **api-platform-iot** folder with **Webstorm**. Then you need to write this command in the command line simulator of the IDE:
> npm install

This will install all the needed packages.

After that, run docker on your computer, and type this two command one after one, on the command line simulator of the IDE :
> docker-compose build
>docker-compose up

So now you can start **socket/server.js** .

Then you can open the mobile folder with **Android Studio**, [create your simulated device](https://developer.android.com/studio/run/managing-avds), and run the **/lib/main.dart**.
