# ER Diagrams for Microservices

## appointment-service
```mermaid
erDiagram
    AvailabilityEntity {
        UUID id
        UUID tenantId
        UUID employeeId
        Integer dayOfWeek
        LocalTime startTime
        LocalTime endTime
        boolean active
        UUID branchId
    }
    AppointmentAttendeeEntity {
        UUID id
        AppointmentEntity appointment FK
        UUID userId
        String status
        LocalDateTime createdAt
        LocalDateTime updatedAt
    }
    AppointmentAttendeeEntity }o--|| AppointmentEntity : "references"
    AppointmentAuditEntity {
        UUID id
        UUID tenantId
        UUID appointmentId
        String action
        String oldStatus
        String newStatus
        LocalDateTime changedAt
        String changedBy
    }
    AppointmentEntity {
        UUID id
        UUID tenantId
        String title
        String customerId
        UUID employeeId
        UUID branchId
        LocalDateTime startTime
        LocalDateTime endTime
        String status
        String type
        String notes
        LocalDateTime createdAt
        LocalDateTime updatedAt
        String createdBy
        boolean isDeleted
        String timezone
        Integer duration
        List~AppointmentAttendeeEntity~ attendees
    }
    AppointmentEntity ||--o{ AppointmentAttendeeEntity : "contains"
```
## client-auth-service
```mermaid
erDiagram
    CustomerContactEntity {
        Long id
        CustomerAuthEntity customer FK
        String name
        String position
        String email
        String phone
        String companyName
        String workPhone
        String documentNumber
        LocalDate birthDate
        Boolean isLegalRepresentative
    }
    CustomerContactEntity }o--|| CustomerAuthEntity : "references"
    ClientRefreshToken {
        Long id
        Long customerId
        String token
        String deviceInfo
        LocalDateTime expiresAt
        LocalDateTime createdAt
        Boolean revoked
    }
    ConfigCreditosEntity {
        Long id
        String configKey
        String configValue
        ConfigType configType
        String description
        Long organizacionId
        LocalDateTime createdAt
        LocalDateTime updatedAt
    }
    CustomerAddressEntity {
        Long id
        CustomerAuthEntity customer FK
        String street
        String city
        String state
        String country
        String postalCode
        String type
    }
    CustomerAddressEntity }o--|| CustomerAuthEntity : "references"
    CustomerAuthEntity {
        Long id
        String name
        String documentNumber
        String email
        String phone
        String type
        LocalDate birthDate
        String companyName
        String position
        String workPhone
        String corporateEmail
        BigDecimal salary
        String status
        String passwordHash
        LocalDateTime lastLogin
        Integer loginAttempts
        Boolean accountLocked
        LocalDateTime lockExpiresAt
        LocalDateTime createdAt
        LocalDateTime updatedAt
        Set~CustomerAddressEntity~ addresses
        Set~CustomerContactEntity~ contacts
    }
    CustomerAuthEntity ||--o{ CustomerAddressEntity : "contains"
    CustomerAuthEntity ||--o{ CustomerContactEntity : "contains"
```
## conversational-hub
```mermaid
erDiagram
    ChannelEntity {
        String id
        String tenantId
        String name
        String description
        String erpEntityId
        String erpEntityType
        LocalDateTime createdAt
        LocalDateTime deletedAt
        boolean isAutomatic
    }
    UserPreferencesEntity {
        String userId
        String chatColor
        boolean isFloatingBubble
        String themeMode
    }
    UserChannelPreferenceEntity {
        String userId
        String channelId
        boolean isPinned
        boolean isArchived
        String userId
        String channelId
    }
    MessageEntity {
        String id
        String channelId
        String senderId
        String recipientId
        String content
        String type
        String metadata
        LocalDateTime timestamp
        LocalDateTime deletedAt
    }
```
## customer-service
```mermaid
erDiagram
    CustomerContactEntity {
        Long id
        CustomerEntity customer FK
        String name
        String position
        String email
        String phone
        String companyName
        String workPhone
        String documentNumber
        LocalDate birthDate
        Boolean isLegalRepresentative
        LocalDateTime createdAt
    }
    CustomerContactEntity }o--|| CustomerEntity : "references"
    CustomerNoteEntity {
        Long id
        CustomerEntity customer FK
        String note
        String createdBy
        LocalDateTime createdAt
    }
    CustomerNoteEntity }o--|| CustomerEntity : "references"
    CustomerHistoryEntity {
        Long id
        CustomerEntity customer FK
        String eventType
        String description
        String createdBy
        LocalDateTime createdAt
    }
    CustomerHistoryEntity }o--|| CustomerEntity : "references"
    CustomerAddressEntity {
        Long id
        CustomerEntity customer FK
        String street
        String city
        String state
        String country
        String postalCode
        AddressType addressType
        LocalDateTime createdAt
    }
    CustomerAddressEntity }o--|| CustomerEntity : "references"
    CustomerEntity {
        Long id
        CustomerType type
        String name
        String documentNumber
        String email
        String phone
        LocalDate birthDate
        String companyName
        String position
        String workPhone
        String corporateEmail
        BigDecimal salary
        CustomerStatus status
        LocalDateTime createdAt
        LocalDateTime updatedAt
        String createdBy
        String updatedBy
        LocalDateTime deletedAt
        List~CustomerAddressEntity~ addresses
        List~CustomerContactEntity~ contacts
        List~CustomerNoteEntity~ notes
        List~CustomerHistoryEntity~ history
    }
    CustomerEntity ||--o{ CustomerAddressEntity : "contains"
    CustomerEntity ||--o{ CustomerContactEntity : "contains"
    CustomerEntity ||--o{ CustomerNoteEntity : "contains"
    CustomerEntity ||--o{ CustomerHistoryEntity : "contains"
```
## erp-portfolio-service
```mermaid
erDiagram
    SystemSettingEntity {
        UUID id
        String key
        String value
        String description
        LocalDateTime createdAt
        LocalDateTime updatedAt
    }
    FolderJpaEntity {
        byte[] id
        String name
        byte[] parentId
        String ownerId
        String path
        boolean deleted
        LocalDateTime createdAt
        LocalDateTime updatedAt
    }
    FileVersionJpaEntity {
        byte[] id
        byte[] fileId
        int versionNumber
        String storagePath
        long sizeBytes
        String checksum
        String createdBy
        LocalDateTime createdAt
    }
    FileJpaEntity {
        byte[] id
        String name
        String originalName
        byte[] folderId
        String ownerId
        String storagePath
        String mimeType
        String extension
        long sizeBytes
        String checksum
        String tags
        String fileType
        boolean deleted
        LocalDateTime createdAt
        LocalDateTime updatedAt
    }
    PortfolioSettingsJpaEntity {
        byte[] id
        String settingKey
        String settingValue
        String description
        LocalDateTime createdAt
        LocalDateTime updatedAt
    }
```
## iam-core
```mermaid
erDiagram
    MenuPermisoEntity {
        Integer id
        MenuEntity menu FK
        PermisoEntity permiso FK
    }
    MenuPermisoEntity }o--|| MenuEntity : "references"
    MenuPermisoEntity }o--|| PermisoEntity : "references"
    MenuEntity {
        Integer id
        String nombre
        String ruta
        String icono
        MenuEntity parent FK
        Integer orden
        EstadoMenuEntity estado
        Set~MenuPermisoEntity~ permisos
        Set~MenuEntity~ subMenus
    }
    MenuEntity }o--|| MenuEntity : "references"
    MenuEntity ||--o{ MenuPermisoEntity : "contains"
    MenuEntity ||--o{ MenuEntity : "contains"
    PermisoEntity {
        Integer id
        String accion
        String recurso
        String descripcion
        Set~RolEntity~ roles
        Set~MenuPermisoEntity~ menus
    }
    PermisoEntity ||--o{ RolEntity : "contains"
    PermisoEntity ||--o{ MenuPermisoEntity : "contains"
    UsuarioEntity {
        Long id
        String username
        String email
        String passwordHash
        Boolean estado
        LocalDateTime fechaCreacion
        OrganizacionEntity organizacion FK
        Set~RolEntity~ roles
    }
    UsuarioEntity }o--|| OrganizacionEntity : "references"
    UsuarioEntity ||--o{ RolEntity : "contains"
    OrganizacionEntity {
        Integer id
        String nombre
        String codigo
        String estado
        LocalDateTime fechaCreacion
        List~UsuarioEntity~ usuarios
    }
    OrganizacionEntity ||--o{ UsuarioEntity : "contains"
    RolEntity {
        Integer id
        String nombre
        String descripcion
        String estado
    }
```
## iam-core-p/iam-core
```mermaid
erDiagram
    Menu {
        Long id
        String nombre
        String ruta
        String icono
        String codigo
        Menu parent FK
        Set~Menu~ children
        Integer orden
        Boolean estado
        Set~RoleMenuPermission~ menuPermissions
    }
    Menu }o--|| Menu : "references"
    Menu ||--o{ Menu : "contains"
    Menu ||--o{ RoleMenuPermission : "contains"
    RoleMenuPermission {
        Long id
        Role role FK
        Menu menu FK
        Boolean canRead
        Boolean canCreate
        Boolean canUpdate
        Boolean canDelete
    }
    RoleMenuPermission }o--|| Role : "references"
    RoleMenuPermission }o--|| Menu : "references"
    Role {
        Integer roleId
        String authority
        Set~RoleMenuPermission~ menuPermissions
    }
    Role ||--o{ RoleMenuPermission : "contains"
    ApplicationUser {
        Integer userId
        String username
        String password
        String email
        Boolean estado
        LocalDateTime fechaCreacion
        Long organizacionId
        String firstName
        String lastName
        String phone
        String bio
        String profilePicture
        String facebook
        String twitter
        String linkedin
        String instagram
        String country
        String city
        String postalCode
        String taxId
        Set~Role~ authorities FK
        Set~GrantedAuthority~ permissions
    }
    ApplicationUser ||--o{ Role : "contains"
    BlacklistedToken {
        Long id
        String token
    }
    UserSession {
        Long id
        Integer userId
        String username
        LocalDateTime startTime
        LocalDateTime endTime
        LocalDateTime expiresAt
        String tokenHash
        String ipAddress
        String deviceInfo
        SessionStatus status
        String closedBy
        String closedReason
        String city
        String country
        Double latitude
        Double longitude
        Boolean isVpn
        Boolean isProxy
        String isp
    }
    AppDesignSettings {
        Long id
        ApplicationUser user FK
        String appName
        String appFont
        String logoUrl
        String faviconUrl
        String primaryColor
        String secondaryColor
        String accentColor
        Boolean isDarkMode
        String sidebarColor
        String tableHeaderColor
        String headerColor
        String infoColor
        String warningColor
        String errorColor
        String successColor
        String systemColor
    }
    AppDesignSettings }o--|| ApplicationUser : "references"
    Project {
        Long projectID
        String project_Name
        String company_Name
        LocalDate start_Date
        LocalDate end_Date
        String rate
        String rate_Type
        String priority
        String total_Hours
        String status
        String created_By
        String description
        String progress
    }
    LeaderProject {
        Long leaderProjectID
        Long projectID
        Long leaderID
        String first_Name
        String last_Name
        String designation
        String imageName
    }
    Item {
        Long itemID
        String name
        String description
        double uniteCost
        Integer quantity
        double amount
        EstimatesInvoices estimateInvoices FK
    }
    Item }o--|| EstimatesInvoices : "references"
    EstimatesInvoices {
        Long id
        String type
        Client client FK
        Project project FK
        LocalDate createDate
        LocalDate estimateDate
        LocalDate expiryDate
        BigDecimal total
        String otherInfo
        String status
        Integer tax
        List~Item~ items
    }
    EstimatesInvoices }o--|| Client : "references"
    EstimatesInvoices }o--|| Project : "references"
    EstimatesInvoices ||--o{ Item : "contains"
    MessageTask {
        Long messageTaskID
        Long taskID
        Long employeeID
        String first_Name
        String last_Name
        String imageName
        String date
        String message
    }
    ImageProject {
        Long imageProjectID
        Long projectID
        String imageName
        String originalName
    }
    Employee {
        Long employeeID
        String first_Name
        String last_Name
        String userName
        String email
        String password
        LocalDate joinDate
        String phone
        Department department FK
        Designation designation FK
        String company
        Integer remainingLeaves
        String role
        Double pinCode
        String cv_Name
        Byte cv
        String cin
        String reportTo
        LocalDate birthday
        String address
        String gender
        String state
        String country
        String imageName
    }
    Employee }o--|| Department : "references"
    Employee }o--|| Designation : "references"
    Holiday {
        Long holidayId
        String holidayName
        LocalDate holidayDate
        LocalDate holidayDateEnd
    }
    Client {
        Long clientID
        String first_Name
        String last_Name
        String gender
        String designation
        String personnel_Email
        String personnel_Phone
        String imageName
        String company_Name
        LocalDate date_Creation
        String address
        String ice
        String rc
        String ville
        String capital
        String rib
        String company_Email
        String company_Phone
        String website
    }
    Leaves {
        Long leavesID
        String username
        String EmployeeName
        LeaveType leaveType FK
        Integer NumberOfDays
        LocalDate StartDate
        LocalDate EndDate
        String LeaveReason
        String ApprovedBy
        String Status
    }
    Leaves }o--|| LeaveType : "references"
    Payment {
        Long id
        EstimatesInvoices estimatesInvoices FK
        LocalDate paidDate
        BigDecimal paidAmount
    }
    Payment }o--|| EstimatesInvoices : "references"
    Expenses {
        Long Id
        String itemName
        String purchaseFrom
        LocalDate purchaseDate
        String purchasedBy
        BigDecimal Amount
        String paidBy
        String Status
        byte[] data
    }
    EmployeeProject {
        Long employeeProjectID
        Project project FK
        Employee employee FK
        String first_Name
        String last_Name
        String designation
        String imageName
    }
    EmployeeProject }o--|| Project : "references"
    EmployeeProject }o--|| Employee : "references"
    Department {
        Long departmentID
        String departmentName
    }
    FileProject {
        Long fileProjectID
        Long projectID
        String fileName
        String originalName
        String dateCreation
    }
    Designation {
        Long designationID
        String designationName
        Department department FK
    }
    Designation }o--|| Department : "references"
    EmployeeTask {
        Long employeeTaskID
        Long taskID
        Long employeeID
        String first_Name
        String last_Name
        String designation
        String imageName
    }
    LeaveType {
        Long leaveTypeId
        String username
        String leaveName
        Integer days
        String leaveStatus
    }
    Task {
        Long taskID
        Project project FK
        String task_Name
        String task_Priority
        LocalDate due_Date
        String description
        String status
    }
    Task }o--|| Project : "references"
```
## notification-service
```mermaid
erDiagram
    Notification {
        Long id
        String userId
        String message
        NotificationType type
        NotificationLevel level
        LocalDateTime timestamp
        boolean readStatus
        String extraData
        void onCreate
    }
```
## parametrizaciones
```mermaid
erDiagram
    CatalogItemJpaEntity {
        Long id
        String catalogCode
        Long parentId
        Long companyId
        String code
        String name
        String description
        Integer orderIndex
        String path
        Integer level
        String extraData
        boolean enabled
        boolean deleted
        LocalDateTime createdAt
        LocalDateTime updatedAt
        String createdBy
        String updatedBy
    }
    ParameterCategoryJpaEntity {
        Long id
        String name
        String description
        LocalDateTime createdAt
        LocalDateTime updatedAt
        String createdBy
    }
    ParameterJpaEntity {
        Long id
        ParameterCategoryJpaEntity category FK
        String serviceName
        String name
        String key
        String value
        String type
        Integer version
        boolean enabled
        LocalDateTime createdAt
        LocalDateTime updatedAt
        String createdBy
        String updatedBy
    }
    ParameterJpaEntity }o--|| ParameterCategoryJpaEntity : "references"
    CatalogJpaEntity {
        Long id
        String code
        String name
        String description
        CatalogType type
        boolean enabled
        LocalDateTime createdAt
        LocalDateTime updatedAt
        String createdBy
        String updatedBy
    }
```
## reportes-service
```mermaid
erDiagram
    ProcessedEventEntity {
        UUID id
        String eventId
        LocalDateTime processedAt
    }
    ReportRequestEntity {
        UUID id
        ReportType reportType
        String parameters
        String requestedBy
        ReportStatus status
        String fileUrl
        String errorMessage
        String lastError
        int retryCount
        Long version
        LocalDateTime createdAt
        LocalDateTime completedAt
    }
    DynamicReportHistoryEntity {
        UUID id
        UUID templateId
        String templateName
        String microserviceId
        String entityId
        String format
        String createdBy
        LocalDateTime createdAt
    }
    ReportExecutionAuditEntity {
        String id
        String userId
        String dataSourceId
        Integer recordCount
        String status
        String errorMessage
        LocalDateTime createdAt
    }
    ReportTemplateEntity {
        UUID id
        String name
        String description
        String config
        String columns
        String charts
        String createdBy
        LocalDateTime createdAt
        LocalDateTime updatedAt
    }
```
