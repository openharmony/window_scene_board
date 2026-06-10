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
  SCBGestureAction,
  SCBGestureActionId,
  SCBScreenProperty,
  SCBSystemSceneSession,
  SystemSessionInfo,
  SCBSceneContainerSession,
  SCBSceneContainerState,
  SCBSceneInfo, SCBSceneSession,
  SCBSceneSessionManager,
} from '@ohos/windowscene';
import {
  FloatMiniCoverController,
  FloatMiniCoverParam,
} from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBFloatMiniCover';
import { SCBSceneContainerBlockCoverController } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBBlockCover';
import { beforeAll, describe, expect, it, Level } from '@ohos/hypium';
import sceneSessionManager from '@ohos.sceneSessionManager';

let sceneContainerSessionTmp: SCBSceneContainerSession;
let screenPropTmp: SCBScreenProperty;
let innerGestureHandler = (action: SCBGestureAction) => {
  blockCoverController.handleGestureAction(sceneContainerSessionTmp, screenPropTmp, action);
  miniCoverController.onGestureChange(sceneContainerSessionTmp, action);
}
let blockCoverController = new SCBSceneContainerBlockCoverController(() => sceneContainerSessionTmp,
  show => needBlockCoverTmp = show);
let eventArea: Area = {
  width: 0,
  height: 0,
  position: {
    x: 0, y: 0
  },
  globalPosition: {
    x: 0, y: 0
  }
};
let needMiniCoverTmp: boolean = false;
let needBlockCoverTmp: boolean = false;
let sceneSessionTmp: SCBSceneSession;
let sceneInfoTmp: SCBSceneInfo;
let eventTarget: EventTarget = {
  area: eventArea
};
let miniCoverController: FloatMiniCoverController;
let param: FloatMiniCoverParam;
let gestureEvent: GestureEvent = {
  target: eventTarget,
  timestamp: 0,
  source: 0,
  pressure: 0,
  tiltX: 0,
  tiltY: 0,
  sourceTool: 0,
  repeat: false,
  fingerList: [],
  offsetX: 0,
  offsetY: 0,
  angle: 0,
  speed: 0,
  scale: 0,
  pinchCenterX: 0,
  pinchCenterY: 0,
  velocityX: 0,
  velocityY: 0,
  velocity: 0
};
let systemSessionInfo: SystemSessionInfo = {
  systemType: sceneSessionManager.SessionType.TYPE_PANEL,
  sceneName: 'SCBFloatMiniCoverTest',
  sceneZIndex: 101,
  isFocusable: false,
  isTouchable: true,
  privacyMode: false,
  hitTestMode: HitTestMode.Default,
  sceneType: sceneSessionManager.SceneType.INPUT_SCENE,
  isOverlayScene: true,
};
let sysSceneSessionTmp: SCBSystemSceneSession = SCBSceneSessionManager.getInstance()
  .requestSystemSceneSession(systemSessionInfo);
let touchEvent: TouchEvent = {
  target: {
    area: {
      width: 0,
      height: 0,
      position: {
        x: 0, y: 0
      },
      globalPosition: {
        x: 1, y: 1
      }
    }
  },
  timestamp: 0,
  source: 0,
  pressure: 1,
  tiltX: 0,
  tiltY: 0,
  sourceTool: 0,
  type: TouchType.Down,
  touches: [],
  changedTouches: [{
    id: 0,
    type: 0,
    displayX: 1,
    displayY: 1,
    windowX: 0,
    windowY: 0,
    screenX: 0,
    screenY: 0,
    x: 0,
    y: 0
  }],
  stopPropagation: (): void => {
    throw new Error('The function is not implemented.');
  },
  getHistoricalPoints: (): HistoricalPoint[] => {
    throw new Error('The function is not implemented.');
  }
}

export function SCBFloatMiniCoverTest() {
  describe('SCBFloatMiniCoverTest_describe', () => {
    beforeAll(() => {
      sceneInfoTmp = new SCBSceneInfo('testFloatMiniCover_bundle', 'testFloatMiniCover_module', 'testFloatMiniCover_ability');
      sceneSessionTmp = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfoTmp), sceneInfoTmp);
      screenPropTmp = new SCBScreenProperty();
      screenPropTmp.height = 2500;
      screenPropTmp.width = 1260;
      sceneContainerSessionTmp = new SCBSceneContainerSession(sceneSessionTmp, screenPropTmp);
      sceneContainerSessionTmp.init();
      param = new FloatMiniCoverParam();
      miniCoverController = new FloatMiniCoverController(() => sceneContainerSessionTmp,
        show => needMiniCoverTmp = show, innerGestureHandler);
      miniCoverController.onAboutToAppear(param);
    })

    SCBFloatMiniCoverTest_handlePanGestureUpdate_func();
    SCBFloatMiniCoverTest_handlePanGestureEnd_func();
    SCBFloatMiniCoverTest_handlePanGestureCancel_func();
    SCBFloatMiniCoverTest_hide_func();
    SCBFloatMiniCoverTest_updateSize_func();
    SCBFloatMiniCoverTest_onContainerStateChange_func();
    SCBFloatMiniCoverTest_onContainerFoldChange_func();
    SCBFloatMiniCoverTest_onGestureChange_func();
    SCBFloatMiniCoverTest_onAboutToAppear_func();
    SCBFloatMiniCoverTest_onAboutToDisappear_func();
    SCBFloatMiniCoverTest_session_func();
    SCBFloatMiniCoverTest_handleClick_func();
    SCBFloatMiniCoverTest_handleDoubleClick_func();
    SCBFloatMiniCoverTest_handleTouchEvent_func();
    SCBFloatMiniCoverTest_handlePanGestureStart_func();
    SCBFloatMiniCoverTest_persistentId_func();
    SCBFloatMiniCoverTest_showIfNeed_func();
    SCBFloatMiniCoverTest_show_func();
    SCBFloatMiniCoverTest_hideIfNeed_func();
  })
}

