# Android Studio Webtop

**Under Active Development, not yet fully functional**

Android Studio Webtop is a Dockerized environment that allows you to run Android Studio within a web browser using a VNC server. This setup is ideal for developers who need a portable and consistent development environment that can be accessed from any device with a web browser.

## Project Goals

 - Fully managed docker image of Android developer environment with fast and responsive Web access to test alternatives to Gateway, Projector, xrdp, etc..
 - Managed window decoration in Android Studio to enable PWA usability
 - Support for customization around precloning repo, setting up defaults in Android Studio, and applying user customizations  

## Features

- **Android Studio**: Run the latest version of Android Studio.
- **Web-based Access**: Access the development environment via a web browser with a modern streaming stack.
- **Openbox Window Manager**: Lightweight and configurable window manager.



## Prerequisites

- Docker installed on your host machine.

## Installation

1. **Clone the Repository**:

    ```sh
    git clone https://github.com/tyvsmith/android-studio-webtop.git
    cd android-studio-webtop
    ```

2. **Build the Docker Image**:

    ```sh
    docker build -t android-studio-webtop .
    ```

3. **Run the Docker Container**:

    ```sh
    docker run --rm -it -p 3000:3000 android-studio-webtop bash
    ```


## Accessing Android Studio

1. Open your web browser.
2. Navigate to `http://localhost:3000`.
3. You should see the Android Studio interface running within the browser.

## License

This project is licensed under the GPL v3 License. See the LICENSE file for details.

## Acknowledgements

- [LinuxServer.io Webtop](https://docs.linuxserver.io/images/docker-webtop) for the base image and inspiration.
- Google and Jetbrains for Android Studio.
