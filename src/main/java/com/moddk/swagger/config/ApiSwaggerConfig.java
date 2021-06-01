package com.moddk.swagger.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

@Configuration
@EnableSwagger2
public class ApiSwaggerConfig {
	@Bean
	public Docket api() {
		return new Docket(DocumentationType.SWAGGER_2)
				.apiInfo(getApiInfo())
				// ApiSelectorBuilder를 생성하여 apis()와 paths()를 사용할 수 있게 한다.
				.select() 
				// api 작성되어있는 패키지를 작성한다.
				.apis(RequestHandlerSelectors.basePackage("com.moddk.swagger.controller"))
				// api 중 원하는 path를 지정하여 문서화 할 수 있다.
				.paths(PathSelectors.any())
				.build();
	}
	
    private ApiInfo getApiInfo() {
        return new ApiInfoBuilder()
                .title("TodoList & Swagger")
                .description(":: Swagger example")
                .version("1.0")
                .build();
    }
}