function SCBFloatMiniCoverTest_handlePanGestureUpdate_func() {
  it('SCBFloatMiniCoverTest_handlePanGestureUpdate_it', Level.LEVEL0, (): void => {
    sceneContainerSessionTmp.changeState(SCBSceneContainerState.MINI_FLOAT);
    miniCoverController.handlePanGestureUpdate(gestureEvent);
    expect(sceneContainerSessionTmp.getState()).assertEqual(SCBSceneContainerState.MINI_FLOAT);
  });
}

function SCBFloatMiniCoverTest_handlePanGestureEnd_func() {
  it('SCBFloatMiniCoverTest_handlePanGestureEnd_it', Level.LEVEL0, (): void => {
    sceneContainerSessionTmp.changeState(SCBSceneContainerState.MINI_FLOAT);
    miniCoverController.handlePanGestureEnd(gestureEvent);
    expect(sceneContainerSessionTmp.getState()).assertEqual(SCBSceneContainerState.MINI_FLOAT);
  });
}

function SCBFloatMiniCoverTest_handlePanGestureCancel_func() {
  it('SCBFloatMiniCoverTest_handlePanGestureCancel_it', Level.LEVEL0, (): void => {
    sceneContainerSessionTmp.changeState(SCBSceneContainerState.MINI_FLOAT);
    miniCoverController.handlePanGestureCancel();
    expect(sceneContainerSessionTmp.getState()).assertEqual(SCBSceneContainerState.MINI_FLOAT);
  });
}

function SCBFloatMiniCoverTest_hide_func() {
  it('SCBFloatMiniCoverTest_hide_it', Level.LEVEL0, (): void => {
    sceneContainerSessionTmp.changeState(SCBSceneContainerState.MINI_FLOAT);
    miniCoverController.hide();
    expect(sceneContainerSessionTmp.getState()).assertEqual(SCBSceneContainerState.MINI_FLOAT);
  });
}

function SCBFloatMiniCoverTest_updateSize_func() {
  it('SCBFloatMiniCoverTest_updateSize_it', Level.LEVEL0, (): void => {
    sceneContainerSessionTmp.changeState(SCBSceneContainerState.MINI_FLOAT);
    miniCoverController.updateSize(100, 500);
    expect(sceneContainerSessionTmp.getState()).assertEqual(SCBSceneContainerState.MINI_FLOAT);
  });
}

function SCBFloatMiniCoverTest_onContainerStateChange_func() {
  it('SCBFloatMiniCoverTest_onContainerStateChange_it', Level.LEVEL0, (): void => {
    sceneContainerSessionTmp.changeState(SCBSceneContainerState.MINI_FLOAT);
    miniCoverController.onContainerStateChange(sceneContainerSessionTmp, SCBSceneContainerState.MINI_FLOAT);
    expect(param.isShow()).assertTrue();
    miniCoverController.onContainerStateChange(sceneContainerSessionTmp, SCBSceneContainerState.FLOAT);
    expect(param.isShow()).assertTrue();
  });
}

function SCBFloatMiniCoverTest_onContainerFoldChange_func() {
  it('SCBFloatMiniCoverTest_onContainerFoldChange_it', Level.LEVEL0, (): void => {
    miniCoverController.onContainerFoldChange(sceneContainerSessionTmp);
    expect(param.isShow()).assertTrue();
    sceneContainerSessionTmp.changeState(SCBSceneContainerState.MINI_FLOAT);
    miniCoverController.show(sceneContainerSessionTmp);
    expect(param.isShow()).assertTrue();
  });
}

function SCBFloatMiniCoverTest_onGestureChange_func() {
  it('SCBFloatMiniCoverTest_onGestureChange_it', Level.LEVEL0, (): void => {
    sceneContainerSessionTmp.changeState(SCBSceneContainerState.MINI_FLOAT);
    let actionTmp: SCBGestureAction = new SCBGestureAction({ id: SCBGestureActionId.FLOAT_GESTURE_END });
    miniCoverController.onGestureChange(sceneContainerSessionTmp, actionTmp);
    expect(param.isShow()).assertTrue();
  });
}

