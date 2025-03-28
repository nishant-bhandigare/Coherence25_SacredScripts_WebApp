import pandas as pd
import numpy as np
import pickle
from sklearn.model_selection import train_test_split
from sklearn.ensemble import ExtraTreesRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error

# Load dataset from CSV (instead of Google Drive)
data_path = "Airquality_index.csv"
df = pd.read_csv(data_path)

# Handle missing values (impute with mean)
df.fillna(df.mean(), inplace=True)

# Separate features (X) and target (y)
X = df.drop(columns=["PM 2.5"])
y = df["PM 2.5"]

# Split dataset
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Train ExtraTreesRegressor model
model = ExtraTreesRegressor(n_estimators=200, random_state=42)
model.fit(X_train, y_train)

# Model evaluation
y_pred = model.predict(X_test)
mae = mean_absolute_error(y_test, y_pred)
mse = mean_squared_error(y_test, y_pred)
rmse = np.sqrt(mse)

# Save the trained model
model_path = "air_quality_model.pkl"
with open(model_path, "wb") as file:
    pickle.dump(model, file)

# Print model performance
print(f"Model trained and saved as {model_path}")
print(f"MAE: {mae:.2f}, MSE: {mse:.2f}, RMSE: {rmse:.2f}")
