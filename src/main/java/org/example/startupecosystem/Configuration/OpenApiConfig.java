package org.example.startupecosystem.Configuration;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.info.License;
import org.springdoc.core.models.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@OpenAPIDefinition(
        info = @Info(
                title = "Startup Ecosystem API",
                version = "v1",
                description = "OpenAPI/Swagger documentation for Startup Ecosystem application.",
                contact = @Contact(name = "Startup Ecosystem"),
                license = @License(name = "Apache 2.0", url = "https://www.apache.org/licenses/LICENSE-2.0")
        )
)
public class OpenApiConfig {

    // Limit scanning to controller package and give it a friendly group name
    @Bean
    public GroupedOpenApi startupEcosystemApi() {
        return GroupedOpenApi.builder()
                .group("startup-ecosystem")
                .packagesToScan("org.example.startupecosystem.controller")
                .build();
    }
}
