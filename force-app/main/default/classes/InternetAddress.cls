/**
* This class is used for processing user e-mail addresses.
*/
public class InternetAddress{
	
    protected string m_address;
    protected string m_encodedPersonal;
    protected string m_personal;
    protected string m_charset;
    protected Id m_userid;
    
    /**
    * Constructor
    */ 
    private InternetAddress(){  
    	 
    }
    
    /**
    * Construtor with settings
    * @param address
    * @param userId
    */
    public InternetAddress( string address,Id userId ){
        this.m_address 	= address;
        this.m_userId 	= userId;
    }
	
	/**
    * Construtor with more settings
    * @param address
    * @param personal
    * @param userId
    */
    public InternetAddress( string address, string personal, Id userId ){
    	
        this.m_address 	= address;
        this.m_personal = personal;
        this.m_userId 	= userId;
    }
    
    /**
    * constructor with more settings
    * @param address
    * @param personal
    * @param charset
    * @param userId
    */
    public InternetAddress( string address, string personal, string charset, Id userId ){
    	
        this.m_address 	= address;
        this.m_personal = personal;
        this.m_charset 	= charset;
        this.m_userId 	= userId;
    }
    
    /**
    * Getter Setter method for address
    * @return String
    */  
    public string Address{
        get { return this.m_address; }
        set { this.m_address = value; }
    }
	
	/**
    * Getter Setter method for EncodedPersonal
    * @return String
    */
    public string EncodedPersonal{
        get { return this.m_encodedPersonal; }
        set { this.m_encodedPersonal = value; }
    }   
    
    /**
    * Getter Setter method for Personal
    * @return String 
    */
    public string Personal{
        get { return this.m_personal; }
        set { this.m_personal = value; }
    }
    
    /**
    * Getter Setter Method for UserId
    * @return Id
    */
    public Id UserId{
        get { return this.m_userId; }
        set { this.m_userid = value; }
    }
    
    /**
    * Getter Setter method for charset
    * @return String
    */
    public string CharSet{
        get { return this.m_charset; }
        set { this.m_charset = value; }
    }
}