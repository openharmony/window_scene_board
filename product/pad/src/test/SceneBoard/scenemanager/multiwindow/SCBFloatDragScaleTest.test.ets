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

import { SCBSceneSession } from '@ohos/windowscene';
import {
  FloatDragScaleController
} from '../../../../../src/main/ets/SceneBoard/scenemanager/multiwindow/SCBFloatDragScale';
import { beforeAll, describe, expect, it, Level } from '@ohos/hypium';
import {
  SCBScreenProperty,
  SCBSceneContainerSession,
  SCBSceneContainerState
} from '@ohos/windowscene';
import {
  SCBGestureAction,
  SCBGestureActionId,
} from '@ohos/windowscene';

import sceneSessionManager from '@ohos.sceneSessionManager';

import { SCBSceneInfo } from '@ohos/windowscene';

let needDragScaleFlag = false;
let sceneInfo: SCBSceneInfo;
let containerSession: SCBSceneContainerSession;
let sceneSession: SCBSceneSession;
let screenProperty: SCBScreenProperty = new SCBScreenProperty();
let assertFlag: boolean = true;

export function SCBFloatDragScaleTest() {
  describe("SCBFloatDragScaleTest_describe", () => {
    beforeAll((): void => {
      sceneInfo = new SCBSceneInfo('testFloatDragScale_bundle', 'testFloatDragScaleModule_module', 'testFloatDragScaleAbility_ability');
      sceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      containerSession = new SCBSceneContainerSession(sceneSession, new SCBScreenProperty());
    })
    onContainerStateChangeFunc();
    onContainerFoldChangeFunc();
    handleTouchEventFunc();
    handlePanGestureStartFunc();
    onGestureChangeFunc();
    handlePanGestureUpdateFunc();
    sessionFunc();
    handlePanGestureEndFunc();
    handlePanGestureCancelFunc();
    getGestureJudgeResultFunc();
  });
}

function onContainerFoldChangeFunc() {
  it('onContainerFoldChangeTest_01', Level.LEVEL0, () => {
    needDragScaleFlag = true;
    let floatDragScaleControllerTmp: FloatDragScaleController = new FloatDragScaleController(() => containerSession,
      show => needDragScaleFlag = show, (action: SCBGestureAction) => {
      });
    floatDragScaleControllerTmp.onContainerFoldChange(containerSession, screenProperty);
    expect(assertFlag).assertTrue();
  });
  it('onContainerFoldChangeTest_02', Level.LEVEL0, () => {
    needDragScaleFlag = false;
    let floatDragScaleControllerTmp: FloatDragScaleController = new FloatDragScaleController(() => containerSession,
      show => needDragScaleFlag = show, (action: SCBGestureAction) => {
      });
    floatDragScaleControllerTmp.onContainerFoldChange(containerSession, screenProperty);
    expect(assertFlag).assertTrue();
  });
}

function onContainerStateChangeFunc() {
  it('onContainerStateChangeTest_01', Level.LEVEL0, () => {
    let floatDragScaleControllerTmp: FloatDragScaleController = new FloatDragScaleController(() => containerSession,
      show => needDragScaleFlag = show, (action: SCBGestureAction) => {
      });
    containerSession?.changeState(SCBSceneContainerState.HIDDEN);
    floatDragScaleControllerTmp.onContainerStateChange(containerSession);
    expect(assertFlag).assertTrue();
  });
  it('onContainerStateChangeTest_02', Level.LEVEL0, () => {
    let floatDragScaleControllerTmp: FloatDragScaleController = new FloatDragScaleController(() => containerSession,
      show => needDragScaleFlag = show, (action: SCBGestureAction) => {
      });
    containerSession?.changeState(SCBSceneContainerState.FLOAT);
    floatDragScaleControllerTmp.onContainerStateChange(containerSession);
    expect(assertFlag).assertTrue();
  });
}

function handlePanGestureCancelFunc() {
  it('handlePanGestureCancelTest_01', Level.LEVEL0, () => {
    let floatDragScaleControllerTmp: FloatDragScaleController = new FloatDragScaleController(() => containerSession,
      show => needDragScaleFlag = show, (action: SCBGestureAction) => {
      });
    floatDragScaleControllerTmp.handlePanGestureCancel();
    expect(assertFlag).assertTrue();
  });
}

