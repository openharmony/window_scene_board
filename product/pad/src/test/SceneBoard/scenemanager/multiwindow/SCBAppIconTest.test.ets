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
import {
  SCBDividerParam,
  SCBSceneContainerSession,
  SCBSceneInfo, SCBSceneSession,
  SCBScreenProperty,
  SCBSplitParam,
  SCBAppIconParam,
  SceneParam,
} from '@ohos/windowscene';
import { ResourceManager } from '@ohos/frameworkwrapper';
import { SCBConstants } from '@ohos/commonconstants';
import { ArgumentMatchers, beforeAll, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  appIconHelper,
  SCBAppIconParamEx } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBAppIconEx';
import { CommonConstants } from '@ohos/launchercommon';

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
  SCBAppIconTest_01();
  SCBAppIconTest_02();
  SCBAppIconTest_03();
  appIconParamExTest_01();
  appIconHelperTest_01();
  resetDraggingTipTest();
}

function SCBAppIconTest_03() {
  describe('SCBAppIconTest_003', () => {
    beforeAll(initAll);

    it('updateAppIconPositionOnMidScene_001', Level.LEVEL0, () => {
      let sceneParam: SceneParam = new SceneParam();
      appIconParam.updateAppIconPositionOnMidScene(sceneParam, screenProperty);
      expect(true).assertTrue();
    });

    it('setCenterPosition_001', Level.LEVEL0, () => {
      let divider: SCBDividerParam = new SCBDividerParam();
      containerSession.isFloat = true;
      appIconParam.setCenterPosition(containerSession, divider, screenProperty);
      containerSession.isFloat = false;
      appIconParam.setCenterPosition(containerSession, divider, screenProperty);
      expect(true).assertTrue();
    });

    it('updateAppIconPos_001', Level.LEVEL0, () => {
      let sceneParam: SceneParam = new SceneParam();
      appIconParam.updateAppIconPos(sceneParam, screenProperty, 0, 0);
      expect(true).assertTrue();
    });
  });
}

function SCBAppIconTest_02() {
  describe('SCBAppIconTest_002', () => {
    beforeAll(initAll);
    it('doAppIconTranslate_001', Level.LEVEL0, () => {
      appIconParam.doAppIconTranslate(1, true);
      expect(appIconParam.translateY).assertEqual(1);
      appIconParam.doAppIconTranslate(1, false);
      expect(appIconParam.translateX).assertEqual(1);
    });

    it('initAppIconPosition_001', Level.LEVEL0, () => {
      appIconParam = new SCBAppIconParam(() => null);
      appIconParam.initAppIconPosition(0, 0, true);
      expect(appIconParam.x).assertEqual(0);
      expect(appIconParam.y).assertEqual(0);
      appIconParam.initAppIconPosition(0, 0, false);
      expect(appIconParam.x).assertEqual(0);
      expect(appIconParam.y).assertEqual(0);
    });
  });
}

function SCBAppIconTest_01() {
  describe('SCBAppIconTest_001', () => {
    beforeAll(initAll);
    it('setIcon_001', Level.LEVEL0, () => {
      let callback = (img: ImageSource) => {
      };
      appIconParam.updateIconUpdateCallback(callback);
      appIconParam.icon = 'appicon';
      expect(true).assertTrue();
    });

    it('getScaleX_001', Level.LEVEL0, () => {
      appIconParam.scale = 1;
      appIconParam.floatScaleX = 1;
      appIconParam.touchScale = 1;
      expect(1).assertEqual(appIconParam.getScaleX());
    });

    it('getScaleY_001', Level.LEVEL0, () => {
      appIconParam.scale = 1;
      appIconParam.floatScaleY = 1;
      appIconParam.touchScale = 1;
      expect(1).assertEqual(appIconParam.getScaleY());
    });

    it('updateIconUpdateCallback_001', Level.LEVEL0, () => {
      let callback = (img: ImageSource) => {
      };
      appIconParam.updateIconUpdateCallback(callback);
      expect(true).assertTrue();
    });

    it('refreshIcon_001', Level.LEVEL0, () => {
      appIconParam = new SCBAppIconParam(() => sceneSession);
      appIconParam.refreshIcon();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(ResourceManager,
        ResourceManager.getInstance().isSCBInnerModule);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      appIconParam.refreshIcon();
      expect(true).assertTrue();
    });

    it('refreshIcon_with_null_session_001', Level.LEVEL0, () => {
      appIconParam = new SCBAppIconParam(() => null);
      appIconParam.refreshIcon();
      expect(true).assertTrue();
    });
  });
}

