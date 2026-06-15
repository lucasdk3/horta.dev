import { initializeApp } from "firebase/app";
import { getAuth, GoogleAuthProvider, signInWithPopup } from "firebase/auth";
import { getFirestore, doc, getDocFromServer, runTransaction, increment, serverTimestamp } from "firebase/firestore";
import firebaseConfig from "@/firebase-applet-config.json";

const app = initializeApp(firebaseConfig);
export const db = getFirestore(app, firebaseConfig.firestoreDatabaseId);
export const auth = getAuth(app);
export const googleProvider = new GoogleAuthProvider();

export const signInWithGoogle = () => signInWithPopup(auth, googleProvider);

async function testConnection() {
  try {
    await getDocFromServer(doc(db, "test", "connection"));
  } catch (error) {
    if (error instanceof Error && error.message.includes("offline")) {
      console.error("Please check your Firebase configuration.");
    }
  }
}
testConnection();

export enum OperationType {
  CREATE = "create",
  UPDATE = "update",
  DELETE = "delete",
  LIST = "list",
  GET = "get",
  WRITE = "write",
}

export function handleFirestoreError(error: unknown, operationType: OperationType, path: string | null) {
  const errInfo = {
    error: error instanceof Error ? error.message : String(error),
    authInfo: {
      userId: auth.currentUser?.uid,
      email: auth.currentUser?.email,
      emailVerified: auth.currentUser?.emailVerified,
      isAnonymous: auth.currentUser?.isAnonymous,
    },
    operationType,
    path
  };
  console.error("Firestore Error:", JSON.stringify(errInfo));
  throw new Error(JSON.stringify(errInfo));
}

export async function grantXP(userId: string, amount: number) {
  const userRef = doc(db, "users", userId);
  try {
    await runTransaction(db, async (transaction) => {
      const userDoc = await transaction.get(userRef);
      if (!userDoc.exists()) {
        transaction.set(userRef, {
          xp: amount,
          level: 1,
          badges: [],
          isAdmin: false,
          createdAt: serverTimestamp()
        });
        return;
      }

      const data = userDoc.data();
      const currentXP = (data.xp || 0) + amount;
      const currentLevel = data.level || 1;
      
      // Level formula: Level = floor(sqrt(XP / 100)) + 1
      const nextLevel = Math.floor(Math.sqrt(currentXP / 100)) + 1;
      
      transaction.update(userRef, {
        xp: increment(amount),
        level: nextLevel > currentLevel ? nextLevel : currentLevel
      });
    });
  } catch (error) {
    handleFirestoreError(error, OperationType.UPDATE, `users/${userId}/xp`);
  }
}

