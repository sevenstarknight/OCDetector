# OCDetector

With the advent of digital astronomy, new benefits and new challenges have been presented to the
modern day astronomer. Here we focus on the construction and application of a novel time-domain
signature extraction methodology and the development of a supporting supervised pattern detection
algorithm for the targeted identification of eclipsing binaries which demonstrate a feature known as the
O’Connell Effect. Our proposed methodology maps stellar variable observations (time-domain data)
to a new representation known as Distribution Fields (DF), whose properties enable us to efficiently
handle issues such as irregular sampling and multiple values per time instance. Given this novel
representation, we develop a metric learning technique directly on the DF space capable of specifically
identifying our stars of interest. The metric is tuned on a set of labeled eclipsing binary data from
the Kepler survey, targeting particular systems exhibiting the O’Connell Effect. Our framework
demonstrates favorable performance on Kepler EB data, taking a crucial step to prepare the way for
large-scale data volumes from next generation telescopes such as LSST 
