# Android Development Best Practices

## Table of Contents
1. [Project Structure](#project-structure)
2. [Code Style](#code-style)
3. [Build Configuration](#build-configuration)
4. [Performance Optimization](#performance-optimization)
5. [Testing](#testing)
6. [Security](#security)
7. [CI/CD](#cicd)
8. [Team Collaboration](#team-collaboration)

## Project Structure

### Recommended Module Structure
```
app/
├── src/
│   ├── main/
│   │   ├── java/com/example/app/
│   │   │   ├── data/
│   │   │   │   ├── local/
│   │   │   │   ├── remote/
│   │   │   │   └── repository/
│   │   │   ├── di/
│   │   │   ├── domain/
│   │   │   │   ├── model/
│   │   │   │   └── usecase/
│   │   │   ├── presentation/
│   │   │   │   ├── ui/
│   │   │   │   └── viewmodel/
│   │   │   └── util/
│   │   ├── res/
│   │   └── AndroidManifest.xml
│   ├── test/
│   └── androidTest/
├── build.gradle.kts
└── proguard-rules.pro
```

### Multi-Module Architecture
```
project/
├── app/                    # Application module
├── core/                   # Core utilities
├── data/                   # Data layer
├── domain/                 # Business logic
├── presentation/           # UI layer
├── features/              # Feature modules
│   ├── feature-auth/
│   ├── feature-profile/
│   └── feature-settings/
└── buildSrc/              # Build configuration
```

## Code Style

### Kotlin Best Practices

1. **Use Kotlin idioms**
```kotlin
// Good
val users = listOf("Alice", "Bob").filter { it.length > 3 }

// Avoid
val users = ArrayList<String>()
for (user in listOf("Alice", "Bob")) {
    if (user.length > 3) {
        users.add(user)
    }
}
```

2. **Null safety**
```kotlin
// Good
fun processUser(user: User?) {
    user?.let {
        // Process non-null user
    } ?: run {
        // Handle null case
    }
}

// Better with sealed classes
sealed class UserState {
    data class Success(val user: User) : UserState()
    object Loading : UserState()
    data class Error(val message: String) : UserState()
}
```

3. **Extension functions**
```kotlin
// Define useful extensions
fun View.show() {
    visibility = View.VISIBLE
}

fun View.hide() {
    visibility = View.GONE
}

fun Context.showToast(message: String, duration: Int = Toast.LENGTH_SHORT) {
    Toast.makeText(this, message, duration).show()
}
```

### Java Best Practices

1. **Use modern Java features**
```java
// Use try-with-resources
try (FileInputStream fis = new FileInputStream("file.txt")) {
    // Process file
} catch (IOException e) {
    // Handle exception
}

// Use Optional
Optional<User> user = userRepository.findById(id);
user.ifPresent(u -> updateUI(u));
```

2. **Immutability**
```java
// Use final for immutability
public final class User {
    private final String name;
    private final int age;
    
    public User(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    // Only getters, no setters
}
```

## Build Configuration

### Gradle Optimization

1. **Build variants**
```kotlin
// app/build.gradle.kts
android {
    buildTypes {
        getByName("debug") {
            isMinifyEnabled = false
            applicationIdSuffix = ".debug"
            versionNameSuffix = "-DEBUG"
        }
        getByName("release") {
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        create("staging") {
            initWith(getByName("release"))
            applicationIdSuffix = ".staging"
            versionNameSuffix = "-STAGING"
        }
    }
    
    productFlavors {
        create("free") {
            dimension = "version"
            applicationIdSuffix = ".free"
        }
        create("paid") {
            dimension = "version"
        }
    }
}
```

2. **Dependency management**
```kotlin
// buildSrc/src/main/kotlin/Dependencies.kt
object Versions {
    const val kotlin = "1.9.20"
    const val compose = "1.5.4"
    const val hilt = "2.48"
}

object Deps {
    const val kotlinStdlib = "org.jetbrains.kotlin:kotlin-stdlib:${Versions.kotlin}"
    
    object Compose {
        const val ui = "androidx.compose.ui:ui:${Versions.compose}"
        const val material3 = "androidx.compose.material3:material3:1.1.2"
    }
    
    object Hilt {
        const val android = "com.google.dagger:hilt-android:${Versions.hilt}"
        const val compiler = "com.google.dagger:hilt-compiler:${Versions.hilt}"
    }
}
```

### Build Performance

1. **Enable build cache**
```properties
# gradle.properties
org.gradle.caching=true
org.gradle.parallel=true
org.gradle.configureondemand=true
android.enableBuildCache=true
```

2. **Optimize dependencies**
```kotlin
dependencies {
    // Use implementation instead of api
    implementation(Deps.kotlinStdlib)
    
    // Use specific modules
    implementation("com.google.firebase:firebase-auth")
    // Not: implementation("com.google.firebase:firebase-bom")
}
```

## Performance Optimization

### Memory Management

1. **Avoid memory leaks**
```kotlin
class MyActivity : AppCompatActivity() {
    // Use weak references for callbacks
    private val callback = WeakReference<Callback>(this)
    
    // Clear references in onDestroy
    override fun onDestroy() {
        super.onDestroy()
        callback.clear()
    }
}
```

2. **Use efficient data structures**
```kotlin
// Use SparseArray for integer keys
val sparseArray = SparseArray<String>()

// Use ArrayMap for small collections
val arrayMap = ArrayMap<String, Any>()
```

### UI Performance

1. **Optimize layouts**
```xml
<!-- Use ConstraintLayout for complex layouts -->
<androidx.constraintlayout.widget.ConstraintLayout>
    <!-- Avoid nested LinearLayouts -->
</androidx.constraintlayout.widget.ConstraintLayout>

<!-- Use ViewStub for rarely used views -->
<ViewStub
    android:id="@+id/stub"
    android:layout="@layout/rarely_used"
    android:layout_width="match_parent"
    android:layout_height="wrap_content" />
```

2. **Image optimization**
```kotlin
// Use Glide or Coil for image loading
Glide.with(context)
    .load(imageUrl)
    .placeholder(R.drawable.placeholder)
    .error(R.drawable.error)
    .diskCacheStrategy(DiskCacheStrategy.ALL)
    .into(imageView)
```

## Testing

### Unit Testing

```kotlin
// Use JUnit5 and MockK
class UserRepositoryTest {
    @MockK
    private lateinit var api: UserApi
    
    @MockK
    private lateinit var dao: UserDao
    
    private lateinit var repository: UserRepository
    
    @BeforeEach
    fun setup() {
        MockKAnnotations.init(this)
        repository = UserRepository(api, dao)
    }
    
    @Test
    fun `test get user success`() = runTest {
        // Given
        val user = User(id = 1, name = "Test")
        coEvery { api.getUser(1) } returns user
        
        // When
        val result = repository.getUser(1)
        
        // Then
        assertEquals(user, result)
        coVerify { dao.insertUser(user) }
    }
}
```

### UI Testing

```kotlin
// Use Espresso and Compose Testing
class MainActivityTest {
    @get:Rule
    val activityRule = ActivityScenarioRule(MainActivity::class.java)
    
    @Test
    fun testButtonClick() {
        onView(withId(R.id.button))
            .perform(click())
        
        onView(withText("Success"))
            .check(matches(isDisplayed()))
    }
}

// Compose UI Testing
class ComposeTest {
    @get:Rule
    val composeTestRule = createComposeRule()
    
    @Test
    fun testCompose() {
        composeTestRule.setContent {
            MyComposable()
        }
        
        composeTestRule
            .onNodeWithText("Click me")
            .performClick()
    }
}
```

## Security

### Data Protection

1. **Encrypt sensitive data**
```kotlin
// Use Android Keystore
class SecureStorage(context: Context) {
    private val masterKey = MasterKey.Builder(context)
        .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
        .build()
    
    private val sharedPreferences = EncryptedSharedPreferences.create(
        context,
        "secure_prefs",
        masterKey,
        EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
        EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
    )
    
    fun saveToken(token: String) {
        sharedPreferences.edit().putString("token", token).apply()
    }
}
```

2. **Network security**
```xml
<!-- network_security_config.xml -->
<network-security-config>
    <domain-config cleartextTrafficPermitted="false">
        <domain includeSubdomains="true">api.example.com</domain>
        <pin-set expiration="2025-01-01">
            <pin digest="SHA-256">base64==</pin>
        </pin-set>
    </domain-config>
</network-security-config>
```

### ProGuard/R8 Rules

```pro
# Keep data classes
-keep class com.example.app.data.model.** { *; }

# Keep Retrofit interfaces
-keep interface com.example.app.data.api.** { *; }

# Remove logging in release
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
}
```

## CI/CD

### GitHub Actions

```yaml
name: Android CI/CD

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/yourusername/android-dev:latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Run tests
      run: ./gradlew test
    
    - name: Run lint
      run: ./gradlew lint
    
    - name: Upload test results
      uses: actions/upload-artifact@v3
      with:
        name: test-results
        path: app/build/reports/tests
  
  build:
    needs: test
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Build APK
      run: ./gradlew assembleRelease
    
    - name: Sign APK
      uses: r0adkll/sign-android-release@v1
      with:
        releaseDirectory: app/build/outputs/apk/release
        signingKeyBase64: ${{ secrets.SIGNING_KEY }}
        alias: ${{ secrets.ALIAS }}
        keyStorePassword: ${{ secrets.KEY_STORE_PASSWORD }}
        keyPassword: ${{ secrets.KEY_PASSWORD }}
```

### Fastlane Integration

```ruby
# fastlane/Fastfile
platform :android do
  desc "Run tests"
  lane :test do
    gradle(task: "test")
  end
  
  desc "Deploy to Play Store"
  lane :deploy do
    gradle(task: "bundle", build_type: "Release")
    upload_to_play_store(
      track: "beta",
      release_status: "draft"
    )
  end
end
```

## Team Collaboration

### Code Review Checklist

- [ ] Code follows project style guidelines
- [ ] All tests pass
- [ ] No hardcoded strings (use resources)
- [ ] Proper error handling
- [ ] No memory leaks
- [ ] Documentation updated
- [ ] Performance impact considered
- [ ] Security implications reviewed

### Git Workflow

```bash
# Feature branch workflow
git checkout -b feature/new-feature
git add .
git commit -m "feat: add new feature"
git push origin feature/new-feature

# Commit message format
# type(scope): subject
# 
# Types: feat, fix, docs, style, refactor, test, chore
```

### Documentation

1. **Code documentation**
```kotlin
/**
 * Repository for managing user data.
 * 
 * This class coordinates between the remote API and local database
 * to provide a single source of truth for user information.
 *
 * @property api Remote API service
 * @property dao Local database access object
 */
class UserRepository(
    private val api: UserApi,
    private val dao: UserDao
) {
    /**
     * Fetches user data from the API and caches it locally.
     * 
     * @param userId The ID of the user to fetch
     * @return User object or null if not found
     * @throws NetworkException if the API call fails
     */
    suspend fun getUser(userId: Int): User? {
        // Implementation
    }
}
```

2. **README template**
```markdown
# Project Name

## Overview
Brief description of the project

## Setup
1. Clone the repository
2. Open in Android Studio
3. Sync project with Gradle files
4. Run the app

## Architecture
- MVVM with Clean Architecture
- Kotlin Coroutines for async operations
- Hilt for dependency injection

## Testing
Run tests: `./gradlew test`
Run instrumented tests: `./gradlew connectedAndroidTest`

## Contributing
See CONTRIBUTING.md for guidelines
```