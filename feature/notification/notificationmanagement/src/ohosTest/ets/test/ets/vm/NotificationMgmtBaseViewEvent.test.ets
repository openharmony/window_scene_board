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
import { afterEach, beforeEach, describe, it } from "@ohos/hypium";
import { NotificationMgmtModel } from "../../../../../main/ets/model/NotificationMgmtModel";
import { NotificationMgmtBaseViewEvent } from "../../../../../main/ets/vm/NotificationMgmtBaseViewEvent";

export default function NotificationMgmtBaseViewEventTest() {
  describe('initModel_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });
    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });
    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });


    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });
    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });
    it('should_initialize_model_with_valid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 12345
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertEqual(12345);
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });

    it('should_initialize_model_with_invalid_appInfo', 0, () => {
      let notificationmgmtbaseviewevent: NotificationMgmtBaseViewEvent = new NotificationMgmtBaseViewEvent();
      let appInfo: ESObject = {
        appBundleName: 'com.example.app',
        appUid: 'invalidUid'
      };
      notificationmgmtbaseviewevent.initModel(appInfo);
      expect(notificationmgmtbaseviewevent.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model).assertInstanceOf(NotificationMgmtModel);
      expect(notificationmgmtbaseviewevent.model?.bundleName).assertEqual('com.example.app');
      expect(notificationmgmtbaseviewevent.model?.uid).assertUndefined();
    });
  });
}
