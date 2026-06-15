# Caso 5:
Indica procesos de revisión, herramientas a utilizar y procesos de propuesta para realizar la optimización de costos
mediante el siguiente escenario.
Una empresa tiene:
10 EC2 t3.large
RDS PostgreSQL db.m5.large
S3 con 20 TB
CloudFront

#Revisión de costos y optimización
1. **Revisión de costos actuales**: Utilizar AWS Cost Explorer y CloudWatch para medir y analizar los costos actuales de EC2, RDS, S3 y CloudFront para identificar costos significativos.

-CPU y memoria de EC2: Activar compute optimizer, e intala un agente de cloudwath para evaluar el uso de t3.large para determinar si es adecuado o si se puede cambiar a una instancia más pequeña o a un tipo de instancia diferente si cpu promedio es menor al 20 porciento bajar a t3.medium

-Uso de savings plans: Si las cargas de trabajo son predecibles, considerar la compra de Savings Plans para EC2 y RDS para obtener descuentos significativos.
Tipos de estancias ec2 - On-Demand: Pago por uso sin compromiso a largo plazo.
- Reserved Instances: Compromiso a largo plazo (1 o 3 años) con descuentos significativos.
- Savings Plans: Compromiso a largo plazo con flexibilidad en tipos de instancias y regiones.
- Compute savings plans: Descuentos para cualquier tipo de instancia EC2, Fargate o Lambda puedes cambiar entre tipos de instancias y regiones.
- EC2 instance savings plans: Descuentos específicos para tipos de instancias EC2, con flexibilidad en regiones pero no en tipos de instancias.
- Spot Instances: Instancias de bajo costo para cargas de trabajo flexibles y tolerantes a interrupciones.

# RDS
Habilitar performance insights, revisar CPU, evaluar si cambiar a db.t4g.medium, si la carga es estable usa saving plans
# s3
S3: Revisar el uso de almacenamiento y las políticas de ciclo de vida para identificar oportunidades de reducción de costos, como mover datos a clases de almacenamiento más económicas. 
S3 standard -> S3 IA o Glacier para datos que no se acceden con frecuencia. -> GLACIER INSTANT RETRIEVE para datos que necesitan acceso rápido pero no frecuente. -> S3 Intelligent-Tiering para datos con patrones de acceso impredecibles. ->s3 Deep Archive para datos que se acceden muy raramente y pueden tolerar tiempos de recuperación más largos.

- Identificar objetos no utilizados o duplicados que puedan eliminarse.
- Analizar si el S3 necesita versionado activado, lo que puede aumentar los costos.

# CloudFront: 
-Evaluar el uso de CloudFront y considerar alternativas como Amazon S3 Transfer Acceleration o AWS Global Accelerator(ENVIA INFOR A EDGE LOCATION Y DESPUES A    RED LOCAL DE AWS SIN PASAR POR INTENET PUBLICA) si el tráfico es principalmente interno o regional.
- Analizar costos de transferencia de datos y considerar optimizaciones como reducir el número de solicitudes o usar compresión para reducir el tamaño de los objetos entregados.
- Analizar cache Hit Ratio para identificar oportunidades de mejorar la caché y reducir las solicitudes a los orígenes, lo que puede reducir costos.
- Cambiar TTL de CloudFront para reducir la frecuencia de las solicitudes a los orígenes, lo que puede reducir costos.
- Cambiar cache policies para optimizar la caché para evitar solicitudes innecesarias a los orígenes, lo que puede reducir costos.

# Crear AWS Budgets:
Para monitorear los costos y establecer alertas para detectar cualquier aumento inesperado en los costos crear AWS Budgets para EC2, RDS, S3 y CloudFront. Esto permitirá recibir notificaciones cuando los costos se acerquen o superen los límites establecidos, facilitando la identificación de áreas que requieren atención, usando SNS para recibir alertas por correo electrónico o SMS.
