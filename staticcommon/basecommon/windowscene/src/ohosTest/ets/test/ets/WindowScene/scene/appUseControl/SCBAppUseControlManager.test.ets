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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import { ReflectionUtils } from '../session/ReflectionUtils';
import {
  SCBAppUseControlManager,
  ControlType,
  ComponentBuilderParam,
  ControlAppInfo,
} from '../../../../../../../main/ets/scene/appUseControl/SCBAppUseControlManager';
import { SCBSceneMode } from '../../../../../../../main/ets/scene/session/SCBSceneInfo';


export function SCBAppUseControlManagerTest() {
  describe('SCBAppUseControlManagerTest', () => {
    beforeAll(() => {
      let componentBuilderParamMap = ReflectionUtils.getProperty(SCBAppUseControlManager.getInstance(),
        'componentBuilderParamMap') as Map<ControlType, ComponentBuilderParam>;
      componentBuilderParamMap.clear();
    });
    beforeEach(() => {
    });
    afterEach(() => {
    });
    afterAll(() => {
    });

    it('registerComponentBuilderParamTest', 0, async (done: Function) => {
      let useControlManager = SCBAppUseControlManager.getInstance();
      let componentBuilderParamMap = ReflectionUtils.getProperty(useControlManager,
        'componentBuilderParamMap') as Map<ControlType, ComponentBuilderParam>;
      expect(componentBuilderParamMap.size).assertEqual(0);
      let builderParam: ComponentBuilderParam = {
        loadBundleName: 'bundleName',
        loadAbilityName: 'ability',
        useControlMainMaskBuilder: () => {},
        useControlRecentMaskBuilder: () => {},
      };
      useControlManager.registerComponentBuilderParam(ControlType.APP_LOCK, builderParam);
      expect(componentBuilderParamMap.size).assertEqual(1);
      expect(componentBuilderParamMap.get(ControlType.APP_LOCK)).assertEqual(builderParam);
      componentBuilderParamMap.clear();
      done();
    });

    it('getComponentBuilderParamByControlTypeTest', 0, async (done: Function) => {
      let useControlManager = SCBAppUseControlManager.getInstance();
      expect(useControlManager.getComponentBuilderParamByControlType(ControlType.APP_LOCK)).assertUndefined();
      let builderParam: ComponentBuilderParam = {
        loadBundleName: 'bundleName',
        loadAbilityName: 'ability',
        useControlMainMaskBuilder: () => {},
        useControlRecentMaskBuilder: () => {},
      };
      useControlManager.registerComponentBuilderParam(ControlType.APP_LOCK, builderParam);
      expect(useControlManager.getComponentBuilderParamByControlType(ControlType.APP_LOCK)).assertEqual(builderParam);
      done();
    });

    it('updateControlAppInfoTest', 0, async (done: Function) => {
      let useControlManager = SCBAppUseControlManager.getInstance();
      let controlTypeMap = ReflectionUtils.getProperty(useControlManager,
        'controlTypeMap') as Map<string, ControlType[]>;
      expect(controlTypeMap.size).assertEqual(0);
      let bundleName = 'bundleName';
      let appIndex = 0;
      let controlAppInfo: ControlAppInfo = {
        bundleName: bundleName,
        appIndex: appIndex,
        isNeedControl: true,
        isControlRecentOnly: false
      };
      useControlManager.updateControlAppInfo(ControlType.APP_LOCK, [controlAppInfo]);
      expect(controlTypeMap.size).assertEqual(1);
      expect(controlTypeMap.get(`${bundleName}#${appIndex}`)?.length).assertEqual(1);
      expect(controlTypeMap.get(`${bundleName}#${appIndex}`)?.[0]).assertEqual(ControlType.APP_LOCK);
      useControlManager.updateControlAppInfo(ControlType.APP_LOCK, [controlAppInfo]);
      expect(controlTypeMap.size).assertEqual(1);
      let controlAppInfo2: ControlAppInfo = {
        bundleName: bundleName,
        appIndex: appIndex,
        isNeedControl: false,
        isControlRecentOnly: false
      };
      useControlManager.updateControlAppInfo(ControlType.APP_LOCK, [controlAppInfo2]);
      expect(controlTypeMap.size).assertEqual(1);
      expect(controlTypeMap.get(`${bundleName}#${appIndex}`)?.length).assertEqual(0);
      controlTypeMap.clear();
      done();
    });

    it('getControlTypeTest', 0, async (done: Function) => {
      let useControlManager = SCBAppUseControlManager.getInstance();
      let bundleName = 'bundleName';
      let appIndex = 0;
      expect(useControlManager.getControlType(bundleName, appIndex).length).assertEqual(0);
      let controlAppInfo: ControlAppInfo = {
        bundleName: bundleName,
        appIndex: appIndex,
        isNeedControl: true,
        isControlRecentOnly: false
      };
      useControlManager.updateControlAppInfo(ControlType.APP_LOCK, [controlAppInfo]);
      expect(useControlManager.getControlType(bundleName, appIndex).length).assertEqual(1);
      expect(useControlManager.getControlType(bundleName, appIndex)[0]).assertEqual(ControlType.APP_LOCK);
      done();
    });

    it('notifyUpdateWindowModeTest', 0, async (done: Function) => {
      let useControlManager = SCBAppUseControlManager.getInstance();
      let appUseControlWindowModeCallBackMap = ReflectionUtils.getProperty(useControlManager,
        'appUseControlWindowModeCallBackMap') as Map<number, Function>;

      let persistentId = 1;
      useControlManager.registerAppUseControlWindowModeCallBack(persistentId, (type: SCBSceneMode) => {});
      expect(appUseControlWindowModeCallBackMap.size).assertEqual(1);
      useControlManager.notifyUpdateWindowMode(persistentId, SCBSceneMode.PRIMARY);

      useControlManager.unRegisterAppUseControlWindowModeCallBack(persistentId);
      expect(appUseControlWindowModeCallBackMap.size).assertEqual(0);
      done();
    });
  });
}