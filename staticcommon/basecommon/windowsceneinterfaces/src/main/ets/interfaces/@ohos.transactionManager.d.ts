/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * Transaction manager.
 *
 * @syscap SystemCapability.Window.TransactionManager
 * @systemapi Hide this for inner system use.
 * @since 10
 */
declare namespace transactionManager {
   /**
   * Open sync transaction
   * @param { number } screenId - ID of the screen for opening a sync transaction.
   */
   function openSyncTransaction(screenId?: number): void;

  /**
   * Close sync transaction
   * @param { number } screenId - ID of the screen for closing a sync transaction.
   */
  function closeSyncTransaction(screenId?: number): void;

  /**
   * Close sync transaction with vsync
   * @param { number } screenId - ID of the screen for closing a sync transaction.
   */
  function closeSyncTransactionWithVsync(screenId?: number): void;
}

export default transactionManager;
