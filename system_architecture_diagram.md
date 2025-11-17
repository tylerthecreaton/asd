# System Architecture Diagram

## High-Level System Architecture

```mermaid
graph TB
    subgraph "Flutter App"
        A[Presentation Layer] --> B[Domain Layer]
        B --> C[Data Layer]
        
        subgraph "Presentation Layer"
            A1[UI Components]
            A2[Riverpod Providers]
            A3[Navigation Router]
        end
        
        subgraph "Domain Layer"
            B1[Entities]
            B2[Use Cases]
            B3[Repository Interfaces]
        end
        
        subgraph "Data Layer"
            C1[Repository Implementations]
            C2[Data Sources]
            C3[Models]
        end
    end
    
    subgraph "External Services"
        D[Supabase Auth]
        E[Supabase Database]
        F[Supabase Storage]
        G[Video Analysis API]
    end
    
    C2 --> D
    C2 --> E
    C2 --> F
    C2 --> G
```

## Application Flow Architecture

```mermaid
graph LR
    A[User Launches App] --> B{Is Authenticated?}
    B -->|No| C[Login/Register Screen]
    B -->|Yes| D[Home Screen]
    C --> E[Authentication Process]
    E --> D
    D --> F[Select Assessment Type]
    F --> G[Questionnaire Module]
    F --> H[Video Analysis Module]
    G --> I[Questionnaire Flow]
    I --> J[Results Screen]
    H --> K[Video Recording Flow]
    K --> L[Video Analysis Results]
    J --> M[Generate PDF Report]
    L --> M
```

## Data Flow Architecture

```mermaid
sequenceDiagram
    participant U as User
    participant UI as UI Layer
    participant P as Riverpod Provider
    participant UC as Use Case
    participant R as Repository
    participant API as External API
    
    U->>UI: Initiates Action
    UI->>P: Calls Provider Method
    P->>UC: Executes Use Case
    UC->>R: Calls Repository Method
    R->>API: Makes API Request
    API-->>R: Returns Response
    R-->>UC: Returns Data
    UC-->>P: Processes Result
    P-->>UI: Updates State
    UI-->>U: Displays Updated UI
```

## Module Architecture

```mermaid
graph TB
    subgraph "Authentication Module"
        A1[Login Screen]
        A2[Registration Screen]
        A3[Password Reset]
        A4[Auth Provider]
        A5[Auth Repository]
    end
    
    subgraph "Questionnaire Module"
        Q1[Introduction Screen]
        Q2[Questionnaire Screen]
        Q3[Progress Indicator]
        Q4[Results Screen]
        Q5[Questionnaire Provider]
        Q6[Questionnaire Repository]
    end
    
    subgraph "Video Analysis Module"
        V1[Introduction Screen]
        V2[Video Recording Screen]
        V3[Video Preview Screen]
        V4[Analysis Results Screen]
        V5[Video Provider]
        V6[Video Repository]
    end
    
    subgraph "Common Components"
        C1[Custom Widgets]
        C2[Utilities]
        C3[Services]
        C4[Constants]
    end
```

## Database Schema (Supabase)

```mermaid
erDiagram
    users {
        uuid id PK
        string email
        string name
        timestamp created_at
        timestamp updated_at
    }
    
    questionnaires {
        uuid id PK
        uuid user_id FK
        jsonb responses
        string risk_level
        timestamp created_at
        timestamp updated_at
    }
    
    videos {
        uuid id PK
        uuid user_id FK
        string file_path
        string stimulus_type
        timestamp created_at
        timestamp updated_at
    }
    
    analysis_results {
        uuid id PK
        uuid video_id FK
        jsonb analysis_data
        string risk_assessment
        timestamp created_at
        timestamp updated_at
    }
    
    users ||--o{ questionnaires : has
    users ||--o{ videos : uploads
    videos ||--o{ analysis_results : has
```

## Technology Integration Architecture

```mermaid
graph TB
    subgraph "Flutter Frontend"
        subgraph "State Management"
            SM1[Riverpod]
            SM2[StateNotifier]
            SM3[FutureProvider]
        end
        
        subgraph "Navigation"
            N1[Go Router]
            N2[Route Guards]
            N3[Deep Links]
        end
        
        subgraph "UI Components"
            UI1[Material 3]
            UI2[Custom Widgets]
            UI3[Lottie Animations]
        end
    end
    
    subgraph "Backend Services"
        subgraph "Supabase"
            S1[Authentication]
            S2[PostgreSQL DB]
            S3[File Storage]
        end
        
        subgraph "Custom API"
            API1[Node.js/Express]
            API2[Video Analysis]
            API3[PDF Generation]
        end
    end
    
    SM1 --> S1
    SM1 --> S2
    SM1 --> S3
    SM1 --> API1
```

## Security Architecture

```mermaid
graph TB
    subgraph "Client Side"
        C1[Flutter Secure Storage]
        C2[JWT Token Management]
        C3[Data Encryption]
    end
    
    subgraph "Network Layer"
        N1[HTTPS/TLS]
        N2[API Key Authentication]
        N3[Request Validation]
    end
    
    subgraph "Server Side"
        S1[Supabase Auth]
        S2[Row Level Security]
        S3[Data Encryption at Rest]
    end
    
    C1 --> N1
    C2 --> N2
    C3 --> N3
    N1 --> S1
    N2 --> S2
    N3 --> S3