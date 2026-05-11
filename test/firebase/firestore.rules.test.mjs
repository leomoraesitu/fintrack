import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';

import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
} from '@firebase/rules-unit-testing';
import {
  deleteDoc,
  doc,
  getDoc,
  serverTimestamp,
  setDoc,
  updateDoc,
} from 'firebase/firestore';

const projectId = 'demo-fintrack-rules';

const testEnv = await initializeTestEnvironment({
  projectId,
  firestore: {
    rules: readFileSync('firestore.rules', 'utf8'),
    host: '127.0.0.1',
    port: 8080,
  },
});

function dbForUser(uid) {
  return testEnv.authenticatedContext(uid).firestore();
}

function anonymousDb() {
  return testEnv.unauthenticatedContext().firestore();
}

function transactionData(overrides = {}) {
  return {
    type: 'expense',
    amount: 82.5,
    date: new Date('2026-04-06T12:00:00.000Z'),
    description: 'Supermercado',
    categoryId: 'food',
    categoryLabel: 'Alimentacao',
    categoryType: 'expense',
    updatedAt: serverTimestamp(),
    ...overrides,
  };
}

function categoryData(overrides = {}) {
  return {
    label: 'Alimentacao',
    type: 'expense',
    ...overrides,
  };
}

async function seedTransaction(userId, transactionId = 'tx-1') {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    await setDoc(
      doc(context.firestore(), 'users', userId, 'transactions', transactionId),
      transactionData(),
    );
  });
}

async function seedCategory(userId, categoryId = 'food') {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    await setDoc(
      doc(context.firestore(), 'users', userId, 'categories', categoryId),
      categoryData(),
    );
  });
}

test.after(async () => {
  await testEnv.cleanup();
});

test.beforeEach(async () => {
  await testEnv.clearFirestore();
});

test('usuario autenticado acessa suas proprias transacoes', async () => {
  const db = dbForUser('user-1');
  const transactionRef = doc(db, 'users/user-1/transactions/tx-1');

  await assertSucceeds(setDoc(transactionRef, transactionData()));
  await assertSucceeds(getDoc(transactionRef));
  await assertSucceeds(
    updateDoc(transactionRef, {
      description: 'Supermercado atualizado',
      updatedAt: serverTimestamp(),
    }),
  );
  await assertSucceeds(deleteDoc(transactionRef));
});

test('usuario autenticado nao acessa transacoes de outro usuario', async () => {
  await seedTransaction('user-2');

  const db = dbForUser('user-1');
  const otherUserTransactionRef = doc(db, 'users/user-2/transactions/tx-1');

  await assertFails(getDoc(otherUserTransactionRef));
  await assertFails(setDoc(otherUserTransactionRef, transactionData()));
  await assertFails(deleteDoc(otherUserTransactionRef));
});

test('usuario anonimo nao acessa transacoes', async () => {
  await seedTransaction('user-1');

  const db = anonymousDb();
  const transactionRef = doc(db, 'users/user-1/transactions/tx-1');

  await assertFails(getDoc(transactionRef));
  await assertFails(setDoc(transactionRef, transactionData()));
  await assertFails(deleteDoc(transactionRef));
});

test('paths fora da colecao de transacoes ficam bloqueados', async () => {
  const db = dbForUser('user-1');

  await assertFails(setDoc(doc(db, 'transactions/tx-1'), transactionData()));
  await assertFails(setDoc(doc(db, 'users/user-1/profile/main'), {
    name: 'User One',
  }));
});

test('transacao precisa respeitar o schema esperado', async () => {
  const db = dbForUser('user-1');
  const validTransactionRef = doc(db, 'users/user-1/transactions/valid');
  const invalidTransactionRef = doc(db, 'users/user-1/transactions/invalid');

  await assertSucceeds(setDoc(validTransactionRef, transactionData()));
  await assertFails(
    setDoc(
      invalidTransactionRef,
      transactionData({
        amount: -10,
      }),
    ),
  );
  await assertFails(
    setDoc(
      invalidTransactionRef,
      transactionData({
        categoryType: 'income',
      }),
    ),
  );
  await assertFails(
    setDoc(
      invalidTransactionRef,
      transactionData({
        unexpectedField: true,
      }),
    ),
  );

  const storedTransaction = await getDoc(validTransactionRef);
  assert.equal(storedTransaction.exists(), true);
});

test('usuario autenticado acessa suas proprias categorias', async () => {
  const db = dbForUser('user-1');
  const categoryRef = doc(db, 'users/user-1/categories/food');

  await assertSucceeds(setDoc(categoryRef, categoryData()));
  await assertSucceeds(getDoc(categoryRef));
  await assertSucceeds(updateDoc(categoryRef, {label: 'Mercado'}));
  await assertSucceeds(deleteDoc(categoryRef));
});

test('usuario autenticado nao acessa categorias de outro usuario', async () => {
  await seedCategory('user-2');

  const db = dbForUser('user-1');
  const categoryRef = doc(db, 'users/user-2/categories/food');

  await assertFails(getDoc(categoryRef));
  await assertFails(setDoc(categoryRef, categoryData()));
  await assertFails(deleteDoc(categoryRef));
});

test('categoria precisa respeitar o schema esperado', async () => {
  const db = dbForUser('user-1');
  const validCategoryRef = doc(db, 'users/user-1/categories/food');
  const invalidCategoryRef = doc(db, 'users/user-1/categories/invalid');

  await assertSucceeds(setDoc(validCategoryRef, categoryData()));
  await assertFails(
    setDoc(
      invalidCategoryRef,
      categoryData({type: 'other'}),
    ),
  );
  await assertFails(
    setDoc(
      invalidCategoryRef,
      categoryData({unexpectedField: true}),
    ),
  );

  const storedCategory = await getDoc(validCategoryRef);
  assert.equal(storedCategory.exists(), true);
});
