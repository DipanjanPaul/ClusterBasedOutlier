# Cluster Based Outlier Detection Model

All Outlier/Anomaly detection processes employs a variety of tricks and techniques to find those items that may either be hiding in plain sight (within a population) or are (in general) easily detectable. However, in all cases, the business users (of these anomaly detection models) want an intuitive way to understand why the model identified something as an outlier. Providing an intuitive explanation to how the model worked has critical advantages - It allows the users to validate the models and (more inportantly) allows them to provide inputs to improve the models. SME knowledge should be incorporated into a model design whenever possible.

In this example, we use a Clustering (Kmeans) based approach to identify outliers. The motivation is to define an activity/event with a series of linear features. This features can be used to compute a Euclidean distance to any of these activities/events. And this distance measure can be utilized to identify outliers. 

The details of this model can be found in the attached PDF document.
