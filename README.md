# Aws Cloud Solutions Architect - SAA-C02

Guia de estudos para a certificação.
Mín. de pontos para aprovação: 710 pts || 48 Qts de 65.
Curso feito: Udemy - Stephane Mareek

# Indice de estudos
1. [IAM & Aws CLI](#IAM)
2. [EC2](#EC2)
3. [High Availability and Scalability: ELB & ASG](#ELB+ASG)
4. [Aws Fundamentals - RDS + Aurora + ElastiCache](#RDSAuroraElasti)
5. [Route53](#Rout53)
6. [Solutions Architect Discussions](#solArch)
7. [Amazon S3](#S3)
8. [AWS SDK, IAM Roles & Policies](#SDKRolesPolicies)
9. [Advanced S3 & Athena](#AdvancedS3Ath)
10. [CloudFront & Global Accelerator](#CloudFrontGlb)
11. [Aws Storage Extras](#AdvancedStorage)
12. [Decoupling applications:  SQS, SNS, Kinesis, Active MQ](#DeclouplingApplications)
13. [Container on Aws: EC2, Fargate, ECR & EKS](#Containers)
14. [Serverless](#Serverless)
15. [Databases](#DB)
16. [Aws Monitoring & Audit: Cloudwatch, cloudTrail & Config](#MonitoringAudit)
17. [Aws Security & encryption: KMS, SSM Parameter Store, CloudHSM, Shield, WAF](#AwsSecurity)
18. [Networking - VPC](#VPC)
19. [Disaster Recovery](#DR)


## IAM & Aws CLI <a name="IAM"></a>

Identity and Access Management, is:
```
Global service
Root account is created by default
User is individual, can be grouped
Groups only contain users, not other groups
Policies = Json with permissions == Users or Groups
Least privilege principle
Inline Policie = permission direct to one user
```

IAM group:
```
is a collection of IAM users. Groups let you specify permissions for multiple users, which can make it easier to manage the permissions for those users.
The following facts apply to IAM Groups:
Groups are collections of users and have policies attached to them.
A group is not an identity and cannot be identified as a principal in an IAM policy.
Use groups to assign permissions to users.
IAM groups cannot be used to group EC2 instances.
Only users and services can assume a role to take on permissions (not groups).
```

CloudShell:
```
is the terminal in the Management Console
all the functionalities of Aws CLI
```

Roles:
```
Usuários que performam serviços precisam de permissões, a melhor prática é criar um Role.
Common roles:
	Ec2 Instances Role
	Lambda function
	Roles for CloudFormation
```

Security Tools:
```
IAM Credentials Report (account-level):
	lists all your account's users and thestatus of their credentials
	Audit permissions

IAM Access Advisor (user-level):
	Shows the service permissions granted to a user and when those services were last accessed.
	Great to revise policies.
```

Best Practices:
```
Não utilizar a root account.
Um usuario físico = um usuário aws
Strong password policy + MFA
Create Roles for giving permissions to Aws services
AccessKEys for Programmatic Access(CLI/SDK)
```

Aws STS - Security Token Service:
```
Allow to grant limited and temporary access to Aws resources
Token is valid for up to one hour (must be refreshed)
AssumeRole:
	within your own account: for enhanced security
	Cross Acc Access: assume role in target account to perform actions there

AssumeRoleWithSAML:
	return credentials for users logged with SAML

AssumeroleWithWebIdenity:
	return creds for users logged with an IdP (Google, OIDC..)
	Aws recommends against using this, and using cognito intead

GetSessionToken:
	for MFA, from a user or Aws account root user

Using STS to Assume role:
	Define IAM Role within your account or cross-account
	Define which principals can access this IAM role
	use AWS STS to retieve credentials and impersonate the IAM role you have access
	Temporary credentials can be valid between 15 minutos to 1 hour
```

Identity Federation in Aws
```
Federation lets users outside of Aws to assume remporary role for accessing Aws resources
These users assume identity provided access role
Federations can have many flavors:
	SAML 2.0: To integrate AD / ADFS with Aws
			  Provide access to Aws Console/CLI (tmp creds)
			  No need to create an IAM user for each of your employees
			  Need to setup a trust between IAM and SAML (both ways)
			  Enables web-based, cross domain SSO
			  Uses the STS API: AssumeRoleWithSAML
			  Note federation through SAML is the old way of doing things
			  Aws SSO Federation is the new managed and simpler way.

	Custom Identity Brokers: Only if identity provider is not compatible with SAML 2.0
							 The identity broker must determine the appropriate IAM policy
							 STS API: Assume Role or GetFederationToken

	Web Identity Federation:
		With web identity federation, you don’t need to create custom sign-in code or manage your own user identities. Instead, users of your app can sign in using a well-known identity provider (IdP) —such as Login with Amazon, Facebook, Google, or any other OpenID Connect (OIDC)-compatible IdP, receive an authentication token, and then exchange that token for temporary security credentials in AWS that map to an IAM role with permissions to use the resources in your AWS account.
		Using an IdP helps you keep your AWS account secure because you don’t have to embed and distribute long-term security credentials with your application.
		AssumeRolewithWebIdentity: not recommended by Aws -- use cognito intead(allows for anonymous users, data synchronization, MFA)


	Web Identity Federation with Amazon Cognito:
		Provide direct access to Aws from the Client Side (mobile,web app)
		Provide temp access to write to S3 bucket using Facebook login
		Problem: we don't want to create iam users for our app users
		How: log in to federated identity provider - or remain anonymous
			 Get temporary Aws credentials back from the Federated Identity pool
			 These cred come with a pre-defined IAM policy stating their permissions

	Single Sign On
	non-SAML with Aws Microsoft AD

Using federation, you don't need to create IAM users
SAML = Security Assertion Markup Language (SAML) é um padrão de federação aberto que permite a um provedor de identidade (IdP) autenticar usuários
```

Aws Directory Services - AD:
```
Aws Managed Microsoft AD:
	Create your own AD in Awws, manage users locally, supports MFA
	Establish trust connections with your on-premise AD

AD Connector:
	Directory Gateway (proxy) to redirect to on-premise AD
	Users are managed on the on-premise AD

Simple AD
	AD-compatible managed directory on Aws
	Cannot be joined with on-premise AD
```

Aws Organizations:
```
Global service
Allows to manage multiple Aws Accounts
the main account is the master account - you can't change it
Other accounts are member accounts
Member accounts can only be part of one organization
Consolidated Billing across all accounts - single payment method
Pricing benefits from aggregated usage (volume discount for EC2, S3...)
API is available to automate Aws account creation

Multi Account Strategies:
	Create accounts per department, per cost center, per dev/test/prod, based on regulatory restrictions (using SCP), for better resource isolation (VPC), to have separate per-account service limits, isolated account for logging.
	Multi Account vs One Account Multi VPC
	Use tagging standards for billing purposes
	Enable Cloudtrail on all accounts, send logs to central S3 account
	Send CloudWatch Logs to central logging account
	Establish Cross Acc roles for admin purposes
	automatically and repeatably create many member accounts within an AWS Organizatio == CloudFormation with scripts

OU - Organizational Units:
	Business Unit: per department
	Environment Lifecycle: Dev / QA / Prod
	Project-based

Service Control Policies (SCP):
	Whitelist or blacklist IAM actions
	Applied at the OU or Account level
	Does not apply to the Master Account
	SCP is applied to all the Users and roles of the Account, including Root
	The SCP does not affect service-linked roles
		service-linked roles enable other Aws services to integrate with Aws Org and can't be restricted by SCPs
	SCP must have an explicit Allow (does not allow anything by default)
	Use cases: restrict access to certain services (ex.: can't use EMR)
			   Enforce PCI compliance

Moving Accounts:
	To migrate accounts from one organization to anotherL
		1. Remove the member acc from the old organization
		2. Send an invite to the new org
		3. Accept the invite to the new org from the member account
	If you want the master account of the old organization to also join the new Org, do the following:
		1. Remove the member accounts from the organizations using procedure above
		2. Delete the old org
		3. Repeat process above to invite the old master acc to the new org
```

IAM Conditions
```
IAM Permission boundaries:
	Can be used in combinations of Aws organizations SCP
	Set a permissions boundary to control the maximum permissions this user can have.
	Use case: Not a common setting but can be used to delegate permission management to others.
			  Useful to restrict one specific user
			  Allow dev to self-assign policies and manage their own permissions, while making sure they can't escalte their own
```

## EC2 <a name="EC2"></a>
Is one of the most popular of Aws' offering
EC2 = Elastic Compute Cloud - Infra as a Service:
```
Virtual  machines - EC2
Storing data on virtual drives - EBS
Distributing load across machines - ELB
Scaling the services using ASG(auto-scaling group)
Instance store: TEMPORARY
	 provides temporary block-level storage for your instance.
	This storage is located on disks that are physically attached to the host computer.
    Instance store is ideal for temporary storage of information that changes frequently, such as buffers, caches, scratch data, and other temporary content, or for data that is replicated across a fleet of instances, such as a load-balanced pool of web servers.
	135,000 IOPS
	You can't detach an instance store volume from one instance and attach it to a different instance
	If you create an AMI from an instance, the data on its instance store volumes isn't preserved
	Instance store is reset when you stop or terminate an instance. Instance store data is preserved during hibernation
```

Block device mapping = EBS + Instance Store == You can use block device mapping to specify additional EBS volumes or instance store volumes to attach to an instance when it’s launched. You can also attach additional EBS volumes to a running instance.

EC2 sizing & Configuration options:
```
OS: linux, windows ow Mac OS
Compute power & cores  (CPU)
random-access memry (RAM)
Storage space:
	EBS & EFS - Network-attached
	Ec2 Instance Store - Hardware
Public Ip address
Firewal rules - Security group
Bootstrap script: User Data
Set the DeleteOnTermination attribute to False using the command line
```

EC2 User Data
```
Bootstrap our instance using an Ec2 User data script
Bootstrapping = running commands when machine starts
				executado uma vez quando a instancia inicia
				Install updates / softwares / common files from the internet
				run with root user
```

EC2 Lifecycle:
```
pending – The instance is preparing to enter the running state. An instance enters the pending state when it launches for the first time, or when it is restarted after being in the stopped state.
running – The instance is running and ready for use.
stopping – The instance is preparing to be stopped. Take note that you will not billed if it is preparing to stop however, you will still be billed if it is just preparing to hibernate.
stopped – The instance is shut down and cannot be used. The instance can be restarted at any time.
shutting-down – The instance is preparing to be terminated.
terminated – The instance has been permanently deleted and cannot be restarted. Take note that Reserved Instances that applied to terminated instances are still billed until the end of their term according to their payment option.

```

Instance Types
```
Naming convention: m5.2xlarge
				   m: instance class
				   5: generation
				   2xlarge: size within the instance class

General purpose: Balance with Compute x Memory x Networking
Compute optimized: possibilidade de alta performance de processamento como Media transcoding/high performance webservers/
				   high performance computing (HPC) / Scientific modeling & machine learning / dedicated gaming servers
				   C.
Memory Optimized
Storage Optimized: High, sequential read and write access to large data
```

Security Group:
```
Are the fundamental of network security in Aws.
Controll how traffic isallowed into or out of our EC2
only contain ALLOW RULES
can reference by IP or others SG
They Regulate:
			Access to Ports
			Authorised IP ranges -Ipv4/6
			Control of inbound network (from other to the instance) - BLOCKED BY DEFAULT
			Control of outbount network (from the instance to the world) - AUTHORISED BY DEFAULT
			Can be attached to MULTIPLE instances
			Locked down to a region /VPC combination
			Does live "outside" the EC2
			It's good to maitain one separate SG for  ssh access

Classic Ports to know:
	22 = SSH ( Secure Shell ) - log into a Linux instance
	21 = FTP (File Transfer Protocol) - upload files using SSH
	80 = HTTP - access unsecure websites
	443 = HTTPS - access secure websites
	3389 = RDP (Remote Desktop Protocol) - log into a windows instance

Default state:
	There is an outbound rule that allows all traffic to all IP addresses
	There are no inbound rules and traffic will be implicitly denied
```

SSH  Summary Table:
```
SSH is a utilitary command tools to connect into instances
Putty is availabily for Windows <10
Is one of  the most important function. It allows you to control a remote machine, all using the command line.
EC2 Instance Connect works to connect by the console
```

EC2 Instances Purchasing Options
```
On-Demand Instances: short workloads, predictable pricing
					 Pay for what you use:
						Linux - billing per second, after the first minute
						all other - billing per hour
					 Has the highest cost but no upfront payment
					 No long-term commitment
					 Recommended for short-term and un-interrupted workloads


Reserved: Min 1 YEAR
		Reserved Instances: long workloads, like DB
							Up to 75% discount compared to On-demand
							Reservation period: 1 year = +discount || 3 years = +++ discount
							Specific instance type
							Unused Standard Reserved Instances can later be sold at the Reserved Instance Marketplace.

		Convertible Reserved Instances: long workloads with flexible instances
										can change the EC2 instance type
										Up to 54% discount
										Convertible Reserved Instances allow you to exchange for another convertible reserved instance of a different instance family.

		Schedule Reserved Instances: every Thursday between 3 ad 6 pm during 1 year.

Spot Instances: short workloads, cheap, can lose instances (less reliable - menos confiáveis)
				you can "lose" at any poitn of time
				Discount of up to 90%
				The MOST cost-efficient instances
				Useful for workloads that are resilient to failure:
					batch jobs / Data analysis / Image processing / flexible starts and end
				NOT GREAT FOR CRITICAL JOBS
				Max spot price:get the instance while current spot price < max you can choose to stop or terminate your instance with a 2 min grace period.
				Spot Block: block sport instance ruing a specified time frame(1 to 6h) without interruptions
				How to terminate?
					First cancel  a Spot Requests, and then terminate the associated Spot Instance
					Only cancel Spot Instance requests that are OPEN, ACTIVE or DISABLED.

Spot Fleets: set of Spot Instances + (optional) On-Demand Instances
			 will try to meet the target capacity with price contraints
			 Define possible launch pools
			 Stops lauching instances when reaching capacity or max cost
			 Strategies to allocate:
			 	lowestPrice: from the pool with the lowest price (cost optimization, short workloads)
				diversified: distributed acrossall pools (great for availability, long worklads)
				capcaityOptimized: pool with the  optimal capacity for the number of instances
			 Allow us to automatically request Spot Instances with the lowest price

Dedicated Hosts: book an entire physical server, control instance placement
				 Is a physical server with EC2 instance capacity fully dedicated to your use
				 Compliance requirements and use existing software licenses
				 3 year period reservation
				 more expensive
				 BYOL - Bring your own license
				Dedicated Hosts enable you to use your existing server-bound software licenses like Windows Server and address corporate compliance and regulatory requirements.

Dedicated Instances: instances running on hardware that's dedicated to you
					 may share hardware
					 no control over instance placement, can move hardware afterstop/start
					 single tenant: You can change the tenancy of an instance from dedicated to host
									You can change the tenancy of an instance from host to dedicated

```

Private x Public IP (IPv4):
```
IPv4: 1.160.1.240
	is still the most common format used online
	allows 3.7 bilions of options

Private Connectios can communicate with the public hosts between Internet Gateway(public) >> www
Public IP: means themachine can be identified on the internet (WWW)
		   Must be unique across the whole web
		   Can be geo-located easily

Private IP: means the machine can only be identified on a private network only
			the IP must be unique across the private network
			Machines connect to WWW using an internet gateway (proxy)
			Only a specified range of IPs can be used as private IP

Elastic IP: when you stop and then start an EC2, it can change its public IP
			if you need a FIXED PUBLIC IP for your instance == Elastic IP
			IPv4
			Mask the failure of an instance or  softwareby rapidly remapping the address to another instance.
			Only 5 Elastic IP by default.
			try avoid ElasticIP: instead, use a random public IP and registera DNS nameto  it
								 or, use a Load Balancer and don't use a public IP
```

EC2 Placement Groups
```
When you want to control over the EC2 instance placement strategy
When you create, you specify one of the following:
	Cluster: clusters instances into a low-latency group in a single AZ
			 PRO: great network
			 Cons: If the rack fails, all instances fails at the same time
			 Use Case: Big DAta job that needs to complete  fast
			 		   App that needs extremely low latency and high network throughput

	Spread: spreads(propagação) instances across underlying hardware (max 7 instancer per group per AZ)
			critical applications
			PRO: Can span across AZ
				 Reduce risk in simultaneous failure
				 EC2 intancesareon differentphysical hardware
			Cons: Limited to 7 instances per AZ
			Use case: App that needts to maximize high availability
					  CriticalApp where each instancemust be isolatedfrom failure from each other

	Partition: BIG DATA spreads instances across many different partitions (which rely on different sets of racks) within an AZ.
			   Scales to 100s of EC2 instances per group
			   Use Case: Big Data applications = Hadoop, Cassandra,Kafka
			   Each partition represents a rack on Aws
			   Up to 7 partitions per AZ
			   Can span across multiple AZ in the same Region
			   Up to 100s of EC2
			   A partition failure can affect manu Ec2, but won't affect other partitions
			   EC2 get access to the partition information as  metadata

```

Elastic Network Interfaces (ENI):
```
Logical component ina VPC that represents a virtual network card
can have the following attributes:
	Primary privateIPv4, one or more secondary Ipv4
	One Elastic IP per private IPv4
	One Public Ip
	One or more security group
	A MAC address
Can create ENI independently and attach them on the EC2 for failover
Limitated to a specific AZ
```

Elastic Fabric Adapter (EFA):
```
is an AWS Elastic Network Adapter (ENA) with added capabilities.The EFA lets you apply the scale, flexibility, and elasticity of the AWS Cloud to tightly-coupled HPC apps.
It is ideal for tightly coupled app as it uses the Message Passing Interface (MPI)

HPC == EFA
HPC + higher packet per second (PPS) performance == ENA:
	Amazon EC2 provides enhanced networking capabilities through the Elastic Network Adapter (ENA). It supports network speeds of up to 100 Gbps for supported instance types.
	Elastic Network Adapters (ENAs) provide traditional IP networking features that are required to support VPC networking.
```

EC2 Hibernate:
```
The in-memory (RAM) state is preservated
the instance  boot is much faster! (OS is not stopped / restarted)
The RAM state is written to a file in the root EBS vlume
The root EBS volume must be encrypted
Doesnt support all the instances families
RAM size bust be less tha 150GB
AMI:Linux AMi, Ubuntu,  Amazon...
Root volume: MUST be EBS, encrypted, not instance store, and large
Available for on-demand and Reserved Instances
An instance cannot be hibernated more than 60 days

Use cases:  pre-warmed so it can launch the analysis right away when needed
			long-running processing
			saving the RAm state
			services that take time to initialize

```

EC2 Nitro:
```
New virtualization technology
Allows for better perfomance:
	Better networking options
	Hight speed EBS, for 64K EBS IOPS
Better underlying security
Instance types: AI, C5...
			    Bare metal
Use case: Use EBS io2 Block Express volumes on Nitro-based EC2 instances to achieve a maximum Provisioned IOPS of 256,000
```

vCPU:
```
Multipple threads can run on one CPU
Each thread is represented as a virtualCPU
Ex.: m5.2xlarge
	 4 CPU
	 2 threadsperCPU
	 => 8 vCPU in total

Can change the vCPU options:
	of CPU cores: decrease ir to decrease licensing costs
	of threads percore: disable multithreading to have 1 thread per CPU, helpful for HPC workloads
```

Ec2 Capacity Reservations:
```
ensure you have EC2 Capacity when needed
Manual or planned end-date for the reservation
No need 1 or 3 years commitment
Capacity access i immediate, you get billed as soon as it starts
Specify: the AZ in which toreservethecapacity
		 number of instances for which to reservecapacity
		 the intance attributes, including the instance  type, tenancy, OS
Combinewith Reserved Instances and SavingPlanstodo cost saving

On-Demand Capacity Reservations enable you to reserve compute capacity for your Amazon EC2 instances in a specific Availability Zone for any duration. By creating Capacity Reservations, you ensure that you always have access to EC2 capacity when you need it, for as long as you need it. When used in combination with savings plans, you can also gain the advantages of cost reduction.
```

EBS Volume:
```
Elastic Block Store Volume, is a network drive you can attach to your instances while they ryn
"Network USB stick":
					Can be detacged from an EC2 instand and attached to another
					have a provisioned capacity (size in GBs, and IOPS)
					Linked to an AZ
					pode ser adicionado mais EBS, contanto que esteja na mesma AZ.
Allows your instances to persist data, even after their termination
Can only be mounted to one instance at time, but exist multi-attach feature for some EBS
Bound to a specific AZ
Free tier: 30GB of free EBS storage type oftype SSD or Magnetic per month
Delete on termination Attribute:
	In creation, there as option.
	Controls the EBS behavior when an EC2 instance terminate
		By default, the root EBS volume is deleted
		By default, any other attachedEBSvolume is not deleted
	this  can be controlled bu Console/ CLI
	Use case: preserve root volume when instance is terminated, to save data.

Volume Types:
	6 types:
		gp2/gp3 (SSD) = General purposethat balances price and performance
						Cost effective storage, low-lattency
						These volumes deliver single-digit millisecond latencies and the ability to burst to 3,000 IOPS for extended periods of time.
						Case use: system boot volumes, virtual desktops, ddevelopment and test environments
						1  - 16 GB
		io1 / io2 (IOPS SSD) = Highest-performance for mission-critical low-latency or high-throughtput workloads
						  PERFORMANCE
						  Case use: Databasesworkloads
						  			4 Gib - 16 Tib
									App that need more than 16K IOPS
									Max IOPS: 64K for Nitro EC2 & 32K for other
						  io2 Block Express ( 4 Gib - 64 Tib): sub-milisecond latency
						  									   MAxPIOPS: 256K with an IOPS:GiB ratio of 1L:1
						  Support EBS multi-attach
		st1 (HDD) = low Cost HDD designed for frequently accessed, throughput-intensive workloads
					CANNOT be a boot volume
					125 Mib to 16 Tib
					Throughput Optimized HDD: Big Data, DAta warehouse, Log Proccessing
		sc1 (HDD) =  lowest cost volume designed for LESS frequently accessed workloads
					for data that is infrequently accessed
					Scenarios where lowest cost is important
					Max throughput 250Mib/s max IOPS 250

	Characterized in Size | Throughput | IOPS (I/O Ops per Sec)
	Only GP2/3 and io1/2 can be used as boot volume
	CANNOT be a boot volume: Throughput Optimized HDD (st1) + Cold HDD (sc1)

Resume of Types SSD x HDD:
	SSD: small, random I/O operation
		 can be bootable volume
		 Best for transactional workloads
		 Critical business app that require susttained IOPS performance
		 Cost moderate/high
		 General Purpose is a type of SSD that can handle small, random I/O operations.
		 The Provisioned IOPS SSD volumes are much more suitable to meet the needs of I/O-intensive database workloads such as MongoDB, Oracle, MySQL, and many others.

	HDD: large, sequential I/O operation
		 not bootable volume
		 Best for large streaming workloads requiring consistent, fast throughput  ar a low price
		 Big data, data warehouse, log processing
		 storage for large volumes of data that is infrequently accessed

Here is a list of important information about EBS Volumes:
	– When you create an EBS volume in an Availability Zone, it is automatically replicated within that zone to prevent data loss due to a failure of any single hardware component.

	– After you create a volume, you can attach it to any EC2 instance in the same Availability Zone

	– Amazon EBS Multi-Attach enables you to attach a single Provisioned IOPS SSD (io1) volume to multiple Nitro-based instances that are in the same Availability Zone. However, other EBS types are not supported.

	– An EBS volume is off-instance storage that can persist independently from the life of an instance. You can specify not to terminate the EBS volume when you terminate the EC2 instance during instance creation.

	– EBS volumes support live configuration changes while in production which means that you can modify the volume type, volume size, and IOPS capacity without service interruptions.

	– Amazon EBS encryption uses 256-bit Advanced Encryption Standard algorithms (AES-256)

	– EBS Volumes offer 99.999% SLA.
	SSD, General Purpose – gp2
		– Volume size 1 GiB – 16 TiB.
		– Max IOPS/volume 16,000.

	SSD, Provisioned IOPS – i01
		– Volume size 4 GiB – 16 TiB.
		– Max IOPS/volume 64,000.

	HDD, Throughput Optimized – (st1)
		– Volume size 500 GiB – 16 TiB.
		Throughput measured in MB/s, and includes the ability to burst up to 250 MB/s per TB, with a baseline throughput of 40 MB/s per TB and a maximum throughput of 500 MB/s per volume.

	HDD, Cold – (sc1)
		– Volume size 500 GiB – 16 TiB.
		Lowest cost storage – cannot be a boot volume.
		– These volumes can burst up to 80 MB/s per TB, with a baseline throughput of 12 MB/s per TB and a maximum throughput of 250 MB/s per volume
		HDD, Magnetic – Standard – cheap, infrequently accessed storage – lowest cost storage that can be a boot volume.

Use AWS Cost Explorer Resource Optimization to get a report of EC2 instances that are either idle or have low utilization and use AWS Compute Optimizer to look at instance type recommendations
```



Amazon EMR:
```
Is a managed cluster platform that simplifies running big data frameworks, such as Apache Hadoop and Apache Spark, on AWS to process and analyze vast amounts of data.
By using these frameworks and related open-source projects such as Apache Hive and Apache Pig, you can process data for analytics purposes and business intelligence workloads.
Additionally, you can use Amazon EMR to transform and move large amounts of data into and out of other AWS data stores and databases such as Amazon Simple Storage Service (Amazon S3) and Amazon DynamoDB.
```


EBS Snapshots:
```
Make a backup of your EBSvolume at a point in time
Not necessary to detach volume to do snapshot, but recommended
Can copy snapshots across AZ or Region
```

AMI - Amazon Machine Image:
```
AMI area customization of an EC2 instance:
	Your add your own software, configuration, Os...
	Faster boot, because the software is pre-built in
AMI are built for a specif region
You can  launch EC2 instances from:
	A Public AMI: Aws provider
	Your own AMI: you make and maintain them yourself
	An Aws Marketplace: an AMI someone else made ( and sells)
```

EC2 Instance Store
```
EBS volumes are network drives with good but "limited" performance
If you need a HIGH-PERFORMANCE hardware disk == Ec2 Instance Store
	Better I/O performance
	Lose their storafeif they're stopped(ephemeral)
	Good for buffer / cache / scratch data / temporary content
	Risk of data loss if hardware fails
	Backups and Replication are your responsability
	most opitimal block storage
	Case use: high-performance database that requires an IOPS of 210,000 for its underlying filesystem
```

EBS multi-attach - io1/io2 family
```
Attach the same EBS volume to multiple EC2 instancces in the same AZ
Each instance has full read & write permissionsto the volume
Use case:
	Achieve higher app availability in clustered Linux App (ex.: Teradata)
	App must manage concurrent writeoperations
Must use a file sys that's cluster-aware (not XFS, EX4..)
```

EBS Encryption:
```
When you created an encrypted EBS volume, you get:
	DAta at rest in encrypted inside the volume
	All the data in flight moving between the instance and thevolume is encrypted
	All snapshots are encrypted
Encryption and decryption are handled transparently (nothing to do)
Encryption has: minimal impact on latency
				leverages keys frorm KMS (AES-256)
				Copying an unencrypted snapshot allows encryption

Encrypt an Unencrypted EBS volume:
	Create an snapshot
	Encrypt the snapshot ( Actions > using copy)
	create new ebs volume from the snapshot encrypted
	now you can attach the ebs volume to an EC2
In EBS encryption, what service does AWS use to secure the volume’s data at rest?
	 using your own keys in AWS Key Management Service (KMS)
	 using Amazon-managed keys in AWS Key Management Service (KMS).
```

EBS RAID Options:
```
EBS is  already redundant storage (replicated within an AZ)
RAID is possible as long as your OS supports it, some options:
	RAID 0 (increase performance): Ec2 + one logical volume (+1EBS volume behind)
								   Combining 2 or more volumes and getting the total disk space
								   But one disk fails, all the data is failed
								   Use cases: an App that needts a lot of IOPS and doesn't need fault-tolerance
								   			  a database that has replication already built-in
											  using this, we can have big disk with a lot of IOPS

	RAID 1 (increase fault-tolerance): Mirroring a volume to another
									   If one disk fails, our logical volume is still working
									   We have to send the data to two EBS volume at the same time (2x network)
									   Use case: App that need increase volume fault tolerance
									   			 App where you need to service disks
	RAID 5/6 - (not recommended fo EBS)
```

EFS - Elastic File System:
```
Managed NFS (network file system) that can be mouted on many Ec2
Works with EC2 in multi-AZ
is one storage solution that provides a file system interface
Highly available, scalable, expensive (3x gp2), pay per use, no capacity planning!
Use case: content management we serving, data sharing, Wordpress
		  use NFSc4 protocol
		  compatible withLinux base AMI (NOT WINDOWS)
Uses SG to control Access to EFS
encryption at rest using KMS
keywords = rapidly changing data
FILE SYSTEM INTERFACE = EFS, the only.

Performance & Storage Classes:
	EFS Scale:  1K of concurrent NFS clients, 10 GB= /s throughput
				Can grow to Petabyte0scale network file system, automatically
	Performance Mode (set at EFS creation time)(default): latency-sensitive use cases (web server, CMS...)
												Max I/O - higher laency, throughtput, highly parallel (BIG DATA, MEDIA PROCESSING)
	Throughput mode: Bursting (1 TB = 50 Mib/s + burst of up to 100 Mib/s)
					 Provisioned: set your throughput regardless of storage size
					 			  recommend as an optimized solution for high-frequency reading and writing
	Storage Tiers: Lifecycle management feature - move file after N days
				   Standard: for frequently accessed files
				   Infrequent access (EFS-IA): cost to retrieve files, lower price to store

EFS IA: You define when Amazon EFS transitions files an IA storage class by setting a lifecycle policy. A file system has one lifecycle policy that applies to the entire file system.

Security of data:
	You can control access to files and directories with POSIX-compliant user and group-level permissions.
	POSIX permissions allows you to restrict access from hosts by user and group.
	EFS Security Groups act as a firewall, and the rules you add define the traffic flow.
```

EFS x EBS:
```
EBS - one zone, one instance at time,
EFS - multi-AZ, multi instances LINUX at time, share website files, more expensive, pay per use.
```

EBS Backup with DML:
```
You can use Amazon Data Lifecycle Manager (Amazon DLM) to automate the creation, retention, and deletion of snapshots taken to back up your Amazon EBS volumes. Automating snapshot management helps you to:

– Protect valuable data by enforcing a regular backup schedule.

– Retain backups as required by auditors or internal compliance.

– Reduce storage costs by deleting outdated backups.

Combined with the monitoring features of Amazon CloudWatch Events and AWS CloudTrail, Amazon DLM provides a complete backup solution for EBS volumes at no additional cost.
```



## ELB & ASG <a name="ELB+ASG"></a>

Concepts:
1 - Scalability:
```
Means that an application can handle greater loads by adapting
Can be:
	Vertical Scalability: increasing the SIZE of the instance
						  is very commom for non distrtibuited systems, such as database
						  RDS, ElastiCache
						  Has a hardware limity
						  SCALE-UP

	Horizontal Scalability(= elasticity): increase the NUMBER of instances for the app
										  implies distributed systems
										  web app/ moderns app
										  SCALE-OUT
```

2 - High Availability
```
Means that you are running your app in at least 2 DC/AZ
The goal is to survive a DC loss
Can be:
	Passive: RDS Multi AZ
	Active: horizontal scaling
```

3 - Load Balancing
```
Are servers that forward traffic to multiple servers (EC2) downstream
Why use?
	Spread load across multiple downstream instances
	Expose a single point of access to your app
	Do regular health checks to your instances
	Provide SSL termination (HTTPS)
	enforce stickiness with cookies
	HA across zones
	Separate public traffic from private traffic
```

Elastic Load Balancer - ELB:
```
Is a managed load balancer: Aws guarentees that it will be  working
							It costs less to setup your own load balancer but it well be a lot more effort
							It is integrated with manu Aws offerings / services
							Provide static DNS

Health Checks: are crucial, checa se a instances consegue receber o trafego ou não
			   They enable to know if instances it forwards traffic to  are available to reply to requests
			   Is done on a port and a route
			   If the response is not 200, the EC2 is unhealthy

4 Types of ELB:
	Classic Load Balancer (v1 - old generation) - 2009 - CLB:
		Supports TCP (layer 4)
		Http & Https (layer 7)
		Health checks are TCP or HTTP based
		fixed hostname: xxx.region.elb.amazonaws.com

	Application Load Balancer (v2 - new generation) - 2016 - ALB:
		Is layer 7 HTTPS
		Load balancing to  multiple HTTP applications across machines(target groups) and to the same machine(containers)
		Support for HTTP/2 and WebSocket
		Support redirects from HTTP to HTTPS
		Routing tables to diff target groups:
			based on path in URL
			on hostname in URL
			on Query string/Headers
		Are great fit for Micro services & container-based app (Docker & amazon ECS)
		Has a port mapping feature toredirect to a dynamic port in ECS
		www --> route/user->External ALB --> Http-> Target Group
		Target Groups: Ec2 instances (can be Auto Scaling Group) - HTTP
					   EC2 tasks (managed by ECS) - HTTP
					   LambdaFunctions - Http request is translated into a JSON event
					   IP Addresses - must be PRIVATE IP
					   ALB can route to multiple target groups
					   Healthy check by the group
		Have fixed hostname
		The ALB don't see the IP of the client directly, they are inserted in the header X-Forwarded-For
		X-Forwarded-Port X-Forwarded-Protocol are available in the header too.
		Enable ACCESSLOG on the ALB to capture HTTP requests

	Network LoadBalancer (v2) - 2017 - NLB:
		Layer 4 allow to:
			Forward TCP & UDP traffic to your instancces
			Handlemilions of request  per second
			less latency
		Has one static IP per AZ, supports assigning Elastic IP
		Are usedfor extreme performance, TCP or UDP traffic
		Not included in Aws free tier

	Gateway LB - 2020 - GWLB: Layer 3 - IP Protocol
		makes it easy to deploy, scale, and manage your third-party virtual appliances. It gives you one gateway for distributing traffic across multiple virtual appliances, while scaling them up, or down, based on demand. This eliminates potential points of failure in your network and increases availability.

Can be: private or public

Security Groups:
Users --> HTTPS/HTTP from anywhere -> SG --> Http Restricted to ALB(allow traffic only from ELB) --> EC2

Sticky Sessions (session affinity/ sessões fixadas): CACHE DE COOKIES
	implement stickiness(ligação) so that the same client is always redirected to the same instance behind a load balancer
	works for CLB& ALB
	Work with the "cookie" used for stickiness has an expiration date. They are:
		Application-based Cookies:
			Custom  cookie: generated by the target
							Can incluse any custom attributes required by app
							Cookie name must be specified individually for each target group
							Don't use AWSALB, AWSALBAPP, AWSALBTG -- reserved by ELB
			Application cookie: Generated by the load balancer
								Cookie name is AWSALBAPP

		Duration-based Cookies: Cookie generated by the load balancer
								Cookie name isAWSALB for ALB, AWSELB for CLB
	Use case: make sure the user doesn't lose session data

Cross-Zone Load Balancing:
	Each load balancer instance distributes evenly across all registered instances in all AZ.
	Route 53 will distribute traffic such that each load balancer node receives 50% of the traffic from the clients.

	ALB: Always on
		 No chargesfor inter AZ data

	NLB: Disabled by default
		 You pay charges for inter AZ data if enabled

	CLB: Console: Enabled by default
		 CLI/API: Disabled by default
		 No charges for inter AZ data

SSL/TLS:
	An SSL Certificate allows traffic between your clients and your load balancer to be encrypted in transit(in-flight encryption)
	SSL refers to Secure Sockets Layer,used to encrypt connections

	TLS refers to Transport Layer Security, which is a newer version, are mainly used(mais usados)

	Public SSl certificates are issued by CA(Comodo, GoDaddy, letsencrypt...), have an expiration date and reniewd
	Load Balancer uses an X.509 certificate(SSL/TLS server certificate)
	You can manage certificates using ACM(Aws Certificate Manager) or upload your own. And to IAM certificate store.

	HTTPS Listener: You must specify a default certificate or an list of certs to multiple domain
					Clients can use SNI(Server Name INdication) to specify the hostname they reach
					Ability to specify a security policy to support older version of SSL/TLS

	SNI: solves the problem of loadinf multiple SSL certificates onto  one  web server
		 It's a newer protocol, and requires the client to indicate the hostname of the target server in the initial SSL handshake
		 The server will then find the correct certificate, or return the default one
		 Works for ALB & NLB & CloudFront

	Certificates resume: CLB(v1) ==> Only one SSL certificate
						 ALB(v2) + NLB == multiple listeners with multiple SSL cert, uses SNI to make it work

Connection Draining:
	Feature naming: CLB = Connection Draining
					ALB & NLB = Deregistration Delay
	Give some time to complete "in-flight requests" while the EC2 is de-registering/unhealthy
	Stops sending new requests to the EC2 which is unhealthy
	Between 1 to 3600 sec (default: 300 sec)
	Can be disabled (set value 0)
	Set to a low value if your requests are short
	Connection draining is enabled by default and provides a period of time for existing connections to close cleanly. When connection draining is in action an CLB will be in the status “InService: Instance deregistration currently in progress”.

Auto Scaling Group - ASG:
	Scale out(add EC2 inst) to match an increased load
	Sclae in (remove Ec2) to match a decreased load
	Ensure we have a min and a max number of machines running
	Automatically register new instances to a load balancer
	Have: A Launch configuration(AMI + Instance type, User Data, EBS vol, SG, SSH key pair)
		  Min Size/ MAx Size/ Initial Capacity
		  Network + Subnets information
		  Load Balancer Information
		  Scaling Policies

	Auto Scaling Alarms: It is possible to scale an ASG based on CloudWatch alarms
						 An alarm monitors metrics (average CPU)
						 Can create scale-out or scale-in policies

	ASG Brain Dump: scalingpolicie can even be on custom metrics or based on a schedule (if you know tour visitors patterns)
					ASG use Launch configurations or Launch Templates
					To update an ASF, you must provide a new launch conf
					IAM roles attached to an ASG will get assigned to EC2
					ASG are free. You pay for the  underlying resources being launched
					ASG can terminate instances marked as unhealthy by an LB (and replace them automatically)
					Auto Scaling chooses the policy that provides the largest capacity for both scale-out and scale-in.

	Dynamic Scaling Policies:
		Target Tracking Scaling: easy to set-up, Increase or decrease the current capacity of the group based on a target value for a specific metric. Ex.: average CPU stay at around 40%
								This is similar to the way that your thermostat maintains the temperature of your home – you select a temperature and the thermostat does the rest.
								you can increase or decrease the current capacity of the group based on a target value for a specific metric. This policy will help resolve the over-provisioning of your resources.

		Simple:  Increase or decrease the current capacity of the group based on a SINGLE scaling adjustment.

		Step Scaling: When a CloudWatch alarmis triggered (CPU>70%), then add 2 units
					  Increase or decrease the current capacity of the group based on a set of scaling adjustments, known as step adjustments, that vary based on the size of the alarm breach.
					  With step scaling, you choose scaling metrics and threshold values for the CloudWatch alarms that trigger the scaling process as well as define how your scalable target should be scaled when a threshold is in breach for a specified number of evaluation periods.

		Schedule Actions: Anticipate ascaling basedon known usage patterns. ex.: increase the min capacity to 10 at 12pm Fridays.

	Predictive Scaling:
		Continuously forecast load and schedule scaling ahead

	Good metrics to scale on: CPUUtilization: Average CPU
							  RequestCountPerTarget: make sure the number of requests per  EC2 is stable
							  Average NetworkIn/Out

	Scaling Cooldowns(esfriamento):
		after scaling activity happens, you are in the cooldown period == 300 seconds
		during the cooldown, the ASG will not launch or terminate additional ec2
		Use a ready-to-use AMI to reduce configuration time
		It ensures that the Auto Scaling group does not launch or terminate additional EC2 instances before the previous scaling activity takes effect.
		Its default value is 300 seconds.
		It is a configurable setting for your Auto Scaling group.

	ASG Default Termination Policy: 1. Find the AZ which has the most number of instances
									2. If there are multiple instances in the AZ to choose from, delete the one with the oldest launch conf
									3. ASG tries the balance the number of instances across AZ by default.
									1. If there are instances in multiple Availability Zones, choose the Availability Zone with the most instances and at least one instance that is not protected from scale in. If there is more than one Availability Zone with this number of instances, choose the Availability Zone with the instances that use the oldest launch configuration.

									2. Determine which unprotected instances in the selected Availability Zone use the oldest launch configuration. If there is one such instance, terminate it.

									3. If there are multiple instances to terminate based on the above criteria, determine which unprotected instances are closest to the next billing hour. (This helps you maximize the use of your EC2 instances and manage your Amazon EC2 usage costs.) If there is one such instance, terminate it.

									4. If there is more than one unprotected instance closest to the next billing hour, choose one of these instances at random.

	Lifecycle Hooks: By default as soon as instance is launched in an ASG it's in service
				     You have the ability to perform extra  steps before the instance goes in service (pending  state) and before the instance is terminated(terminated)
					 Use the Auto Scaling group lifecycle hook to put the instance in a wait state and launch a custom script that installs the proprietary forensic tools and performs a pre-activation status check.
					 able to download log files whenever an instance terminates because of a scale-in event from an auto-scaling policy.
					 Use case:
					 	A Solutions Architect must implement a solution that collects all of the application and server logs effectively. She should be able to perform a root cause analysis based on the logs, even if the Auto Scaling group immediately terminated the instance.
					 		== Add a lifecycle hook to your Auto Scaling group to move instances in the Terminating state to the Terminating:Wait state to delay the termination of unhealthy Amazon EC2 instances. Configure a CloudWatch Events rule for the EC2 Instance-terminate Lifecycle Action Auto Scaling Event with an associated Lambda function. Trigger the CloudWatch agent to push the application logs and then resume the instance termination once all the logs are sent to CloudWatch Logs.

	Launch Template vs Launch COnfiguration:
		Both: Id of the AMI, instance type, key pair, SG, tags, user data...
		Launch conf(legacy):Must be re-created every time
		Launch Template (newer): Can have multiple versions
								 Create  parameters subsets (partial confforre-use and inheritance)
								 Provisioning using both On-Demand and Spot (or mix)
								 Can use T2 and  is recommended by Aws.
```

Amazon Transcribe:
```
is an automatic speech recognition (ASR) service that makes it easy to convert audio to text.
One key feature of the service is called speaker identification, which you can use to label each individual speaker when transcribing multi-speaker audio files. You can specify Amazon Transcribe to identify 2–10 speakers in the audio clip.
```


## RDS + Aurora + ElastiCache <a name="RDSAuroraElasti"></a>

RDS:
```
Relational Database Service
It's a managed DB service for DB use SQL as query language
Can be: Postgres, MySQL, MAriaDB,Oracle,SQL server, Aurora(aws proprietary database)

Advantage of RDS vs EC2:
	RDS is a managed service:
		Automated provisioning, OS patching
		countinuous backup and restore to specific timespamt (Point in Time Restore)
		monitoring dashboard
		scaling capacity - vertical or horizontal
		But you CAN'T access throught SSH

IAM DB Authentication:
	IAM database authentication provides the following benefits:
		Network traffic to and from the database is encrypted using Secure Sockets Layer (SSL).
		You can use IAM to centrally manage access to your database resources, instead of managing access individually on each DB instance.
		For applications running on Amazon EC2, you can use profile credentials specific to your EC2 instance to access your database instead of a password, for greater security

RDS Backups:
	Are automaticaly enabled in RDS
	Daily full backup of the databse
	Transaction logs are backed-up by RDS every 5 min
	ability to restore any point in time
	7 days retention (can be 35 days)

DB Snapshots:
	Manually trirggered by the user
	Retention of backup for as long as you want
	Point in time recovery allows you to create an additional RDS instance, based on the data as it existed on your instance at any specific point in time you choose between the oldest available automated backup and approximately 5 minutes ago

Store Auto Scaling:
	Helps you increase storage on your RDS dynamically
	When RDS detects you are running out of free database storage, it scales automatically
	Avoid manually scaling your DB store
	You have to set Maximum Storage Threshold
	Automatically modify storage if:
		Free storage is less than 10% of allocated storage
		Low storage lasts at least 5 min
		5 hours have passed since last modification
	Useful for app with unpredictable workloads
	Supports all RDS engines

Read Replicas: **important**
	Provide enhanced performance and durability for database (DB) instances.
	Help to scale your read/write capacity
	**Up to 5 read replicas**
	Within AZ, Cross AZ or Cross Region
	Replication is ASYNC, so reads are eventually consistent
	Replicas can be promoted to their own DB
	App must update the connection string to leverage read replicas
	Use cases:
		You have a Prod DB that is taking on normal load, you want to run reporting app to run some analytics.
		You create a Read Replica to run the new workload there.The prod app is unaffected.
		Read replicas are used for SELECT(=read) only kind of statements (not INSERT, UPDATE, DELETE)
	Network Cost:
		For RDS Read Replicas within the SAME region, you don't pay the fee(honorarios)
		For Cross Region, you pay!

Multi AZ (Disaster Recovery):
	Synchronous
	SYNC replication == one standby DB
	One DNS name - automatic app failover to standby
	Increase availability
	Failover in case of loss of AZ, loss of network, instance or storage failure
	No manual intervention ins apps
	Not used for scaling
	the Read Replicas can setup as Multi AZ for Disaster Recovery(DR)
	DB maintenance window
	In case of failover from the first instance: simply flips the canonical name record (CNAME) for your DB instance to point at the standby, which is in turn promoted to become the new primary.
	You can create a read replica as a Multi-AZ DB instance. Amazon RDS creates a standby of your replica in another Availability Zone for failover support for the replica. Creating your read replica as a Multi-AZ DB instance is independent of whether the source database is a Multi-AZ DB instance.
	Any database engine level upgrade for an RDS DB instance with Multi-AZ deployment triggers both the primary and standby DB instances to be upgraded at the same time. This causes downtime until the upgrade is complete

How a RDS can go from Single-AZ to Multi-AZ?
	Zero downtime operation (no need to stop)
	Just click on "modify" for the DB
	Happens internally:	A snapshot is taken
						A new DB is restored from the snapshot in a new AZ
						Synchronization is established between the two DB

RDS Security - Encryption:
	At rest encryption: Possibility to encrypt the master & replicas with Aws KMS - AES-256 encryption
						Encryption has to be defined at launch time
						If the master is not encrypted, the read replicas cannot be encrypted
						Transparent Data Encryption (TDE) available for Oracle and SQL Server

	In-flight encryption: SSL certificates to encrypt data to RDS in flight
						  Provide SSL options with trust certificate when cnnecting with databse
						  To enforce SSL: PostgreSQL: rds.force_ssl=1 in the Parameter Groups;
						  				  MySQL: Within theDB: GRANT USAGE ON *.*TO 'mysqluser'@'%' REQUIRE SSL;
												Download the Amazon RDS Root CA certificate. Import the certificate to your servers and configure your application to use SSL to encrypt the connection to RDS.

	Encryption Operations:
		Encrypting RDS backups: Un-encrypted create a snapshots un-encrypted
								Encrypted create a snapshots encrypted
								To encrypt a backup you can Copy a snapshot into an encrypted one
		To Encrypt an un-encrypted RDS: Create a snapshot of the un-encrypted DB
										copy the snapshot and enable encryption for the snapshot
										Restore the DB from the encrypted snapshot
										Migrate app to the new DB and delete the old DB

RDS Security - Network & IAM
	Network Security: RDS are usually deployed within a private subnet,not in a public one
					  RDS security works by leveraging SG - it controls which IP /SG can communicate with RDS
	Access Management: IAM policies help  control who can manage RDS (throught the API)
					   Traditional User&Pass can be used to login into
					   IAM-based auth can be used to login in RDS Mysql & PostgreSQL
	IAM authentication: just need an authentication token obtained throught IAM & RDSAPI calls
						Auth token has lifetime of 15min
						Benefitis: Network in/out must be encrypted using ssl
								   IAM to centrally message users instead of DB
								   Can leverage IAM Roles andEC2 profiles for easy integration
	Aws responsability:no ssh access, no manual DB/OS patching

RDS Enhanced Monitoring:
	monitoring CPU recurses
	RDS processes – Shows a summary of the resources used by the RDS management agent, diagnostics monitoring processes, and other AWS processes that are required to support RDS DB instances.
	OS processes – Shows a summary of the kernel and system processes, which generally have minimal impact on performance.
	show how the different processes or threads on a DB instance use the CPU, including the percentage of the CPU bandwidth and total memory consumed by each process.

```

Amazon Aurora:
```
Aurora is proprietary technology from Aws (NOT OPEN SOURCED)
Postgres/Mysql are supported as Aurora DB
is Cloud Optimized and claims 5x performance improvement over MySQL on RDS, over 3x of Postgres on RDS
Automatically grows in increments of 10GB, up to 64TB
*Can have 15 read replicas* while Mysql has 5, and the replication process is faster (sub 10 ms replica lag)
Failoverin Aurora  is instantaneous. It's HA native.
Aurora costs more than RDS(20% more) - but is more efficient

HA and Read Scaling:
	6 copies of your data across 3 AZ: 4 copies out 6 needed for writes
									   3 copies out of 6 need for reads
									   Self healing with peer-to-peer replication
									   Storage isstriped across 100s of volumes
	One Aurora Instance takes writes (MASTER)
	Automatedfailover for master in less than 30 sec
	Master+up to 15 Aurora Read Replicas serve reads
	Each Read Replica is associated with a priority tier (0-15). In the event of a failover, Amazon Aurora will promote the Read Replica that has the highest priority (the lowest numbered tier).
	If two or more Aurora Replicas share the same priority, then Amazon RDS promotes the replica that is largest in size.
	If two or more Aurora Replicas share the same priority and size, then Amazon Aurora promotes an arbitrary replica in the same promotion tier.
	read replica vai promover a que tiver com maior prioridade(ord crescente) e de maior tamanho, ex: entre 0-10, Tier-1(32GB) e Tier10(16TB), a Tier-1 será a escolhida.

Aurora DB Cluster:
	Writer Endpoint -- point to tha mster
	Reader Endpoint - Connection Load Balancing
					  (make the orchestration between the replicas and the master into Replicas ASG)
	Custom Endpoint - Run analytical queries on specific replicas
					  Define a subset of Aurora Instances as a Custom Endpoint
					  Grupo separado de instancias para rodar cargas específicas

Features: Routine Maintenance
		  Advance Monitoring
		  Automated Patching

Aurora Security:
	Similar to RDS, uses the same engines

Aurora Serverless:
	Automated DB instantiation and auto-scaling based on actual usage
	Good for infrequent, intermittent or unpredictable workloads
	No capacity planning need
	Pay per second, can be more cost-effective

Aurora Multi-Master:
	Immediate failover for write node (HA)
	every node does r/w

Global Aurora:
	Aurora Cross Region Read Replicas: Useful for disaster recovery
									   Simple to put in place

	Aurora Global Database (recommended): 1 primary Region (r/w)
										  Up to 5 sec(read-only) regions, replication lag is less than 1 sec
										  Up to 16 Read Replicas per second region
										  Helps for decreasing latency
										  Promoting another region (for disaster recovery) has an RTO of <1 min
										  Use case: Disaster recovery

Aurora Machine Learning:
	Enables your to add ML-based predictions to your app via SQL
	Simple, optimized, and secure integration between Aurora and Aws ML services
	Supported services: Aws SageMaker (use with any ML model)
						Aws Comprehend (for sentiment analyst)
	don't need experience with ML
	Use cases: fraud detection, ads targeting, sentiment analysis, product recommendations

Aurora Failover:
	Aurora will attempt to create a new DB Instance in the same Availability Zone as the original instance and is done on a best-effort basis.
	Failover is automatically handled by Amazon Aurora so that your applications can resume database operations as quickly as possible without manual administrative intervention.
	If you have an Amazon Aurora Replica in the same or a different Availability Zone, when failing over, Amazon Aurora flips the canonical name record (CNAME) for your DB Instance to point at the healthy replica, which in turn is promoted to become the new primary. Start-to-finish, failover typically completes within 30 seconds.

```

Amazon ElastiCache:
```
Is to get managed Redis or Memcached
Caches are in-memory dB with really high performance, low latency
Helps reduce load off of DB for read intensive workloads
Help make your app stateless [recursos isolados](https://www.redhat.com/pt-br/topics/cloud-native-apps/stateful-vs-stateless)
Aws takes care of OS maintenance/patching/backup/failure recovery
Can be used as a distributed in-memory cache-based for session management

HIPAA eligibility:
	The AWS HIPAA Compliance program includes Amazon ElastiCache for Redis as a HIPAA eligible service.

	To use ElastiCache for Redis in compliance with HIPAA, you need to set up a Business Associate Agreement (BAA) with AWS. In addition, your cluster and the nodes within your cluster must satisfy the requirements for engine version, node type, and data security listed following.

Using ElastiCache involves heavy app code changes!

Architecture DB Cache:
	App queries ElastiCache, if not available, get from RD and store in ElastiCache.
	Helps relieve load in RDS
	Cache must have an invalidation strategy to make sure only the most current data is used in there.

Architecture User Session Store:
	User logs into any of the app
	The app WRITES the session data into ElastiCache
	The user hits another instance of our app
	The instance retrieves the data and the user is already logged in
	OR
	DynamoDB and ElastiCache

Redis vs Memcached:
	Redis: multi AZ with Auto-failover
		  read replicas to scale reads and have high availability
		  data durability using AOF persistence
		  Backup and restore features
		  Use case: Gaming Leaderboards are computationally complex, so Redis Sorted sets guarantee both uniqueness and element ordering.
		  			Each time a new element added, it's ranked in real time, then added in correct order

	Memcached: Multi-node for patitioning data (sharding - fragmentos)
			   No HA(replication)
			   Non persistent
			   No backup and restore
			   Multi-threaded architecture

Cache Security:
	All caches in ElatiCache: Do not support IAM auth
							  IAM policies on ElastiCache are only used for AWS API-level security
	Redis AUTH: can be user/ppass when you create a Redis cluster
		        This is an extra level of security for your cache
				Support SSL in flight encryption
	Memcached: supports SASL-based auth(advanced)

Patterns for ElastiCache:
	Lazy Loading: all the read data is cached, data can become stale in cache
	Write Throught: Adds or update data in the cache when written to a DB(no stale data)
	Session Store: store temporary session data in a cache (using TTL features)

```

AWS Batch
```
eliminates the need to operate third-party commercial or open source batch processing solutions.
There is no batch software or servers to install or manage.
AWS Batch manages all the infrastructure for you, avoiding the complexities of provisioning, managing, monitoring, and scaling your batch computing jobs.
```

AWS Batch Multi-node:
```
parallel jobs enable you to run single jobs that span multiple Amazon EC2 instances. With AWS Batch multi-node parallel jobs, you can run large-scale, tightly coupled, high performance computing applications and distributed GPU model training without the need to launch, configure, and manage Amazon EC2 resources directly.
is compatible with any framework that supports IP-based, internode communication, such as Apache MXNet, TensorFlow, Caffe2, or Message Passing Interface (MPI).
```

List of Ports to be familiar with
```
Here's a list of standard ports you should see at least once. You shouldn't remember them (the exam will not test you on that), but you should be able to differentiate between an Important (HTTPS - port 443) and a database port (PostgreSQL - port 5432)

Important ports:

	FTP: 21
	SSH: 22
	SFTP: 22 (same as SSH)
	HTTP: 80
	HTTPS: 443

	RDS Databases ports:
		PostgreSQL: 5432
		MySQL: 3306
		Oracle RDS: 1521
		MSSQL Server: 1433
		MariaDB: 3306 (same as MySQL)
		Aurora: 5432 (if PostgreSQL compatible) or 3306 (if MySQL compatible)
```

## Route53 <a name="Route53"></a>

DNS:
```
Domain Name System - translate the human friendly hostnames into the machine IP addresses
www.google.com => 17.125.35.33
DNS is the backbone of the internet
DNs uses hierarchical naming structure:   .com
									   example.com
									   www.example.com
									   api.example.com

DNS Terminologies:
	Domain Register: Aws Route53, GoDaddy...
	DNS records: A, AAAA, CNAME, NS
	Zone file: contains DNS records
	Name Server: resolves DNS queries (Authoritative or Non-Authoritative)
	Top Level Domain (TLD): .com,.us,.in,.gov,.org....
	Second Level Domain (SLD): amazon.com, google.com

	[FQDN(Fully Qualified Domain Name)]
	Htttp://api.www.example.com.
	Protocol://DomainName(subdomain.subdomain.SLD.TLD.root)

DNS Works:
Web Browser --> request access to example.com --> Local DNS Server --> TLD DNS Server(.com) + SLD DNS Server --> return the answer.
```

Aws Route 53:
```
A highly available, scalable, fully managed and Authoritative DNS
	Authoritative = the client can update the DNS records
Is a Domain Register
Ability to check the health of your resources
The ONLY Aws Service which provides 100% availability SLA
Why 53? 53 is a reference to the traditional DNS port.

Records:
	How you want to route traffic for a domain
	Each record contains:
		Domain/Subdomain name - example.com
		RecordType: A - maps a hostname to IPv4
					AAAA - maps a hostname to IPv6
					CNAME - maps a hostname to another hostname
						The target is a domain name which must have an A or AAAA
						Can't create a CNAME record for the top node of a DNS namespace(Zone Apex)
						Ex.: you can't create example.com, but you can create for www.example.com
					NS - Name Servers for the Hosted Zone
						Control how traffic is routed for a domain
		Value - 123.456.22.11
		Routing Policy - how route53 responds to queries
		TTL (Time To Live) - amount of time the record cached at DNS Resolvers
			High TTL - 24h: Less traffic on route53
							Possbile outdated records
			Low TTL - 60sec: MOre traffic on rout53($$)
							 Records are outdated for less time
							 Easy to change records
			Except for Alias records, TTL is mandatory for each DNS record

	Alias Records: Maps a hostname to an Aws Resource (DNS --> Type A --> Value: ALB)
				   An extension to DNS functionality
				   Automatically recognizes changes in the resource's IP addresses
				   It can be used fot he top node of a DNS namespace != of CNAME
				   Is always of type A/AAAA for Aws resources
				   You can't set the TTL
				   Targets: ELB
				   			CloudFront
							Api Gateway, VPC Endpoints
							Elastic Beanstalk
							S3 Websites
							route53 records
					Cannot set for EC2 DNS name
					An Alias record can be used for resolving APEX or naked domain names (e.g. example.com).
					You can create an A record that is an Alias that uses the customer’s website zone apex domain name and map it to the ELB DNS name.
					Alias records provide a Route 53–specific extension to DNS functionality. Alias records let you route traffic to selected AWS resources, such as CloudFront distributions and Amazon S3 buckets.
					ex.: Create an alias record for covid19survey.com that routes traffic to www.covid19survey.com


	Route53 supports the following DNS record types:
		A/aaaa/cname/NS
		CAA/DS/MX/NAPTR/PTR/SOA/TXT/SPF/SRV

	Hosted Zones: A container for records that define how to route traffic to a domain and its subdomains
				  Public Hosted Zones: contains records that specify how to route traffic on the Internet (app.meypublicdomain.com)
				  Provate hosted Zones: contain records that specify how you route traffic within one or more VPC(app2.company.internal)
				  You pay $0.50 per month

	CNAME vs Alias:
		When you want to redirect your ALB to your DNS, you can use:
			CNAME: points a hostname to any other hostname (app.mydomain.com => blabla.anything.com)
				   ONLY FOR NON ROOT DOMAIN
				   test.domain.com >> Type: cNAME >> Value: the ALB

			Alias: points a hostname to an Aws Resource (app.mydomain.com => blabla.anything.com)
				   WORK FOR ROOT DOMAIN AND NON ROOT DOMAIN(aka.mydomain.com)
				   Free of charge
				   Native health check
				   domain.com >> Type A >> Value: Alias (set the ALB)

Commands to check the availability of our domain:
	`sudo yum install -y bind-utils`
	nslookup test.exemple.com
	dig test.exemple.com

Routing Policies:
	Define how Route53 responds to DNS queries
	Supports:
		Simple: route traffic to a single resource
				can specify multiple values in the same record
				If multiple values are returned, a rendom on is chosen by the client
				when Alias enabled, specify only one Aws resource
				Can't be associate with healthy checks

		Weighted: control the % of the requests that go to each specific resource
				  assign each record a relative weight(max 100)
				  DNs records must have the same name and type
				  Can be associate with healthy checks
				  Use cases: load balancing between regions, testing new app version
				  			 If you want to stop sending traffic to a resouce --> weight=0
							 If all records are 0, they will be divide equally

		Latency-based: redirect to the resource that has the least latency close to us
					   super helpful when latency for users is a priority
					   latency is based on traffic between users and Aws Region
					   Germany users may be directed to the US
					   Can be associate with Health Checks(has a failover capability)

		Failover (Active-Passive): Create 2 instances, and set the HC. If the first become unhealthy, then the second is up to respond to DNS requests

		Geolocation: different from latency-based!
					 Is based on user location!
					 Specify location by Continent, Country or by US State
					 Should create a "Default" record (in case the's no match on location)
					 Use cases: website localization, restrict content distribution, load balancing
					 Can be associate with HC

		Geoproximity: Route traffic to your resources bases on the geographic location of users and resources
					  Ability to shift more traffic to resouces based on the defined bias(valor):
					  	To change the size of the geografic region: To expand(1 to 99) more traffic to the resource
						  											To shrink (-1 to -99) less traffic to the resource
					  Resources can be: Aws resources or Non-Aws resources

		Multi-Value: Use when routing traffic to multiple resources
					 Route53 return multiple values/resources
					 Can be associate with HC(return only healthy resources)
					 Up to 8 health records are returned for each
					 Is not substitute to ELB

		Active-Active Failover:
			Use this failover configuration when you want all of your resources to be available the majority of the time. When a resource becomes unavailable, Route 53 can detect that it's unhealthy and stop including it when responding to queries.
			In active-active failover, all the records that have the same name, the same type (such as A or AAAA), and the same routing policy (such as weighted or latency) are active unless Route 53 considers them unhealthy. Route 53 can respond to a DNS query using any healthy record.

		Active-Passive Failover:
			Use an active-passive failover configuration when you want a primary resource or group of resources to be available the majority of the time and you want a secondary resource or group of resources to be on standby in case all the primary resources become unavailable. When responding to queries, Route 53 includes only the healthy primary resources. If all the primary resources are unhealthy, Route 53 begins to include only the healthy secondary resources in response to DNS queries.


Traffic Flow: Simplify the process of creating and maintaining records in large and complex conf
			  It's a visual editor to manage complex routing decision trees
			  Configurations can be saved as Traffic Flow Policy

Health Checks: HTTP health checks are only for public resources
			   Integrated with CloudWatch metrics
			   Automated DNS Failover: 1. Monitor an endpoint: About 15 global health checkers:
																	Healthy/Unhealthy threshold - 3 by default
																	Supported protocol: HTTP, HTTPS and TCP
																	Ability to choose which locations you want route53 to use
															   Health pass only when the endpoint responds with the 2xx and 3xx status code
															   Can be setup to pass/fail based on the text in the first 5120bytes of the response
															   Configure you roter/firewall to allow incoming requests from route53 HC
			   						   2. Monitor other health check(calculate): combine the results of multiple HC into a single HC
										  										 can use OR, AND or NOT
																				 can monitor up to 256 child HC
																				 Specify how many if the checks need to pass to make the parent pass
																				 Usage: perfom maintenance to your website without causing all HC to fail
									   3. Monitor CloudWatch Alarms(full control)
			   Monitor Private hosted zones: with CloudWatch Metric and associate a CloudWatch Alarm, then the HC will check

Godaddy(3rd Party) as Registrar & Route53 as DNS Service:
	Register on GoDaddy + Public Hosted Zone(will deliver the name servers, that have to be add in Godaddy)
```

## Solutions Architect Discussions <a name="solArch"></a>

Case 1: Stateless Web App
```
whatisthetime.com allows people to know what time it is
don't need a DB // don't srote data on the host = stateless

Stateless = Dynamo + elaticache
Scaling horizontally: Group of 3 Private EC2 instances in +2 AZ within ASG --> Restricted Security groups rules -->
					  ELB + health checks --> Clients requests --> DNS Query within Route53
```

Case 2: Stateful Web App
```
myclothes.com allows people to buy clothes online
There's a shopping cart
hundreds of users at the same time
require some kind of storage == stateful

 - Introduce Stickiness(para manter os dados da sessão)
 - Introduce User Cookies: cookies must be validated and must be less than 4kb
 - Introduce Server Session with ElastiCache: DNS queries by route53 --> User requests
 											 --> ELB with multi-az --> ASG with 3 groups of EC2 in different AZ
											 --> Elasticache store/retrieve session data and make sure the data is secure
 - Storing User Data in a DB: DNS with route53 --> Users requests
							  --> multiAZ ELB --> ASG with 3 groups of EC2 in different AZ
							  --> RDS storing/retrieve user data(address, name, etc)
 - Scaling Reads: DNS with route53 --> Users requests
				--> multiAZ ELB --> ASG with 3 groups of EC2 in different AZ
				--> RDS master --> RDS replica
 - Scaling Reads - write through: DNS with route53 --> Users requests
						--> multiAZ ELB --> ASG with 3 groups of EC2 in different AZ
						--> Check if the info is already in cache in ElastiCache
						--> Caso nao tenha:
					    --> RDS read/write
 - Multi Az - survive disaster: DNS with route53 --> Users requests
						--> multiAZ ELB --> ASG with 3 groups of EC2 in different AZ
						--> Check if the info is already in cache in ElastiCache MultiAz
						--> Caso nao tenha:
					    --> RDS read/write MultiAz
 - Security Group rules: Route53 --> Client Request
						--> Rule: Open HTTP/S to 0.0.0.0/0 --> ELB multiAZ
						--> Rule: restrict traffic to EC2 SG from the ELB --> ASG with groups of ec2 in differents az
						--> Rule: restrict traffic to ElastiCache SG from the Ec2 SG --> Elasticache MultiAZ
						--> Rule: restrict traffic to RDS SG from the Ec2 SG --> RDs MultiAZ
```

Case 3: Stateful Web App mywordpress.com
```
Fully scalable Wordpress website
that website access and correctly display picture uploads
our user data should be stored in MySql DB

 - RDS Layer or
 - Aurora MySQL: benefits of Multi Az Read Replicas
 - Storing images with EBS: DNS with route53 --> Users send image
						--> multiAZ ELB --> EC2 and one EBS volume attached
						Obs: the problem with EBs is that it only works within one instance
 - Storing images with EFS: DNS with route53 --> Users send image
						--> multiAZ ELB --> EC2 + ENI(Elastic Network Interfaces)
						--> One EFS storing the images
						Obs.: the EFS is shared with many instances
```

Instantiating Applications quickly(rapidamente):
```
EC2 instances:
	Use Golden AMI: install your app, OS dependencies...before hand and launh your EC2 from the AMI
	Booststrap using User DAta: for dynamic configuration, use User Data Scripts
	Hybrid: mis golden AMi and User Data (Elastic Beanstalk)

RDS DB:
	Restore from a snapshot: the DB will have schemas and data ready!

EBS Volumes:
	Restore from snapshot: the disk will already be formatted and have data!

```

X-Ray:
```

AWS X-Ray helps developers analyze and debug production, distributed applications, such as those built using a microservices architecture.
With X-Ray, you can understand how your application and its underlying services are performing to identify and troubleshoot the root cause of performance issues and errors. X-Ray provides an end-to-end view of requests as they travel through your application, and shows a map of your application’s underlying components.

You can use X-Ray to collect data across AWS Accounts. The X-Ray agent can assume a role to publish data into an account different from the one in which it is running. This enables you to publish data from various components of your application into a central account.

The engineering team at the company would like to debug and trace data across these AWS accounts and visualize it in a centralized account. == x-ray
```


ElasticBeanstalk:
```
Is a developer centric view of deploying an app on Aws
It uses all the component's we've seen before: EC2, ASG, ELB, RDS///
Managed Service: automatically handles capacity provisioning...
				 just tha pp code is the responsibility of the developer
We still have full control over the conf
Is free but you pay for the underlying instances
Components:
	Application: collections of Elastic Beanstalk components(environments, versions, conf...)
	Application Version: an iteration of your app code
	Environment:
		Collection of Aws resources running an app version(only one app version at a time)
		Tiers: Web server environment Tier(ELB) & Worker Environment Tier(SQS Queue)
		You can create multiple environments(dev, test/qa, prod...)
Supports: Go, Java, .NET, PHP, Python...or you can write a template for your language.

Is looking for a way to easily deploy the application whilst maintaining full control of the underlying resources.

time to create a new instance in your Elastic Beanstalk deployment to be less than 2 minutes ==
```

## Amazon S3 <a name="S3"></a>

Resume:
```
Infinitely scaling storage
Many websites use S3 as a backbone
Amazon S3 allows people to store objects(files) in "buckets"(directories)
Buckets must have: globally unique name
				   defined at the region level
				   no uppercase, no underscore, 3-63 characteres long
				   not an IP, must start with lowercase letter or number
```

Objects:
```
 objects have a key
		 The key is the full path:
		 	s3://my-bucket/myfile.txt
		    composed of prefix+object name
		 Values are the content of the vody:
		 	Max object is 5TB
			If > 5GB, must use "multi-part upload"
		 Metadata is a list of text key/value pairs - system or user metadata
		 Tags: unicode key/value - useful for security/lifecycle
		 Version ID (if versioning is enabled)
```

Versioning:
```
you can version your files, it is enabled at the bucket level
Same key overwrite will increment the version: 1,2,3...
It is best practice to version your buckets: Protect against unintend deletes and has easy roll back to previous version
Notes: Any file that is not versioned prior to enabling versioning will have version "null"
	   Suspending versioning does not delete the previous versions
```

Encryption for Objects:
```
Make your objects secures
There are 4 methods of encrypting objects:
	SSE-S3: encrypts S3 objects using keys handled & managed by Aws
		    objects is encrypted server side
			AES-256 encryption type
			Must set header: "x-amz-server-side-enc":"AES256"
			HTTPS/HTTPS

	SSE-KMS: leverage KMS to manage encryption keys
			 user control + audit trail
			 objects is encrypted server side
			 Must set header: "x-amz-server-side-encryption":"aws:kms"
			 Object --> HTTP/S + Header --> KMS encryption -- S3 Bucket.

	SSE-C: when you want to manage your won encryption keys
		   S3 does not store the encryption key you provide
		   HTTPS must be used
		   Encryption key must provided in HTTP headers, for every HTTP request made
		   Object + Client side data key --> HTTPS only + DataKey in Header --> Client encryption -- Bucket.

	Client Side Encryption: clients must encrypt data themselves before sending to S3
							clients must decrypt data themselves when retrieving from S3
							customer fully manages the keys and encryption cycle

Encryption in trasit(SSL/TLS):
	S3 exposes: HTTP endpoint: non encrypted
				HTTPS endpoint: encryption in flight
	You're free to use the endpoint you want, but HTTPS is recommended by default
	HTTPS is mandatory for SSE-C
	in flight == SSL/TLS
```

S3 Security:
```
User based:
	IAM policies - which API calls shoud be alloewd for a specific user from IAM console
				   an IAM principal can access an S3 object if: the user permissions allow it OR the resource policy allows it
				   												and there's no explicit DENY

Resource Bases:
	Bucket Policies - bucket wide rules from the S3 console - allows cross account
					  JSON based policies: Resources buckets and objects
										   Actions: Set of API to allow or Deny
										   Effect: Allow/Deny
										   Principal"The account or user to apply the policy to
					  Use to: Grant public access to the bucket
					  		  Force objects to be encrypted at upload
							  Grand access to another account (Cross Account)
					  Block Public Access throught: new access control list (ACLs)
					  								any access control lists(ACLs)
													new public bucket or access point policies
													these setting were created to prevent company data leaks

	Objects Access Control List (ACL) - finer grain
	Bucket Access Control List (ACL) - less commom

Networking:
	Supports VPC ENdpoint (for instances in VPC without www internet)
Logging and Audit:
	S3 Access Logs can be stored in other S3 bucket
	API calls can be logged in Aws CloudTrail
User Security:
	MFA Delete: MFA can be required in versioned buckets to delete objects
	Pre-Signed URLs: URLs that are valid only for a 3600 sec limited time
					 Opção usada para quando precisamos visualizar o objeto por um tempo, mas sem deixá-lo público.
					 Can change timeout with --epires-in [time-by-seconds] argument
					 Users given a pre-signed URL inherit the permissions of the person who generate the URL for GET/PUT
					 Examples:
					 	Allow only logged-in users to download a premium video
						Allow temporarily a user to upload a file to a precise location in our bucket


```

S3 Websites:
```
S3 can host static websites and have them accessible on the www
The website URL: <bucket-name>.s3-website.<Aws-Region>.amazonaws.com
				If return 403(Forbidden) error, make sure the bucket policy allows public reads!
				Use Aws Policy Generator
```

S3 CORS:
```
An ORIGIN is a scheme(protocol), host(domain) and port
	https://www.exemple.com (443 for HTTPS and 80 for HTTP)
CORS = Cross-Origin Resource Sharing
Web Browser based mechaninsm to allow requests to other origins while visiting the main origin
	Same origin: http://example.com/app  & http://example.com/app3
	Different origins: http://www.example.com  & http://other.example.com
The requests won't be fulfilled unless the other origin allows for the requests, using CORS Headers
	ex: Access-control-allow-origin

"A origem http://www.ex.com está me direcionando para o seu site, voce permite isso Cross Origin http://www.crossother.com ?
--> Sim, o www.ex.com está permitido via Access-Control-Allow-Origin, com os Access-Control-Allow-Methods: GET,PUT,DELETE"

If a client does a cross-origin request on our s3 bucket, we need to enable the correct CORS headers
**It's a popular exam question**
You can allow for a specific origin or for *(all origins) ON THE CROSS ORIGIN BUCKET, the origin bucket only make a request.
```

S3 Consistency Model:
```
Strong consistency as of December 2020
After a: successful write of a new object (new PUT)
		 or an overwrite or delete of an existing object (overwrite PUT/DELETE)
...any: subsequent read request immediately receives the latest version of the object(read after write consistency)
		subsequent list request immediately reflects changes(list consistency)
Available at no additional cost, without any perfomance impact
```

## AWS SDK, IAM Roles & Policies <a name="SDKRolesPolicies"></a>
EC2 Metadata:
```
Metadata = info about the instance
Userdata = lunch script of the Ec2 instance

In the Ec2:
	curl http://169.254.169.254/latest/meta-data/  # return the meta-data

```

SDK Overview:
```
Perform actions on Aws directly from your applications code
Languages: Java, .NET, PHP, Python(boto3 botocore), Go, Ruby
When calling DynamoDB this use Aws SDK.
Default region: us-east-1
```

## Advanced Amazon S3 & Athena <a name="AdvancedS3Ath"></a>

S3 MFA-Delete:
```
Enable Versioning on the S3, so you will need MFA to:
	Permanently delete an object version
	Suspend versioning on the bucket

You don't need MFA for: enabling versioning, listing deleted versions
Only root account can enbale/disable MFA-Delete by using the CLI.
```

S3 Default Encryption vs Bucket Policies:
One way to "force encryption" is to use a bucket policy and refuse any API call to PUT an S3 object without encryption headers.
```
{
	"Version": "2012-10-17",
	"Id": "PutObjectPolicy",
	"Statement": [
		{
			"Sid": "DenyIncorrectEncryptionHeader",
			"Effecty": "Deny",
			"Principal": "*",
			"Action": "s3:PutObject",
			"Resource": "arn:aws:s3::<bucket>/*",
			"Condition": {
				"Null": {"s3:x-amz-server-side-encryption": true}
			}
		}
	]
}
```

Another way is to use the default encryption in S3.
order: 1 - Default encryp
	   2 - bucket policie

S3 Access Logs:
```
For audit purpose, you may want to log all access to S3 buckets
Any request made to S3, from any account, authorized or denied, will be logged into another S3 bucket.
That data can be analyzes using data analysis tools/Athena.
Warning: do not set your logging bucket to be the monitored bucket
		 It will create a logging loop, and your bucket will grow in size exponentially
```

S3 Replication (CRR & SRR):
```
Must enable versioning in source and destination buckets:
	After activating, only new objects are replicated
	For DELETe operations: can repolciate delete markers from source to target (optional)
						   deletions with a version IS are not replicated (to avoid malicious deletes)
	There ir no "chaining = encademento" of replication: if bucket 1 has replication into bucket 2, which has replication into bucket 3. then objects created in bucket 1 are not replicated to bucket 3.
Cross Region Replication = CRR
Same Region Replication = SRR
Buckets can be in different accounts
Copying is async
Must give proper IAm permissions to S3

Asynchronous: eu-west-1 --> us-east1

CRR - use cases: Compliance
				 lower latency access
				 replication across accounts

SRR - use cases: Log aggregation
				 Live replication between production and test accounts
```

S3 Storage Classes:
```
S3 Standard - General Purpose:
	High durability of objects across multiple AZ
	99,99% Availability over a given year
	Sustain 2 concurrent facility failure
	use Cases: Big Data analytics,
			   Mobile & gaming app
			   content distribution...

S3 Standard-Infrequent Access (IA):
	Suitable for data that is less frequently accessed, but requires rapid access when needed
	99.9% Availability
	Low cost compared to Amazon S3 Standard
	Sustain 2 concurrent facility failures
	Use Cases: as a data store for disaster recovery, backups...

S3 One Zone-IA:
	Data is stored in a single AZ
	99.5% Availability
	Low latency and high throughput performance
	Suports SSL for data at transit and encryption at rest
	Low cost compared to IA (20%)
	Use CAses: Storing secondary backup copies of on-premise data, or storing data you can recreate

S3 Intelligent tiering:
	Same low latency and hight throughout perfomance of S3 standard
	Small monthly monitoring and auto-tiering fee
	Automatically moves objects between two access tiers based on changing access patterns
	Designed for durability of 99.9% over a giver year across multiple AZ
	Resilient against events that impact an entire AZ

Amazon Glacier:
	ENCRYPTION BY DEFAULT
	Not public objects
	Low cost object storage meant for archiving/backup
	Data is retained for the longer term - 10 years
	Alternative to on-premise magnetic tape storage
	Average annual durability is 99.99%
	Cost per storage per month ($0.004 / GB) + retrieval cost
	Each item in Glacier is called "Archive" (+ 40TB)
	Archives are stored in Vaults
	3 retrieval options:
		Expedited - 1 to 5 min
		standard - 3 to 5h
		Bulk - 5 to 12h
		Minimum storage duration = 90 days

	Vault Lock: Adopt a WORM(Write Once Read Many) model
				Lock the policy for future edits (can no longer be changed)
				Helpful for compliance and data retention
				Use S3 Glacier vault to store the sensitive archived data and then use a vault lock policy to enforce compliance controls

Amazon Glacier Deep Archive:
	For long term storage - cheaper:
		Standard - 12h
		Bulk - 48h
		Minimum storage duration = 180 days

Glacier Seletec - tras os dados mais rapido

S3 Reduced Redundancy Storage (deprecated)
Provisioned capacity - melhora a entrega de dados no modo expedited
```

S3 Lifecycle Rules:
```
Transition actions:
	It defines when objects are transitioned to another storage class.
		Ex.: Move obj to Standard IA class 60 days after creation
			 Move to glacier for archiving after 6 months
		INVALID lifecycle Transitions: S3 Intelligent-Tiering => S3 Standard
									   S3 One Zone-IA => S3 Standard-IA
										* => *Standard*

Expiration actions:
	Configure objects to expire(DELETE) after some time.
		Ex.: Access log files can be set to deleter after 365 days
			 Can be used to delete old versions of files (if versioning is enabled)
			 Can be used to delete incomplete multi-part uploads

Rules can be created for:
	A certain prefix (s3://bucket/mp3/*)
	Certain objects tags (Department:Finance)

Scenario 1:
"App on EC2 creates images thumbnails after profile photos are uploaded to S3. These thumbnails can be easily recriated, and only need to be kept for 45 days. the source images should be able to be immediately retrieved for these 45 days, anda afterwards, the user can wait up to 6hours. How would you design this?"
	-- S3 source images can be on Standard, with lifecycle configuration to transition them to GLACIER Standard after 45 days.
	-- S3 thumbnails can be ONEZONE_IA, with a lifecycle configuration to expire them (delete) after 45 days.

scenario 2:
"You should be able to recover your deleted S3 objects immediately for 15 days, although this may happen rarely. After this time, and for up to 365 days, deletec objects should be recoverable within 48h"
	-- Enable S3 verisoning in order to have object versions
	-- You can transition there "noncurrent version" of the object to S3_IA
	-- You can transition afterwards there noncurrent to DEEP_ARCHIVE Bulk.
```

S3 Analytics - Storage Class Analysis
```
You can setup s3 analytics to help determine when to transition objects from Stardard to Standard_IA
does not work for ONEZONE_IA or GLACIER
Report is updated daily
Takes about 24h to 48h to first start
Good first step to put together Lifecycle rules
```

S3 Baseline Performance:
```
S3 automatically scales to high requests rates, latency 100-200ms
Your app can achieve at least 3.500 PUT/COPY/POST/DELETE and 5.500 GET/HEAD request per second per prefix in a bucket.
There are no limits to the number of prefixes in a bucket.
If you spread reads across all four prefixes evenly, you can achieve 22K request per second fot GET and HEAD

S3 - KMS limitation:
	If you use SSe-KMS, you may be impacted by the KMS limits
	When you upload, it calls the GenerateDatakey KMS API
	When you download, it calls the Decrypt KMS API
	Count towards the KMS wuota per second, you can increase using the Service Wuotas Console.

S3 Performance:
	Multi-Part upload:
		recommended for file > 100MB
		must use for files > 5GB
		Can help parallelize uploads (speed up transfer)

	S3 Transfer Acceleration:
		Increase transfer speed by transferring file to an Aws edge location which will forward the data to the S3 bucket in the target region.
		Compatible with multi-art upload

	S3 Byte-Range Fetches:
		Parallelize GETs by requesting specific byte ranges
		Better resilience in case of failures
		Can be used to speed up downloads
		Can be used to retrieve only partial data (ex.: head of file)
```

S3 Select & Glacier Select:
```
retrieve less data using SQL by performing server side filtering
Can be filter by rows & columns *simples Sql statements*
Less network transfer, less CPU cost client-size
```

S3 Select & Redshift Spectrum:
```
Amazon S3 Select is designed to help analyze and process data within an object in Amazon S3 buckets, faster and cheaper. It works by providing the ability to retrieve a subset of data from an object in Amazon S3 using simple SQL expressions

Amazon Redshift Spectrum allows you to directly run SQL queries against exabytes of unstructured data in Amazon S3. No loading or transformation is required.
```

S3 Event Notification:
```
S3:ObjectCreated..
Object name filtering possibile (*.jpg)
Use case: generate thumbnails of images uploaded to S3
Can create as many S3 events as desired
S3 event notif typically deliver events in seconds but can sometimes take a minute or longer
If you want to ensure that an event notification is send every successful write, you can enable versioning on your bucket.
Amazon S3 supports the following destinations where it can publish events:
	Amazon Simple Notification Service (Amazon SNS) topic
	Amazon Simple Queue Service (Amazon SQS) queue
	AWS Lambda
	Currently, the Standard SQS queue is ONLY allowed as an Amazon S3 event notification destination, whereas the FIFO SQS queue is NOT allowed.
```

S3 Requester Pays:
```
In general, bucket owners pay for all S3 storage and data transfer costs associated with their bucket.
Whith requester Pays buckets, the requester pays the cost of the request and the data download from the bucket.
Helpgul when you want to share large datasets with other accounts.
The requester mus be authenticated in Aws (cannot be anonymous)
```

Athena:
```
Serveless service to perform analytics directly against S3 files
Uses SQL language to query the files
Has a JDBS / ODBC driver
Charged per query and amount of data scanned
Supports CSV, JSON, ORC, Avro, and Parquet (built on Presto)
Use cases: BI, analytics, reporting, VPC Flow Logs
		   ELB Logs, CloudTrail trails...

		   ANALYZE DATA DIReCTLY ON S3 ==> USE ATHENA
```

S3 Object Lock:
```
enable versioning
Adopt WORM model
Block an object version deletion for a specified amount of time
Object retention:
	Retention Period: specifies a fixed period
					  Different versions of a single object can have different retention modes and periods
					  When you apply a retention period to an object version explicitly, you specify a Retain Until Date for the object version.
	Legal Hold: same protection, no expiry date

Modes:
	Governance mode: users can't overwrite or delete an object version or alter its lock setting unless they have special permissions

	Compliance mode: a protected object verison can't be overwriteen or deleted by any user, including the root user in your Aws account. When an object is locked in compliance mode, its  retention mode can't be changed, and irs retention period can't be shortned.
```

## CloudFront & Global Accelerator <a name="CloudFrontGlb"></a>

CloudFront == CDN
```
Content Delivery Network = CDN
Improves read performance, content is cached at the edge
216 points of presence globally *edge locations*
DDoS protection, ingration with Shield and WAF
Can expose external HTTPS and can talk to internal HTTPS backends

CloudFront Origins:
	S3 Bucket: For distributing files and caching them at the edge
			   Enhance security with cloudfront OriginAccessIdentity(OAI) + S3 bucket policy
			   Cloudfront can be used as an ingress (to upload files)

	Custom Origin (HTTP):
		ALB: Client --> Request --> SG(ALB Public) --> Allow SG of ALB --> SG(EC2 private)
		EC2: Client --> Req --> Edge locations --> Allow public IP of edge locations --> SG(ec2 public)
		S3 website (enable bucket as a static s3 website)
		Any HTTP backend you want

CloudFront Multiple Origin:
	To route to different kind of origins based on the content type
	Based on path pattern: /images/* --> S3 Bucket
						   /api/* --> ALB

CloudFront Origin Groups:
	To increase HA and do failover
	Origin group: one primary and onde secondary origin
				  If th eprimary origin fails, the second one is used


CloudFront Geo Registriction:
	Restric who can access your distribution:
		Whitelist
		Blacklist
	The country is determined using Geo-IP database
	Use case: Coyright Laws to control access to content

Cloudfront vs S3 CRR:
	CloudFront: Global Edge Network
				Files are cached fot a TTL (maybe a day)
				Great for static content that must be available everywhere
	S3 CRR: Must be setup for each region you want replication to happen
			Files are update in near real-time
			Read only
			Freat for dynamic content that needs to be available at low-latency in few regions

Cloudfront Signed URL / Signed Cookies
	When you want to distribute paid shared content to premium users over the world.
	Attach a policy with:
		Includes URL expiration
		Includes IP ranges to access the data from
		trusted signers (which Aws accounts can create signed URL)
	How long should be URL be valid for?
		Shared content: make ir short (movie, music)
		Private content: for years (private to the user)

	Signed URL = access to individual files (one signed URL per file)
				 You want to use an RTMP distribution. Signed cookies aren’t supported for RTMP distributions.
				 You want to restrict access to individual files, for example, an installation download for your application.
				 Your users are using a client (for example, a custom HTTP client) that doesn’t support cookies.

	Signed Cookies = access to multiple files (one signed coolie for many files)
					 You want to provide access to multiple restricted files, for example, all of the files for a video in HLS format or all of the files in the subscribers’ area of a website.
					 You don’t want to change your current URLs.

CloudFront Signed URL vs S3 Pre-Signed URL:
	Cloudfront: Allow access to a path, no matter the origin
				Account wide key-pair, only the root can manage it
				Can filter by IP, path, date, expiration
				Can leverage caching features

	S3 Pre-Signed: Issue a request as the person who pre-signed the URL
				   Uses the IAM key of the signing IAM principal
				   Limited lifetime

CloudFront Field Level Encryption: == PII
	Protect user sensitive information throught app stack
	Adds an additional layer of security along with HTTPS
	Sensitive information encrypted at the edge close to user
	Usage: Specify set of fields in POST requests(up to 10) and sprecify te public key to encrypt them
		   A government agency is using CloudFront for a web application that receives personally identifiable information (PII) from citizens.

Cloudfront Pricing:
	The cost of data out per edge location varies
	Price Classes:
		1. Price Class All: all regions -- best performance
		2. Price Class 200: most regions, but excludes the most expensive regions
		3. Price Class 100: only the least expensive regions

CloudFront Multi-tier cache:
	Regional edge caches that improve latency.

	Bypass: Dynamic content, as determined at request time (cache-behavior configured to forward all headers)
			Proxy methods PUT/POST/PATCH/OPTIONS/DELETE go directly to the origin

The Cache-Control and Expires headers control how long objects stay in the cache.
The Cache-Control max-age directive lets you specify how long (in seconds) you want an object to remain in the cache before CloudFront gets the object again from the origin server.
The minimum expiration time CloudFront supports is 0 seconds for web distributions and 3600 seconds for RTMP distributions.
```

Aws Global Accelerator:
```
Application with global users who want to access it directly.
We wish to go as fast as possible through Aws network to minimize network
AWS Global Accelerator is a service that improves the availability and performance of applications with local or global users.
You can configure the ALB as a target and Global Accelerator will automatically route users to the closest point of presence.

UnicastIP: one server holds one IP address
AnycastIP: All server hold the same IP address and the client is routed to the nearest one.

Global Accelerator: leverage aws internal net to route to your app
					2 Anycast IP are created for your app
					The anycast send traffic directly to Edge Locations
					The Edge locations send the traffic to your app
					Work with: elastic IP, instances, ALB, NLB, public or private
					Consistent Performance: Intelligent routing to lowest latency and fast regional failover
											No issue with client cache (because the IP don't change)
											Internal Aws network
					Health Checks: helps make your app global, great for sisaster recovery
					Security: only 2 external IP need to be whitelisted
							  DDoS protection thanks to Aws Shield

The engineering team at the company needs to allow the IP addresses of the ALBs in the on-premises firewall to enable connectivity == Global accelerator

Global Accelerator vs CloudFront:
	They both use Aws global network and its edge locations around the world
	Both sevices integrate with Aws Shield for DDoS protection

	Cloudfront: Improves performance for both cacheable content (images and videos)
				Dynamic content (API acceleation an d dynamic site delivery)
				Content is served at the edge

	Global Accelerator: Improves performance for a wide range of app over TCP or UDP
						Proxying packets at the edge to app running in one or more Aws regions
						Good fit for non-HTTP use cases, such as gaming(UDP), IoT (MQTT), or VoiceIP(voip)
						Good for HTTP use cases that require static IP or deterministic, fast regional failover.
```

Aws Trusted Advisor:
```
Is an online tool that provides you real-time guidance to help you provision your resources following AWS best practices.
AWS Trusted Advisor offers a Service Limits check (in the Performance category) that displays your usage and limits for some aspects of some services.
It inspects your AWS environment and makes recommendations for saving money, improving system performance and reliability, or closing security gaps.
```


## Aws Storage Extras <a name="AdvancedStorage"></a>
Aws Snow Family:
```
Highly-secure, portable devices to collect and process data at the edge, and migrate data into and out of AWS
Offer offiline devices to perform data migrations
If takes more than a week to transfer over the network, use Snowball devices!

Data migration:
	Aws Services: Snowcone: it's a small box
							Small, portable computing anywhere, rugged & secure, withstands harsh environments(desert, rain)
							Light (4.5 pounds, 2.1 kg)
							Device used for edge computing, store and data transfer
							8 TB of usable storage
							Use Snowcone where snowball does not fit
							Must provide your own battery / cables
							Can be sent back to Aws offline, or connect ir to internet and use Aws DataSync to send data

				  Snowball edge: its a huge box
				  				 Physical data transport solution: move TB or PBs of data in or out of Aws
								 Alternative to moving data over the network
								 Pay per data transfer job
								 80 TB usable store
								 Provide block storage and S3-compatible object storage
								 Snowball Edge Storage Optimized: 80Tb of HGG capcaity for block volume and s3 storage
								 Snowball Edge Compute Optimized: 42Tb of HGG capcaity for block volume and s3 storage
								 Use cases: large data cloud migrations, DC decommission, disaster recovery

				  Snowmobile: it's a TRUCK (caminhão)
				  			  Transfer exabytes of data (1 EB = 1000 PB = 10000000 TBs)
							  High security: temparature controlled, GPS, 24/7 video surveillance
							  Better than snowball if your transfer more than 10PB

	Challenges: Limited connectivity/bandwidth
				High network cost
				Shared bandwith
				Connection stability

Usage process:
	1. Request Snowball devices from the Aws console for delivery
	2. Install the snowball client / AWs OpsHub on your servers
	3. Connect the snowball to your servers an copy files using the client
	4. Ship back the device when you're done
	5. Data will be loaded into an S3 bucket
	6. Snowball is completely wiped


Edge computing:
	What is Edge computing?
		Process data while it's being create on an edge location.
			can be: a truck on the road, shipt on the sea...
		These locations may have:
			limited / no internet access
			limited / no easy access to computing power
		we setup a snowball Edge / Snowcone device to do edge computing
		Use cases: Preprocess data
				   Machine learning at the edge
				   Transcoding media streams
		Eventually we can ship back the device to Aws (for transferring data for example)

	Snowcone (smaller):
		2 CPUs, 4GB of memory, wired or wireless access
		USB-C power using a cord or the optional battery

	Snowball Edge - Compute optimized:
		52 vCPUs, 208 GiB of RAM
		Optional GPU (useful for video processing or machine learning)
		42 TB usable storage

	Snowball Edge - Storage optimized:
		Up to 40 vCPUs, 80 Gib RAM
		Objects storage clustering available

	All: can run EC2 & Lambda functions (using aws IoT Greengrass)
	Long-term deployment options: 1 and 3 years discounted pricing

Aws OpsHub:
	To use Snow Familly devices, you need a CLI
	you can use Aws OpsHub (software to install) to manage Snow family device:
		Unlicking and configuring single or clusted devices
		Transferring files
		Launching and managing isntances
		monitor devices metrics (storage, active instances)
		Launch compatible Aws services on your devices (DataSync, NFS, EC2)

```

Aws CodeDeploy:
```
O AWS CodeDeploy é um serviço totalmente gerenciado de implantação que automatiza implantações de software em diversos serviços de computação como Amazon EC2, AWS Fargate, AWS Lambda e servidores locais. O AWS CodeDeploy facilita o lançamento rápido de novos recursos, ajuda a evitar tempo de inatividade durante a implantação de aplicativos e lida com a complexidade de atualizá-los. Você pode usar o AWS CodeDeploy para automatizar implantações de software e eliminar a necessidade de operações manuais propensas a erros. O serviço é dimensionado para estar de acordo com as suas necessidades de implantação.
```

Aws DataSync:
```
can be used to move large amounts of data online between on-premises storage and Amazon S3 or Amazon Elastic File System (Amazon EFS).
DataSync eliminates or automatically handles many of these tasks, including scripting copy jobs, scheduling and monitoring transfers, validating data, and optimizing network utilization.
The source datastore can be Server Message Block (SMB) file servers.
AWS DataSync is better for workloads that require you to move or migrate your data. On-premises data would not be utilized anymore.

```

Snowball into glacier:
```
Snowball cannot import to Glacier directly
Must use S3 first, in combination with an S3 lifecycle policy.
```

Aws Storage Gateway:
```
Problem: Hybrid Cloud for storage, S3 is proprietary technology (unlike NFS / EFS), so how do you expose the S3 data on-premises?

Solution: Aws Storage Gateway
	Bridge between on-premises data and cloud data in S3
	Use cases: disaster recovery, backup & restore, tiered storage
	3 types: **important to know the diff**
		File Gateway: Configured S3 buckets are accessible using NFS and SMB protocol
					  Supports S3 standard, S3 IA, S3 One Zone IA
					  Bucket access using IAm roles for each File Gateway
					  Most recently used data is cached in the file gateway
					  Can be mounted on many servers
					  Integrated with AD for user authentication

		Volume Gateway: Block storage using iSCSI protocol backed by S3
						Backed by EBS snapshots which can help restore on-premises volumes!
						Cached volumes: low latency access to most recent data.
										By using Cached volumes, you store your data in Amazon Simple Storage Service (Amazon S3) and retain a copy of frequently accessed data subsets locally in your on-premises network. Cached volumes offer substantial cost savings on primary storage and minimize the need to scale your storage on-premises. You also retain low-latency access to your frequently accessed data.
						Stored Volumes: entire dataset is on premise, scheduled backups to S3

		Tape Gateway: Some companies have backup process using physical tapes
					  With Tape Gateway, companies use the same process but, in the Cloud
					  Virtual Tape Library (VTL) backed by S3 and Glacier
					  Back up data using existing tape-based processes (and iSCSI interface)
					  Works with leading backup software vendors

	Storage Gateway - Hardware appliance:
		Using Storage Gateway means you nedd on-premises virtualization
		Otherwise, you can use a Storage Gateway Hardware Appliance
		You can buy it on amazon.com
		Works with File, Volume and tape Gateway
		Has the required CPU, memory, network, sSD cache resources
		Helpful for daily NFS backups in small data centers

Tips for exam:
	On-premises data to the cloud == Storage Gateway

	File access/NFS - user auth with AD == File Gateway (backed by s3)

	Volumes/ Block Storage / iSCSI == Volume gateway (backed by s3 with EBS snapshot)

	VTL Tape Solution / Backup with iSCSI == Tape Gateway (s3 and glacier)

	No on-premises virtualization == Hardware applicance
```

Amazon Workspaces:
```
O Amazon Workspaces é um serviço de virtualização de desktop totalmente gerenciado para Windows e Linux que habilita o acesso a recursos a partir de qualquer dispositivo compatível.

```

Amazon FSx for Windows (FIle Server):
```
Problem: EFS is a shared POSIX ssystem for linux system
Resolution: FSx for Windows
	Is a fully managed Windows file system shared drive
	Supports SMB protocol & NTFS
	Microsoft AD integration, ACLs, user quotas
	Built on SSD, scale up to 10s of GB, millions os IOPS, 100s PB of data
	Can be accessed from your on-premise infrastructure
	Can be configured to be Multi-AZ (HA)
	Data is backed-up daily to S3
```

Amazon FSx for Lustre:
```
Lustre is a type of parallel distributed file system, for large-scale computing
the name Lustre is derived from "Linux" and "cluster"
use cases: Machine learning, High Performance Computing(HPC)
		   Video Processing, Financial Modeling, Eletronic Design Automation(EDA)
Scales up to 100s GBs, millions of IOPS, sub-ms latencies
Seamless integration with S3: Can read S3 as a file system (through FSx)
							  Can write the output of the computations back to S3
Can be used from on-premises servers

FSx File System Deployment Options:
Scratch File System: temporary storage
					 Data is not replicated (doesn't persist if file server fails)
					 High burst (6x faster, 200mbp per Tib)
					 usade: short-term processing, optimize costs

Persistent File System: Long-term storage
						Data is replicated within same AZ
						Replace failed files within minutes
						Usage: long-term processing, store sensitive data

```

Aws Transfer Family:
```
a fully-managed service for file transfers into and out of Amazon S3 or EFS using the FTP protocol
Supported Protocols:
	Aws Transfer for FTP (within VPC)
	Aws Transfer for FTPS (File Transfer Protocol over SSL(FTPS))
	Aws Transfer for STPS (Secure File Transfer Protocol(SFTP))
Managed infrastructure, Scalable, reliable, Highly Available (multi-AZ)
Pay per provisioned endpoint per hour + data transfers in GB
store and manage users credentials within the service
Integrate with existing auth systems (Microsoft AD, LDAP, Okta, Amazon Cognito, custom)
Usage: sharing files, public datasets, CRM, ERP...
```

Resume:
```
S3: Object store
Glacier: Object Archival
EFS: Network File System for Linux intances, POSIX
FSx for Windows: NFS for Windows Server
FSx for Lustre: High Performance Computing Linux file system
EBS volume: Network storage for one Ec2 instance at a time
Instance Storage: Physical store for your EC2, 135,000 IOPS
Storage Gateway: File gateway, Volume Gateway(cache & stored), Tape Gateway
Snowball / Snowmobile: to move large amount of data to the cloud, physically
Database: for specific workloads, usually with indexing and querying
```

AWS Managed Microsoft AD:
```
 AWS Directory Service lets you run Microsoft Active Directory (AD) as a managed service.
```

## Decloupling Applications: SQS, SNS, Kinesis, Active MQ <a name="DeclouplingApplications"></a>

Mutiple applications need to communicate with one another, there are two patterns of this:
1 - Synchronous communications: app to app
		Can be problematic if there are sudden spikes of traffic
		In that case, it's better to decouple your app:
			using SQS: queue model
			using SNS: pub/sub model
			using Kinesis: ream-time streaming model
		these services can scale independently from our app!

2 - Asynchronous communications / Event based: app to queue to app

Amazon SQS:
```
What's a queue(fila)? ==> é um serviço de entrega descentralizada de msg, onde existe um/varios produtores de msg -- envia a msg -- sqs recebe --> entrega para o/os consumidores --> retira a msg da fila Sqs.

Standard Queue:
	Oldest offering - 10 years
	Fully managed service, **used to decouple applications**
	Attributes:
		Unlimited throughut, unlimited number of messages in queue
		Default retention of message: 4 days - 14 days, after that, will be lost.
		Low latency (<10ms on publish and receive)
		Limitation of 256kb per message sent
	Can have duplicated messages (at least once delivery, occasionally)
	Can have out of order messages (best effort ordering)
	SQS scales automcatically

Producing Messages:
	Message up to 256kb, produced to SQS using the SDK( SendMessage API)
	the message is persisted in SQS until a consumer deletes it
	Message retentionL min 4 days, up to 14 days

	Example: send an order to be processed
		Order id
		Customer id
		Any attributes you want

	SQS standard: unlimited throughput

Consuming Messages:
	Consumers (running on Ec2, servers, lambda...)
	Pool SQS for messages (receive up to 10 messages at a time) Tem mensagem aí pra mim?
	Process the messages (ex.: insert the msg into an RDS DB)
	Delete the message using the DeleteMessag API
	The visibility timeout is the amount of time a message is invisible in the queue after a reader picks up the message. If a job is processed within the visibility timeout the message will be deleted. If a job is not processed within the visibility timeout the message will become visible again (could be delivered twice). The maximum visibility timeout for an Amazon SQS message is 12 hours.

Multiple Ec2 consumers:
	Consumers receive and process msg in parallel
	At least once delivery
	Best-effort message ordering
	Consumers delete messages after processing them
	We can scale consumers horizontally to improve throughput of processing

SQS with ASG:
	Sqs will send a poll for msg into an ASG
	Them Cloudwatch Metric - Queue length (ApproximateNumberOfMessages) will Alarm for breach at CloudWatch Alarm
	It will scale directly to ASG
	The ApproximateAgeOfOldestMessage metric is useful when applications have time-sensitive messages and you need to ensure that messages are processed within a specific time period. (SLA)

SQS to decouple between app tiers:
	Requests --> ASG with Front --> send msg --> SQS Queue  --> receive msg --> ASG witth backend --> insert in S3

SQS security:
	Encryption: in-flight enccryption using https api
				At rest enc using kms keys
				client-side enc if the client wants to perform enc/decryp itself

	Access Controls: IAM policies to regulate access to the SQS API

	SQS Access Policies: useful for cross-account access to SQS queues
						 useful for allowing other services (SNS,S3...) to write to an SQS queue

SQS Message Visibility Timeout:
	After a message is polled by a consumer, it becomes invisible to other consumers
	By default is 30s to be processed. After that, the msg is received.
	If a message is not processed within the visibility timeout, it will be processed twice
	Solution == consumer call ChangeMessageVisibility API to get more time. Cautin with the time set, don't has to be too high(hours) or too low(sec)

SQS Dead Letter Queue - DLQ (filas mortas):
	Scenario: a consumer fails to process a msg within the Visibility Timeout.. the msg goes back to the queue.
	We can set a threshold of how many timmes a msg can go back to the queue
	After the MaximumReceives threshold is exceeded, the mmsg goes into a dead letter queue(DLQ)
	Useful for debuggig!
	Make sure to process the msg in the DLQ before 14 days expire

SQS Request-Response Systems:
	Architecture for a backend HA/decoupled
	Requesters --> Send request --> Request Queue --> ASG Responders
	<-- Send response to Response Queue --> Send response to Requesters
	To implement this pattern: use the [Sqs Temporaty Queue Client](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-temporary-queues.html)
	It leverages virtual queues intead of creating/deleting SQS queues (cost-effective)

SQS Delay Queues - Fila de espera:
	Delay a msg (consumers don't see it immediately) up to 15 min
	Default is 0 sec
	Can set a default at queue level
	Can override the default on send using the DelaySeconds parameter

SQS FIFO Queue - primeiro a entrar, primeiro a sair:
	FIFO = Fisrt in First Out (ordering of msg in the queue)
	Limited throughtout: 300msg/sec without batching or 3000msg/s with batching(lote).
	Exactly-once send capability (by removing duplicates)
	Messages are processed in order by the consumer
	Has to end with .fifo
	NO DUPLICATED MESSAGE

Amazon SQS temporary queues:
	Temporary queues help you save development time and deployment costs when using common message patterns such as request-response. You can use the Temporary Queue Client to create high-throughput, cost-effective, application-managed temporary queues.

The ReceiveMessageWaitTimeSeconds is the queue attribute that determines whether you are using Short or Long polling. By default, its value is zero which means it is using Short polling. If it is set to a value greater than zero, then it is Long polling.

SQS Standard to SQS FIFO MIGRATION:
	Delete the existing standard queue and recreate it as a FIFO queue
	Make sure that the name of the FIFO queue ends with the .fifo suffix
	Make sure that the throughput for the target FIFO queue does not exceed 3,000 messages per second

SQS Long Polling:

	– Long polling helps reduce your cost of using Amazon SQS by reducing the number of empty responses when there are no messages 	available to return in reply to a ReceiveMessage request sent to an Amazon SQS queue and eliminating false empty responses when messages are available in the queue but aren’t included in the response.

	– Long polling reduces the number of empty responses by allowing Amazon SQS to wait until a message is available in the queue before sending a response. Unless the connection times out, the response to the ReceiveMessage request contains at least one of the available messages, up to the maximum number of messages specified in the ReceiveMessage action.

	– Long polling eliminates false empty responses by querying all (rather than a limited number) of the servers. Long polling returns messages as soon any message becomes available.
```

Amazon SNS:
```
What if you want to send one message/email to many receivers?
Pub / Sub pattern:
	Buying Service --> SNS Topic -- Event receivers (email notif, fraud service, shipping serv, sqs queue)

The "event producer" only sends message to one SNS topic
As many event receivers (subscriptions) as we want to listen to the SNS topic notifications
Each subscriber to the topic will get all the messages
Up to 10Millions subscriptions per topic
Subscribers can be: SQS
					HTTP/HTTPS
					Lambda
					email-JSON
					SMS
					Mobile Not

SNS integrates with a lot of AWS Services:
	Many Aws services can send data directly to SNS for notifications
	CloudWatch (for alarms)
	ASG notifications
	S3 on bucket events
	CloudFormation (upon state changes ==> failed to build, etc)

How to publish:
	Topic Publish (using the SDK):
		Create a topic // a subscription // publish to the topic
	Direct Publish (for mobile apps SDK):
		Create a plataform app // a plataform endpoint // publish to the platform endpoint // works with Google GCM, Amazon ADM...

Sns Security:
	Encryption: in-flight enccryption using https api
				At rest enc using kms keys
				client-side enc if the client wants to perform enc/decryp itself

	Access Controls: IAM policies to regulate access to the SNS API

	SNS Access Policies: useful for cross-account access to SNS topic
						 useful for allowing other services (SQS,S3...) to write to an SNS topic

SNS FIFO Topic:
	Similar features as SQS FIFO: Orderind by Message Group ID
								  Deduplication using a Deduplication ID or Content Based Deduplication
	Can oly have SQS FIFO queues as subscribers
	Limited throughput
	In case you need Fan Out + Ordering + deduplication

SNS - Message Filtering:
	JSON policy used to filter messages sent to SNS topic's subscriptions
	If a subscription doesn't have a filter policy, it receives every message
```

SNS + SQS: Fan Out:
```
Push once in SNS, receive in all SQS queues that are subscribers
Fully decoupled, no data loss
SQS allows for: data persistence
				delayed processing and retries of work
Ability to add more SQS subscribers over time
Make sure your SQS queue access policy allows for SNS to write

S3 events to multiple queues:
	For the same combiantion of: event type and prefix you can only have one S3 event rule.
	If you want to send the same S3 event to many SQS, use Fan Out model.
```

Kinesis:
```
Makes it easy to collect, process, and analyze sreaming data in real-time
Ingest real-time data such as: App logs, Metrics, Website clickstreams, IoT telemetry...
Types:
	Kinesis Data Streams: capture, process and store data streams
		Producers(App, Client, SDK, KPL, Kinesis Agent) --> Send Record (partition key + DAta Blob (up to 1MB)) 1MB/sec or 1K msg/sec per shard
		--> Kinesis Data Steams scale the shards(blocos) --> send to Consumers(Apps, Lambda, Kinesis Data Firehose, Kinesis Data Analytics) 2MB/sec per shard
		Billing is per shard provisioned, can have as many shards as you want
		Retention between 1 day to 365 days
		Ability to reprocess(replay) data
		Once data is inserted in Kinesis, it can't be deleted (immutability)
		DAta that shares the same partition goes to the same shard (ordering)
		Producers: Aws SDK, Kinesis Producer Library (KPL), Kinesis Agent
		Consumers:
			Write your own: KCL, Aws SDK
			Managed: Lambda, Kinesis DAta Firehose, Kinesis Data Analytics
			Store results in: redshift, S3
		Multiple-consumers == ENHANCED FANOUT:
			You should use enhanced fan-out if you have multiple consumers retrieving data from a stream in parallel.
			With enhanced fan-out developers can register stream consumers to use enhanced fan-out and receive their own 2MB/second pipe of read throughput per shard, and this throughput automatically scales with the number of shards in a stream.

	Kinesis Data Firehose: load data streams into Aws data stores
		Producers --> Record up to 1 MB --> Kinesis Data Firehose --> Data transformation <-->Batch writes --> Aws Destinations: S3, Redshift(copy through S3), Elastisearch
		Fully managed service, no administration, automatic scaling, serverless
			Aws: Redshift / S3 / ElastiSearch
			3rd party partner: Splunk / MongoDB/ DataDog / NewRelic
			Custom: send to any HTTP endpoint
		Pay for data going through  firehose
		Near Real Time:
			60 sec latency minimum for non full batches
			Or minimum 32MB of data at a time
		Supports many data formats, conversions, transformations using Lambda
		Can send failed or all data to a backup S3 bucket

	Kinesis Data Analytics (SQL App): analyze data streams with SQL or Apache Flink
		Sources (Kinesis Data Streams / Firehose) --> Data Analytics --> Sinks
		Perform real-time analytics on Kinesis Stream using SQL
		Fully managed, no servers to provision
		Automatic scaling
		Real-time analytics
		Pay for actual consumption rate
		Can create streams out of the real-time queries
		Use cases: Time-series analytics
				   Real-time dashboards
				   Ream-time metrics

	Kinesis Video Streams: capture, process, and store video streams


Data Streams vs Firehose:
	Data Streams: Streaming service for ingest at scale
					  Write custom code (producer / consumer)
					  Real-time (˜200ms)
					  Managed scaling (shard splitting/ merging)
					  Data storage for 1 to 365 days
					  Supports replay capability

	Data Firehose: Load sreaming data into S3/ Redshift..
					   Fully Managed
					   Near real-time
					   Automatic scaling
					   No data storage
					   Doesn't support replay capability

Ordering data into Kinesis:
	If you have 5 trucks on the road sending their GPS positions refularly into Aws
	You want to consume the data in order for each truck, so that you can track their movement accurately.
	how should you send that data into Kinesis?
		==> Send using a "Partition key" value of the "truck_id"
			The same key will always go to the same shard

Ordering data into SQS:
	For SQS standard, there is no ordering.
	For SQS FIFO:
		if you don't use a Group ID, msg are consumed in the order they are sent, with only ONE consumer.
		You want to scale the number of consumers, but you want msg to be grouped when they are related to each other == Use a Group ID (similar to Partition key in Kinesis)

Kinesis vs SQS ordering:
	Case: 100 trucks, 5 kinesis shards, 1 SQS FIFO
	Kinesis Data Streams: On average you'll have 20 trucks per shard
						  Trucks will have their data ordered within each shard
						  The max amount of consumer in parallel we can have is 5
						  Can receive up to 5MB of data - good
	SQS FIFO: Only one SQS FIFO queue
		      100 group Id
			  up to 100 COnsumers (due to the 100 group id) - each consumer in one group id
			  up to 300msg/sec (3K if using batching)


ProvisionedThroughputExceededException == batch messages
```

SQS vs SNS vs Kinesis:
```
SQS: Consumer "pull data"
	 Data is deleted after being consumed
	 Can have as many workers (consumers) as we want
	 No need to provision throughtput
	 Ordering guarentees only on FIFO queues
	 Individual msg delay capability

SNS: Push data to many subscribers
	 Up to 12.500K subscribers
	 Data is not persisted (lost if no delivered)
	 PUB/Sub
	 Up to 100K topics
	 No need to provision throughput
	 Integrates with SQS for fan-out architecture pattern
	 FIFO capability for SQS FIFO

Kinesis: Standard: pull data with 2MB per shard
		 Enhance-fan out: oush data 2MB per shard per consumer
		 Possibility to replay data
		 Meant for real-time big data, analytics and ETL
		 Ordering at the shard level
		 Data expires after X days
		 Must provision throughput
```

Amazon MQ:
```
SQS, SNS are Cloud-native services
Traditional app running from on-premises may use Open protocols such as: MQTT, AMQP, STOMP, Openwire, WSS

When migration to the cloud, intead of re-engineering the application to use SQS/SNS, we can use Amazon MQ
MQ = Managed Apache ActiveMQ
	MQ doen't scale as much as SQS/SNS
	MQ runs on dedicated machine, can run in HA with failover
	MQ has both queue feaure (SQS) and topic features (SNS)

MQ - HA: 2 AZ with an EFS
```

Amazon Simple Workflow Service (SWF):
```
is a web service that makes it easy to coordinate work across distributed application components.
SWF enables applications for a range of use cases, including media processing, web application back-ends, business process workflows, and analytics pipelines, to be designed as a coordination of tasks.
```


## Container on Aws: EC2, Fargate, ECR & EKS <a name="Containers"></a>

Docker:
```
Docker is a software dev platform to deploy apps
Apps are packaged in containers that can be run on any OS
Apps run the same, regardless of where they're run:
	Any machine
	no compatibility issues
	Predictable behavior
	Less work
Images are stored in Docker REpositories
	Public: dockerhub
	Private: Amazon ECR
	Public: Amazon ECR Public

Docker vs VM:
	Resources are shared with the host OS ==> many containers on one server

Docker structure:
	Dockerfile -- Build --> Build Img -- run --> Docker container

docker Containers Management:
	3 choices:
		ECS: Amazon's own container platform
		Fargate: Amazon's own Serveless container platform
		EKS: Amazon's managed Kubernetes (open source)
```

ECS
```
Elastic Container Service
Launch docker container on Aws
You must provision & maintain the infra (the Ec2 instances)
Aws takes care of starting / stopping containers
Has integrations with the ALB

EC2 launch type for ECS:
	ASG with containers that contain ECS Agent and ECS Tasks

IAM Roles for ECS Tasks:
	EC2 instance profile:
		Used by the ECS agent
		Makes APi calls to ECS service
		Send containers logs to CloudWatch
		Pull Docker image from ECR
		Reference sensitive data in Secrets Manager os SSM Parameter Store

	ECS Task Role:
		Allow each task to have a specific role
		Use different roles for the diff ECS Services you run
		Task Roles is defined in the task definition

Amazon ECS enables you to inject sensitive data into your containers by storing your sensitive data in either AWS Secrets Manager secrets or AWS Systems Manager Parameter Store parameters and then referencing them in your container definition. This feature is supported by tasks using both the EC2 and Fargate launch types.

ECS Data Volumes - EFS File Systems:
	EC2 + EFS NFS
	Fargate Tasks + EFS NFS = serverless + data storage without managing servers == Case: persistent multi-AZ shared storage for containers
	Ability to mount EFS vol onto tasks
	Tasks launched in any AZ will be able to share the same data in the EFS volume

ECS Services & Tasks:
	ECS Cluster (ECS container instance) --> Service A --> send taks  --> ALB

Load Balancing for EC2 Launch Type:
	We get a dynamic port mapping
	The ALB supports finding the right port on your Ec2

ECS tasks invoked by Event Bridge:
	Automated way to run ECS Task

ECS Scaling
	Service CPU Usage:  Configure the Task into an ASG
						Configure Cloudwatch Metric that will call a Trigger -->
						CloudWatch Alarm --> Scales to ASG
						If the're not ASG -- call Scale ECS Capacity Providers

ECS Rolling updates:
	When updating from v1 to v2, we can control how many tasks can be started and stopped, and in which order
	You define the Minimum healthy percent and the maximum
```

Fargate
```
Launch Docker containers on Aws
You do not provision the infra (no EC2 instances to manage) - simplier!
Serverless offering
Aws just runs containers for you based on the CPU/RAM you need


Load Balancing for Fargate:
	Each task has a unique IP in ENI(Elastic Network Interface)
	You must allow on the ENI SG the task port from the ALB SG

```

ECR - Elastic Container Registry:
```
Store, manage and deploy containers on Aws, pay for what you use
Fully integrated with ECS & IAM for securiity, backed by Amazon S3
Supports image vulnerability scanning, version tag, image lifecycle
```

EKS - Elastic Kubernetes Service:
```
It is a way to launch a managed K8S clusters on Aws
K8S is an open-souce system for automatic deployment, scaling and management of containerized (Docker) application
It's an alternative to ECS, similar goal but different APi
EKS supports EC2 if you want to deploy worker nodes or Fargate to deploy serverless containers
Use case: if your company is already using K8S on-premises or in another cloud, and wants to migrate to Aws using K8S.
		  K8S is cloud-afnostic(can be any cloud...)

To expose one EKS = ELB
```

Enhanced networking:
```
provides higher bandwidth, higher packet-per-second (PPS) performance, and consistently lower inter-instance latencies.
If your packets-per-second rate appears to have reached its ceiling, you should consider moving to enhanced networking because you have likely reached the upper thresholds of the VIF driver.
It is only available for certain instance types and only supported in VPC.
You must also launch an HVM AMI with the appropriate drivers.

AWS currently supports enhanced networking capabilities using SR-IOV. SR-IOV provides direct access to network adapters, provides higher performance (packets-per-second) and lower latency.
```

## Serverless <a name="Serverless"></a>

What's serverless:
```
Serverless is a new paradigm in which the developers don't have to manage servers anymore.
They just deploy code/functions.
Initially Serverless == FaaS (Function as a Service)
Serverless was pioneered by Aws Lambda. Does not mean there are no servers...you just don't manage /provision/ see them.

Serverless in Aws: Lambda, DynamoDB
				   Aws Cognito, API Gateway
				   S3, SNS & SQS
				   Kinesis Data Firehose, Aurora Serverless
				   Step functions, Fargate
```

Aws Lambda
```
Virtual functions - no servers to manage!
Limited by time - short executions
run on-demand
Scaling is automated!
Supports resource-based permissions policies for Lambda functions and layers.
Resource-based policies let you grant usage permission to other AWS accounts on a per-resource basis. You also use a resource-based policy to allow an AWS service to invoke your function on your behalf.

Benefits:
	Pricing: Pay per request and compute time
			 Free tier of 1 mi requests and 400K GBs of compute time
			 $0.20 per 1 million req thereafter
	Integrated with the whole Aws suit of services
	Easy to minitoring throught Aws CloudWatch
	Increasing RAM will also improve CPU and network!

Languague support: Nodejs
			       Python
				   Java (8)
				   C#
				   Golang
				   Ruby
Lambda container image: implement the lambda runtime API --> ECS/Fargate is preferred for running Docker img

Limits - per region:
	Execution:
		Memory allocation: 128MB - 10GB (1 mb increments)
		Max exec time: 900 sec = 15 min
		Environment variables (4KB)
		Disk capacity in the "function container" (in /tmp): 512MB
		Concurrency exec: 1000 (can be increased)

	Deployment:
		Deployment Size: 50MB
		Uncompressed deployment: 250MB
		Can use the /tmp to load oher files at startup
		Size of environment variables: 4 kb

Lambda Edge:
	You have deployed a CDN using CloudFront
	What if you wanted to run a global Aws Lambda alongside?
	You can use Lambda@Edge - Build more responsive app, don't manage servers, lambda is deployed globally, Customize the CSN content, pay only for what you use.
	Do what?
		Change CloudFront requests and responses:
			After Cloudfront receives a req from a viewer (viewer req)
			Before CloudFront forwards the request to the origin (origin request)
			Origin response / Viewer response
			You can also generate responses to viewers without ever sending the request to the origin
	Use cases: Website Security and Privacity
			   Dynamic Web App at the Edge
			   Search Engine Optimization (SEO)
			   Intelligently Route Across Origins and Data Centers
			   Bot mitigation at the Edge
			   Real-time Img Transf
			   A/B Testing
			   User Auth and Authorization
			   User Priotization / Tracking and Analytics

Lambda as backbone:
	By default, Lambda functions always operate from an AWS-owned VPC and hence have access to any public internet address or public AWS APIs. Once a Lambda function is VPC-enabled, it will need a route through a NAT gateway in a public subnet to access public resources
	Since Lambda functions can scale extremely quickly, its a good idea to deploy a CloudWatch Alarm that notifies your team when function metrics such as ConcurrentExecutions or Invocations exceeds the expected thresholdSince Lambda functions can scale extremely quickly, its a good idea to deploy a CloudWatch Alarm that notifies your team when function metrics such as ConcurrentExecutions or Invocations exceeds the expected threshold
	If you intend to reuse code in more than one Lambda function, you should consider creating a Lambda Layer for the reusable code
```

DynamoDB:
```
Fully managed, HA with replication across multiple AZ
NoSQL DB - not a relational database
Scales to massive workloads, distributed DB
Millions of requests per sec, trillions of row, 100s of TG of storage
Fast and consistent in performance (low latency on retrieval)
Integrated with IAM for security, auth and adm
Enables event driven programming with DynamoDB Streams
Low cost and auto-scaling capabilities

Basics:
	made of tables
	each table has a primary key
	each table can have an infinite number of items (=rows)
	each iteam gas attributes
	handle frequent schema changes
	can scale globally
	Max size of an item is 400KB
	Data types supported:
		Scalar Type - string, number, binary, boolean, null
		document Type - list , map
		Set Types - String set, number set, binary set
	By default, all DynamoDB tables are encrypted under an AWS owned customer master key (CMK), which do not write to CloudTrail logs

DynamoDB best practices include:
	Keep item sizes small.
	If you are storing serial data in DynamoDB that will require actions based on data/time use separate tables for days, weeks, months.
	Store more frequently and less frequently accessed data in separate tables.
	If possible compress larger attribute values.
	Store objects larger than 400KB in S3 and use pointers (S3 Object ID) in DynamoDB.

Read/Write Capacity Modes:
	Control how you manage your table's capacity (read/write throughput)
	2 modes:
		Provisioned Mode (default):
			You specify the number of r/w per sec
			You need to plan capacity beforehand
			Pay for privisioned Read Capacity Units(RCU) & Write Capacity Unitis (WCU)
			Possibility to add auto-scaling mode for RCU & WCU
			Encrease performance: Use partition keys with high-cardinality attributes, which have a large number of distinct values for each item.

		On-Demand Mode:
			Read/writes automatically scale up/down with your workloads
			No capacity planning needed
			Pay for what you use, more expensive ($$$$)
			Great for unpredictable workloads

DynamoDB Accelerator (DAX):
	Fully managed, HA, seamless in-memory cache for DynamoDB
	Help solve read congestion by caching
	Microseconds latency for cached data
	Doesn't require application logic modification (existing DynamoDB APIs)
	5 min TTl for cache (default)

DAX vs ElastiCache:
	DAX: Individual objects cache
		 Query & Scan cache
	ElastiCache: Store Aggregation Result

DynamoDB Streams:
	Ordered stream of item-level modifications (create/update/delete) in table
	Stream records can be:
		Sent to Kinesis Data Streams
		Read by Aws Lambda
		Read by Kinesis client Library app
	Data retention for up to 24h
	Use cases:
		react to changes in real-time (welcome email to users)
		Analytics
		Insert into derivative tables
		Insert into ElasticSerach
		Implement cross-region replication

DynamoDB Global Tables
	Make a  DynamoDB table accessible with low latency in multiple-regions
	Active-Active replication
	App can READ and WRITE to the table in any region
	Must enable DynamoDB Streams as a Pre-req

DynamoDB - Time To Live (TTL):
	Automatically delete items after an expiry timestamp
	Use cases: reduce stored data by keeping only current items, adhere to regulatory obligations...

Dynamo Indexes:
	Global Secondary Indexes (GSI) & Local Secondary Indexes (LSI)
	High level: allow to query on attributes other than the Primary Key
	With indexes, we can query by Game ID, gamte_ts, result...

Dynamo Transactions:
	possibility that a Transaction is written to both tables, or none!

DynamoDB auto scaling:
	uses the AWS Application Auto Scaling service to dynamically adjust provisioned throughput capacity on your behalf, in response to actual traffic patterns.
	This enables a table or a global secondary index to increase its provisioned read and write capacity to handle sudden increases in traffic, without throttling.
	When the workload decreases, Application Auto Scaling decreases the throughput so that you don’t pay for unused provisioned capacity.


```



API Gateway:
```
It's an Amazon's REST API
Aws Lambda + API Gateway: no infra to manage = full serverless
Support for WebSocket Protocol
Handle APi versioning(v1,v2..)
Handle different environments (dev. teste. [prod])
Handle security (Auth and Authorization)
Create API Keys, handle request throttling
Swagger / Apen API importo to quicly defines APIs
Transform and validate requests and responses
Generate SDK and API specifications
Cache API responses
Throttling limits == 429 Too Many Requests
Reduce request latency and the number of calls to EC2 == create a cache for a stage and configure TTL

You can enable API caching in Amazon API Gateway to cache your endpoint's responses. With caching, you can reduce the number of calls made to your endpoint and also improve the latency of requests to your API.
When you enable caching for a stage, API Gateway caches responses from your endpoint for a specified time-to-live (TTL) period, in seconds.
API Gateway then responds to the request by looking up the endpoint response from the cache instead of making a request to your endpoint. The default TTL value for API caching is 300 seconds. The maximum TTL value is 3600 seconds. TTL=0 means caching is disabled.
TIPS:
	– Enables you to build RESTful APIs and WebSocket APIs that are optimized for serverless workloads
    – You pay only for the API calls you receive and the amount of data transferred out.


Integrations:
	Lambda:
		Invoke Lambda + Easy way to expose REST API backed by Lambda
	HTTP:
		Expose HTTP endpoints in the backend
		ex: internal http API on premise, ALB
		why? add rate limiting, caching, user auth, API keys, etc...
	Aws Service:
		Expose any Aws API through the API gateway?
		ex: start an Aws Step Func workflow, post a msg to SQS..
		Why? Add auth, deploy publicly, rate control..

API Gateway - Endpoints (Deploy options):
	Edge-Optimized (default):
		For global clients
		Req are routed through the Cloudfront Edge locations (improves latency)
		The API Gat still lives in only one region

	Regional:
		For clients within the same region
		Could manually combine with Cloudfront (more control over the caching strategies and the distribution)

	Private:
		Can only be accessed from your VPC using an interface VPC endpoint(ENI)
		Use a resource policy to define access

Security:
	IAM Permissions:
		Create an IAM policy authorization and attach to User/Role
		API Gateway verifies IAM permissions and passed by the calling application
		Good to provide access within your own infrastructure
		Leverages "Sig v4" capability where IAM credential are in headers
		Use case: great for user/roles already within your Aws account
				  Handle auth + authorization

	Lambda Authorizer (custom authorizers):
		Uses Lambda to validate the token in header being passed
		Option to cache result of auth
		Helps to use OAuth / SAML / 3rd party
		Lambda must return an IAM policy for the user
		Use case: great for 3rd party tokens
				  very flexible in terms of what IAM policy is returned
				  Auth + autho
				  pay per lambda invocation

	Cognito User Pools:
		Cognito fully manages user lifecycle
		API gateway verifies identity automatically from Aws Cognito
		No custom implementation required
		Cognito only helps with authentication, not authorization
		Use case: you manage your own user pool (can be Facebook, Google login...)
			      no need to write any custom code
				  must implement authorization in the backend
```

Aws Cognito:
```
Give our users an identity so that they can interact with our app

Cognito User Pools (CUP):
	Sign in functionality for app users
	Integrate with API Gateway for authentication
	Create a serverless DB of user for your mobile apps
	Simple login: user/pass combination
	Possibility to verify emails / phone and add MFA
	Can enable federated Identitities(Facebook, Google, SAML...)
	Sends back a JSON Web Token (JWT)

Cognito Federated Identity Pools:
	Provide Aws Credentials to users so they can access Aws resources directly
	Integrate with Cognito user pools as an identitiy provider
	How: Log in to federated identitiy provider - or remain anonymous
		 Get temporary Aws credentials back from the Federated Identity Pool
		 These credentials come with a pre-defined IAM policy stating their permissions
	Ex: provide temporary access to write to S3 using Facebook login

Cognito Sync:
	Synchronize data from device to Cognito (up to 1MB)
	May be deprecated and replaced by AppSync
	Store preferences, configuration, state of app
	Cross device synch
	Offline capability (sync when back online)
	requires Federated Identity Pool in Cognito (not User pool)
	up to 20 datasets to sync
```

Aws SAM - Serverless Application Model:
```
Framework for dev and deploying serverless app
All the conf is YAML code:
	Lambda, Dynamo, API Gateway, Cognito User Pools
SAM can help you to run  locally
SAM use CodeDeploy to deploy lambda
```

Scenarios:
```
	- Mobile APP:
		The requisites:
			- Expose as REST API with HTTPS == API Gateway
			- Serverless architecture == invoke Lambda
			- Users should be able to directly interact with their own folder in S3 == Auth in Cognito + get tmp cred -- S3
			- Users should authenticate through a managed serverless service == Amazon Cognito
			- The users can write and read to-dos, but they mostly read them
			- The database should scale, and have some high read throughput == DAX --> DynamoDB
		Flow:
			Mobile  ----------------> API Gateway
			 	|__Auth --> Cognito -- Generate temp cred
				|__Store/retrieve files --> S3 with permissions
		Resolution resume:
			Serverless REST API: HTTPS, API Gateway, Lambda, DynamoDB
			Using Cognito to generate temporary credentials with STS to access S3 bucket with restricted policy. App users can directly access Aws resources this way. Pattern can be applied to Dynamo, Lambda...
			Caching the reads on DynamoDB using DAX
			Caching the REST requests at the API gateway level
			Security for auth and authorization with Cognite, STS

	- MyBlog.com - Serverless hosted website:
		The Req:
			- Website should scale globally = CloudFront
			- Blogs are rarely written, but often read
			- some of the website is purely static files, the rest is dynamic REST API
			- Caching must be implement where possible
			- Any new users that subscribers should receive a welcome nail - Dynamo Stream + Lambda / SNS
			- Any photo uploaded to the blog should have a thumbnail generated
		Serving static content, globally, securely:
			Client --> interaction --> CloudFront
											|__OAI: Origin Access Identity
												|__ S3 with Bucket policy(only auth from OAI)
		Adding a public serverless REST API:
			Client --> REST HTTPS --> API  Gateway
										|__ invoke --> Lambda
														|__ Query/read -- DAX --> DynamoDB Global Tables
																					|__ Dynamo Stream
																						|__ invokes Lambda
																							|__ SDK to send email with SES
		Thumbnail Generation flow:
			Client --> Upload --> S3
								  |__ OAI -- CloudFront
								  				|__ >> Upload photos with transfer acceleration
								  |__ trigger -- Lambda --> create thumbnail to S3

		Solution Resume:
			Static content being distributed using CloudFront with S3
			The REST API was serverless, didn't need Cognito because public
			Leverage a Global DynamoDB table to serve the data globally -- cloud hava used Aurora Global
			Enabled DynamoDB streams to trigger a lambda function -- use SES and send the welcome email
			S3 can trigger SQS/SNS/Lambda to notify of events

	- Micro Services architecture:
		The challenge:
			We want to switch to a micro service architecture
			Many services interact with each other directly using a REST API
			EACH architecture for each micro service may vary in form and shape
			This micro-service architecture has to be a leaner development lifecycle for each service

		Solutions:
			Synchronous patterns: API Gateway, Load Balancers
			Asynchronous patterns: SQS, Kinesis, SNS, Lambda triggers (S3)
			Challenges with micro-services:
				repeated overhead for creating
				issues with optimizing server density/utilization
				complexity of running multiple versions of multiple microservices simultaneously
				proliferation of client-side code requirements to integrate with many separate services
			Some of the challenges are solved by Serverless patterns:
				API Gateway, Lambda scale automatically and you pay per usage
				You can easily clone API, reproduce environments
				Generated client SDK through Swagger integration for the API gateway

	- Distributing paid content:
		Requirements:
			Sell videos online and users have to paid to buy videos
			Each videos can be bought
			we only want to distribute videos to users who are premium users = CloudFront with Signed URL
			We have a DB of premium users = Dynamo
			Links we send to premium users should be short lived
			Our application is global
			We want to be fully serverless

		Premium user service:
			Client --> Auth --> Cognito
								|__ verify auth -- API Gateway --> lambda -- DynamoDB

		Solution resume:
			Cognito for authentication
			DynamoDB for storing users that are premium
			2 serverless applications:
				Premium user registration
				Cloudfront signed URL generator
			Content is stored in S3 (serveless and stable)
			Integrated with CloudFront with OAI for security (users can't bypass)
			CloudFront can only be used SIgned URLs to prevent unauthorized users
			S3 Signed URL? Not efficient for global access.

	- Software Updates offloading:
		Requirements:
			An app wunning on EC2, that ditributes software updates once in a while
			When a new software update is update is out, we get a lot of request and the content is distributed in mass over the network. It's very costly
			We don't want to change our app, but want to optimize our costs and CPU, how can we do it?

		Solution resume: CloudFront!!!
			No changes to arch
			will cache software update files at the edge
			Software update files are not dynamic, they're static (never changing)
			Our Ec2 aren't serverless
			But CloudFront is, and will scale for us
			Our ASG will not scale as much, and we'll save tremendously in Ec2
			We'll also save in availability, network bandwidth cost, etc
			Easy way to make an existing app more scalable and cheaper!

	- Big Data Ingestion Pipeline:
		Requeriments:
			- We want the ingestion pipeline to bew fully serverless = IoT Devices
			- We want to collect data in real time = Kinesis DAta streams
			- We want to transform the data = Kinesis Firehose
			- We want to query the transformed data using SQL = Lambda trigger Amazon Athena
			- The reports created using the queries should be in S3 = Lambda trigger Kinesis Data Firhose
			- We want to load that data into a warehouse and create dashboards = QuickSight // Redshift (not serverless)

		Solution Resume:
			IoT Core allows you to harvest data from IoT devices
			Kinesis Data Stream is great for real-time data collection
			Kinesis Firehose helps with data delivery to S3 in near realt-time(1 min)
			Lambda can help Firehose with data transformations
			S3 can trigger notificaitons to SQS
			Lambda can subscribe to SQS
			Athena is a serverless SQL service and results are stored in S3
			The reporting bucket contains analyzed data and can be used by reporting tool such as QuickSight or Redshift

```

## Databases <a name="DB"></a>

Choosing the Right DB:
```
	Questions to choose the right DB based on your architecture:
		Read-heady, write-heacy, balanced workload?
		Throughput needs? (taxa de transferencia)
		Will it change, does it need to scale or fluctuate during the day?
		How much data to store and for how long? Will it grow? Average object size? How are they accessed?
		Data durability? Source of truth for the data?
		Latency requirements? Concurrent users?
		Data model? How will you query the data? Joins? Structured? Semi-structured?
		Strong schema? More flexibility? reporting? Search? RBDMS / NoSQL?
		Licence costs, like Oracle? Sqitch to Cloud Native DB such as Aurora?
```

AWS Database Migration Service (AWS DMS):
```
AWS DMS enables you to seamlessly migrate data from supported sources to relational databases, data warehouses, streaming platforms, and other data stores in AWS cloud.

S3 + Kinesis Data Firehose = DMS to integrate
```

DB Types:
```
RDBMS (SQL/OLTP): RDS
				  Aurora - great for joins and complex queries
NoSQL DB: DynamoDB (JSON)
		  ElastiCache (key/value pairs)
		  Neptune (graphs) - no joins, no SQL
Object Store: S3 - big objects
			  Glacier - backups /archives
Data warehouse (SQL Analytics / BI): Redshift (OLAP)
									 Athena
Search: elastiSearch (JSON) - free text, unstructured searches
Graphs: Neptune - display relationships between data
Big Data Analysis reading S3: EMR + Glue
```

RDS:
```
Managed PostgreSQL / MySQL / Oracle / SQL Server
Must provision an EC2 instance & EBS volume type and size
Supports for Read Replicas and MultiAZ
Security throught IAM, Security Groups, KMS, SSL in transit
Backup / Snapshot / Point in time restore feature
Managed and Schedule maintenance
Monitoring and Scheduled maintenance

Use case: Store relational datasets, perform SQL queries, transctional inserts/update/delete is available

RDs + SSL/TLS in transit = Download the AWS-provided root certificates. Use the certificates when connecting to the RDS DB instance

RDS + Well-architect framework(5 pilars):
	1 - Operations:
		small downtime when failover happens, when maitenance happens, scaling in read replicas / ec2 / restore EBS implies manual intervention, application changes
	2 - Security:
		Aws responsible for OS security, we are responsible for setting up KMS, SG, IAM policies, authorizing users in DB, using SSL
	3 - Reliability (confiança): MultiAZ feature, failover in case of failures
	4 - Performance:
		Depends on EC2 instance type, EBS volume type, ability to add Read replicas. Storage auto-scaling & manual scaling of instances
	5 - Costs: pay per hour based on provisioned Ec2 and EBS

```

Aurora:
```
Compatible API for PostgreSQL / MySQL
Data is held in 6 replicas, acoss 3 AZ
Auto healing capability
Multi AZ, Auto Scaling Read Replicas
Read Replicas can be Global
Aurora DB can be Global for DR or latency purposes
Auto scaling of storage from 10GB to 128 TB
define EC2 instance type for aurora
Same security / monitoring / maintenance features as RDS
Aurora Serverless - for unpredictable / intermittent workloads
Aurora Multi-Master - for continuous writes failover
Use case: same as RDS, but with less maintenance, / more flexibility / more performance

Aurora + Well-architect framwork:
	1 - Operations: less operations, auto scaling store
	2 - Security: Aws responsible for OS security, we are responsible for setting up KMS, SG, Iam policies, authorizing users in DB, using SSL
	3 - Reliability: multi AZ, highly available, possibly more than RDS, Aurora serverless oprtion, Autora Multi-Master option
	4 - Performance: 5x performance due to architectural optimazations. Up to 15 read replicas (only 5 for RDS)
	5 - Costs: Pay per hour based on EC2 and storage usage. Possibly  lower costs compared to Enterprise grade DB such as Oracle.
```

ElastiCache:
```
Managed Redis / Memcached
Is an in-memory database that can be used as a database caching layer. The memached engine supports multiple cores and threads and large nodes.
must provision an Ec2 type
Support for Clustering (Redis) and MultiAZ, Read Replicas (sharding)
Security throught IAM, SG, KMS, redis Auth
Backup / snapshor / point in time restore feature
Managed and schedule maintenance
monitoring through Cloudwatch

Use Case: Key/Value store, Frequent reads, less writes, cache results for DB queries, store session data for websites, cannot use SQL.

ElastiCache + well-achitected framework:
	1 - Operations: same as RDS
	2 - Security: user with Redis Auth
	3 - Reliability: Clustering, Multi AZ
	4 - Performance: Sub-millisencond performance, in memory, read replicas for sharding, very popular cache oprtion
	5 - Costs: pay per hour based on ec2 and storage usage

TIP: Sub-millisencond performance == ElastiCache
```

DynamoDB:
```
Aws proprietary tech, managed NoSQL DB
Serverless, provisioned capacity, auto scaling, on demand capacity
Can replace ElastiCache as a key/value store (storing session data for example)
HA, Multi AZ by default, Read and Write are decoupled, DAX for read cache
Reads can be eventually consistent or strongly consistent
Security, auth and authorization is done through IAM
DynamoDB Streams to integrate with Aws Lambda
Backup / Restore feature, Global Table feature
Monitoring through Cloudwatch
Can only query on primary key, sort key, or indexes
Use case: Serverless app development (small documents 100Kb), distributed serverless cache, doesn't have SQL query languague available, has transactions capability

Dynamo + well-achitected framework:
	1 - Operations: no operations needed, auto scaling capability, serverless
	2 - Security: full security through IAM policies, KMs encryp, SSL in flight
	3 - Reliability: MultiAz, Backups
	4 - Performance: single digit millisecond performance, DAX for caching reads, performance doesn't degrade if your app scales
	5 - Costs: Pay per provisioned capacity and storage usage (no need to guess in advance any capacity - can use auto scaling)
```

S3:
```
Is a key/value store for objects
Great for big objects,not so great for small objects
Serverless, scales infinitely, max object size is 5 TB
Strong consistency
Tiers: S3 Standard, S3 IA, S3 One Zone IA, Glacier for backups
features: Verioning, encryption, cross region replication - CRR..
Security: IAM, bucket policies, ACL
Encryption: SSE-S3, SSE-KMS, SSE-C, SSL in transit
Use case: static files, key value store for big files, website hosting

S3 + well-achitected framework:
	1 - Operations: no operations needed
	2 - Security: IAM, Bucket policies, ACL, encryption (server/client), SSL
	3 - Reliability: 99.999999 durability / 99.99 availability, Multi AZ, CRR
	4 - Performance: scales to thousands of read / writes per second, transfer acceleration / multi=part for big files
	5 - Costs: pay per storage usage, network cost, requests number
```

Athena:
```
Fully Serverless DB with SQL capabilities
Used to query data in S3
Pay per query
Output results back to S3
Secured through IAM
Use case: one time SQL queries, serverless queries on S3, log analytics

Athena + well-achitected framework:
	1 - Operations: no operations needed, serverless
	2 - Security: IAM + S3 Security
	3 - Reliability: managed service, uses presto engine, hihly available
	4 - Performance: queries sacale based on data size
	5 - Costs: pay per query / per TB of data scanned, serverless
```

Redshift:
```
Is based on PostgreSQL, but it's not used for OLTP
It's OLAP - online analytical processing - data warehousing
10x better performance then other data warehouses, scales to PBs of data
Columnar storage of data (intead of row based)
Massively Parallel Query Execurtion (MPP)
Pay as you go based on the instances privisioned
Has a SQL interface for performing queries
BI tools such as Quicksight or Tableau integrate with it
Data is loaded from S3, DynamoDB, DMs...
From 1 node to 128 nodes, up to 128 TB of space per node
Leader node: for query planning, results aggregation
Compute node: for performing the queries. send results to leader
FLEXIBLE QUERIES
Redshift Spectrum:
	perform queries directly against S3
	query data that is already in S3 without loading it
	must have a redshift cluster available to start the query
	The query is then submitted to thousands of Redshift Spectrum nodes

Backup & Restore, Sercurity VPC / IAM / KMS, Monitoring
Redshift Enhance VPC Routing: COPY/UNLOAD goes through VPC


Snapshot & DR:
	Redshift has no Multi-AZ mode
	Snapshots are point-in-time backups of a cluster, stored in ternally in S3
	snapshots are incremental (only what has changed is saved)
	You can restore a snapshot into a new cluster
	Automated: snapshot is retained until you delete it
	You can configure to automatically copy snapshots of a cluster to another Aws region
	Cross-region snapshot copy =  you need to enable this copy feature for each cluster and configure where to copy snapshots and how long to keep copied automated snapshots in the destination region. When cross-region copy is enabled for a cluster, all new manual and automatic snapshots are copied to the specified region.

Loading data into Redshift:
	Aws Kinesis Data Firehose
	S3 using copy command through Internet // VPC
	EC2 instance - JDBC driver

TIP: Analytics and data warehousing == Redshift
Redshift + well-achitected framework:
	1 - Operations:  like RDS
	2 - Security: IAM, VPC, KMS, SSL
	3 - Reliability: Auto gealing features, cross-region snapshot copy
	4 - Performance: 2-x performance vs other data warehousing, compression
	5 - Costs: pay per node provisioned, 1/10 of the cost vs other warehouses
	vs Athena: faster queries / joins / aggregations thanks to indexes
```

Glue:
```
Managed extract, transform and load (ETL) service
Useful to prepare and transform data for analytics
Fully serverless service
Glue Data catalog: catalog of datasets
	Glue Data Crawler: writes metadata of aws services --> Data Catalog --> serve data discovery --> Athena, Redshift
```

Neptune:
```
Fully managed graph DB
High relationship data
Social networking: users friends with Users, replied to comment on post of user and likes other comments.
Knowledge graphs (wikipedia)
HA across 3 AZ, up to 15 read replicas
Point-in-time recovery, continuous backup to Amazon s3
Support for KMS encryption at rest + HTTP

Neptune + well-achitected framework:
	1 - Operations: similitar to RDS
	2 - Security: Iam Auth + similar to RDS
	3 - Reliability: Multi-AZ, clustering
	4 - Performance: best suited for graphs, clustering to improve performance
	5 - Costs: pay per node provisioned

TIP: GRAPS == Neptune
```

OpenSearch / ElasticSearch:
```
Opensource tech and sold as a service on Aws
Ex.: In Dynamo, you can only find by primary key or indexes. BUT with OpenSearch, you can serach any field, even partially matches.
It's common to use OpenSearch as a complement to another DB
Also has some usage for BigData app
You can provision a cluster of instances
Built-in integrations: Kinesis Data Firehose, aws IoT, cloudWatch Logs for data ingestion
Security through Cognito & IAM, KMs encr, SSL & VPC
Comes with Kibana (visualization) & Logstash (log ingestion) - ELK stack

TIP: search/indexing any field = OpenSearch
OpenSearch + well-achitected framework:
	1 - Operations: similitar to RDS
	2 - Security: Cognito, IAM, vpc, kms, ssl
	3 - Reliability: Multi-AZ, clustering
	4 - Performance: based on ElasticSerach project, petabyte scale
	5 - Costs: pay per node provisioned
```

## Aws Monitoring & Audit: Cloudwatch, cloudTrail & Config <a name="MonitoringAudit"></a>

CloudWatch:
```
Provides metrics for every services in Aws
Metric is a variable to monitor (CPUUtilization, NetworkIn...)
Metrics belong to namespaces
Dimension is an attribute of a metric (instance id, environment, etc...)
Up to 10 dimensions per metric
Metrics have timestamps
Can create CloudWatch dashboards of metrics

EC2 Detailed monitoring:
	Ec2 metrics have metrics every 5 minutes
	With detailed monitoring (for a cost), you get data every 1 min
	Use detailed monitoring if you want to scale faster for your ASG
		Aws Free Tier allows us to have 10 detailed monitoring metrics
	Note: Ec2 memory usage is by default not pushed (must be pushed from inside the instance as a custom metric)

Custom Metrics:
	Possibility to define and send your own custom metrics to cloudWatch
	Ex.: memory RAM usage, disk space, number of logged in users...
	Use API call putMetricData
	Ability to use dimensions (attributes) to segment metrics:
		Instance.id
		Environment.name
	Metric resolution (StorageResolution API parameter - two possible value):
		Standard: 1 min
		High Resolution: 1/5/10/30 sec - Higher cost
	Important: Accepts metric data points two weeks in the past and two hours in the future (make sure to configure your Ec2 time correctly)

CloudWatch Dashboards:
	Great way to setup custom dashboards for quick access to key metrics and alarms
	Dashboards are global
	Dashboard can include graphs from different Aws acc and regions
	Pricing: 3 dash for free
			 $3/dashboard/month afterwards

CloudWatch logs:
	App can send logs to Cloudwatch using the SDK
	Cloudwatch can collect log from:
		elastic Beanstalk
		ECS
		Lambda
		VPC Flow Logs
		API Gateway
		CloudTrail based on filter
		CloudWatch log agents
		Route53: log DNS queries
	Can go to:
		Batch exporter to S3 for archival
		Stream to ElastiSearch cluster for futher analytics
	Storage architecture:
		Log groups: arbitrary name, usually representing an app
		Log stream: instances within app / log files / containers
		Using the CLI we can tail logs
		to send logs to cloudwatch, make sure IAM permissions are correct!
		Security: encryption of logs using KMS at the Group level
	Logs for EC2:
		by default, no logs from you rEc2 machine will go to cloudWatch
		You need to run a CloudWatch agent on EC2 to push the log files you want
		make sure IAM permissions are correct
		The CloudWatch log agent can be setup on-premises too
		Types: Logs Agents - old version
			   Unified Agent - collect additional system-level metrics such as RAM
	Logs for Lambda:
		Lambda tracks the number of requests, the latency per request, and the number of requests resulting in an error.
		You can view the request rates and error rates using the AWS Lambda Console, the CloudWatch console, and other AWS resources.

Cloudwatch Alarms:
	Alarms are used to trigger notifications for any metric
	Various options (sampling, %, max, min, etc...)
	Alarm States: OK, INSUFFICIENT_DATA, ALARM
	Period: High resolution custom metrics: 1s, 10s, 30s or multiples of 60s
			Can be created based on CloudWatch logs metrics filters
			If you set an alarm on a high-resolution metric, you can specify a high-resolution alarm with a period of 10 seconds or 30 seconds, or you can set a regular alarm with a period of any multiple of 60 seconds.
	Alarms Targets:
		Stop, terminate, reboot, recovery an Ec2
		Trigger uto Scaling Action
		Send notification on SNS
	EC2 Instance Recovery:
		Status Check: instance status = check the ec2 vm
					  system status = check the underlying hardware
					  Recovery: same private, public, elastic IP, metadata, placement group

CloudWatch Events:
	Event pattern: Intercept events from Aws services
	Schedule or Cron (ex.: create an event every 4h)
	A JSON payload is created from the event and passed to a target..
		Compute: lambda, batch, ecs
		Integration: sqs, sns...
		Orchestration: Step functions, code pipeline, codebuild
		Maintenance: ssm, ec2 actions

CloudWatch Agent:
	to collect more system-level metrics from Amazon EC2 instances. Here’s the list of custom metrics that you can set up:
		– Memory utilization
		– Disk swap utilization
		– Disk space utilization
		– Page file utilization
		– Log collection
```

AWS Step Functions (Lambda + glue):
```
AWS Step Functions lets you coordinate and orchestrate multiple AWS services such as AWS Lambda and AWS Glue into serverless workflows.
Workflows are made up of a series of steps, with the output of one step acting as input into the next.
A Step Function automatically triggers and tracks each step, and retries when there are errors, so your application executes in order and as expected.
The Step Function can ensure that the Glue ETL job and the lambda functions execute in order and complete successfully as per the workflow defined in the given use-case. Therefore, Step Function is the best solution.
```

Amazon EventBrigde (Saas applications):
```
Eventbridge is the next evollution of CloudWatch Events
Default event bus: generated by Aws services (Cloudwatch Events)
Partner event bus: receive events from SaaS service or app (DataDog, Auth0..)
Custom event buses: for your own app
Event buses can be accessed by other Aws accounts
Rules: how to process the events

Amazon EventBridge is recommended when you want to build an application that reacts to events from SaaS applications and/or AWS services. Amazon EventBridge is the only event-based service that integrates directly with third-party SaaS partners.
```

Aws CloudTrail:
```
Provides governance, complicance and audit for your Aws acc
cloudTrail is enabled by default!
Get an history of events / API calls made within your Aws Account by:
	Console, SDK, CLI, Aws Services
Can put logs from CloudTrail into CloudWatch Logs or S3
A trail can be applied to All Regions or a single Region
If a resource is deleted in Aws, investigate CloudTrail FIRST!
3 types of events:
	Management Events:
		Operations that are preformed on resources in your Aws account
			ex: Config security (IAM attachRolePolicy)
				Config rules for routing data(CreateSubnet)
				Setting up logging (CreateTrail)
		By default, trails are configured to log managent events.
		Can separate Read Events from Write Events
		Management Events which are also known as control plane operations
		Provide visibility into management operations that are performed on resources in your AWS account. These are also known as control plane operations.
		Management events can also include non-API events that occur in your account.

	Data Events:
		Provide visibility into the resource operations performed on or within a resource.
		By default, data events are not logged (because high volume operations)
		S3 object-level activiy(getObj, DelObj, PutObj): can separate Read and write
		Lambda function execution activity (invoke api)
		Data Events which are also known as data plane operations

	Cloudtrail Insight Events:
		Enable Cloudtrail Insights to detect unusual activity in your account:
			inaccurate resource provisioning
			hitting service limis
			Burst of Aws IAM actions
			Gaps in periodic maintenance activity
		Analyzes normal management events to create a baseline
		And then analyzes write events to detect unusual patterns
			Anomalies apper in the CloudTrail console
			Event is sent to S3
			Eventbridge event is generated (for automation needs)

CloudTrail Events Retention:
	Events are stored for 90 days in CloudTrail
	To keep events beyond this period, log them to S3 and use Athena
	CloudTrail event log files are encrypted using Amazon S3 server-side encryption (SSE)
```

Aws Config:
```
Is a service that enables you to assess, audit, and evaluate the configurations of your AWS resources.
Helps with auditing and recording compliance of your Aws resources
Helps record configurations and changes over time
Questions that can be solved by Aws Config:
	Is there unrestricted SSH access to my SG?
	Do my buckets have any public access?
	How has my ALB configuration changed over time?
You can receive alerts (SNS notifications) for any changes
Aws Config is a per-region service
Can be aggregated across regions and accounts
Possibility of storing the conf data into S3 (analyzed by athena)

Config Rules:
	Can use Aws managed condig rules (over 75)
	Can make custom config rules (must be defined in Aws Lambda)
	Can be evaluated / trigged:
		for each config changed
		and / or: at regular time intervals
	Aws config rules does not prevent actions from happening (no deny)
	Pricing: no free tier, $0.003 per configuration item recorded per region

Config Resource:
	View compliance of a resource over time
	View conf of a resource over time
	View CloudTrail API calls of a resource over time

config Rules - Remediations:
	automate remediation of non-compliant resources using SSM automation

Notifications: use eventbridge to trigger notifications when Aws resources are non-comliant
			   ability to send conf changes and compliance state notifications
```

CloudWatch x CloudTrail x Config
```
Watch: Perform monitoring(metrics, CPU, network..) & dashboards
	   Events & Alerting
	   Log Aggregation & Analysis

Trail: Record API calls made within your Account by everyone
	   Can define trails for specific resources
	   Global Service

Config: record conf changes
		no free tier
		Evaluate resources against compliance rules
		Get timeline of changes and compliance

ex.: For an ELB
	Watch: Monitoring incoming connections metric
		   visualize error codes as a % over time
		   make a dashboard to get an idea of your load balancer performance
	Config: track SG rules for the LB
			track conf changes for the LB
			ensure an SSL certificate is always assigned to the LB (compliance)
	Trail: Track who made any changes to the LB with API calls
```

Resource Access Manager (RAM):
```
Share AWS resources that you own with other Aws Accounts
share with any account or within your Organizations
Avoid resource duplication!
VPC Subnet:
	Allow to have all the resources launched in the same subnets
	must be from the same Aws org
	Cannot share SG and Default VPC, but Sg can be referenced
	Participants can manage their own resources in there
	Participants can't view, modify, delete resources that belong to other participants or the owner.
	Network is shared so anything deployed in the VPC can talk to other resources in the VPC
	Applications are accessed easily using private IP!
Aws Transit Gateway
Route53 Resolver Rules
Licence Manager Configurations
VPC sharing:
	VPC sharing (part of Resource Access Manager) allows multiple AWS accounts to create their application resources such as EC2 instances, RDS databases, Redshift clusters, and Lambda functions, into shared and centrally-managed Amazon Virtual Private Clouds (VPCs).
	To set this up, the account that owns the VPC (owner) shares one or more subnets with other accounts (participants) that belong to the same organization from AWS Organizations.
	After a subnet is shared, the participants can view, create, modify, and delete their application resources in the subnets shared with them. Participants cannot view, modify, or delete resources that belong to other participants or the VPC owner.
```

Aws SSO - Single Sign On
```
Centrally manage SSO to access multiple accounts and 3rd-party business applications
Integrated with Aws Organizations
Centralized permission management
Centralized auditing with CloudTrail
Can be connected with on-premises with AD Connector
```

AWS CloudFormation:
```
You can use JSON or YAML to describe what AWS resources you want to create and configure.
If you want to design visually, you can use AWS CloudFormation Designer.

provides two methods for updating stacks: direct update or creating and executing change sets.
When you directly update a stack, you submit changes and AWS CloudFormation immediately deploys them.
Use direct updates when you want to quickly deploy your updates.

CloudFormation Change Sets:
	allow you to preview how proposed changes to a stack might impact your running resources.

AWS StackSets:
	lets you provision a common set of AWS resources across multiple accounts and regions with a single CloudFormation template.
	StackSets takes care of automatically and safely provisioning, updating, or deleting stacks in multiple accounts and across multiple regions.
	Update == change set

AWS Serverless Application Model (AWS SAM) is an extension of AWS CloudFormation that is used to package, test, and deploy serverless applications.

Cloudformation Template:
	Outputs: is an optional section of the template that describes the values that are returned whenever you view your stack’s properties.

Monitoring
	CloudFormation is integrated with AWS CloudTrail, a service that provides a record of actions taken by a user, role, or an AWS service in CloudFormation.
	CloudTrail captures all API calls for CloudFormation as events, including calls from the CloudFormation console and from code calls to the CloudFormation APIs.

```

## Aws Security & encryption: KMS, SSM Parameter Store, CloudHSM, Shield, WAF <a name="AwsSecurity"></a>

Encryption
```
SSL - Encryption in flight:
	Data is encrypted before sending and decrypted after receiving
	SSL certificates help with encryption (HTTPS)
	Encryption in flight ensures no MITM can happen

Server Side Encryption at rest:
	Data is encrypted after being received by the server
	DAta is decrypted before being sent
	It is stored in an encrypted form thanks to a key
	The encryption/decryption keys must be managed somewhere and the server must have access to it

Client Side Encryption:
	Data is encrypted by the client and never decrypted by the server
	Data will be decrypted by a receiving client
	The server should not be able to decrypt the data
	Cloud leverage Envelope Encryption
```

Aws KMS - Key Management Server
```
Anytime you hear "encryption" for an Aws service, it's most likely KMS
Easy way to control access to your data, Aws manages keys for us
Fully integrated with IAM for authorization
Seamlessly integrated into:
	EBS: encrypt volumes
	S3: Server side encryption of obj
	Redshift/RDS: encryption of data
	SSM: Parameter Store
You can also use CLI/SDK

Types:
	Symmetric (AWS-256 keys):
		First offering of KMS, single encryption key that is used to Encrypt and Decrypt
		Aws services that are integrated with KMS use Symmetric CMKs
		Necessary for envelope encryption
		You never get access to the Key unencrypted (must call KMS API to use)

	Asymmetric (RSA & ECC key pairs):
		Public (Encrypt) and Private Key (Decrypt) pair
		Used for Encrypt/Decrypt, or Sign/Verify operations
		The public key is downloadable, but you can't access the Private Key unencrypted
		Use case: encryption outside of Aws by users who can't call the KMS API

Key Management Service:
	Able to fully manage the keys & policies:
		Create
		Rotation policies
		Disable
		Enable
	Able to audit key usage (CloudTrail)
	Three types of Customer Master Keys(CMK):
		Aws Managed Service Default CMK: free
		User Keys created in KMS: $1/month
		User keys imported (must be 256-bit symm key): $1/month
	+ pay for API call to KMS ($0.03 / 10000 calls)

Use Cases 101:
	Anytime you need to share sensitive information == KMS:
		DB pass
		Credentials to external services
		Private Key of SSL certificates

	The value in KMS is that the CMK used to encrypt data can never be retrieved by the user, and the CMK can be rotated for extra security.

	Never store your secrets in plaintext!
	Encrypted secrets can be stored in the code / environment variables
	KMS can only help in encrypting up to 4KB of data per call
	If data >4 KB, use envelope encryption

	To give access to KMS to someone:
		Make sure the Key policy allows the user
		Make sure the IAM policy allows the API calls

	Copying Snapshots across regions:
		One KMs key peer Region
		EBS encrypted with keyA ---> Reencrypted with key B in another region
		1 - Create a snapshot, encrypted with your own CMK
		2 - Attach a Key Policy to authorize cross-account access
		3 - Share the encrypted snapshot
		4 - (in target) Create a copy of the snapshot, encrypt it with a KMS key in your acc
		5 - Create a volume from the snapshot

KMS Key Policies:
	Controll access to KMS keys, "similar" to S3 bucket policies
	Difference: you cannot control access without them
	Default Policy:
		Created if you don't provide a specific policy
		complete access to the key to the root user = entire Aws account
		gives access to the IAM policies to the KMS key

KMS Automatic Key Rotation:
	For CMK (not Aws managed):
		If enabled: automatic key rotation happens every 1 year
		Previous key is kept active so you can decrypt old data
		New key has the same CMK ID (only the backing key is changed)

KMS Manual Key Rotation:
	When you want to rotate key every 90 days, 180 days..
	New key has a different CMK ID
	Keep the previous key active so you can decrypt old data
	Better to use alias in this case(to hide the change of key for the app)
	Good solution to rotate CMK that are not eligible for automatic rotation (like asymmetric CMK)

KMS Alias Updating:
	Better to use aliases in this case (to hide the change of key for the application)
Tenancy: Multi-Tenant
Standard: FIPS 140-2 Level 2
Access: Aws IAM
Key accessibility: Aws regions
Cryptographic Acceleration: NONE
HA: Aws managed
Audit: CloudTrail/Watch
```

SSM Parameter Store
```
Secure storage for configuration and secrets
Optional Seamless Encryption using KMS
Serverless, scalable, durable, easy SDK
version tracking of conf/secrets
Conf management using path & IAM
Notifications with CloudWatch Events
Integration with Cloudformation

SSM Parameter Store Hierarchy:
	/my-dept/
		/my-app/ -- GetParameters or GetParametersByPath

	Standard = 10K
	Advanced = 100K

Parameters Policies:
	Allow to assign a TTL to a parameter(expiration date) to force updating or deleting sensitive data such as passwd
	Can assign multiple policies at a time
```

Aws Secrets Manager
```
Newer service, meant for storing secrets
can force ROTATION of secrets every x days
Automate generation of secrets on rotation(lambda)
Integration with RDS
Secrets are encrypted using KMS
Mostly meant for RDS integration
Types: Cred for RDS/Redshift/DocumentDB/API key
```

CloudHSM:
```
KMS == Aws manages the software for encryption
HSM == Aws provisions encryption hardware
Dedicated Hardware(HSM = Hardware Security Module)
Your manage your own encryption keys entirely (not Aws)
HSM device is tamper resistant, FIPS 140-2 Level 3 compliance
Supports both symmetric and asymmetric encryption(SSL/TLS)
No free tier available
Must use CloudHSM Client Software
redshift supports for DB encryption and key
Good option to use with SSE-C encryption

HA:
	HSM clusters are spread across MultiAZ

Cryptographic Acceleration: SSL/TLS + Oracle TDE Acceleration
Access: You create users and manage their permissions
Tenancy: Single-Tenant
Key accessibility: Deployed and manged in a VPC
				   Can be shared across VPC peering
Audit: CloudTrail/Watch/MFA support

Use Case: a support staff mistakenly attempted to log in as the administrator three times using an invalid password in the Hardware Security Module. This has caused the HSM to be zeroized, which means that the encryption keys on it have been wiped. Unfortunately, you did not have a copy of the keys stored anywhere else. How can you obtain a new copy of the keys that you have stored on Hardware Security Module?
	Amazon does not have access to your keys nor to the credentials of your Hardware Security Module (HSM) and therefore has no way to recover your keys if you lose your credentials.
	Amazon strongly recommends that you use two or more HSMs in separate Availability Zones in any production CloudHSM Cluster to avoid loss of cryptographic keys.
	The keys are lost permanently if you did not have a copy.
```

Aws Shield:
```
Standard:
	Free service that is activated for every Aws customer
	Provides protection from attacks sucj as SYN/UDP Floods, Reflection attacks and other layer3/4 attacks

Advanced:
	Optional DDoS mitigation service ($3K per month per Org)
	Protect against more sophisticated attack
	24/7 access to Aws DDoS response ream (DRP)
	Protect against higher fees during usage spikes due to DDoS
```

Aws WAF - Web App Firewall
```
protects your web app from commom web exploits (layer 7)
Layer 7 is HTTP (L4 is TCP)
Deploy on ALB, API Gateway, CloudFront

Define Web ACL (Web Access Control List):
	Rules can include: IP addresses, HTTP Headers/body, or URI strings, geo
	Protects from common attach - SQL injection and XSS(cross-site scripting)
	Size constraints, geo-match (block countries)
	Rate-based rules (to count occurrences of events) - for DDoS protection: tracks the rate of requests for each originating IP address and triggers the rule action on IPs with rates that go over a limit. You set the limit as the number of requests per 5-minute time span. You can use this type of rule to put a temporary block on requests from an IP address that’s sending excessive requests.
```

Aws Firewall Manager:
```
Manage rules in all accounts of an Aws Organization
Common set of security rules
WAF rules (ALB, API Gateway, Cloudfront)
Aws Shield Advanced (alb, clb, elastic ip, Cloudfront)
SG for Ec2 and ENI resources in VPC
```

GuardDuty:
```
Intelligent Threat discovery to Protect Aws Account
Uses Machine Learning algorithms, anomaly detection, 3rd party data
One click to enable (30 days trial), no need to install softw

input data includes:
	CloudTrail Logs: unusual API calls, unauthorized deployments
	VPC Flow Logs: unusual internal traffic, unusual IP address
	DNS Logs: compromised EC2 instances sending encoded data within DNS queries

Can setup CloudWatch Event rules to be notified in case of findings
CloudWatch Events rules can target Aws lambda or SNS

Can protect against CryptoCurrency attacks (has a dedicated "finding" for it)

When a company decides to stop use GuardDuty service + delete all existing findings:
 ==> Disable the service in the general settings -
 Disabling the service will delete all remaining data, including your findings and configurations before relinquishing the service permissions and resetting the service. So, this is the correct option for our use case.

Logs supported: VPC Flow Logs, DNS logs, CloudTrail events

CloudTrail log file:
	To determine whether a log file was modified, deleted, or unchanged after CloudTrail delivered it
```

Amazon Inspector - EC2 ONLY
```
Automated Security Assessments for EC2 instances
Analyze the running OS against known vuln
Analyze against unintended network accessibility
Inspector Agent must be installed on OS in Ec2

After the assessment, you get a report with a list of vuln
Possibility to send notifications to SNS

What does Inspector evaluate?
	Network assessments (agentless)
	Host assessments (with agent): Commom vuln and exposures
								   Center for Internet Security CIS Benchmarks
								   Security Best Practicess
```

Macie
```
Is a fully managed DATA SECURITY and data privacy service that uses machine learning and patterns matching to discover and protect your sensitive data in Aws.
Helps identify and alert you to sensitive data, sush as personally indentifiable information (PII)
```

Shared Responsability Model
```
AWS Responsability - Security OF the Cloud:
	Protecting infrastructure that runs all the Aws services
	Manage services like S3, Dynamo, RDS...

Customer responsability - Security IN the Cloud:
	for Ec2, customer is responsible for management of the guest OS, firewall & network conf, IAM
	encrypting app data

Shared Controls:
	Patch management, conf management, Awareness & Training

Examples:
	RDS:
		Aws Resp: manage the underlying Ec2, sidable SSH
				  automated DB / Os patching
				  Audit the underlying instance and disk & guarantee it functions
		Your Resp: Check the ports / IP/ SG inbound rules in DB SG
			       In-database user creation/permissions
				   With ot without public access
				   parameter groups or DB is config to only allow SSL
				   DB encryption setting

	S3:
		Aws Resp: guarantee you get unlimited storage/ get encryption
				  ensure separation of the data between diff customers
				  ensure aws employees can't access your data
		Your Resp: Bucket conf / policy / public setting / IAM user and roles
				   enabling encryption
```


## Networking - VPC <a name="VPC"></a>

CIDR - IPv4:
```
Classless Inter-Domain Routing - a method for allocaint IP addresses
Used in Securitu Groups rules and Aws networking in general
They help to define an IP address range:
	xx.xx.xx.xx/32 => One IP
	0.0.0.0/0 => All IPs
	192.168.0.0/26 => 64 IP addresses

A CIDR consists of two components:
	Base IP:
		represents an IP contained in the range
	Subnet Mask:
		Defines how many bits can change in the IP
		ex.: /0, 0/24, 0/32
		Can take two forms:
			/8 == 255.0.0.0
			/16 == 255.255.0.0
			/24 == 255.255.255.0
			/32 == 255.255.255.255
		The Subnet MAsk basically allows part of the underlying IP to get additional next values from the base IP
			/32 => allows for 1 IP - no octect can change
			/31 => allows for 2 IP
			/30 => allows for 4 IP
			/29 => allows for 8 IP
			/28 => allows for 16 IP
			/27 => allows for 32 IP
			/26 => allows for 64 IP
			/25 => allows for 128 IP (2 elevado a 7)
			/24 => allows for 256 IP (2 elevado a 8) - last octet can change
			/16 => allows for 65.536 IP (2 elevado a 16) - last 2 octets can change
			/0 => allows for all IP (2 elevado a 16) -- all octets can change
		the max CIDR size in AWS is /16.

Public vs Private IP (IPv4):
	IANA established certain blocks of IPv4 addresses for the use of private and public addresses
	PRIVATE IP can only allow certain values:
		10.0.0.0/8 - in big networks
		172.16.0.0/12 - Aws default VPC in that range
		192.168.0.0/16 - home networks
	All the rest of the IP addresses on the Internet are Public

To help == https://www.ipaddressguide.com/
```

Default VPC - Virtual Private Cloud:
```
All new Aws accounts have a default VPC
New EC2 instances are launched into the default VPC if no subnet is specified
Default VPC has Internet connectivity and all EC2 inside it have public IPv4 addresses
1 VPC -- 5 CIDR -- 1 region

You can have multiple VPCs in an Aws regions: max 5 per region - soft limit
Max. CIDR per VPC is 5, for each CIDR:
	Min size is /28 (16 IP)
	Max size is /16 (65536 IP)
because VPC is private, only the Private IPv4 ranges are allowed (/8, /12, /16)
your VPC CIDR should not overlap with your other networks (ex.:corporate)
A VPC automatically comes with a default network ACL which allows all inbound/outbound traffic. A custom NACL denies all traffic both inbound and outbound by default.

When you launch an instance into a default VPC:
	we provide the instance with public and private DNS hostnames that correspond to the public IPv4 and private IPv4 addresses for the instance.

When you launch an instance into a nondefault VPC:
	 we provide the instance with a private DNS hostname and we might provide a public DNS hostname, depending on the DNS attributes you specify for the VPC and if your instance has a public IPv4 address.

NOT Supported by VPC Console wizard = VPC with a public subnet only and AWS Site-to-Site VPN access

```

VPC - Subnet (IPv4):
```
Aws reserves 5 IP addresses (first 4 & last 1) in each subnet
These 5 IP are not aabilable for use and can't be assigned to an Ec2
Ex.: CIDR block 10.0.0.0/24, then reserved IP are:
		10.0.0.0 - Net address
		10.0.0.1 - Reserved by Aws for the VPC router
		10.0.0.2 - Reserved by Aws for mapping to aws-provided DNS
		10.0.0.3 - Reserved by Aws for future use
		10.0.0.255 - Network broadcast Address, aws does not support broadcast in VPC, therefore the address is reserved
Exam Tip = if you need 29 IP for EC2:
	You can't choose a subnet of size /27 (32 IP, 32-5 = 27 < 29)
	You need to choose a subsnet size /26 (64 Ip, 65-5 = 59 > 29)
```

Internet Gateway - IGW
```
Allows resources in a VPC connect to the Internet (ec2)
It scales horizontally and is highly available and redundant
Must be created separately from a VPC
One VPC can only be attached to one IGW and vice versa

Internet Gateways on their own do not allow Internet access...Route tables must also be edited!
ex.: Public Ec2 inside Public Subnet1  -- Route Table ---> Router ---> Internet Gateway
```

Bastion Hosts:
```
Ec2 Bastion Host in a Public Subnet --> SSH in EC2 in a Private Subnet
We can use a Bastion Host to SSH into our private EC2 instances
the bastion is in the public subnet which is then connected all other private subnets
Bastion Host SG must be tightened (rigido)

ExamTip: Make sure the bastion host only has por22 traffic from the IP address you need, not from the SG of your other EC2
```

NAT Instance - outdated
```
NAT = Network Address Translation
Allow sEC2 in private subnets to connect to the Internet
Must be lauched in a public subnet
Must disable Ec2 settings: Source / Destination Check
Must have elastic IP attached to it
Route Tables must be configured to route traffic from private subnets to he NAT instance

Not HA / resilient setup out of the box
	You need to create an ASG in multi-AZ
Internet traffic bandwidth depends on Ec2 type
You must manage SG & rules:
	Inbound: Allow HTTP/S coming from Private Subnets
			 Allow SSH from your home network
	Outbound: HTTP/S traffic to the internet
```

NAT Gateway:
```
Allow EC2 in private subnets to connect to the Internet
Aws-managed NAT, higher bandwidth, HA, no administration
Pay per hour for usage and bandwidth
NATGW is created in specific AZ, uses an Elastic IP
Can't be used by EC2 in the same subnet (only from other subnets)
Requires an IGW (Private sbnet => NATGW => IGW)
5 Gbps of bandwidth with automatic scaling up to 45 GB
No SG to manage / required

EC2 -- Private Subnet --> NAT Gateway in Public Sub --> Router --> IGW

NAT Gateway with HA:
	Is resilient within a single AZ
	Must create multiple NAT Gateway in multiple AZ for fault-tolerance
	There is no cross-AZ failover needed because if an AZ goes down it doesn't need NAT

You can use a network address translation NAT gateway to enable instances in a private subnet to connect to the internet or other AWS services, but prevent the internet from initiating a connection with those instances.
```

DNS Resolution in VPC
```
DNS Resolution (enableDnsSupport):
	Decides if DND resolution from Route53 Resolver server is supported for the VPC
	True (default): it queries the Aws Provider DNS server at 169.254.169.253 or the reserved IP at the base of the VPC IPv4 network range plus two.

DNS Hostnames (enableDnsHostnames):
	By default:
		True == default VPC
		False == newly created VPC
	Won't do anything unless enableDnsSupport=true
	If true, assign public hostname to Ec2 if it has a public ipv4
	If you use custonDNS domain names in a Private Hosted Zone in Route53, you must set both these attributes (dnssupport & dnshostname) to true
```

NACLs & SG:
```
NACL = stateless
SG = stateful
Request --> NACL inbound rules ---> Subnet SG inbound rules --> Ec2 --> SG outbound allowed(statefull) --> NACL Outbound Rules (stateless)

NACL are like a firewall wich crontroll traffic from and to subnets
One NACL per subnet, new subnets are assigned the Default NACL
You define NACL Rules:
	Rules have a number(1-32766), higher precedence with a lower number
	First rule match will drive the decision
	Ex.: if you define #100 allow 10.0.0.10/32 and #200 DENY 10.0.0.10/32, the IP will be allowed because 100 has a gigher precedence over 200. REGRA CRESCENTE, MENOR PARA O MAIOR.
	The last rule is an * and denies a request in case of no rules match
	Aws recommends adding rules by increment of 100...(100,200,300,400..)

Newly created NACLs will deny everything
NACL are a great way of blocking a specific IP address at the subnet level

Default NACL:
	Accepts EVERYTHING inbound/outbound with the subnets it's associated with
	Do NOT modify the Default NACL, instead create custom NACLs.

Ephemeral Ports:
	For any two endpoints to establish a connection, they must use ports
	Clients connect to a defined port, and expect a response on an ephemeral port
	Different Operating Systems use different port ranges, ex.:
		IANA & MS Windows 10 = 49152 - 65535
		Linux Kernels = 32768 -60999

NACL with Ephemeral Ports, you'll allow port in range xxx-xxxx
Create NACL rules for each target subnets CIDR


SG vs NACL:
	SG: Operates at the Instance level
		Supports allow rules only
		Stateful: return traffic is automatically allowed
		All rules are evaluated before deciding whether to allow traffic
		Applies to an Ec2 when specidied by someone
	NACL: Operates at the subnet level
		  Supports allow rules an deny rules
		  Stateless: return traffic must be explicitly allowed by rules (think of ephemeral ports)
		  Rules are evaluated in order (lowest to highest) when deciding whether to allow traffic, fisrt match wins
		  Automatically applies to all EC2 in the subnet that it's associated with
```

VPC Reachability Analyzer:
```
A network diagnostics tool that troubleshoots network connectivity between two endpoints in your VPC
Ir builds a model of the network conf, then checks the reachability(acessibilidade) based on these conf (it doesn't send packets)
When the destination is:
	Reachable - it produces hop-by-hop details of the virtual network path
	Not Reachable - ir identifies the blocking components (SG, NACLS, RouteTable..)

Use Cases: troubleshoot connectivity issues, ensure network conf is an intended...
```

VPC Peering:
```
Privately connect two VPCs using Aws network
Make them behave as if they were in the same network
Must not have overlapping CIDRs
VPC Peering connection is NOT transitive (must be established for each VPC that need to communicate with one another)
You must update route tables in each VPC's subnets to ensure EC2 can communicate with each other

You can create VPC Perring connection between VPCs in different Aws accounts/regions, the target account must accept the invitation
You can reference a SG in a peered VPC (works cross acc - same region): AccountID/sg-dsdjsij
```

VPC Endpoints:
```
Conexão privada para os serviços da Aws, sem exposição pela internet.
Every Aws service s publiciy exposed (public URL)
VPC endpoints (PrivateLink + NLB) allows you to connect to Aws services using a private network instead of using the public internet
They're redundant and scale horizontally
They remove the need of IGW, NATGW..
In case  of issues: Check DNS resolution in your VPC and Route Tables
Two types:
	Interface Endpoints: Provisions an ENI (private IP) as an entry point (must attach a SG)
						 Supports most Aws services
	Gateway Endpoints: Provisions a gateway(caminho) and must be aused as a target in a route table
					   A company wishes to restrict access to their Amazon DynamoDB table to specific, private source IP addresses from their VPC = Gateway
					   Supports ONLY S3 and DynamoDB
					   you can attach an endpoint policy that controls access to the service to which you are connecting.
					   We can use a bucket policy or an endpoint policy to allow the traffic to trusted S3 buckets

```

VPC Flow Logs:
```
Capture information about IP traffic going into your interfaces:
	VPC Flow Logs
	Subnet Flow Logs
	Elastic Network Interface (ENI) Flow Logs
Helps to monitor & troubleshoot connectivity issues
Flow logs data can go to S3 / CloudWatch logs
Captures network information from Aws managed interfaces too: ELB, RDS, ElastiCache, Redshift, NATGW..

VPC Flow Logs Syntax:
	srcaddr & dstaddr - help identify problematic IP
	srcport & dstport - help indentify problematic ports
	Action - success/failure of the request due to SG/NACL
	Can be used for analytics on usage patterns, or malicious behavior
	Query VPC flow logs using Athena on S3 or Cloudwatch logs insights

Troubleshoot SG & NACL issue:
	look at the ACTION field
	Incoming Request:
		Inbound REJECT => NACL or SG
		Inbound ACCEPT, Outbount REJECT => NACL
	Outgoing Requests:
		outbound REJECT => NACL or SG
		outbound ACCEPT, inbount REJECT => NACL

A Solutions Architect needs to capture information about the traffic that reaches an Amazon Elastic Load Balancer. The information should include the source, destination, and protocol === Create a VPC flow log for each network interface associated with the ELB.
```

Site-to-Site VPN:
```
Virtual Private Gateway (VGW):
	VPN concentrator on the Aws side of the VPN connection
	VGW is created and attached to the VPC from which you want to create the Site-to-site VPN connection
	Possibility to customize the ASN (Autonomous System Number)

Customer Gateway (CGW):
	Software app or physical device on customer side of the VPN connection
	What IP to use?
		Public internet-routable IP address for your Customer Gateway device
		If it's behind NAT device that's enabled for NAT traversal (NAT-T), use the public IP of the NAT device
	Important = enable Route Propagation for the VGW in the route table that is associated with your subnets
				if you need to ping your Ec2 from on-premises, make sure you add the ICMP protocol on the inbound of your SG

VPN CloudHub:
	Provides secure communication between multiple sites, if you have multiple VPN connections
	Low-cost hub-and-spoke model for primary or secondary network connectivity between diff locations (VPN only)
	It's a VPN connection so it goes over the public internet
	To set it up, connect multiple VPN connections on the same VGW, setup dynamic routing and configure route tables
```

Direct Connect (DX):
```
Provides a dedicated PRIVATE connection from a remote network to your VPC
Dedicated connection must be setup between your DC and Aws Direct Connect locations
You need to setup a VGW on your VPC
Access public resources(s3) and private (Ec2) on same connection
Use cases:
	Increase bandwidth throughput - working with large data sets - lower cost
	More consistent network experience - applications using real-time data feeds
	Hybrid environments
Supports both IPv4 and IPv6

If you want to setup a DIrect Connect to ONE or MORE VPC in many diff regions (same account), you must use Direct Connect Gateway.
Backup for DX == Implement an IPSec VPN are active and being advertised using the Border Gateway Protocol (BGP)

Connections Types:
	Dedicated Connections:
		1Gb and 10 GB capacity
		Physical ethernet port dedicated to a customer
		Request made to Aws first, then completed by Aws DirectConnect Partners

	Hosted Connections: 50Mbs, 500Mbs, to 10 Gbs
		Connection request are made via Direct Connect Partners
		Capacity can be added or removed on demand
		1,2,5,10GB available at select Aws Direct Connect Partners

	EXAMTIP: If you need to transfer some data faster, then Direct Connect IS NOT A OPTION.
			 Lead times are often longer than 1 month to establish a new connection.

Encryption:
	Data in transit is not encrypted but is private
	Aws Direct Connect + VPN provides an IPsec-encrypted private connection
	Good for an extra level of security, but slightly more complex to put in place.

Resiliency:
	High Resiliency for Critical Workloads = One connection at multiple locations
	Maximum Resiliency for Critical Workloads: = using separate connections terminating on separate devices in more than one location.
```

Exposing Services in your VPC to other VPC:
```
Option 1: make it public
	goes through the public www
	tough to manage access (dificil)

Option 2: VPC peering
	Must create many peering relations
	Opens the whole network

BETTER OPTION == Aws PrivateLink(VPC Endpoint Services):
	Most secure & scalable way to expose a service to 1000s of VPC (own or other accounts)
	Does not require VPC peering, internet gateway, NAt, route tables....
	Requires a network load balancer (service VPC) and ENI (Customer VPC) or GWLB

Amazon EC2 instances needs to publish personally identifiable information (PII) about customers using Amazon SNS. The application is launched in private subnets within an Amazon VPC. == PRIVATELINK
```

ClassicLink - DEPRECATEd -- used by EC2-Classic

Transit Gateway:
```
For having transitive peering between thousands of VPC and on-premises, hub-and-spoke (star) connection.
Regional resource, can work cross-region
Share cross-account using Resource Access Manager (RAM)
You can peer transit Gateway across regions
Route Tables: limit which VPC can talk with other VPC
Works with Direct Connect Gateway, VPN connections
Supports IP MULTICAST

Site-to-Site VPN ECMP:
	ECMP = Equal-cost multi-path routing
		   2 tunnels used by default
		   Pay ger Gb
	Routing strategy to allow to forward a packet over multiple best path
	Use case:
		create multiple Site-to-site VPN connections to increase the BANDWIDTH of your connection to Aws
		Problems with slow connectivity:
			Associate the VPCs to an Equal Cost Multipath Routing (ECMR)-enabled transit gateway and attach additional VPN tunnels.

Share Direct Connect between multiple accounts:
	You can use RAM to share Transit Gateway with others accounts.
```

VPC - Traffic Mirroring
```
Allows you to capture and inpect network traffic in your VPC
Route the traffic to security appliances that you manage
Capture the traffic:
	From (source) - ENI
	To (targerts) - an ENI or a NLB
Capture all packets or capture the packets of your interest (optionally, truncate packets)
Source and Target can be in the same VPC or diff VPC (VPC peering)
Use cases: content inspection, threat monitoring, troubleshooting..
```

IPV6 for VPC
```
IPv4 designed to provide 3.6 Billion addresses (they'll be exhausted soon)
IPv6 is the successor of IPv4, every address is public and Internet-routable (no private range)
Ex.: 2001:db8:3333:4444:5555:6666:7777:8888

Ipv4 cannot be disabled for your VPC and subnets
You can enable Ipv6 to operate in dual-stack mode (public)
Your Ec2 will get at least a private internal IPv4 and a public IPv6
They can communicate using either IPv4 or IPv6 to the internet through an Internet Gateway.

IPv6 Troubleshooting:
	IPv4 cannot be disabled for your VPC ans sub...
	So, if you cannot launch an EC2 in your subnet:
		It's not because it cannot acquire an IPv6 (the space is very large)
		It's because there are no available IPv4 in your subnet!
	Solution = Create a new IPv4 CIDR in your subnet

Egress-only Internet Gateway:
	ONLY FOR IPv6 in Private Subnet
	Similar to a NAT gateway but for Ipv6
	Allows instances in your VPC outbound connections over Ipv6 while preventing the internet to initiate an IPv6 connection to your instances
	You must update the Route Tables
	Ec2 == internet
	internet !!! ec2
```

VPC Resume:
```
CIDR - IP Range
VPC - Virtual Private Cloud => define a list of IPv4/6 CIDR
SUbnets - tied to an AZ, we define a CIDR
Internet Gateway - IGW - at the VPC level, provide Ipv4/6 Internet access
RouteTables - must be edited to add routes from subnets to the IGW, VPC peering conn, VPC Endpoints..
BastionHost - public EC2 to SSH into, that has SSh connectivity to Ec2 in private subnets
NAT Instances - gives internet access to Ec2 in PRIVATE subnets. Old, must be setup in a public sub, disable Source / Destination check flag
NAT Gateway - managed by Aws, provides scalable Internet access to private Ec2, IPv4 only
Private DNS + route53 - enable DNS Resolution + DNs hostnames (VPC)
NACL - stateless, subnet rules for inbound/outbound, don't forget Ephemeral Ports
SG - stateful, operate at the EC2 level
Reachability Analyzer - perform network connectivity testing between Aws resources
VPC Peering - connect two VPC with non overlapping CIDR, non-transitive
VPC Endpoints - provide private access to Aws services within a VPC
VPc Flow Logs - can be setup at the VPC / Subnet / ENI Level, for ACCEPT and REJECT traffic, helps identify attacks, analyze using Athena or CloudWatch logs insights
Site-to-site VPC - setup a Customer Gateway on DC, a Virtual Private GAteway on VPC, and site-to-site VPN over public internet
Aws VPN CloudHub - hub-and-spoke VPN model to connect your series
Direct Connect - setup a Virtual Private Gateway on VPC, and establish a direct private connection to an Aws Direct Connect Location
Direct Connect Gateway - setup a Direct Connect to many VPCs in different Aws regions
Aws PrivateLink / VPC Endpoints Services: connect services privately from your service VPC to customers VPC
										  doesn't need VPC Peering, public internet, NAt Gateway, RouteTAbles
										  must be used with NLB & ENI
ClassicLink - connect EC2-Classic Ec2 instances privately to your VPC
Transit Gateway - transitive peering connections for VPC, VPN & DX
Traffic Mirroring - copy network traffic from ENIs for futher analysis
Egress-only Internet Gateway
```

Networking Costs in Aws per GB:
```
incoming traffic to EC2 = free
PublicIp/Elastic IP = $0.02
PrivateIp = $0.01
Inter-region = $0.02

Use Private IP instead of Public IP for good savings and better network performance
Use same AZ for maximum savings (at the cost of HA)

Minimizing egress traffic network cost:
	Egress traffic: outbound traffic (from AWs to outside)
	Ingress traffic: inbound traffic - from outside to Aws (typically free)
	Try to keep as much internet traffic within Aws to minimize costs
	Direct Connect location that are co-located in the same REgion result in lower cost for egress.

S3 Data Transfer Pricing:
	S3 ingress = free
	S3 to internet = $0.09 per GB
	S3 Transfer Acceleration = $0.04 to $0.08 per GB
	S3 to CloudFront = $0.00
	CloudFront to Internet: $0.085
	S3 CRR: $0.02

Gateway endpoint = $0.01, much more cheaper than NAT Gateway
```

Run command (Windows Instances):
```
Is designed to support a wide range of enterprise scenarios including installing software, running ad hoc scripts or Microsoft PowerShell commands, configuring Windows Update settings, and more.

Run Command can be used to implement configuration changes across Windows instances on a consistent yet ad hoc basis and is accessible from the AWS Management Console, the AWS Command Line Interface (CLI), the AWS Tools for Windows PowerShell, and the AWS SDKs.
```


## Disaster Recovery <a name="DR"></a>

Backup and restore (RPO in hours, RTO in 24 hours or less): Back up your data and applications using point-in-time backups into the DR Region. Restore this data when necessary to recover from a disaster.

Pilot light (RPO in minutes, RTO in hours):
	Replicate your data from one region to another and provision a copy of your CORE WORKLOAD infrastructure. Resources required to support data replication and backup such as databases and object storage are always on. Other elements such as application servers are loaded with application code and configurations, but are switched off and are only used during testing or when Disaster Recovery failover is invoked.
	Minimum costs,the facility can only bear data loss of a few minutes without jeopardizing the forecasting models.

Warm standby (RPO in seconds, RTO in minutes):
	 Maintain a scaled-down but FULLY functional version of your workload always running in the DR Region. Business-critical systems are fully duplicated and are always on, but with a scaled down fleet. When the time comes for recovery, the system is scaled up quickly to handle the production load. The more scaled-up the Warm Standby is, the lower RTO and control plane reliance will be. When scaled up to full scale this is known as a Hot Standby.

Multi-region (multi-site) active-active (RPO near zero, RTO potentially zero):
	Your workload is deployed to, and actively serving traffic from, multiple AWS Regions. This strategy requires you to synchronize data across Regions. Possible conflicts caused by writes to the same record in two different regional replicas must be avoided or handled. Data replication is useful for data synchronization and will protect you against some types of disaster, but it will not protect you against data corruption or destruction unless your solution also includes options for point-in-time recovery. Use services like Amazon Route 53 or AWS Global Accelerator to route your user traffic to where your workload is healthy. For more details on AWS services you can use for active-active architectures see the AWS Regions section of Use Fault Isolation to Protect Your Workload.

Az goes down:
	As the Availability Zones got unbalanced, Amazon EC2 Auto Scaling will compensate by rebalancing the Availability Zones. When rebalancing, Amazon EC2 Auto Scaling launches new instances before terminating the old ones, so that rebalancing does not compromise the performance or availability of your application
	Amazon EC2 Auto Scaling creates a new scaling activity for terminating the unhealthy instance and then terminates it. Later, another scaling activity launches a new instance to replace the terminated instance


## Practice Test Tips

Order of the storage charges($$$) incurred for the test file on storage types:
```
Cost of test file storage on S3 Standard < Cost of test file storage on EFS < Cost of test file storage on EBS
```

The company has been asked to block access from two countries and allow access only from the home country of the company ==> Configure AWS WAF on the Application Load Balancer in a VPC.

Deletion of Customer Master Key(CMK) of KMS:
```
To delete a CMK in AWS KMS you schedule key deletion.
You can set the waiting period from a minimum of 7 days up to a maximum of 30 days.
The default waiting period is 30 days. During the waiting period, the CMK status and key state is Pending deletion.
To recover the CMK, you can cancel key deletion before the waiting period ends. After the waiting period ends you cannot cancel key deletion, and AWS KMS deletes the CMK.
```

The product team at a startup has figured out a market need to support both STATEFUL and STATELESS client-server communications via the APIs developed using its platform:
```
API Gateway creates RESTful APIs that enable stateless client-server communication and API Gateway also creates WebSocket APIs that adhere to the WebSocket protocol == which enables stateful, full-duplex communication between client and server
```

AWS Lambda currently supports 1000 concurrent executions per AWS account per region. If your Amazon SNS message deliveries to AWS Lambda contribute to crossing these concurrency quotas, your Amazon SNS message deliveries will be throttled. You need to contact AWS support to raise the account limit.

To prevent your API from being overwhelmed by too many requests == Amazon API Gateway, Amazon SQS and Amazon Kinesis

Continue to be processed even if any instance goes down, as the underlying application architecture would ensure the replacement instance has access to the required dataset == Use Instance Store based EC2 instances.

Company wants to migrate 70TB de cada 10 applicações para a Aws == Order 10 Snowball Edge Storage Optimized devices to complete the one-time data transfer + Setup Site-to-Site VPN to establish connectivity between the on-premises data center and AWS Cloud.

By default, one region can be 20 instances.
Enhanced networking

O que precisa ser configurado fora da VPC para que a VPN site-to-site funcione?
R = An internet-routable IP address static of the customer gateway's external interface for the on-premises network

ec2throttledException:
Your VPC does not have sufficient subnet ENIs or subnet IPs.
You only specified one subnet in your Lambda function configuration. That single subnet runs out of available IP addresses and there is no other subnet or Availability Zone which can handle the peak load.

AWS Backup is a centralized backup service that makes it easy and cost-effective for you to backup your application data across AWS services in the AWS Cloud, helping you meet your business and regulatory backup compliance requirements. AWS Backup makes protecting your AWS storage volumes, databases, and file systems simple by providing a central place where you can configure and audit the AWS resources you want to backup, automate backup scheduling, set retention policies, and monitor all recent backup and restore activity.

An AI-powered Forex trading application consumes thousands of data sets to train its machine learning model. The application’s workload requires a high-performance, parallel hot storage to process the training datasets concurrently. It also needs cost-effective cold storage to archive those datasets that yield low profit. == Use Amazon FSx For Lustre and Amazon S3 for hot and cold storage respectively.

A new application is to be published in multiple regions around the world. The Architect needs to ensure only 2 IP addresses need to be whitelisted. The solution should intelligently route traffic for lowest latency and provide fast regional failover. == Ec2 + NLB + global Accelerator

NFS migrated data + Availability + durability = Aws Storage Gateway File Gateway, because backs of to S3

EC2 with data in transit encrypted = NLB + TCP Listener, then terminate SSL on EC2
									 ALB with HTTPS listernet, then install SSL certificates on the ALB and Ec2

An application requires a MySQL database which will only be used several times a week for short periods. == aurora serverless

An application runs on Amazon EC2 instances backed by Amazon EBS volumes and an Amazon RDS database. The application is highly sensitive and security compliance requirements mandate that all personally identifiable information (PII) be encrypted at rest. == Configure Amazon EBS encryption and Amazon RDS encryption with AWS KMS keys to encrypt instance and database volumes

EC2 instances in a private subnet. The EC2 instances process data that is stored in an Amazon S3 bucket. The data is highly confidential and a private and secure connection is required between the EC2 instances and the S3 bucket. == Bucket policy that allow only the VPC

Company has a presence in AWS in multiple regions. The company has established a new office and needs to implement a high-bandwidth, low-latency connection to multiple VPCs in multiple regions within the same account. The VPCs each have unique CIDR ranges.
What would be the optimum solution design using AWS technology? == Create a Direct Connect gateway, and create private VIFs to each region. Implement a Direct Connect connection to the closest AWS region.

Streaming media service = elastiCache for Redis cluster

EBS Ecryption:
	All EBS types and all instance families support encryption but not all instance types support encryption. There is no direct way to change the encryption state of a volume. Data in transit between an instance and an encrypted volume is also encrypted.

Which is the only resource-based policy that the IAM service supports? TRUST POLICY

Default state of the security group:
	There is an outbound rule that allows all traffic to all IP addresses
	There are no inbound rules and traffic will be implicitly denied

Default state of the Network ACL:
	There is a default inbound rule denying all traffic
	There is a default outbound rule denying all traffic

EBS insufficient-data == the check may still in progress

persistent data storage ==

EC2 Impaired =  It will wait a few minutes for the instance to recover and if it does not it will mark the instance for termination, terminate it, and then launch a replacement

VPC/VPNs that are in the SAME REGION by associating a Direct Connect gateway to a transit gateway

VPC in various regions = A Direct Connect gateway can then be used to create private virtual interfaces (VIFs) to each AWS region.