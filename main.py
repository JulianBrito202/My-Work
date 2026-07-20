"""Julian"""
def warn(*args, **kwargs):
    pass
import warnings
warnings.warn = warn
import get_images
import get_landmarks
from sklearn.multiclass import OneVsRestClassifier as ORC
from sklearn.model_selection import train_test_split
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.neighbors import KNeighborsClassifier as knn
from sklearn.svm import SVC as svm


def plot_scoreDist(gen_scores, imp_scores):
    plt.figure()
    plt.hist(gen_scores, color='green', lw=2, histtype='step', hatch='//', label='Genuine Scores')
    plt.hist(imp_scores, color='red', lw=2, histtype='step', hatch='\\', label='Impostor Scores')
    plt.xlim([-0.05,1.05])
    plt.grid(color = 'gray', linestyle = '--', linewidth = 0.5)
    plt.legend(loc='upper left', fontsize=12)
    plt.xlabel('Matching Score', fontsize = 15, weight = 'bold')
    plt.ylabel('Score Frequency', fontsize = 15, weight = 'bold')
    plt.gca().spines['top'].set_visible(False)
    plt.gca().spines['right'].set_visible(False)
    plt.xticks(fontsize=12)
    plt.yticks(fontsize=12)
    plt.title('Score Distribution Plot')
    plt.show()

    return

image_directory = '../Caltech Faces Dataset'
X, y = get_images.get_images(image_directory)

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.33, random_state=42)

X_train, y_train = get_landmarks.get_landmarks(X_train, y_train, 'landmarks/', num_coords=5, to_save=False)

clf_knn = ORC(knn())
clf_knn.fit(X_train, y_train)

clf_svm = ORC(svm(probability=True))
clf_svm.fit(X_train, y_train)

X_test, y_test = get_landmarks.get_landmarks(X_test, y_test, 'landmarks/', num_coords=5, to_save=False)

matching_scores_knn = clf_knn.predict_proba(X_test)
matching_scores_svm = clf_svm.predict_proba(X_test)

matching_scores = (matching_scores_knn + matching_scores_svm) / 2.0

gen_scores = []
imp_scores = []
classes = clf_knn.classes_
matching_scores = pd.DataFrame(matching_scores, columns=classes)

for i in range(len(y_test)):    
    scores = matching_scores.loc[i]
    mask = scores.index.isin([y_test[i]])
    gen_scores.extend(scores[mask])
    imp_scores.extend(scores[~mask])

plot_scoreDist(gen_scores, imp_scores)