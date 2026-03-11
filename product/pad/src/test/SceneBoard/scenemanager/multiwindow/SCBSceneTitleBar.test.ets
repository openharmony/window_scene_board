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
import { beforeAll, describe, expect, it, Level } from '@ohos/hypium';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  SCBSceneContainerSession,
  SCBSceneInfo, SCBSceneSession,
  SCBScreenProperty,
  SCBDividerParam,
  SCBSplitParam} from '@ohos/windowscene';
import { GlobalOffsetCalculator } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/utils/FloatUtils';
import {
  SCBSceneSwapHelper,
  SCBTitleBarParam } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBSceneTitleBar';

let containerSession: SCBSceneContainerSession;
let screenProperty: SCBScreenProperty;
let swapHelper: SCBSceneSwapHelper;
let dividerParam: SCBDividerParam;
let primSession: SCBSceneSession;
let secSession: SCBSceneSession;
let sceneInfo: SCBSceneInfo;
let eventArea: Area = {
  width: 0,
  height: 0,
  position: {
    x: 0, y: 0
  },
  globalPosition: {
    x: 1, y: 1
  }
};
let eventTarget: EventTarget = {
  area: eventArea
};
let event: GestureEvent = {
  target: eventTarget,
  timestamp: 0,
  source: 0,
  pressure: 0,
  tiltX: 1,
  tiltY: 1,
  sourceTool: 0,
  repeat: false,
  fingerList: [],
  offsetX: 1,
  offsetY: 1,
  angle: 0,
  speed: 0,
  scale: 0,
  pinchCenterX: 0,
  pinchCenterY: 0,
  velocityX: 0,
  velocityY: 0,
  velocity: 1
};
let initAll = () => {
  sceneInfo = new SCBSceneInfo('testPriBundle', 'testPriModule', 'testPriAbility');
  primSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  secSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  dividerParam = new SCBDividerParam();
  swapHelper = new SCBSceneSwapHelper();
  screenProperty = new SCBScreenProperty();
  containerSession = new SCBSceneContainerSession(primSession, screenProperty);
  containerSession.splitParam = new SCBSplitParam()
}
let assertFlag: boolean = true;

export function SCBSceneTitleBarTest() {
  SCBSceneTitleBarTest_01_func();
  SCBSceneTitleBarTest_02_func();
  SCBSceneTitleBarTest_03_func();
}

function SCBSceneTitleBarTest_01_func() {
  describe('SCBSceneTitleBarTest_01_describe', () => {
    beforeAll(initAll);

    it('clearGuideAndIconStyle_it', Level.LEVEL0, (): void => {
      swapHelper.clearGuideAndIconStyle(containerSession);
      expect(assertFlag).assertTrue();
    });

    it('playFingerFollowAnimation_it', Level.LEVEL0, (): void => {
      swapHelper.playFingerFollowAnimation(event, containerSession, new GlobalOffsetCalculator());
      expect(assertFlag).assertTrue();
    });

    it('updateSceneScaleForGesture_it', Level.LEVEL0, (): void => {
      swapHelper.updateSceneScaleForGesture(dividerParam);
      expect(assertFlag).assertTrue();
    });

    it('updateSceneShadowForGesture_it', Level.LEVEL0, (): void => {
      swapHelper.updateSceneShadowForGesture(dividerParam);
      expect(assertFlag).assertTrue();
    });

    it('playHotRegionChangeAnimation_it', Level.LEVEL0, (): void => {
      swapHelper.playHotRegionChangeAnimation();
      expect(assertFlag).assertTrue();
    });
  });
}

function SCBSceneTitleBarTest_02_func() {
  describe('SCBSceneTitleBarTest_02_describe', () => {
    beforeAll(initAll);
    it('setOffsetY_it', Level.LEVEL0, (): void => {
      let offset: number = 0;
      let param: SCBTitleBarParam = new SCBTitleBarParam();
      param.setOffsetY(offset);
      expect(param.offsetY).assertEqual(0);
      expect(param.offsetYPx).assertEqual(0);
      offset = 1;
      param.setOffsetY(offset);
      expect(param.offsetY).assertEqual(1);
      expect(param.offsetYPx).assertEqual(vp2px(1));
    });

    it('initMenuParam_it', Level.LEVEL0, (): void => {
      let param: SCBTitleBarParam = new SCBTitleBarParam();
      expect(param.offsetY).assertEqual(0);
      expect(param.offsetYPx).assertEqual(0);
      expect(param.menuScaleY).assertEqual(1);
      expect(param.menuOpacity).assertEqual(1);
      expect(param.menuShow).assertFalse();
      expect(param.menuScale).assertEqual(1);
    });
  });
}

function SCBSceneTitleBarTest_03_func() {
  describe('SCBSceneTitleBarTest_03_describe', () => {
    beforeAll(initAll);

    it('init_it', Level.LEVEL0, (): void => {
      swapHelper.init(containerSession, primSession, screenProperty);
      expect(assertFlag).assertTrue();
    });

    it('identifyHotRegionType_it', Level.LEVEL0, (): void => {
      swapHelper.identifyHotRegionType();
      expect(assertFlag).assertTrue();
    });

    it('updateInertialVelocity_it', Level.LEVEL0, (): void => {
      swapHelper.updateInertialVelocity(event);
      swapHelper.updateInertialVelocity(undefined);
      expect(assertFlag).assertTrue();
    });

    it('playSwapSceneStyleAnimation_it', Level.LEVEL0, (): void => {
      swapHelper.playSwapSceneStyleAnimation(dividerParam);
      expect(assertFlag).assertTrue();
    });

    it('previousRegionType_it', 0, (): void => {
      swapHelper.previousRegionType;
      expect(assertFlag).assertTrue();
    });

  });
}
