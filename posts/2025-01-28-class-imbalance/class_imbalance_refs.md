

Refs:

MC Note: SMOTE really only work some of the time for 'weak learners' and not much in practice for more robust ML models like boosting/RF. I'm less familiar with ADASYN but it strikes as 'SMOTE +'

SMOTE FAIL

https://www.kaggle.com/competitions/playground-series-s4e1/discussion/467034#2602231
https://www.kaggle.com/competitions/playground-series-s4e1/discussion/467034#2597761
https://twitter.com/predict_addict/status/1750189232637825383

https://arxiv.org/abs/2201.08528 To SMOTE, or not to SMOTE?
https://mindfulmodeler.substack.com/p/dont-fix-your-imbalanced-data
https://machinelearningmastery.com/tactics-to-combat-imbalanced-classes-in-your-machine-learning-dataset/

ISSUES WITH ADASYN
https://towardsdatascience.com/the-mystery-of-adasyn-is-revealed-73bcba57c3fe


COST SENSITIVE LEARNING

https://machinelearningmastery.com/cost-sensitive-learning-for-imbalanced-classification/
- he notes csl as encompassing sampling/algorithmic/thresholding techniques
- we could add just using different metrics for selection (e.g. recall instead of accuracy)

https://fraud-detection-handbook.github.io/fraud-detection-handbook/Chapter_6_ImbalancedLearning/Introduction.html
- heavily cites learning from imbalanced data by fernandez et al


Research:
Shwartz-Ziv: https://openreview.net/pdf?id=iGmDQn4CRj Simplifying Neural Network Training Under Class Imbalance (very interesting, they look at both CV and tabular data)
>  Notably, we demonstrate that simply tuning existing components of standard deep learning pipelines, such as the batch size, data augmentation, optimizer, and label smoothing, can achieve state-of-the-art performance without any such specialized class imbalance methods.
For the tabular data, results and are almost identical to basic MLP and not significantly improved over XGB
Data = Otto: all numeric counts; Adult (income?): mixed; Covertype: all numeric/dummy


ISSUES:

Simple RUS/Oversampling are computationally inefficient ways to produce what weighting would already give you.