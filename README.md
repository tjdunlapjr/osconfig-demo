# OSConfig Demonstration

This script and the associated .init file will allow you manage numerous remotely deployed Linux boxes leveraging Microsoft's Azure Cloud service and their open-source tool, [OSConfig](https://github.com/Azure/azure-osconfig).

Designed to manage IoT devices at-scale, I demonstrate in this [YouTube video](https://www.youtube.com/playlist?list=PLiXHQdAPCxK0_t6La80SySMlRJBeV6CaQ) how OSConfig can be applied beyond simple configuration settings for IoT devices.

## Getting Started

These instructions will help you get copy of the project up and running on your local machine for development and testing purposes.

**User beware:** It's been awhile since I used ```bash``` so there may be better ways to implement and write this script! Improvements are welcomed.

### Prerequisites

You will need to be familiar with:

* Linux
* bash
* apt commands
* Azure (or be willing to learn)

To follow along with the video demo you will need a free [Azure account](https://azure.microsoft.com/en-us/free/). You may want to explore setting up VMs on another service to represent your deployed Linux boxes, like [Digital Ocean](https://www.digitalocean.com) or similar. Another option would be to use your own VMs on your own machine to represent the deployed boxes.

### Installing

The following is a one-time environment set-up process to interact with Azure from the command line:

1. Set up your free [Azure account](https://azure.microsoft.com/en-us/free/)
2. Open your terminal and install the Azure CLI
    * For [macOS](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-macos)
    * For [Linux](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux)
3. Download or clone this repo for ```demo.sh``` and ```osConfigRemoteInstall.init```
4. Navigate to the ```demo.sh``` file
5. Make the script executable by running the following command: ```sudo chmod +x demo.sh```

### Connecting to Your Azure Account from the CLI

1. Run the following command: ```./demo.sh```
2. The LP Command & Control menu should appear. Choose option ```c```
3. This will open a browser window so you can authenticate to your Azure account

### Testing Your Azure Connection

To make sure you're connected, let's choose option ```1) Create Resource Groups``` From our menu. You can learn more about Azure Resource Groups [here.](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal)

1. Choose option ```1) Create Resource Groups```
2. At the prompt, give your Resource Group a name (ex. myTestResourceGroup)
3. To view that the Resource Group was created, log into your [Azure portal](https://portal.azure.com/#home)
4. In the search bar at the top, search for Resource Groups
5. Select the Service that appears as "Resource groups"
6. You should see the name of your newly created Resource Group

### Follow the YouTube Video Demonstration

Once you verified your connection to Azure is working from your command line, you should be able to follow along with my [YouTube demo video.](https://youtu.be/AmADAGwjgQs) Be sure you have your Linux boxes or VMs up and running whether locally or on another cloud service.

Technically, you could run this entire demo all within Azure. But I find it more compelling and meaningful if you can mirror reality by keeping the boxes you want to manage via OSConfig outside of the Azure ecosystem. But hey, do what works for you!

## Authors

* **Terry Dunlap** - *Initial work*

## License

This project is licensed under the MIT License - see the [License.md](https://github.com/tjdunlapjr/osconfig-demo/blob/main/LICENSE.md) file for details

## Acknowledgments

* Big shout-out to Matthew Reynolds from Microsoft's OSConfig team for putting up with my never-ending n00bie questions.
