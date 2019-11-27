public interface IABConfiguration {
	void LoadPluginConfigurations();
	void TogglePluginConfigurations(Boolean state);
	String GetTranslatedKey(String key);
	Map<String,String> GetAllProperties(Boolean translateKey);
	String GetPropertyByKey(String key);
}