function appIconHelperTest_01() {
  describe('appIconHelperTest_001', () => {
    it('createParamTest_001', Level.LEVEL0, () => {
      let param = appIconHelper.creatParam('test');
      expect(param.tag).assertEqual('test');
    });
  });
}

function appIconParamExTest_01() {
  describe('appIconParamExTest_001', () => {
    it('getScaleTest_001', Level.LEVEL0, () => {
      let param = new SCBAppIconParamEx('test');
      param.scale = 1;
      param.touchScale = 2;
      param.floatScaleX = 3;
      param.floatScaleY = 4;
      expect(param.getScaleX()).assertEqual(6);
      expect(param.getScaleY()).assertEqual(8);
    });
    it('constructorTest_001', Level.LEVEL0, () => {
      let param = new SCBAppIconParamEx('test');
      expect(param.tag).assertEqual('test');
      expect(param.show).assertFalse();
      expect(param.icon).assertUndefined();
      expect(param.size).assertEqual(64);
      expect(param.positionX).assertEqual(0);
      expect(param.positionY).assertEqual(0);
      expect(param.anchorX).assertEqual(0);
      expect(param.anchorY).assertEqual(0);
      expect(param.translateX).assertEqual(0);
      expect(param.translateY).assertEqual(0);
      expect(param.scale).assertEqual(1);
      expect(param.touchScale).assertEqual(1);
      expect(param.floatScaleX).assertEqual(1);
      expect(param.floatScaleY).assertEqual(1);
      expect(param.opacity).assertEqual(1);
      expect(param.rotateAngle).assertEqual(0);
      expect(param.zIndex).assertEqual(1);
      expect(param.radius).assertEqual(CommonConstants.DEFAULT_ICON_RADIUS);
      expect(param.syncLoad).assertFalse();
    });
    it('refreshIconTest_001', Level.LEVEL0, () => {
      let param = new SCBAppIconParamEx('test');
      param.refreshIcon(null);
      expect(param.show).assertFalse();
      expect(param.icon).assertUndefined();
      param.refreshIcon(undefined);
      expect(param.show).assertFalse();
      expect(param.icon).assertUndefined();
      let sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
      param.refreshIcon(sceneInfo);
      sceneInfo = new SCBSceneInfo(SCBConstants.SCENE_BOARD_PKG, SCBConstants.NTF_MANAGEMENT_MODULE, 'testPriAbility');
      param.refreshIcon(sceneInfo);
      expect(param.show).assertTrue();
    });
  });
}

function resetDraggingTipTest() {
  describe('resetDraggingTipTest', () => {
    it('resetDraggingTipTest', Level.LEVEL0, () => {
      let sceneSession1 = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let appIconParam1 = new SCBAppIconParam(() => sceneSession1);
      appIconParam1.resetDraggingTip();
      expect(appIconParam1.needPrimIconTip).assertFalse();
      expect(appIconParam1.needSecIconTip).assertFalse();
      expect(appIconParam1.primIconTip).assertEqual('');
      expect(appIconParam1.secIconTip).assertEqual('');
      expect(appIconParam1.primIconTipOpacity).assertEqual(0);
      expect(appIconParam1.secIconTipOpacity).assertEqual(0);
      expect(appIconParam1).assertEqual(1.2);
      expect(appIconParam1.secIconTipOpacity).assertEqual(1.2);
    });
  });
}
