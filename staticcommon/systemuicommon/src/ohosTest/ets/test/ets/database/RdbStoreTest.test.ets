/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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
import { relationalStore } from '@kit.ArkData';
import ctx from '@ohos.app.ability.common';
import { CustomPromise } from '@ohos/frameworkwrapper/src/main/ets/base/CustomPromise';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { SystemUICommonUtil } from '../../../main/ets/utils/SystemUICommonUtil';
import { TaskItem, TaskQueue } from '../../../main/ets/utils/TaskQueue';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { RdbStore } from '../../../main/ets/database/RdbStore';
export default function RdbStoreTest() {
  describe('initStore_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_resolve_storePromise_when_initStore_success', 0, async () => {
      let context: ctx.Context = new ctx.Context();
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockInitStore: Function = mocker.mockFunc(relationalStore, relationalStore.getRdbStore);
      when(mockInitStore)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(new CustomPromise((resolve) => {
        resolve('success');
      }));

      await rdbstore.initStore(context);

      expect(rdbstore.storePromise).assertPromiseIsResolvedWith('success');

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(relationalStore, relationalStore.getRdbStore);
    });

    it('should_log_error_when_initStore_fails', 0, async () => {
      let context: ctx.Context = new ctx.Context();
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockInitStore: Function = mocker.mockFunc(relationalStore, relationalStore.getRdbStore);
      when(mockInitStore)(ArgumentMatchers.any, ArgumentMatchers.any).afterThrow('error');

      await rdbstore.initStore(context);

      expect(rdbstore.storePromise).assertPromiseIsRejectedWith('error');

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(relationalStore, relationalStore.getRdbStore);
    });

    it('should_retry_initStore_when_initStore_fails_and_retryTimes_less_than_MAX_RETRY_TIMES', 0, async () => {
      let context: ctx.Context = new ctx.Context();
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockInitStore: Function = mocker.mockFunc(relationalStore, relationalStore.getRdbStore);
      when(mockInitStore)(ArgumentMatchers.any, ArgumentMatchers.any).afterThrow('error');

      rdbstore.initRetryTimes = 0;
      await rdbstore.initStore(context);

      expect(rdbstore.initRetryTimes).assertEqual(1);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(relationalStore, relationalStore.getRdbStore);
    });

    it('should_not_retry_initStore_when_initStore_fails_and_retryTimes_greater_than_or_equal_to_MAX_RETRY_TIMES', 0, async () => {
      let context: ctx.Context = new ctx.Context();
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockInitStore: Function = mocker.mockFunc(relationalStore, relationalStore.getRdbStore);
      when(mockInitStore)(ArgumentMatchers.any, ArgumentMatchers.any).afterThrow('error');

      rdbstore.initRetryTimes = MAX_RETRY_TIMES;
      await rdbstore.initStore(context);

      expect(rdbstore.initRetryTimes).assertEqual(MAX_RETRY_TIMES);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(relationalStore, relationalStore.getRdbStore);
    });

    it('should_call_store_commit_when_storePromise_is_resolved', 0, async () => {
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(rdbstore, rdbstore.storePromise);
      when(mockfunc)().afterReturn(new CustomPromise((resolve) => resolve({commit: () => {}})));

      await rdbstore.commit();

      mocker.ignoreMock(rdbstore, rdbstore.storePromise);
    });

    it('should_handle_error_when_storePromise_is_rejected', 0, async () => {
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(rdbstore, rdbstore.storePromise);
      when(mockfunc)().afterReturn(new CustomPromise((resolve, reject) => reject(new Error('storePromise rejected'))));

      await rdbstore.commit();

      mocker.ignoreMock(rdbstore, rdbstore.storePromise);
    });

    it('should_begin_transaction_successfully', 0, async () => {
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();

      await rdbstore.beginTransaction();

    });
    it('should_resolve_storePromise_when_initStore_success', 0, async () => {
      let context: ctx.Context = new ctx.Context();
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockInitStore: Function = mocker.mockFunc(relationalStore, relationalStore.getRdbStore);
      when(mockInitStore)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(new CustomPromise((resolve) => {
        resolve('success');
      }));

      await rdbstore.initStore(context);

      expect(rdbstore.storePromise).assertPromiseIsResolvedWith('success');

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(relationalStore, relationalStore.getRdbStore);
    });

    it('should_log_error_when_initStore_fails', 0, async () => {
      let context: ctx.Context = new ctx.Context();
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockInitStore: Function = mocker.mockFunc(relationalStore, relationalStore.getRdbStore);
      when(mockInitStore)(ArgumentMatchers.any, ArgumentMatchers.any).afterThrow('error');

      await rdbstore.initStore(context);

      expect(rdbstore.storePromise).assertPromiseIsRejectedWith('error');

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(relationalStore, relationalStore.getRdbStore);
    });

    it('should_retry_initStore_when_initStore_fails_and_retryTimes_less_than_MAX_RETRY_TIMES', 0, async () => {
      let context: ctx.Context = new ctx.Context();
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockInitStore: Function = mocker.mockFunc(relationalStore, relationalStore.getRdbStore);
      when(mockInitStore)(ArgumentMatchers.any, ArgumentMatchers.any).afterThrow('error');

      rdbstore.initRetryTimes = 0;
      await rdbstore.initStore(context);

      expect(rdbstore.initRetryTimes).assertEqual(1);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(relationalStore, relationalStore.getRdbStore);
    });

    it('should_not_retry_initStore_when_initStore_fails_and_retryTimes_greater_than_or_equal_to_MAX_RETRY_TIMES', 0, async () => {
      let context: ctx.Context = new ctx.Context();
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockInitStore: Function = mocker.mockFunc(relationalStore, relationalStore.getRdbStore);
      when(mockInitStore)(ArgumentMatchers.any, ArgumentMatchers.any).afterThrow('error');

      rdbstore.initRetryTimes = MAX_RETRY_TIMES;
      await rdbstore.initStore(context);

      expect(rdbstore.initRetryTimes).assertEqual(MAX_RETRY_TIMES);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(relationalStore, relationalStore.getRdbStore);
    });

    it('should_call_store_commit_when_storePromise_is_resolved', 0, async () => {
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(rdbstore, rdbstore.storePromise);
      when(mockfunc)().afterReturn(new CustomPromise((resolve) => resolve({commit: () => {}})));

      await rdbstore.commit();

      mocker.ignoreMock(rdbstore, rdbstore.storePromise);
    });

    it('should_handle_error_when_storePromise_is_rejected', 0, async () => {
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(rdbstore, rdbstore.storePromise);
      when(mockfunc)().afterReturn(new CustomPromise((resolve, reject) => reject(new Error('storePromise rejected'))));

      await rdbstore.commit();

      mocker.ignoreMock(rdbstore, rdbstore.storePromise);
    });

    it('should_begin_transaction_successfully', 0, async () => {
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();

      await rdbstore.beginTransaction();

    });
    it('should_resolve_storePromise_when_initStore_success', 0, async () => {
      let context: ctx.Context = new ctx.Context();
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockInitStore: Function = mocker.mockFunc(relationalStore, relationalStore.getRdbStore);
      when(mockInitStore)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(new CustomPromise((resolve) => {
        resolve('success');
      }));

      await rdbstore.initStore(context);

      expect(rdbstore.storePromise).assertPromiseIsResolvedWith('success');

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(relationalStore, relationalStore.getRdbStore);
    });

    it('should_log_error_when_initStore_fails', 0, async () => {
      let context: ctx.Context = new ctx.Context();
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockInitStore: Function = mocker.mockFunc(relationalStore, relationalStore.getRdbStore);
      when(mockInitStore)(ArgumentMatchers.any, ArgumentMatchers.any).afterThrow('error');

      await rdbstore.initStore(context);

      expect(rdbstore.storePromise).assertPromiseIsRejectedWith('error');

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(relationalStore, relationalStore.getRdbStore);
    });

    it('should_retry_initStore_when_initStore_fails_and_retryTimes_less_than_MAX_RETRY_TIMES', 0, async () => {
      let context: ctx.Context = new ctx.Context();
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockInitStore: Function = mocker.mockFunc(relationalStore, relationalStore.getRdbStore);
      when(mockInitStore)(ArgumentMatchers.any, ArgumentMatchers.any).afterThrow('error');

      rdbstore.initRetryTimes = 0;
      await rdbstore.initStore(context);

      expect(rdbstore.initRetryTimes).assertEqual(1);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(relationalStore, relationalStore.getRdbStore);
    });

    it('should_not_retry_initStore_when_initStore_fails_and_retryTimes_greater_than_or_equal_to_MAX_RETRY_TIMES', 0, async () => {
      let context: ctx.Context = new ctx.Context();
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockInitStore: Function = mocker.mockFunc(relationalStore, relationalStore.getRdbStore);
      when(mockInitStore)(ArgumentMatchers.any, ArgumentMatchers.any).afterThrow('error');

      rdbstore.initRetryTimes = MAX_RETRY_TIMES;
      await rdbstore.initStore(context);

      expect(rdbstore.initRetryTimes).assertEqual(MAX_RETRY_TIMES);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(relationalStore, relationalStore.getRdbStore);
    });

    it('should_call_store_commit_when_storePromise_is_resolved', 0, async () => {
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(rdbstore, rdbstore.storePromise);
      when(mockfunc)().afterReturn(new CustomPromise((resolve) => resolve({commit: () => {}})));

      await rdbstore.commit();

      mocker.ignoreMock(rdbstore, rdbstore.storePromise);
    });

    it('should_handle_error_when_storePromise_is_rejected', 0, async () => {
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(rdbstore, rdbstore.storePromise);
      when(mockfunc)().afterReturn(new CustomPromise((resolve, reject) => reject(new Error('storePromise rejected'))));

      await rdbstore.commit();

      mocker.ignoreMock(rdbstore, rdbstore.storePromise);
    });

    it('should_begin_transaction_successfully', 0, async () => {
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();

      await rdbstore.beginTransaction();

    });
    it('should_resolve_storePromise_when_initStore_success', 0, async () => {
      let context: ctx.Context = new ctx.Context();
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockInitStore: Function = mocker.mockFunc(relationalStore, relationalStore.getRdbStore);
      when(mockInitStore)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(new CustomPromise((resolve) => {
        resolve('success');
      }));

      await rdbstore.initStore(context);

      expect(rdbstore.storePromise).assertPromiseIsResolvedWith('success');

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(relationalStore, relationalStore.getRdbStore);
    });

    it('should_log_error_when_initStore_fails', 0, async () => {
      let context: ctx.Context = new ctx.Context();
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockInitStore: Function = mocker.mockFunc(relationalStore, relationalStore.getRdbStore);
      when(mockInitStore)(ArgumentMatchers.any, ArgumentMatchers.any).afterThrow('error');

      await rdbstore.initStore(context);

      expect(rdbstore.storePromise).assertPromiseIsRejectedWith('error');

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(relationalStore, relationalStore.getRdbStore);
    });

    it('should_retry_initStore_when_initStore_fails_and_retryTimes_less_than_MAX_RETRY_TIMES', 0, async () => {
      let context: ctx.Context = new ctx.Context();
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockInitStore: Function = mocker.mockFunc(relationalStore, relationalStore.getRdbStore);
      when(mockInitStore)(ArgumentMatchers.any, ArgumentMatchers.any).afterThrow('error');

      rdbstore.initRetryTimes = 0;
      await rdbstore.initStore(context);

      expect(rdbstore.initRetryTimes).assertEqual(1);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(relationalStore, relationalStore.getRdbStore);
    });

    it('should_not_retry_initStore_when_initStore_fails_and_retryTimes_greater_than_or_equal_to_MAX_RETRY_TIMES', 0, async () => {
      let context: ctx.Context = new ctx.Context();
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockInitStore: Function = mocker.mockFunc(relationalStore, relationalStore.getRdbStore);
      when(mockInitStore)(ArgumentMatchers.any, ArgumentMatchers.any).afterThrow('error');

      rdbstore.initRetryTimes = MAX_RETRY_TIMES;
      await rdbstore.initStore(context);

      expect(rdbstore.initRetryTimes).assertEqual(MAX_RETRY_TIMES);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(relationalStore, relationalStore.getRdbStore);
    });

    it('should_call_store_commit_when_storePromise_is_resolved', 0, async () => {
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(rdbstore, rdbstore.storePromise);
      when(mockfunc)().afterReturn(new CustomPromise((resolve) => resolve({commit: () => {}})));

      await rdbstore.commit();

      mocker.ignoreMock(rdbstore, rdbstore.storePromise);
    });

    it('should_handle_error_when_storePromise_is_rejected', 0, async () => {
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(rdbstore, rdbstore.storePromise);
      when(mockfunc)().afterReturn(new CustomPromise((resolve, reject) => reject(new Error('storePromise rejected'))));

      await rdbstore.commit();

      mocker.ignoreMock(rdbstore, rdbstore.storePromise);
    });

    it('should_begin_transaction_successfully', 0, async () => {
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();

      await rdbstore.beginTransaction();

    });
    it('should_handle_error_when_storePromise_is_rejected', 0, async () => {
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(rdbstore, rdbstore.storePromise);
      when(mockfunc)().afterReturn(new CustomPromise((resolve, reject) => reject(new Error('storePromise rejected'))));

      await rdbstore.commit();

      mocker.ignoreMock(rdbstore, rdbstore.storePromise);
    });

    it('should_begin_transaction_successfully', 0, async () => {
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();

      await rdbstore.beginTransaction();

    });
    it('should_begin_transaction_successfully', 0, async () => {
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();

      await rdbstore.beginTransaction();

    });
    it('should_handle_error_when_storePromise_is_rejected', 0, async () => {
      let rdbstore: RdbStore = RdbStore.INSTANCE;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(rdbstore, rdbstore.storePromise);
      when(mockfunc)().afterReturn(new CustomPromise((resolve, reject) => reject(new Error('storePromise rejected'))));

      await rdbstore.commit();

      mocker.ignoreMock(rdbstore, rdbstore.storePromise);
    });

  });
}
