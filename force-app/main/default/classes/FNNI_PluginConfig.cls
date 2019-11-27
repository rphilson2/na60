public class FNNI_PluginConfig {
    public Map<String, String> pluginConfigMap {get; set;}
    
    public FNNI_PluginConfig(String pluginName, String pluginVersion){
        pluginConfigMap = new Map<String, String>();
        List<nFUSE.PluginConfigurationManager.PluginConfiguration> configs = new nFUSE.PluginConfigurationManager(pluginName, pluginVersion).getConfigurations();
        for(nFUSE.PluginConfigurationManager.PluginConfiguration config : configs){
            pluginConfigMap.put(config.key, config.value);
        }
    }
    
    public String getPluginConfig(String key){
        if(pluginConfigMap.containsKey(key))
            return pluginConfigMap.get(key);
        else
            return null;
    }
}