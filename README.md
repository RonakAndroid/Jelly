
# Jelly
Created using custom painter.  
![N|Solid](demo.gif)

### Description
With help of Bezier curve, created shape from path like Jelly and with animation, made effect like animation. Parameters used in custom painter are configurable.

* We can define configuration as per below for each Jelly.
    ```
    JellyConfiguration(size);
    ```

* If we want to create multiple Jellies on each other:
    ```
    List<JellyConfiguration> jellyConfigurations = List();
      for (int i = 0; i < jellyCount; i++) {
        jellyConfigurations.add(JellyConfiguration(size,
            position: i, reductionRadiusFactor: 1.5 - ((i + 1) / jellyCount)));
      }
    ```


# LICENSE!
Jelly is [MIT-licensed](/LICENSE).

# Let us know!
We’d be really happy if you send us links to your projects where you use our component. Just send an email to sales@mindinventory.com And do let us know if you have any questions or suggestion regarding our work.        
