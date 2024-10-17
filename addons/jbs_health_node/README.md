# <img src="https://raw.githubusercontent.com/JBSnippets/godot4-health/main/jbs_health_node_128.png" width="32" height="32" /> Health node ~ Godot 4+
A custom Godot 4+ node designed to store and update the health amount of a node, emitting signals based on health amount changes and set properties.

The node enables the addition of health capabilities, which can be adjusted by invoking the `update_amount` function. It can automatically send signals based on changes in the health amount and set properties.

## 🧬 Features
- Customizable health and maximum health values.
- Simplified connection to a `TextureProgressBar` and `ProgressBar` node as a health bar.
- Configurable auto-hide feature for the health bar.
- Option to switch from manual to automatic health update behavior.
- Ability to pause the automatic health update for a specified number of seconds.
- Ability to enable or disable damageable, healable, and revivable behaviors.
- Signals are emitted based on behavior, set properties, and updates to health amounts.

## 💽 Supported Versions
<img src="https://img.shields.io/badge/Godot-v4.1.1-%23478cbf?logo=godot-engine&logoColor=cyian&color=blue"> <img src="https://img.shields.io/badge/Godot-v4.1.2-%23478cbf?logo=godot-engine&logoColor=cyian&color=blue"> <img src="https://img.shields.io/badge/Godot-v4.1.3-%23478cbf?logo=godot-engine&logoColor=cyian&color=blue"> <img src="https://img.shields.io/badge/Godot-v4.1.4-%23478cbf?logo=godot-engine&logoColor=cyian&color=blue"> <img src="https://img.shields.io/badge/Godot-v4.2.0-%23478cbf?logo=godot-engine&logoColor=cyian&color=blue"> <img src="https://img.shields.io/badge/Godot-v4.2.1-%23478cbf?logo=godot-engine&logoColor=cyian&color=blue"> <img src="https://img.shields.io/badge/Godot-v4.2.2-%23478cbf?logo=godot-engine&logoColor=cyian&color=blue"> <img src="https://img.shields.io/badge/Godot-v4.3-%23478cbf?logo=godot-engine&logoColor=cyian&color=blue">

## 📥 Installing the Plugin
### Install using Godot's AssetLib

1. Go to the `AssetLib` in the Godot Editor.
1. Type "health" to search for the `Health` node.
1. Select the asset (by JBSnippets 😊) and click Download.

### Install with examples

- Download as a ZIP file from this repository or
- Clone this repository

## 🚀 How to add the node
After enabling this plugin, you can add the `Health` node as a child of another node, usually a CharacterBody or StaticBody, to use its capabilities.

1. Right-click on a node or press Ctrl+A.

![Add Node](https://github.com/JBSnippets/godot4-health/blob/main/assets/add_node0.png)

2. Type "health" on the Search textbox of the Create New Node form to filter the node list and easily find the `Health` node.

![Add Node](https://github.com/JBSnippets/godot4-health/blob/main/assets/add_node1.png)

3. Double-click the `Health` node to add as a child of the node.

![Add Node](https://github.com/JBSnippets/godot4-health/blob/main/assets/add_node2.png)

## 📺 Video on How to use the plugin.
[![Watch the video](https://github.com/JBSnippets/godot4-health/blob/main/assets/JBSnippets%20YT%20Thumbnail%203.png)](https://www.youtube.com/watch?v=CS524A5O90s)

## 📡 More Plugins!
Head on over to my website at [https://plugins.jbsnippets.com](https://plugins.jbsnippets.com) to read more about this plugin and other plugins that I've been creating during my game development journey Godot.
