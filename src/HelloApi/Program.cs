var builder = WebApplication.CreateBuilder(args);

var allowedOrigins = Environment.GetEnvironmentVariable("CORS_ALLOWED_ORIGINS")?
    .Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries)
    ?? ["http://localhost:8000", "http://127.0.0.1:8000"];

builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy => policy
        .WithOrigins(allowedOrigins)
        .AllowAnyHeader()
        .AllowAnyMethod());
});

var app = builder.Build();

app.UseCors();
app.MapGet("/hello", () => Results.Ok(new { response = "Hello, World!" }));

app.Run();
