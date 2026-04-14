/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import { commonEventManager, osAccount } from '@kit.BasicServicesKit';
import { bundleManager } from '@kit.AbilityKit';
import process from '@ohos.process';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { NotificationConfigEntity, PinTopConfigCommand } from '../../../main/ets/model/NotificationConfigEntity';
import { SystemuiConstants } from '../../../main/ets/constants/SystemuiConstants';
import { SCBConstants } from '@ohos/commonconstants/src/main/ets/constants/SCBConstants';
import {
  NotificationConfigEvent,
  NotificationConfigEventType,
  NotificationConfigHideBannerContentEvent,
  NotificationConfigPinTopEvent,
} from '../../../main/ets/model/NotificationConfigEvent';
import { BundleResource } from '../../../main/ets/utils/BundleResourceUtil';
import { HideBannerContentType } from '../../../main/ets/constants/HideBannerContentType';
import { LogWithHa } from '../../../main/ets/maintenance/CommonExceptionMaintenance';
import { CommonExceptionCode } from '../../../main/ets/maintenance/CommonExceptionCode';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationConfigBaseManager } from '../../../main/ets/manager/NotificationConfigBaseManager';
export default function NotificationConfigBaseManagerTest() {
  describe('getPinTopCount_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_count_when_pin_top_is_true_for_user', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();
      let notificationConfigEntity: NotificationConfigEntity = new NotificationConfigEntity();
      let mockfunc: Function = mocker.mockFunc(notificationConfigEntity, notificationConfigEntity.queryCount);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(5);
      let predicates: TablePredicates = NotificationConfigEntity.getPredicates();
      let mockfunc2: Function = mocker.mockFunc(predicates, predicates.equalTo);
      when(mockfunc2)({ pinTop: true, userId: notificationconfigbasemanager.userId }).afterReturn(predicates);

      const result = await notificationconfigbasemanager.getPinTopCount();
      expect(result).assertEqual(5);
      mocker.ignoreMock(notificationConfigEntity, notificationConfigEntity.queryCount);
      mocker.ignoreMock(predicates, predicates.equalTo);
    });

    it('should_return_count_when_pin_top_is_false_for_user', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();
      let notificationConfigEntity: NotificationConfigEntity = new NotificationConfigEntity();
      let mockfunc: Function = mocker.mockFunc(notificationConfigEntity, notificationConfigEntity.queryCount);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(0);
      let predicates: TablePredicates = NotificationConfigEntity.getPredicates();
      let mockfunc2: Function = mocker.mockFunc(predicates, predicates.equalTo);
      when(mockfunc2)({ pinTop: false, userId: notificationconfigbasemanager.userId }).afterReturn(predicates);

      const result = await notificationconfigbasemanager.getPinTopCount();
      expect(result).assertEqual(0);
      mocker.ignoreMock(notificationConfigEntity, notificationConfigEntity.queryCount);
      mocker.ignoreMock(predicates, predicates.equalTo);
    });

    it('should_return_pin_top_list_when_query_success', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();

      let mockEqualToFunc: Function = mocker.mockFunc(NotificationConfigEntity.Predicates, NotificationConfigEntity.Predicates.equalTo);
      when(mockEqualToFunc)([ArgumentMatchers.anyObj]).afterReturn(NotificationConfigEntity.Predicates);

      let mockQueryListFunc: Function = mocker.mockFunc(NotificationConfigEntity, NotificationConfigEntity.queryList);
      let mockEntities: NotificationConfigEntity[] = [
        new NotificationConfigEntity(),
        new NotificationConfigEntity()
      ];
      when(mockQueryListFunc)([ArgumentMatchers.anyObj]).afterReturn(mockEntities);

      const result = await notificationconfigbasemanager.getPinTopList();
      expect(result.length).assertEqual(2);
      mocker.ignoreMock(NotificationConfigEntity.Predicates, NotificationConfigEntity.Predicates.equalTo);
      mocker.ignoreMock(NotificationConfigEntity, NotificationConfigEntity.queryList);
    });

    it('should_return_empty_list_when_query_fails', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();

      let mockEqualToFunc: Function = mocker.mockFunc(NotificationConfigEntity.Predicates, NotificationConfigEntity.Predicates.equalTo);
      when(mockEqualToFunc)([ArgumentMatchers.anyObj]).afterReturn(NotificationConfigEntity.Predicates);

      let mockQueryListFunc: Function = mocker.mockFunc(NotificationConfigEntity, NotificationConfigEntity.queryList);
      when(mockQueryListFunc)([ArgumentMatchers.anyObj]).afterThrow("Query failed");

      const result = await notificationconfigbasemanager.getPinTopList();
      expect(result.length).assertEqual(0);
      mocker.ignoreMock(NotificationConfigEntity.Predicates, NotificationConfigEntity.Predicates.equalTo);
      mocker.ignoreMock(NotificationConfigEntity, NotificationConfigEntity.queryList);
    });

    it('should_return_false_when_queryByProps_throws_error', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
      when(mockfunc)(ArgumentMatchers.any).afterThrow("Error");
      const result = await notificationconfigbasemanager.getPinTopState(1);
      expect(result).assertEqual(false);
      mocker.ignoreMock(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
    });

    it('should_return_false_when_queryByProps_returns_null', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      const result = await notificationconfigbasemanager.getPinTopState(1);
      expect(result).assertEqual(false);
      mocker.ignoreMock(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
    });

    it('should_return_true_when_queryByProps_returns_pinTop_true', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
      let config: NotificationConfigEntity = {
        uid: 1,
        pinTop: true
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(config);
      const result = await notificationconfigbasemanager.getPinTopState(1);
      expect(result).assertEqual(true);
      mocker.ignoreMock(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
    });

    it('should_return_false_when_queryByProps_returns_pinTop_false', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
      let config: NotificationConfigEntity = {
        uid: 1,
        pinTop: false
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(config);
      const result = await notificationconfigbasemanager.getPinTopState(1);
      expect(result).assertEqual(false);
      mocker.ignoreMock(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
    });

    it('should_return_false_when_queryByProps_returns_pinTop_undefined', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
      let config: NotificationConfigEntity = {
        uid: 1,
        pinTop: undefined
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(config);
      const result = await notificationconfigbasemanager.getPinTopState(1);
      expect(result).assertEqual(false);
      mocker.ignoreMock(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
    });

    it('should_return_false_when_queryByProps_returns_pinTop_null', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
      let config: NotificationConfigEntity = {
        uid: 1,
        pinTop: null
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(config);
      const result = await notificationconfigbasemanager.getPinTopState(1);
      expect(result).assertEqual(false);
      mocker.ignoreMock(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
    });

    it('should_return_false_when_queryByProps_returns_pinTop_empty_object', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
      let config: NotificationConfigEntity = {
        uid: 1,
        pinTop: {}
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(config);
      const result = await notificationconfigbasemanager.getPinTopState(1);
      expect(result).assertEqual(false);
      mocker.ignoreMock(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
    });

    it('should_return_false_when_queryByProps_returns_pinTop_other_values', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
      let config: NotificationConfigEntity = {
        uid: 1,
        pinTop: "some other value"
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(config);
      const result = await notificationconfigbasemanager.getPinTopState(1);
      expect(result).assertEqual(false);
      mocker.ignoreMock(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
    });
    it('should_return_count_when_pin_top_is_true_for_user', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();
      let notificationConfigEntity: NotificationConfigEntity = new NotificationConfigEntity();
      let mockfunc: Function = mocker.mockFunc(notificationConfigEntity, notificationConfigEntity.queryCount);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(5);
      let predicates: TablePredicates = NotificationConfigEntity.getPredicates();
      let mockfunc2: Function = mocker.mockFunc(predicates, predicates.equalTo);
      when(mockfunc2)({ pinTop: true, userId: notificationconfigbasemanager.userId }).afterReturn(predicates);

      const result = await notificationconfigbasemanager.getPinTopCount();
      expect(result).assertEqual(5);
      mocker.ignoreMock(notificationConfigEntity, notificationConfigEntity.queryCount);
      mocker.ignoreMock(predicates, predicates.equalTo);
    });

    it('should_return_count_when_pin_top_is_false_for_user', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();
      let notificationConfigEntity: NotificationConfigEntity = new NotificationConfigEntity();
      let mockfunc: Function = mocker.mockFunc(notificationConfigEntity, notificationConfigEntity.queryCount);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(0);
      let predicates: TablePredicates = NotificationConfigEntity.getPredicates();
      let mockfunc2: Function = mocker.mockFunc(predicates, predicates.equalTo);
      when(mockfunc2)({ pinTop: false, userId: notificationconfigbasemanager.userId }).afterReturn(predicates);

      const result = await notificationconfigbasemanager.getPinTopCount();
      expect(result).assertEqual(0);
      mocker.ignoreMock(notificationConfigEntity, notificationConfigEntity.queryCount);
      mocker.ignoreMock(predicates, predicates.equalTo);
    });

    it('should_return_pin_top_list_when_query_success', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();

      let mockEqualToFunc: Function = mocker.mockFunc(NotificationConfigEntity.Predicates, NotificationConfigEntity.Predicates.equalTo);
      when(mockEqualToFunc)([ArgumentMatchers.anyObj]).afterReturn(NotificationConfigEntity.Predicates);

      let mockQueryListFunc: Function = mocker.mockFunc(NotificationConfigEntity, NotificationConfigEntity.queryList);
      let mockEntities: NotificationConfigEntity[] = [
        new NotificationConfigEntity(),
        new NotificationConfigEntity()
      ];
      when(mockQueryListFunc)([ArgumentMatchers.anyObj]).afterReturn(mockEntities);

      const result = await notificationconfigbasemanager.getPinTopList();
      expect(result.length).assertEqual(2);
      mocker.ignoreMock(NotificationConfigEntity.Predicates, NotificationConfigEntity.Predicates.equalTo);
      mocker.ignoreMock(NotificationConfigEntity, NotificationConfigEntity.queryList);
    });

    it('should_return_empty_list_when_query_fails', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();

      let mockEqualToFunc: Function = mocker.mockFunc(NotificationConfigEntity.Predicates, NotificationConfigEntity.Predicates.equalTo);
      when(mockEqualToFunc)([ArgumentMatchers.anyObj]).afterReturn(NotificationConfigEntity.Predicates);

      let mockQueryListFunc: Function = mocker.mockFunc(NotificationConfigEntity, NotificationConfigEntity.queryList);
      when(mockQueryListFunc)([ArgumentMatchers.anyObj]).afterThrow("Query failed");

      const result = await notificationconfigbasemanager.getPinTopList();
      expect(result.length).assertEqual(0);
      mocker.ignoreMock(NotificationConfigEntity.Predicates, NotificationConfigEntity.Predicates.equalTo);
      mocker.ignoreMock(NotificationConfigEntity, NotificationConfigEntity.queryList);
    });

    it('should_return_false_when_queryByProps_throws_error', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
      when(mockfunc)(ArgumentMatchers.any).afterThrow("Error");
      const result = await notificationconfigbasemanager.getPinTopState(1);
      expect(result).assertEqual(false);
      mocker.ignoreMock(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
    });

    it('should_return_false_when_queryByProps_returns_null', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      const result = await notificationconfigbasemanager.getPinTopState(1);
      expect(result).assertEqual(false);
      mocker.ignoreMock(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
    });

    it('should_return_true_when_queryByProps_returns_pinTop_true', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
      let config: NotificationConfigEntity = {
        uid: 1,
        pinTop: true
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(config);
      const result = await notificationconfigbasemanager.getPinTopState(1);
      expect(result).assertEqual(true);
      mocker.ignoreMock(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
    });

    it('should_return_false_when_queryByProps_returns_pinTop_false', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
      let config: NotificationConfigEntity = {
        uid: 1,
        pinTop: false
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(config);
      const result = await notificationconfigbasemanager.getPinTopState(1);
      expect(result).assertEqual(false);
      mocker.ignoreMock(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
    });

    it('should_return_false_when_queryByProps_returns_pinTop_undefined', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
      let config: NotificationConfigEntity = {
        uid: 1,
        pinTop: undefined
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(config);
      const result = await notificationconfigbasemanager.getPinTopState(1);
      expect(result).assertEqual(false);
      mocker.ignoreMock(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
    });

    it('should_return_false_when_queryByProps_returns_pinTop_null', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
      let config: NotificationConfigEntity = {
        uid: 1,
        pinTop: null
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(config);
      const result = await notificationconfigbasemanager.getPinTopState(1);
      expect(result).assertEqual(false);
      mocker.ignoreMock(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
    });

    it('should_return_false_when_queryByProps_returns_pinTop_empty_object', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
      let config: NotificationConfigEntity = {
        uid: 1,
        pinTop: {}
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(config);
      const result = await notificationconfigbasemanager.getPinTopState(1);
      expect(result).assertEqual(false);
      mocker.ignoreMock(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
    });

    it('should_return_false_when_queryByProps_returns_pinTop_other_values', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
      let config: NotificationConfigEntity = {
        uid: 1,
        pinTop: "some other value"
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(config);
      const result = await notificationconfigbasemanager.getPinTopState(1);
      expect(result).assertEqual(false);
      mocker.ignoreMock(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
    });
    it('should_return_count_when_pin_top_is_true_for_user', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();
      let notificationConfigEntity: NotificationConfigEntity = new NotificationConfigEntity();
      let mockfunc: Function = mocker.mockFunc(notificationConfigEntity, notificationConfigEntity.queryCount);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(5);
      let predicates: TablePredicates = NotificationConfigEntity.getPredicates();
      let mockfunc2: Function = mocker.mockFunc(predicates, predicates.equalTo);
      when(mockfunc2)({ pinTop: true, userId: notificationconfigbasemanager.userId }).afterReturn(predicates);

      const result = await notificationconfigbasemanager.getPinTopCount();
      expect(result).assertEqual(5);
      mocker.ignoreMock(notificationConfigEntity, notificationConfigEntity.queryCount);
      mocker.ignoreMock(predicates, predicates.equalTo);
    });

    it('should_return_count_when_pin_top_is_false_for_user', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();
      let notificationConfigEntity: NotificationConfigEntity = new NotificationConfigEntity();
      let mockfunc: Function = mocker.mockFunc(notificationConfigEntity, notificationConfigEntity.queryCount);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(0);
      let predicates: TablePredicates = NotificationConfigEntity.getPredicates();
      let mockfunc2: Function = mocker.mockFunc(predicates, predicates.equalTo);
      when(mockfunc2)({ pinTop: false, userId: notificationconfigbasemanager.userId }).afterReturn(predicates);

      const result = await notificationconfigbasemanager.getPinTopCount();
      expect(result).assertEqual(0);
      mocker.ignoreMock(notificationConfigEntity, notificationConfigEntity.queryCount);
      mocker.ignoreMock(predicates, predicates.equalTo);
    });

    it('should_return_pin_top_list_when_query_success', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();

      let mockEqualToFunc: Function = mocker.mockFunc(NotificationConfigEntity.Predicates, NotificationConfigEntity.Predicates.equalTo);
      when(mockEqualToFunc)([ArgumentMatchers.anyObj]).afterReturn(NotificationConfigEntity.Predicates);

      let mockQueryListFunc: Function = mocker.mockFunc(NotificationConfigEntity, NotificationConfigEntity.queryList);
      let mockEntities: NotificationConfigEntity[] = [
        new NotificationConfigEntity(),
        new NotificationConfigEntity()
      ];
      when(mockQueryListFunc)([ArgumentMatchers.anyObj]).afterReturn(mockEntities);

      const result = await notificationconfigbasemanager.getPinTopList();
      expect(result.length).assertEqual(2);
      mocker.ignoreMock(NotificationConfigEntity.Predicates, NotificationConfigEntity.Predicates.equalTo);
      mocker.ignoreMock(NotificationConfigEntity, NotificationConfigEntity.queryList);
    });

    it('should_return_empty_list_when_query_fails', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();

      let mockEqualToFunc: Function = mocker.mockFunc(NotificationConfigEntity.Predicates, NotificationConfigEntity.Predicates.equalTo);
      when(mockEqualToFunc)([ArgumentMatchers.anyObj]).afterReturn(NotificationConfigEntity.Predicates);

      let mockQueryListFunc: Function = mocker.mockFunc(NotificationConfigEntity, NotificationConfigEntity.queryList);
      when(mockQueryListFunc)([ArgumentMatchers.anyObj]).afterThrow("Query failed");

      const result = await notificationconfigbasemanager.getPinTopList();
      expect(result.length).assertEqual(0);
      mocker.ignoreMock(NotificationConfigEntity.Predicates, NotificationConfigEntity.Predicates.equalTo);
      mocker.ignoreMock(NotificationConfigEntity, NotificationConfigEntity.queryList);
    });

    it('should_return_false_when_queryByProps_throws_error', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
      when(mockfunc)(ArgumentMatchers.any).afterThrow("Error");
      const result = await notificationconfigbasemanager.getPinTopState(1);
      expect(result).assertEqual(false);
      mocker.ignoreMock(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
    });

    it('should_return_false_when_queryByProps_returns_null', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      const result = await notificationconfigbasemanager.getPinTopState(1);
      expect(result).assertEqual(false);
      mocker.ignoreMock(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
    });

    it('should_return_true_when_queryByProps_returns_pinTop_true', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
      let config: NotificationConfigEntity = {
        uid: 1,
        pinTop: true
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(config);
      const result = await notificationconfigbasemanager.getPinTopState(1);
      expect(result).assertEqual(true);
      mocker.ignoreMock(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
    });

    it('should_return_false_when_queryByProps_returns_pinTop_false', 0, async () => {
      let notificationconfigbasemanager: NotificationConfigBaseManager = new NotificationConfigBaseManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
      let config: NotificationConfigEntity = {
        uid: 1,
        pinTop: false
      };
      when(mockfunc)(ArgumentMatchers.any).afterReturn(config);
      const result = await notificationconfigbasemanager.getPinTopState(1);
      expect(result).assertEqual(false);
      mocker.ignoreMock(NotificationConfigEntity, NotificationConfigEntity.queryByProps);
    });

  });
}
