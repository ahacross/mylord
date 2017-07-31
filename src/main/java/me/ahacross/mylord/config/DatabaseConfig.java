package me.ahacross.mylord.config;

import java.io.IOException;

import javax.sql.DataSource;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.session.SqlSessionFactory;
import org.jasypt.encryption.pbe.StandardPBEStringEncryptor;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@Configuration
@EnableTransactionManagement
@MapperScan(
        annotationClass=Mapper.class,
        basePackages="me.ahacross.mylord",
        sqlSessionFactoryRef="sqlSessionFactoryBean")
public class DatabaseConfig {
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
	 public SqlSessionFactoryBean sqlSessionFactoryBean(DataSource dataSource, ApplicationContext applicationContext) throws IOException {
		 SqlSessionFactoryBean factoryBean = new SqlSessionFactoryBean();
		 factoryBean.setDataSource(dataSource);
		 
		 factoryBean.setConfigLocation(applicationContext.getResource("classpath:mybatis/configuration.xml"));
		 factoryBean.setMapperLocations(applicationContext.getResources("classpath:mapper/**/*.xml"));

		 return factoryBean;
	 }
	 
	 @Bean
	 public SqlSessionTemplate sqlSessionTemplate(SqlSessionFactory sqlSessionFactory) {
		 return new SqlSessionTemplate(sqlSessionFactory);
	 }
}