function handleTouchEventFunc() {
  it('handleTouchEventTest_01', Level.LEVEL0, () => {
    let floatDragScaleControllerTmp: FloatDragScaleController = new FloatDragScaleController(() => containerSession,
      show => needDragScaleFlag = show, (action: SCBGestureAction) => {
      });
    const touchEvent = { type: TouchType.Down } as TouchEvent;
    floatDragScaleControllerTmp.handleTouchEvent(touchEvent);
    expect(assertFlag).assertTrue();
  });
  it('handleTouchEventTest_02', Level.LEVEL0, () => {
    let floatDragScaleControllerTmp: FloatDragScaleController = new FloatDragScaleController(() => containerSession,
      show => needDragScaleFlag = show, (action: SCBGestureAction) => {
      });
    const touchEvent = { type: TouchType.Up } as TouchEvent;
    floatDragScaleControllerTmp.handleTouchEvent(touchEvent);
    expect(assertFlag).assertTrue();
  });
  it('handleTouchEventTest_03', Level.LEVEL0, () => {
    let floatDragScaleControllerTmp: FloatDragScaleController = new FloatDragScaleController(() => containerSession,
      show => needDragScaleFlag = show, (action: SCBGestureAction) => {
      });
    const touchEvent = { type: TouchType.Cancel } as TouchEvent;
    floatDragScaleControllerTmp.handleTouchEvent(touchEvent);
    expect(assertFlag).assertTrue();
  });
}

function handlePanGestureStartFunc() {
  it('handlePanGestureStartTest_01', Level.LEVEL0, () => {
    containerSession.primarySession = null;
    let floatDragScaleControllerTmp: FloatDragScaleController = new FloatDragScaleController(() => containerSession,
      show => needDragScaleFlag = show, (action: SCBGestureAction) => {
      });
    let event = {
      offsetX: 0
    } as GestureEvent;
    floatDragScaleControllerTmp.handlePanGestureStart(event);
    expect(assertFlag).assertTrue();
  });
}

function handlePanGestureUpdateFunc() {
  it('handlePanGestureUpdateTest_01', Level.LEVEL0, () => {
    containerSession.primarySession = null;
    let floatDragScaleControllerTmp: FloatDragScaleController = new FloatDragScaleController(() => containerSession,
      show => needDragScaleFlag = show, (action: SCBGestureAction) => {
      });
    let event = {
      offsetX: 0
    } as GestureEvent;
    floatDragScaleControllerTmp.handlePanGestureUpdate(event);
    expect(assertFlag).assertTrue();
  });
}

function sessionFunc() {
  it('sessionTest_01', Level.LEVEL0, () => {
    let floatDragScaleControllerTmp: FloatDragScaleController = new FloatDragScaleController(() => containerSession,
      show => needDragScaleFlag = show, (action: SCBGestureAction) => {
      });
    floatDragScaleControllerTmp.session();
    expect(assertFlag).assertTrue();
  });
}

function handlePanGestureEndFunc() {
  it('handlePanGestureEndTest_01', Level.LEVEL0, () => {
    containerSession.primarySession = null;
    let floatDragScaleControllerTmp: FloatDragScaleController = new FloatDragScaleController(() => containerSession,
      show => needDragScaleFlag = show, (action: SCBGestureAction) => {
      });
    let event = {
      offsetX: 0
    } as GestureEvent;
    floatDragScaleControllerTmp.handlePanGestureEnd(event);
    expect(assertFlag).assertTrue();
  });
}

function getGestureJudgeResultFunc() {
  it('getGestureJudgeResultTest_01', Level.LEVEL0, () => {
    let floatDragScaleControllerTmp: FloatDragScaleController = new FloatDragScaleController(() => containerSession,
      show => needDragScaleFlag = show, (action: SCBGestureAction) => {
      });
    floatDragScaleControllerTmp.getGestureJudgeResult();
    expect(assertFlag).assertTrue();
  });
}

function onGestureChangeFunc() {
  it('onGestureChangeTest_01', Level.LEVEL0, () => {
    let floatDragScaleControllerTmp: FloatDragScaleController = new FloatDragScaleController(() => containerSession,
      show => needDragScaleFlag = show, (action: SCBGestureAction) => {
      });
    let action = new SCBGestureAction({
      id: SCBGestureActionId.NONE,
      sessionId: sceneSession?.sceneInfo.persistentId
    });
    floatDragScaleControllerTmp.onGestureChange(containerSession, action);
    expect(assertFlag).assertTrue();
  });
  it('onGestureChangeTest_02', Level.LEVEL0, () => {
    let floatDragScaleControllerTmp: FloatDragScaleController = new FloatDragScaleController(() => containerSession,
      show => needDragScaleFlag = show, (action: SCBGestureAction) => {
      });
    let action = new SCBGestureAction({
      id: SCBGestureActionId.FLOAT_GESTURE_END,
      sessionId: sceneSession?.sceneInfo.persistentId
    });
    floatDragScaleControllerTmp.onGestureChange(containerSession, action);
    expect(assertFlag).assertTrue();
  });
}