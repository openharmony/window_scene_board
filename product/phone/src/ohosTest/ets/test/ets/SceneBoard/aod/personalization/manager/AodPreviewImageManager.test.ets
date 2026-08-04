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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium'
import {
  AodPreviewImageManager
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/manager/AodPreviewImageManager'
import { commonEventManager } from '@kit.BasicServicesKit'
import { AodCommonEventBundleName, AodCommonEventPermission } from '@ohos/aodcommon'
import { AodPreviewImageRefreshReason as RefreshReason, } from '@ohos/aodcommon';
import { AodThemeParam } from '@ohos/aod'
import fs from '@ohos.file.fs';

export default function AodPreviewImageManagerTest() {
  describe('AodPreviewImageManagerTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('AodPreviewImageManager_getInstance', 0, () => {
      const instance0 = AodPreviewImageManager.getInstance();
      const instance1 = AodPreviewImageManager.getInstance();
      expect(instance0).assertDeepEquals(instance1);
    });

    it('AodPreviewImageManager_subscribeEvent', 0, async (done: Function) => {
      let aodPreviewImageManager: AodPreviewImageManager = AodPreviewImageManager.getInstance();
      aodPreviewImageManager.subscribeEvent();
      expect(aodPreviewImageManager).not().assertUndefined();
      done();
    });

    it('AodPreviewImageManager_unsubscribeEvent', 0, async (done: Function) => {
      const subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
        events: ['custom.event.REQUEST_REFRESH_AOD_PREVIEW_IMAGE'],
        publisherPermission: AodCommonEventPermission.ACTIVATE_THEME_PACKAGE,
        publisherBundleName: AodCommonEventBundleName.SCENE_BOARD,
        userId: 10,
      };
      let subscriber: Nullable<commonEventManager.CommonEventSubscriber> =
        await commonEventManager.createSubscriber(subscribeInfo);
      let aodPreviewImageManager: AodPreviewImageManager = AodPreviewImageManager.getInstance();
      (aodPreviewImageManager as object)['subscriber'] = subscriber;
      aodPreviewImageManager.unsubscribeEvent();
      expect(aodPreviewImageManager).not().assertUndefined();
      done();
    });

    it('AodPreviewImageManager_needRefresh1', 0, async (done: Function) => {
      let aodPreviewImageManager: AodPreviewImageManager = AodPreviewImageManager.getInstance();
      (aodPreviewImageManager as object)['needRefresh'](RefreshReason.RESET_VALUE);
      expect(aodPreviewImageManager).not().assertUndefined();
      done();
    });

    it('AodPreviewImageManager_needRefresh2', 0, async (done: Function) => {
      let aodPreviewImageManager: AodPreviewImageManager = AodPreviewImageManager.getInstance();
      (aodPreviewImageManager as object)['needRefresh'](RefreshReason.SHOW_PREVIEW_IMAGE);
      expect(aodPreviewImageManager).not().assertUndefined();
      done();
    });

    it('AodPreviewImageManager_needRefresh3', 0, async (done: Function) => {
      let aodPreviewImageManager: AodPreviewImageManager = AodPreviewImageManager.getInstance();
      (aodPreviewImageManager as object)['hasImageShown'] = true;
      (aodPreviewImageManager as object)['needRefresh'](RefreshReason.THEME_STYLE_CHANGE);
      expect(aodPreviewImageManager).not().assertUndefined();
      done();
    });

    it('AodPreviewImageManager_needRefresh4', 0, async (done: Function) => {
      let aodPreviewImageManager: AodPreviewImageManager = AodPreviewImageManager.getInstance();
      (aodPreviewImageManager as object)['needRefresh'](RefreshReason.LANGUAGE_CHANGE);
      expect(aodPreviewImageManager).not().assertUndefined();
      done();
    });

    it('AodPreviewImageManager_needRefresh5', 0, async (done: Function) => {
      let aodPreviewImageManager: AodPreviewImageManager = AodPreviewImageManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc((aodPreviewImageManager as object), (aodPreviewImageManager as object)['isFontChange']);
      await when(mockFunction)().afterReturn(true);
      (aodPreviewImageManager as object)['needRefresh'](RefreshReason.OTHER_CONFIGURATION_CHANGE);
      expect(aodPreviewImageManager).not().assertUndefined();
      mocker.clear((aodPreviewImageManager as object));
      mocker.clearAll();
      done();
    });

    it('AodPreviewImageManager_needRefresh6', 0, async (done: Function) => {
      let aodPreviewImageManager: AodPreviewImageManager = AodPreviewImageManager.getInstance();
      (aodPreviewImageManager as object)['needRefresh'](RefreshReason.START_UP);
      expect(aodPreviewImageManager).not().assertUndefined();
      done();
    });

    it('AodPreviewImageManager_isFontChange', 0, async (done: Function) => {
      let aodPreviewImageManager: AodPreviewImageManager = AodPreviewImageManager.getInstance();
      (aodPreviewImageManager as object)['isFontChange']();
      expect(aodPreviewImageManager).not().assertUndefined();
      done();
    });

    it('AodPreviewImageManager_getFontId', 0, async (done: Function) => {
      let aodPreviewImageManager: AodPreviewImageManager = AodPreviewImageManager.getInstance();
      (aodPreviewImageManager as object)['getFontId']('path');
      expect(aodPreviewImageManager).not().assertUndefined();
      done();
    });

    it('AodPreviewImageManager_getThemeParam', 0, () => {
      let aodPreviewImageManager: AodPreviewImageManager = AodPreviewImageManager.getInstance();
      aodPreviewImageManager.getThemeParam();
      expect(aodPreviewImageManager).not().assertUndefined();
    });

    it('AodPreviewImageManager_loadThemeParam', 0, async (done: Function) => {
      let aodPreviewImageManager: AodPreviewImageManager = AodPreviewImageManager.getInstance();
      aodPreviewImageManager.loadThemeParam(RefreshReason.START_UP);
      expect(aodPreviewImageManager).not().assertUndefined();
      done();
    });

    it('AodPreviewImageManager_refreshPreviewImage', 0, async (done: Function) => {
      let aodPreviewImageManager: AodPreviewImageManager = AodPreviewImageManager.getInstance();
      let aodThemeParam: AodThemeParam = new AodThemeParam();
      let builder: CustomBuilder = () => {
      };
      aodPreviewImageManager.refreshPreviewImage(RefreshReason.START_UP, aodThemeParam, builder);
      expect(aodPreviewImageManager).not().assertUndefined();
      done();
    });

    it('AodPreviewImageManager_createPreviewImage1', 0, async (done: Function) => {
      let aodPreviewImageManager: AodPreviewImageManager = AodPreviewImageManager.getInstance();
      let builder: CustomBuilder = () => {
      };
      (aodPreviewImageManager as object)['createPreviewImage'](RefreshReason.START_UP, builder);
      expect(aodPreviewImageManager).not().assertUndefined();
      done();
    });

    it('AodPreviewImageManager_createPreviewImage2', 0, async (done: Function) => {
      let aodPreviewImageManager: AodPreviewImageManager = AodPreviewImageManager.getInstance();
      let builder: CustomBuilder = () => {
      };
      (aodPreviewImageManager as object)['createPreviewImage'](RefreshReason.SHOW_PREVIEW_IMAGE, builder);
      expect(aodPreviewImageManager).not().assertUndefined();
      done();
    });

    it('AodPreviewImageManager_publishEvent', 0, () => {
      let aodPreviewImageManager: AodPreviewImageManager = AodPreviewImageManager.getInstance();
      (aodPreviewImageManager as object)['publishEvent']();
      expect(aodPreviewImageManager).not().assertUndefined();
    });

    it('AodPreviewImageManager_closeFile1', 0, () => {
      let aodPreviewImageManager: AodPreviewImageManager = AodPreviewImageManager.getInstance();
      (aodPreviewImageManager as object)['closeFile'](undefined);
      expect(aodPreviewImageManager).not().assertUndefined();
    });

    it('AodPreviewImageManager_closeFile2', 0, async (done: Function) => {
      let file =
        await fs.open('/data/themes/s/aod/settings_preview_image.jpg', fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      let aodPreviewImageManager: AodPreviewImageManager = AodPreviewImageManager.getInstance();
      (aodPreviewImageManager as object)['closeFile'](file);
      expect(aodPreviewImageManager).not().assertUndefined();
      done();
    });

  })
}