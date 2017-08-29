package me.ahacross.mylord.config;

import javax.sql.DataSource;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.transaction.jdbc.JdbcTransactionFactory;
import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.transaction.annotation.TransactionManagementConfigurer;

@Configuration
@Lazy
@EnableTransactionManagement
@MapperScan(
        annotationClass=Mapper.class,
        basePackages="me.ahacross.mylord",
        sqlSessionFactoryRef="sqlSessionFactoryBean")
public class DatabaseConfig implements TransactionManagementConfigurer {
	
	@Autowired
    ApplicationContext applicationContext;
	
	private String decryptor (String password){
		 StandardPBEStringEncryptor standardPBEStringEncryptor = new StandardPBEStringEncryptor();  
		 standardPBEStringEncryptor.setAlgorithm("PBEWithMD5AndDES");  
		 standardPBEStringEncryptor.setPassword("dbPass");  
		 String encodedPass = standardPBEStringEncryptor.decrypt(password);
		return encodedPass;
	}
	
	@Bean
	public DataSource dataSource() {
		 String encodedPass = decryptor("sVVblCHrM+Rgh+D6m+tw3cQj/XAbbEPJKkKJMrHmYMI=");
		 
		 DriverManagerDataSource dataSource = new DriverManagerDataSource();
		 dataSource.setDriverClassName("org.mariadb.jdbc.Driver");
		 dataSource.setUrl("jdbc:mariadb://192.168.50.50:3306/myload?autoReconnect=true&useUnicode=true&characterEncoding=utf8");
		 dataSource.setUsername("ahacross");
		 dataSource.setPassword(encodedPass);
		 
		 return dataSource;
	 }
	 
	 @Bean
	 public PlatformTransactionManager transactionManager() {
        return new DataSourceTransactionManager(dataSource());
    }
	 
	 @Bean
	 public SqlSessionFactory sqlSessionFactoryBean() throws Exception {
		 SqlSessionFactoryBean sessionFactory = new SqlSessionFactoryBean();
	     sessionFactory.setDataSource(dataSource());	     
	     sessionFactory.setTransactionFactory(new JdbcTransactionFactory());
	     sessionFactory.setConfigLocation(new ClassPathResource("mybatis/configuration.xml"));
	     sessionFactory.setMapperLocations(applicationContext.getResources("classpath:mapper/**/*.xml"));
	     return sessionFactory.getObject();
	 }
	 
	 @Bean
	 public SqlSessionTemplate sqlSessionTemplate(SqlSessionFactory sqlSessionFactory) {
		 return new SqlSessionTemplate(sqlSessionFactory);
	 }

	@Override
	public PlatformTransactionManager annotationDrivenTransactionManager() {
		return transactionManager();
	}
}