function SCBFloatMiniCoverTest_onAboutToAppear_func() {
  it('SCBFloatMiniCoverTest_onAboutToAppear_it', Level.LEVEL0, (): void => {
    sceneContainerSessionTmp.changeState(SCBSceneContainerState.MINI_FLOAT);
    miniCoverController.onAboutToAppear(param);
    expect(param.isShow()).assertTrue();
  });
}

function SCBFloatMiniCoverTest_onAboutToDisappear_func() {
  it('SCBFloatMiniCoverTest_onAboutToDisappear_it', Level.LEVEL0, (): void => {
    miniCoverController.onAboutToDisappear();
    expect(miniCoverController.session()).assertNull();
  });
}

function SCBFloatMiniCoverTest_session_func() {
  it('SCBFloatMiniCoverTest_session_it', Level.LEVEL0, (): void => {
    let systemSceneSession = miniCoverController.session();
    expect(systemSceneSession).assertNull();
  });
}

function SCBFloatMiniCoverTest_handleClick_func() {
  it('SCBFloatMiniCoverTest_handleClick_it', Level.LEVEL0, (): void => {
    sceneContainerSessionTmp.changeState(SCBSceneContainerState.MINI_FLOAT);
    miniCoverController.handleClick();
    expect(sceneContainerSessionTmp.getState()).assertEqual(SCBSceneContainerState.MINI_FLOAT);
  });
}

function SCBFloatMiniCoverTest_handleDoubleClick_func() {
  it('SCBFloatMiniCoverTest_handleDoubleClick_it', Level.LEVEL0, (): void => {
    sceneContainerSessionTmp.changeState(SCBSceneContainerState.MINI_FLOAT);
    miniCoverController.handleDoubleClick();
    expect(sceneContainerSessionTmp.getState()).assertEqual(SCBSceneContainerState.MINI_FLOAT);
  });
}

function SCBFloatMiniCoverTest_handleTouchEvent_func() {
  it('SCBFloatMiniCoverTest_handleTouchEvent_it', Level.LEVEL0, (): void => {
    sceneContainerSessionTmp.changeState(SCBSceneContainerState.MINI_FLOAT);
    miniCoverController.handleTouchEvent(touchEvent);
    touchEvent.type = TouchType.Move;
    miniCoverController.handleTouchEvent(touchEvent);
    touchEvent.type = TouchType.Up;
    miniCoverController.handleTouchEvent(touchEvent);
    expect(sceneContainerSessionTmp.getState() !== SCBSceneContainerState.MINI_FLOAT).assertTrue();
  });
}

function SCBFloatMiniCoverTest_handlePanGestureStart_func() {
  it('SCBFloatMiniCoverTest_handlePanGestureStart_it', Level.LEVEL0, (): void => {
    sceneContainerSessionTmp.changeState(SCBSceneContainerState.MINI_FLOAT);
    miniCoverController.handlePanGestureStart(gestureEvent);
    expect(sceneContainerSessionTmp.getState()).assertEqual(SCBSceneContainerState.MINI_FLOAT);
  });
}

function SCBFloatMiniCoverTest_persistentId_func() {
  it('SCBFloatMiniCoverTest_persistentId_it', Level.LEVEL0, (): void => {
    let persistentId = miniCoverController.persistentId();
    expect(persistentId).assertUndefined();
  });
}

function SCBFloatMiniCoverTest_showIfNeed_func() {
  it('SCBFloatMiniCoverTest_showIfNeed_it', Level.LEVEL0, (): void => {
    sceneContainerSessionTmp.changeState(SCBSceneContainerState.MINI_FLOAT);
    miniCoverController.showIfNeed(sceneContainerSessionTmp);
    expect(sceneContainerSessionTmp.getState()).assertEqual(SCBSceneContainerState.MINI_FLOAT);
  });
}

function SCBFloatMiniCoverTest_show_func() {
  it('SCBFloatMiniCoverTest_show_it', Level.LEVEL0, (): void => {
    sceneContainerSessionTmp.changeState(SCBSceneContainerState.MINI_FLOAT);
    miniCoverController.show(sceneContainerSessionTmp);
    expect(param.isShow()).assertTrue();
  });
}

function SCBFloatMiniCoverTest_hideIfNeed_func() {
  it('SCBFloatMiniCoverTest_hideIfNeed_it', Level.LEVEL0, (): void => {
    sceneContainerSessionTmp.changeState(SCBSceneContainerState.MINI_FLOAT);
    miniCoverController.hideIfNeed();
    expect(sceneContainerSessionTmp.getState()).assertEqual(SCBSceneContainerState.MINI_FLOAT);
  });
}
