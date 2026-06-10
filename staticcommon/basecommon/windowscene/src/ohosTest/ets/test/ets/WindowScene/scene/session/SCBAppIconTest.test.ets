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

import { ArgumentMatchers, beforeAll, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  SCBAppIconParam,
  SCBSceneSession,
  SCBSceneInfo,
  SCBSceneContainerSession,
  SCBScreenProperty,
  SCBSplitParam,
  SCBDividerParam,
  SceneParam,
} from '../../../../../../../main/ets/TsIndex';
import { ResourceManager } from '@ohos/frameworkwrapper';

type ImageSource = PixelMap | ResourceStr | DrawableDescriptor;

let appIconParam: SCBAppIconParam;
let sceneSession: SCBSceneSession;
let sceneInfo: SCBSceneInfo;
let containerSession: SCBSceneContainerSession;
let screenProperty: SCBScreenProperty;
let initAll = () => {
  sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
  sceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  appIconParam = new SCBAppIconParam(() => sceneSession);
  screenProperty = new SCBScreenProperty();
  containerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
  containerSession.splitParam = new SCBSplitParam();
}

export function SCBAppIconTest() {
  SCBAppIconTest01();
  SCBAppIconTest02();
  SCBAppIconTest03();
}

function SCBAppIconTest03() {
  describe('SCBCommonAppIconTest_03', () => {
    beforeAll(initAll);

    it('setCenterPosition', Level.LEVEL0, () => {
      let divider: SCBDividerParam = new SCBDividerParam();
      containerSession.isFloat = true;
      appIconParam.setCenterPosition(containerSession, divider, screenProperty);
      containerSession.isFloat = false;
      appIconParam.setCenterPosition(containerSession, divider, screenProperty);
      expect(true).assertTrue();
    });

    it('updateAppIconPositionOnMidScene', Level.LEVEL0, () => {
      let sceneParam: SceneParam = new SceneParam();
      appIconParam.updateAppIconPositionOnMidScene(sceneParam, screenProperty);
      expect(true).assertTrue();
    });
  });
}

function SCBAppIconTest02() {
  describe('SCBCommonAppIconTest_02', () => {
    beforeAll(initAll);
    it('initAppIconPosition', Level.LEVEL0, () => {
      appIconParam = new SCBAppIconParam(() => null);
      appIconParam.initAppIconPosition(0, 0, true);
      expect(appIconParam.x).assertEqual(0);
      expect(appIconParam.y).assertEqual(0);
      appIconParam.initAppIconPosition(0, 0, false);
      expect(appIconParam.x).assertEqual(0);
      expect(appIconParam.y).assertEqual(0);
    });

    it('doAppIconTranslate', Level.LEVEL0, () => {
      appIconParam.doAppIconTranslate(1, true);
      expect(appIconParam.translateY).assertEqual(1);
      appIconParam.doAppIconTranslate(1, false);
      expect(appIconParam.translateX).assertEqual(1);
    });
  });
}

function SCBAppIconTest01() {
  describe('SCBCommonIconTest_01', () => {
    beforeAll(initAll);
    it('setIcon', Level.LEVEL0, () => {
      let callback = (img: ImageSource) => {
      };
      appIconParam.updateIconUpdateCallback(callback);
      appIconParam.icon = 'appicon';
      expect(true).assertTrue();
    });

    it('updateIconUpdateCallback', Level.LEVEL0, () => {
      let callback = (img: ImageSource) => {
      };
      appIconParam.updateIconUpdateCallback(callback);
      expect(true).assertTrue();
    });

    it('getScaleX', Level.LEVEL0, () => {
      appIconParam.scale = 1;
      appIconParam.floatScaleX = 1;
      appIconParam.touchScale = 1;
      expect(1).assertEqual(appIconParam.getScaleX());
    });

    it('getScaleY', Level.LEVEL0, () => {
      appIconParam.scale = 1;
      appIconParam.floatScaleY = 1;
      appIconParam.touchScale = 1;
      expect(1).assertEqual(appIconParam.getScaleY());
    });

    it('refreshIcon', Level.LEVEL0, () => {
      appIconParam = new SCBAppIconParam(() => sceneSession);
      appIconParam.refreshIcon();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(ResourceManager,
        ResourceManager.getInstance().isSCBInnerModule);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      appIconParam.refreshIcon();
      expect(true).assertTrue();
    });

    it('refreshIcon_with_null_session', Level.LEVEL0, () => {
      appIconParam = new SCBAppIconParam(() => null);
      appIconParam.refreshIcon();
      expect(true).assertTrue();
    });
  });
}

