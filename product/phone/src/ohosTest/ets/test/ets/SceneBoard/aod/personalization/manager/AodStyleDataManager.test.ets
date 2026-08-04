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
import { AodManifest, AodThemeConstants, AodThemeUtil } from '@ohos/aod';

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium'
import {
  AodStyleDataManager
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/manager/AodStyleDataManager';
import {
  PageController
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/controller/PageController';
import { common, UIExtensionAbility } from '@kit.AbilityKit';
import { StyleGroupName } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/constant/Constant';
import { AodDescription } from '@ohos/aod/src/main/ets/model/AodThemeConfig';
import {
  AodStyleGroupConfig
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/config/AodStyleGroupConfig';
import {
  AodStyleGroupListModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/model/AodStyleGroupListModel';
import {
  AodStyleGroupModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/model/AodStyleGroupModel';

export function AodStyleDataManagerTest() {
  let mocker = new MockKit();
  describe('AodStyleDataManagerTest', () => {

    beforeAll((): void => {

    })

    beforeEach((): void => {

    })

    afterEach((): void => {

    })

    afterAll((): void => {

    })

    it('only_one_instance_when_call_any_times_of_getInstance', 0, () => {
      const instance0 = AodStyleDataManager.getInstance();
      const instance1 = AodStyleDataManager.getInstance();
      expect(instance0).assertDeepEquals(instance1);
    });

    it('AodStyleDataManagerTest_parseData', 0, () => {
      const instance = AodStyleDataManager.getInstance();
      let aodStyleDataManagerTestClass = new AodStyleDataManagerTestClass();
      instance.parseData();
      expect(instance !== null).assertEqual(true);
    });

    it('AodStyleDataManagerTest_parseData1', 0, () => {
      const instance = AodStyleDataManager.getInstance();
      let aodStyleDataManagerTestClass = new AodStyleDataManagerTestClass();
      instance.parseData();
      expect(instance !== null).assertEqual(true);
    });

    it('AodStyleDataManagerTest_refreshFullScreenGroup', 0, () => {
      const instance = AodStyleDataManager.getInstance();
      instance.refreshFullScreenGroup(true);
      expect(instance !== null).assertEqual(true);
    });

    it('AodStyleDataManagerTest_refreshFullScreenGroup1', 0, () => {
      const instance = AodStyleDataManager.getInstance();
      instance.refreshFullScreenGroup(false);
      expect(instance !== null).assertEqual(true);
    });

    it('AodStyleDataManagerTest_getStyleListConfig', 0, () => {
      const instance = AodStyleDataManager.getInstance();
      let aodStyleGroupModel: Map<StyleGroupName, Array<AodManifest>> = (instance as object)['styleListConfig'];
      let model = aodStyleGroupModel.get(StyleGroupName.FULL_SCREEN);
      let result = instance.getStyleListConfig(StyleGroupName.FULL_SCREEN);
      expect(result).assertEqual(model);
    });

    it('AodStyleDataManagerTest_getAllStyleGroup', 0, () => {
      const instance = AodStyleDataManager.getInstance();
      let aodStyleGroupListModel: AodStyleGroupListModel = (instance as object)['allStyleGroup'];
      let result = instance.getAllStyleGroup();
      expect(result).assertEqual(aodStyleGroupListModel);
    });

    it('AodStyleDataManagerTest_getDescription', 0, () => {
      const instance = AodStyleDataManager.getInstance();
      let aodDescription: AodDescription = (instance as object)['description'];
      let result = instance.getDescription();
      expect(result).assertEqual(aodDescription);
    });

    it('AodStyleDataManagerTest_setDescription', 0, () => {
      const instance = AodStyleDataManager.getInstance();
      let aodDescription: AodDescription = (instance as object)['description'];
      instance.setDescription(aodDescription);
      expect(instance).not().assertUndefined();
    });

    it('AodStyleDataManagerTest_refreshFullScreenGroup2', 0, () => {
      const instance = AodStyleDataManager.getInstance();
      let aodStyleGroupModel: AodStyleGroupModel = new AodStyleGroupModel();
      aodStyleGroupModel.name = StyleGroupName.FULL_SCREEN;
      let styleGroup: AodStyleGroupListModel = new AodStyleGroupListModel();
      styleGroup.push(aodStyleGroupModel);
      let mockerFun: Function = mocker.mockFunc(instance, instance.getAllStyleGroup);
      when(mockerFun)().afterReturn(styleGroup);
      instance.refreshFullScreenGroup(true);
      expect(instance).not().assertUndefined();
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('AodStyleDataManagerTest_isNeedRefresh1', 0, () => {
      const instance = AodStyleDataManager.getInstance();
      let aodStyleGroupConfig: AodStyleGroupConfig = new AodStyleGroupConfig();
      let aodStyleGroupModel: AodStyleGroupModel = new AodStyleGroupModel();
      (instance as object)['isNeedRefresh'](aodStyleGroupConfig, aodStyleGroupModel);
      expect(instance).not().assertUndefined();
    });

    it('AodStyleDataManagerTest_isNeedRefresh2', 0, () => {
      const instance = AodStyleDataManager.getInstance();
      let aodStyleGroupConfig: AodStyleGroupConfig = new AodStyleGroupConfig();
      let aodStyleGroupModel: AodStyleGroupModel = new AodStyleGroupModel();
      aodStyleGroupConfig.groupName = StyleGroupName.MY_DOWNLOAD;
      (instance as object)['isNeedRefresh'](aodStyleGroupConfig, aodStyleGroupModel);
      expect(instance).not().assertUndefined();
    });

    it('AodStyleDataManagerTest_isNeedRefresh3', 0, () => {
      const instance = AodStyleDataManager.getInstance();
      let aodStyleGroupConfig: AodStyleGroupConfig = new AodStyleGroupConfig();
      let aodStyleGroupModel: AodStyleGroupModel = new AodStyleGroupModel();
      aodStyleGroupModel.name = StyleGroupName.FULL_SCREEN;
      (instance as object)['isNeedRefresh'](aodStyleGroupConfig, aodStyleGroupModel);
      expect(instance).not().assertUndefined();
    });

    it('AodStyleDataManagerTest_isNeedRefresh4', 0, () => {
      const instance = AodStyleDataManager.getInstance();
      let aodStyleGroupConfig: AodStyleGroupConfig = new AodStyleGroupConfig();
      let aodStyleGroupModel: AodStyleGroupModel = new AodStyleGroupModel();
      aodStyleGroupConfig.groupName = StyleGroupName.MY_DOWNLOAD;
      aodStyleGroupModel.name = StyleGroupName.FULL_SCREEN;
      (instance as object)['isNeedRefresh'](aodStyleGroupConfig, aodStyleGroupModel);
      expect(instance).not().assertUndefined();
    });

    it('AodStyleDataManagerTest_getCurrentStyleId1', 0, () => {
      let manifest: AodManifest = new AodManifest();
      manifest.type = AodThemeConstants.FULL_SCREEN;
      const instance = AodStyleDataManager.getInstance();
      (instance as object)['getCurrentStyleId'](manifest);
      expect(instance).not().assertUndefined();
    });

    it('AodStyleDataManagerTest_getCurrentStyleId2', 0, () => {
      let manifest: AodManifest = new AodManifest();
      manifest.type = AodThemeConstants.OUTER_CLOCK_STYLE;
      const instance = AodStyleDataManager.getInstance();
      (instance as object)['getCurrentStyleId'](manifest);
      expect(instance).not().assertUndefined();
    });

    it('AodStyleDataManagerTest_loadThemeStyleGroupConfig1', 0, async (done: Function) => {
      const instance = AodStyleDataManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(AodThemeUtil, AodThemeUtil.getThemeOriginPath);
      when(mockFunction)().afterReturn('');
      (instance as object)['loadThemeStyleGroupConfig']();
      expect(instance).not().assertUndefined();
      mocker.clear(AodThemeUtil);
      mocker.clearAll();
      done();
    });

    it('AodStyleDataManagerTest_loadThemeStyleGroupConfig2', 0, async (done: Function) => {
      const instance = AodStyleDataManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(AodThemeUtil, AodThemeUtil.getThemeOriginPath);
      when(mockFunction)().afterReturn('themePath');
      (instance as object)['loadThemeStyleGroupConfig']();
      expect(instance).not().assertUndefined();
      mocker.clear(AodThemeUtil);
      mocker.clearAll();
      done();
    });

    it('AodStyleDataManagerTest_loadOnlineStyleGroupConfig', 0, async (done: Function) => {
      const instance = AodStyleDataManager.getInstance();
      (instance as object)['loadOnlineStyleGroupConfig']();
      expect(instance).not().assertUndefined();
      done();
    });

    it('AodStyleDataManagerTest_loadPresetConfig', 0, async (done: Function) => {
      const instance = AodStyleDataManager.getInstance();
      (instance as object)['loadPresetConfig']();
      expect(instance).not().assertUndefined();
      done();
    });
  });

  class AodStyleDataManagerTestClass extends UIExtensionAbility {
    public getContext(): common.UIExtensionContext {
      return this.context;
    }
  }

}