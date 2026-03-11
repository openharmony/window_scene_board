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
import {
  PreferMultiWindowOrientation,
  SCBKeyboardManager,
  SCBSceneContainerSession,
  scbEventExclusiveManager,
  SCBGestureAction,
  SCBSceneInfo, SCBSceneSession,
  SCBScreenProperty,
  SCBScreenSessionManager
} from '@ohos/windowscene';
import { RectItem } from '@ohos/basicutils';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { describe, Level, it, MockKit, when, ArgumentMatchers, expect, beforeAll } from '@ohos/hypium';
import {
  SCBMultiWindowUtils
} from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBMultiWindowUtils';
import {
  FloatGestureProcessor,
  HotAreaType
} from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBFloatGestureProcessor';
import { BlockCoverController } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBBlockCover';
import {
  FloatMiniCoverController
} from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBFloatMiniCover';
import { SCBFloatManager } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/SCBFloatManager';
import { ReflectionUtils } from './ReflectionUtils';
import { FloatRect } from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/utils/FloatUtils';
import { screenLockService } from '@ohos/screenlockcommon/src/main/ets/TsIndex';

let sceneInfoTmp: SCBSceneInfo;
let floatProcessorTmp: FloatGestureProcessor;
let sceneInfoBTmp: SCBSceneInfo;
let sceneSessionBTmp: SCBSceneSession;
let activeContainerTmp: SCBSceneContainerSession;
let screenPropTmp: SCBScreenProperty;
let containerSessionTmp: SCBSceneContainerSession;
let sceneSessionTmp: SCBSceneSession;
let needBlockCoverFlag: boolean = false;
let needMiniCoverFlag: boolean = false;
let eventAreaTmp: Area = {
  width: 0,
  height: 0,
  position: {
    x: 0, y: 0
  },
  globalPosition: {
    x: 0, y: 0
  }
};
let eventTargetTmp: EventTarget = {
  area: eventAreaTmp
};
let touchEventTmp: TouchEvent = {
  target: {
    area: {
      width: 0,
      height: 0,
      position: {
        x: 0, y: 0
      },
      globalPosition: {
        x: 0, y: 0
      }
    }
  },
  timestamp: 0,
  source: 0,
  pressure: 0,
  tiltX: 0,
  tiltY: 0,
  sourceTool: 0,
  type: TouchType.Down,
  touches: [],
  changedTouches: [{
    id: 0,
    type: 0,
    displayX: 0,
    displayY: 0,
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
let gestureEventTmp: GestureEvent = {
  target: eventTargetTmp,
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
let miniCoverControllerTmp: FloatMiniCoverController;
let blockCoverControllerTmp = new BlockCoverController(() => containerSessionTmp,
  show => needBlockCoverFlag = show);
let innerGestureHandler = (action: SCBGestureAction) => {
  blockCoverControllerTmp.handleGestureAction(containerSessionTmp, screenPropTmp, action);
  miniCoverControllerTmp.onGestureChange(containerSessionTmp, action);
}
let assertFlag: boolean = true;

let initAll = () => {
  sceneInfoBTmp = new SCBSceneInfo('testPri_Bundle_01', 'testPri_Module_01', 'testPri_Ability_01');
  sceneInfoTmp = new SCBSceneInfo('testPri_Bundle', 'testPri_Module', 'testPri_Ability');
  screenPropTmp = new SCBScreenProperty();
  screenPropTmp.width = 1260;
  screenPropTmp.height = 2500;
  sceneSessionBTmp = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfoBTmp), sceneInfoBTmp);
  sceneSessionTmp = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfoTmp), sceneInfoTmp);
  activeContainerTmp = new SCBSceneContainerSession(sceneSessionBTmp, screenPropTmp);
  containerSessionTmp = new SCBSceneContainerSession(sceneSessionTmp, screenPropTmp);
  activeContainerTmp.requestActivation();
  containerSessionTmp.requestActivation();

  if (containerSessionTmp.primarySession && activeContainerTmp.primarySession) {
    containerSessionTmp.primarySession.preferMultiWindowOrientation = PreferMultiWindowOrientation.DEFAULT;
    activeContainerTmp.primarySession.preferMultiWindowOrientation = PreferMultiWindowOrientation.DEFAULT;
  }
  floatProcessorTmp = new FloatGestureProcessor(() => containerSessionTmp, innerGestureHandler);
  miniCoverControllerTmp = new FloatMiniCoverController(() => containerSessionTmp,
    show => needMiniCoverFlag = show, innerGestureHandler);
  gestureEventTmp.fingerList[0] = {
    globalX: 1,
    globalY: 2,
    id: 1,
    localX: 1,
    localY: 2,
    displayX: 1,
    displayY: 2
  };
}

export function SCBFloatGestureProcessorTest() {
  describe('FloatGestureProcessorTest_describe', () => {
    beforeAll(initAll);
    SCBFloatGestureProcessorTest1_func();
    SCBFloatGestureProcessorTest2_func();
    SCBFloatGestureProcessorTest3_func();
    SCBFloatGestureProcessorTest4_func();
    SCBFloatGestureProcessorTest5_func();
    processFloatToSplitTest1_func();
    processFloatToSplitTest2_func();
  })
}

function SCBFloatGestureProcessorTest1_func() {
  it('init_it', Level.LEVEL0, () => {
    let KeyboardManager = SCBKeyboardManager.getInstance();
    let screenSessionManager = SCBScreenSessionManager.getInstance();
    let mocker1: MockKit = new MockKit();
    let func1: Function =
      mocker1.mockFunc(KeyboardManager, KeyboardManager.getKeyboardSession().isKeyboardShowing);
    when(func1)(ArgumentMatchers.any).afterReturn(true);

    let func2: Function = mocker1.mockFunc(SCBMultiWindowUtils,
      SCBMultiWindowUtils.isVertical);
    when(func2)(ArgumentMatchers.any).afterReturn(true);

    let func3: Function = mocker1.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);
    when(func3)(ArgumentMatchers.any).afterReturn(true);

    floatProcessorTmp.init(screenPropTmp);
    mocker1.clear(SCBMultiWindowUtils);
    expect(assertFlag).assertTrue();
    mocker1.clear(screenSessionManager);
    mocker1.clear(KeyboardManager);
  });

  it('handleTouchEvent_it_02', Level.LEVEL0, () => {
    touchEventTmp.type = TouchType.Down;
    floatProcessorTmp.handleTouchEvent(touchEventTmp);
    containerSessionTmp.requestBackground();
    floatProcessorTmp.handleTouchEvent(touchEventTmp);
    expect(assertFlag).assertTrue();
  });
  it('handleTouchEvent_it_01', Level.LEVEL0, () => {
    let moveEventTmp1: TouchEvent = {
      type: TouchType.Down,
      touches: [{
        id: 1,
        windowX: 1,
        windowY: 1,
      }, {
        id: 3,
        windowX: 3,
        windowY: 3,
      }],
      changedTouches:
      [{
        id: 1,
        windowX: 1,
        windowY: 1,
      }]
    } as TouchEvent;
    let moveEventTmp2: TouchEvent = {
      type: TouchType.Move,
      touches: [{
        id: 4,
        windowX: 4,
        windowY: 4,
      }]
    } as TouchEvent;
    floatProcessorTmp.handleTouchEvent(moveEventTmp1);
    moveEventTmp1.type = TouchType.Move;
    floatProcessorTmp.handleTouchEvent(moveEventTmp1);
    floatProcessorTmp.handleTouchEvent(moveEventTmp2);
    moveEventTmp1.type = TouchType.Up;
    floatProcessorTmp.handleTouchEvent(moveEventTmp1);
    moveEventTmp1.type = TouchType.Cancel;
    floatProcessorTmp.handleTouchEvent(moveEventTmp1);
  });

  it('handleTouchEvent_it_04', Level.LEVEL0, () => {
    touchEventTmp.type = TouchType.Up;
    floatProcessorTmp.handleTouchEvent(touchEventTmp);
    expect(assertFlag).assertTrue();
  });
  it('handleTouchEvent_it_03', Level.LEVEL0, () => {
    touchEventTmp.type = TouchType.Move;
    floatProcessorTmp.handleTouchEvent(touchEventTmp);
    expect(assertFlag).assertTrue();
  });

  it('getGestureJudgeResult_it_02', Level.LEVEL0, () => {
    let mocker1: MockKit = new MockKit();
    let func1: Function = mocker1.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.getEventExclusiveByCaller);
    when(func1)(ArgumentMatchers.any).afterReturn(true);
    let func2: Function = mocker1.mockFunc(AppStorage, AppStorage.get);
    when(func2)(ArgumentMatchers.any).afterReturn(true);
    floatProcessorTmp.getGestureJudgeResult();
    expect(assertFlag).assertTrue();
    mocker1.clear(func1);
    mocker1.clear(func2);
  });
  it('getGestureJudgeResult_it_01', Level.LEVEL0, () => {
    let mocker1: MockKit = new MockKit();
    let func1: Function = mocker1.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.getEventExclusiveByCaller);
    when(func1)(ArgumentMatchers.any).afterReturn(false);
    let func2: Function = mocker1.mockFunc(AppStorage, AppStorage.get);
    when(func2)(ArgumentMatchers.any).afterReturn(false);
    containerSessionTmp.floatingParam.isFocused = false;
    floatProcessorTmp.getGestureJudgeResult();
    expect(assertFlag).assertTrue();
    mocker1.clear(func1);
    mocker1.clear(func2);
  });

  it('handleGestureActionUpdate_it_01', Level.LEVEL0, () => {
    initAll();
    containerSessionTmp.primarySession = null;
    let mocker: MockKit = new MockKit();
    screenLockService.setLock(false);
    let fun2: Function = mocker.mockFunc(floatProcessorTmp, floatProcessorTmp.applyPositionToContainer);
    when(fun2)(ArgumentMatchers.any);
    let activeContainerFun: Function = mocker.mockFunc(floatProcessorTmp, floatProcessorTmp.getActiveContainer);
    activeContainerTmp.requestBackground();
    when(activeContainerFun)(ArgumentMatchers.any).afterReturn(activeContainerTmp);
    floatProcessorTmp.handleGestureActionUpdate(gestureEventTmp);
    mocker.clear(activeContainerFun);
    mocker.clear(fun2);
    expect(assertFlag).assertTrue();
  });

  it('handleGestureActionUpdate_it_02', Level.LEVEL0, () => {
    initAll();
    let floatRect: FloatRect = new FloatRect(0, 0, 0, 0);
    screenLockService.setLock(false);
    floatRect.top = 0;
    ReflectionUtils.setProperty(floatProcessorTmp, 'isKeyboardShow', true);
    floatRect.dragDownRect = new RectItem(px2vp(630), 0, px2vp(630), 10);
    ReflectionUtils.setProperty(floatProcessorTmp, 'floatRect', floatRect);
    containerSessionTmp.splitParam.isPreSplit = true;
    let mocker1: MockKit = new MockKit();
    let fun1: Function = mocker1.mockFunc(floatProcessorTmp, floatProcessorTmp.applyPositionToContainer);
    when(fun1)(ArgumentMatchers.any);
    let activeContainerFun: Function = mocker1.mockFunc(floatProcessorTmp, floatProcessorTmp.getActiveContainer);
    activeContainerTmp.requestBackground();
    when(activeContainerFun)(ArgumentMatchers.any).afterReturn(activeContainerTmp);
    floatProcessorTmp.handleGestureActionUpdate(gestureEventTmp);
    mocker1.clear(fun1);
    mocker1.clear(activeContainerFun);
    expect(assertFlag).assertTrue();
  });

  it('handleGestureActionUpdate_it_03', Level.LEVEL0, () => {
    initAll();
    screenLockService.setLock(false);
    let floatRect: FloatRect = new FloatRect(0, 0, 0, 0);
    floatRect.top = 50;
    ReflectionUtils.setProperty(floatProcessorTmp, 'floatRect', floatRect);
    let mocker1: MockKit = new MockKit();
    let fun1: Function = mocker1.mockFunc(floatProcessorTmp, floatProcessorTmp.applyPositionToContainer);
    when(fun1)(ArgumentMatchers.any);
    let activeContainerFun: Function = mocker1.mockFunc(floatProcessorTmp, floatProcessorTmp.getActiveContainer);
    activeContainerTmp.requestBackground();
    when(activeContainerFun)(ArgumentMatchers.any).afterReturn(activeContainerTmp);
    floatProcessorTmp.handleGestureActionUpdate(gestureEventTmp);
    mocker1.clear(fun1);
    mocker1.clear(activeContainerFun);
    expect(assertFlag).assertTrue();
  });

  it('handleGestureActionUpdate_it_04', Level.LEVEL0, () => {
    initAll();
    let emptyGestureEventTmp: GestureEvent = {
      target: eventTargetTmp,
      timestamp: 0,
      source: 0,
      pressure: 0,
      tiltX: 1,
      tiltY: 0,
      sourceTool: 0,
      repeat: false,
      fingerList: [],
      offsetX: 1,
      offsetY: 0,
      angle: 0,
      speed: 0,
      scale: 0,
      pinchCenterX: 1,
      pinchCenterY: 0,
      velocityX: 0,
      velocityY: 0,
      velocity: 1
    }
    screenLockService.setLock(false);
    floatProcessorTmp.handleGestureActionUpdate(emptyGestureEventTmp);
    expect(assertFlag).assertTrue();
  });

  it('recoverObliquityAnimate_it_01', Level.LEVEL0, () => {
    let mocker1: MockKit = new MockKit();
    let func1: Function = mocker1.mockFunc(floatProcessorTmp, floatProcessorTmp.getActiveContainer);
    activeContainerTmp.isSplit = true;
    when(func1)(ArgumentMatchers.any).afterReturn(activeContainerTmp);
    expect(assertFlag).assertTrue();
    floatProcessorTmp.recoverObliquityAnimate(containerSessionTmp, false);
    mocker1.clear(func1);
  });

  it('recoverObliquityAnimate_it_02', Level.LEVEL0, () => {
    let mocker1: MockKit = new MockKit();
    let func1: Function = mocker1.mockFunc(floatProcessorTmp, floatProcessorTmp.getActiveContainer);
    activeContainerTmp.isSplit = false;
    when(func1)(ArgumentMatchers.any).afterReturn(activeContainerTmp);
    floatProcessorTmp.recoverObliquityAnimate(containerSessionTmp, false);
    mocker1.clear(func1);
    expect(assertFlag).assertTrue();
  });

  it('doObliquityAnimate_it_01', Level.LEVEL0, () => {
    let mocker1: MockKit = new MockKit();
    let func1: Function = mocker1.mockFunc(floatProcessorTmp, floatProcessorTmp.getActiveContainer);
    activeContainerTmp.isSplit = false;
    when(func1)(ArgumentMatchers.any).afterReturn(activeContainerTmp);
    floatProcessorTmp.doObliquityAnimate(containerSessionTmp);
    mocker1.clear(func1);
    expect(assertFlag).assertTrue();
  });

  it('doObliquityAnimate_it_02', Level.LEVEL0, () => {
    let mocker1: MockKit = new MockKit();
    let func1: Function = mocker1.mockFunc(floatProcessorTmp, floatProcessorTmp.getActiveContainer);
    activeContainerTmp.isSplit = true;
    when(func1)(ArgumentMatchers.any).afterReturn(activeContainerTmp);
    floatProcessorTmp.doObliquityAnimate(containerSessionTmp);
    mocker1.clear(func1);
    expect(assertFlag).assertTrue();
  });

  it('doObliquityAnimateit_03', Level.LEVEL0, () => {
    let mocker1: MockKit = new MockKit();
    let func1: Function = mocker1.mockFunc(floatProcessorTmp, floatProcessorTmp.getActiveContainer);
    activeContainerTmp.isSplit = false;
    when(func1)(ArgumentMatchers.any).afterReturn(activeContainerTmp);
    ReflectionUtils.setProperty(floatProcessorTmp, 'touchDisplayY', 0);
    ReflectionUtils.setProperty(floatProcessorTmp, 'isUpDownSplit', true);
    floatProcessorTmp.doObliquityAnimate(containerSessionTmp);
    mocker1.clear(func1);
    expect(assertFlag).assertTrue();
  });
}

function SCBFloatGestureProcessorTest2_func() {
  it('initSplitHotArea_it_01', Level.LEVEL0, () => {
    let mocker1: MockKit = new MockKit();
    let func1: Function = mocker1.mockFunc(floatProcessorTmp, floatProcessorTmp.getActiveContainer);
    activeContainerTmp.isSplit = true;
    when(func1)(ArgumentMatchers.any).afterReturn(activeContainerTmp);
    floatProcessorTmp.initSplitHotArea(screenPropTmp);
    mocker1.clear(func1);
    expect(assertFlag).assertTrue();
  });

  it('initSplitHotArea_it_02', Level.LEVEL0, () => {
    let mocker1: MockKit = new MockKit();
    let func1: Function = mocker1.mockFunc(floatProcessorTmp, floatProcessorTmp.getActiveContainer);
    when(func1)(ArgumentMatchers.any).afterReturn(activeContainerTmp);
    activeContainerTmp.isSplit = true;
    let obj1 = activeContainerTmp.dividerParam;
    let func2: Function = mocker1.mockFunc(obj1, obj1.isUpDownSplit);
    when(func2)(ArgumentMatchers.any).afterReturn(true);
    floatProcessorTmp.initSplitHotArea(screenPropTmp);
    mocker1.clear(func1);
    mocker1.clear(func2);
    expect(assertFlag).assertTrue();
  });

  it('initSplitHotArea_it_03', Level.LEVEL0, () => {
    let mocker1: MockKit = new MockKit();
    let func1: Function = mocker1.mockFunc(floatProcessorTmp, floatProcessorTmp.getActiveContainer);
    when(func1)(ArgumentMatchers.any).afterReturn(activeContainerTmp);
    activeContainerTmp.isSplit = true;
    let obj1 = activeContainerTmp.dividerParam;
    let func2: Function = mocker1.mockFunc(obj1, obj1.isUpDownSplit);
    when(func2)(ArgumentMatchers.any).afterReturn(false);
    floatProcessorTmp.initSplitHotArea(screenPropTmp);
    mocker1.clear(func1);
    mocker1.clear(func2);
    expect(assertFlag).assertTrue();
  });

  it('initSplitHotArea_it_04', Level.LEVEL0, () => {
    let mocker1: MockKit = new MockKit();
    let func1: Function = mocker1.mockFunc(floatProcessorTmp, floatProcessorTmp.getActiveContainer);
    activeContainerTmp.isSplit = false;
    if (!containerSessionTmp.primarySession) {
      expect(assertFlag).assertTrue();
      mocker1.clear(func1);
      return;
    } else {
      containerSessionTmp.primarySession.preferMultiWindowOrientation = PreferMultiWindowOrientation.LANDSCAPE;
    }
    when(func1)(ArgumentMatchers.any).afterReturn(activeContainerTmp);
    floatProcessorTmp.initSplitHotArea(screenPropTmp);
    containerSessionTmp.primarySession.preferMultiWindowOrientation = PreferMultiWindowOrientation.LANDSCAPE_AUTO;
    floatProcessorTmp.initSplitHotArea(screenPropTmp);
    expect(assertFlag).assertTrue();
    mocker1.clear(func1);
  });

  it('initSplitHotArea_it_05', Level.LEVEL0, () => {
    let mocker1: MockKit = new MockKit();
    let func1: Function = mocker1.mockFunc(floatProcessorTmp, floatProcessorTmp.getActiveContainer);
    activeContainerTmp.isSplit = false;
    if (!activeContainerTmp.primarySession) {
      expect(assertFlag).assertTrue();
      mocker1.clear(func1);
      return;
    } else {
      activeContainerTmp.primarySession.preferMultiWindowOrientation = PreferMultiWindowOrientation.LANDSCAPE;
    }
    when(func1)(ArgumentMatchers.any).afterReturn(activeContainerTmp);
    floatProcessorTmp.initSplitHotArea(screenPropTmp);
    expect(assertFlag).assertTrue();

    activeContainerTmp.primarySession.preferMultiWindowOrientation = PreferMultiWindowOrientation.LANDSCAPE_AUTO;
    when(func1)(ArgumentMatchers.any).afterReturn(activeContainerTmp);
    floatProcessorTmp.initSplitHotArea(screenPropTmp);
    mocker1.clear(floatProcessorTmp);
  });

  it('initSplitHotArea_it_06', Level.LEVEL0, () => {
    let mocker1: MockKit = new MockKit();
    let func1: Function = mocker1.mockFunc(SCBMultiWindowUtils, SCBMultiWindowUtils.isVertical);
    when(func1)(ArgumentMatchers.any).afterReturn(false);
    let func2: Function = mocker1.mockFunc(floatProcessorTmp, floatProcessorTmp.getActiveContainer);
    activeContainerTmp.isSplit = false;
    when(func2)(ArgumentMatchers.any).afterReturn(activeContainerTmp);
    floatProcessorTmp.initSplitHotArea(screenPropTmp);
    expect(assertFlag).assertTrue();
    mocker1.clear(func1);
    mocker1.clear(func2);
  });

  it('initSplitHotArea_it_07', Level.LEVEL0, () => {
    let mocker1: MockKit = new MockKit();
    let func1: Function = mocker1.mockFunc(SCBMultiWindowUtils, SCBMultiWindowUtils.isVertical);
    when(func1)(ArgumentMatchers.any).afterReturn(true);
    let func2: Function = mocker1.mockFunc(floatProcessorTmp, floatProcessorTmp.getActiveContainer);
    activeContainerTmp.isSplit = false;
    when(func2)(ArgumentMatchers.any).afterReturn(activeContainerTmp);
    let obj3 = SCBScreenSessionManager.getInstance();
    let func3: Function = mocker1.mockFunc(obj3, obj3.isFoldablePhoneExpandStatus);
    when(func3)(ArgumentMatchers.any).afterReturn(true);
    floatProcessorTmp.initSplitHotArea(screenPropTmp);
    expect(assertFlag).assertTrue();
    mocker1.clear(func1);
    mocker1.clear(func2);
    mocker1.clear(func3);
  });
}

function SCBFloatGestureProcessorTest3_func() {
  it('doPreSplitAnimate_it_01', Level.LEVEL0, () => {
    floatProcessorTmp.doPreSplitAnimate(activeContainerTmp, containerSessionTmp, HotAreaType.PRE_SPLIT);
    expect(assertFlag).assertTrue();
  })

  it('doPreSplitAnimate_it_02', Level.LEVEL0, () => {
    activeContainerTmp.isSplit = true;
    floatProcessorTmp.doPreSplitAnimate(activeContainerTmp, containerSessionTmp, HotAreaType.PRE_SPLIT);
    expect(assertFlag).assertTrue();
  })

  it('doFloatToPreSplitAnimate_it_01', Level.LEVEL0, () => {
    initAll();
    let mocker1: MockKit = new MockKit();
    let obj1 = SCBFloatManager.getInstance();
    let func1: Function = mocker1.mockFunc(obj1, obj1.isSupportPairSplit);
    when(func1)(ArgumentMatchers.any).afterReturn(true);
    ReflectionUtils.setProperty(floatProcessorTmp, 'isAnimated', false);

    let activeContainerFun: Function = mocker1.mockFunc(floatProcessorTmp, floatProcessorTmp.getActiveContainer);
    activeContainerTmp.requestBackground();
    activeContainerTmp.isSplit = true;
    when(activeContainerFun)(ArgumentMatchers.any).afterReturn(activeContainerTmp);

    floatProcessorTmp.doFloatToPreSplitAnimate(containerSessionTmp, HotAreaType.PRE_SPLIT);
    mocker1.clear(func1);
    mocker1.clear(activeContainerFun);
    expect(assertFlag).assertTrue();
  })

  it('doFloatToPreSplitAnimate_it_02', Level.LEVEL0, () => {
    initAll();
    let mocker1: MockKit = new MockKit();
    let func1: Function = mocker1.mockFunc(floatProcessorTmp, floatProcessorTmp.getActiveContainer);
    activeContainerTmp.requestBackground();
    when(func1)(ArgumentMatchers.any).afterReturn(activeContainerTmp);
    let obj2 = SCBFloatManager.getInstance();
    let func2: Function = mocker1.mockFunc(obj2, obj2.isSupportPairSplit);
    when(func2)(ArgumentMatchers.any).afterReturn(true);
    floatProcessorTmp.doFloatToPreSplitAnimate(containerSessionTmp, HotAreaType.LEFT_SPLIT);
    mocker1.clear(func1);
    mocker1.clear(func2);
    expect(assertFlag).assertTrue();
  })

  it('doFloatToPreSplitAnimate_it_03', Level.LEVEL0, () => {
    initAll();
    let mocker1: MockKit = new MockKit();
    let func1: Function = mocker1.mockFunc(floatProcessorTmp, floatProcessorTmp.getActiveContainer);
    activeContainerTmp.requestBackground();
    when(func1)(ArgumentMatchers.any).afterReturn(activeContainerTmp);

    let obj2 = SCBFloatManager.getInstance();
    let func2: Function = mocker1.mockFunc(obj2, obj2.isSupportPairSplit);
    when(func2)(ArgumentMatchers.any).afterReturn(true);

    floatProcessorTmp.doFloatToPreSplitAnimate(containerSessionTmp, HotAreaType.RIGHT_SPLIT);
    mocker1.clear(func1);
    mocker1.clear(func2);
    expect(assertFlag).assertTrue();
  })
}

function SCBFloatGestureProcessorTest4_func() {
  it('handleGestureActionStart1', Level.LEVEL0, () => {
    initAll();
    floatProcessorTmp.handleGestureActionStart(gestureEventTmp);
    expect(assertFlag).assertTrue();
  })

  it('doPreSplitTransformFromSplit1', Level.LEVEL0, () => {
    floatProcessorTmp.doPreSplitTransformFromSplit(null, HotAreaType.PRE_SPLIT);
    expect(assertFlag).assertTrue();
  })

  it('doPreSplitTransformFromSplit2', Level.LEVEL0, () => {
    floatProcessorTmp.doPreSplitTransformFromSplit(activeContainerTmp, HotAreaType.PRE_SPLIT);
    expect(assertFlag).assertTrue();
  })

  it('doPreSplitTransformFromSplit3', Level.LEVEL0, () => {
    floatProcessorTmp.doPreSplitTransformFromSplit(activeContainerTmp, HotAreaType.LEFT_SPLIT);
    expect(assertFlag).assertTrue();
  })

  it('handleGestureActionCancel1', Level.LEVEL0, () => {
    initAll();
    floatProcessorTmp.handleGestureActionCancel();
    expect(assertFlag).assertTrue();
  })

  it('handleGestureActionCancel2', Level.LEVEL0, () => {
    initAll();
    containerSessionTmp.isSplit = true;
    floatProcessorTmp.handleGestureActionCancel();
    expect(assertFlag).assertTrue();
  })

  it('calcObliquity1', Level.LEVEL0, () => {
    containerSessionTmp.isSplit = true;
    ReflectionUtils.setProperty(floatProcessorTmp, 'isUpDownSplit', true);
    floatProcessorTmp.calcObliquity(true);
    expect(assertFlag).assertTrue();
  })

  it('calcObliquity2', Level.LEVEL0, () => {
    containerSessionTmp.isSplit = true;
    ReflectionUtils.setProperty(floatProcessorTmp, 'isUpDownSplit', false);
    floatProcessorTmp.calcObliquity(true);
    expect(assertFlag).assertTrue();
  })

  it('doBlurScaleForPreSplit1', Level.LEVEL0, () => {
    floatProcessorTmp.doBlurScaleForPreSplit(null, HotAreaType.LEFT_SPLIT);
    expect(assertFlag).assertTrue();
  })

  it('doBlurScaleForPreSplit2', Level.LEVEL0, () => {
    activeContainerTmp.dividerParam.splitOrderIsNotReverse = true;
    activeContainerTmp.isSplit = true;
    floatProcessorTmp.doBlurScaleForPreSplit(activeContainerTmp, HotAreaType.LEFT_SPLIT);
    expect(assertFlag).assertTrue();
  })
}

function SCBFloatGestureProcessorTest5_func() {
  it('handleGestureActionEnd1', Level.LEVEL0, () => {
    initAll();
    let mocker1: MockKit = new MockKit();
    let obj1 = SCBFloatManager.getInstance();
    let func1: Function = mocker1.mockFunc(obj1, obj1.reachThreshold);
    when(func1)(ArgumentMatchers.any).afterReturn(true);
    floatProcessorTmp.handleGestureActionEnd(gestureEventTmp);
    mocker1.clear(func1);
    expect(assertFlag).assertTrue();
  })
}

function processFloatToSplitTest2_func() {
  it('processFloatToSplit_it_2_1', Level.LEVEL0, () => {
    let mocker1: MockKit = new MockKit();
    activeContainerTmp.requestActivation();
    activeContainerTmp.isSplit = true;
    let screenPropertyTmp: SCBScreenProperty = new SCBScreenProperty();
    screenPropertyTmp.screenId = 0;
    screenPropertyTmp.rotation = 0;
    screenPropertyTmp.width = 1260;
    screenPropertyTmp.height = 2440;
    containerSessionTmp = new SCBSceneContainerSession(sceneSessionTmp, screenPropertyTmp);
    containerSessionTmp.requestActivation();
    containerSessionTmp.splitParam.isPreSplit = true;
    ReflectionUtils.setProperty(floatProcessorTmp, 'isAnimated', true);
    let obj1 = SCBFloatManager.getInstance();
    let func1: Function = mocker1.mockFunc(obj1, obj1.isSupportPairSplit);
    when(func1)(ArgumentMatchers.any).afterReturn(true);
    floatProcessorTmp.processFloatToSplit(activeContainerTmp, containerSessionTmp, HotAreaType.LEFT_SPLIT,
      screenPropTmp, true);
    expect(assertFlag).assertTrue();
    mocker1.clear(obj1);
  });

  it('processFloatToSplit_it_2_2', Level.LEVEL0, () => {
    let mocker: MockKit = new MockKit();
    activeContainerTmp.requestActivation();
    activeContainerTmp.isSplit = true;
    activeContainerTmp.dividerParam.needCutOut = true;
    let screenPropertyTmp: SCBScreenProperty = new SCBScreenProperty();
    screenPropertyTmp.screenId = 0;
    screenPropertyTmp.rotation = 0;
    screenPropertyTmp.width = 1260;
    screenPropertyTmp.height = 2440;
    containerSessionTmp = new SCBSceneContainerSession(sceneSessionTmp, screenPropertyTmp);
    containerSessionTmp.requestActivation();
    containerSessionTmp.splitParam.isPreSplit = true;
    ReflectionUtils.setProperty(floatProcessorTmp, 'isAnimated', true);
    let obj1 = SCBFloatManager.getInstance();
    let func1: Function = mocker.mockFunc(obj1, obj1.isSupportPairSplit);
    when(func1)(ArgumentMatchers.any).afterReturn(true);
    floatProcessorTmp.processFloatToSplit(activeContainerTmp, containerSessionTmp, HotAreaType.RIGHT_SPLIT,
      screenPropTmp, true);
    expect(assertFlag).assertTrue();
    mocker.clear(func1);
  });
}

function processFloatToSplitTest1_func() {
  it('processFloatToSplit_it_1_1', Level.LEVEL0, () => {
    let result = floatProcessorTmp.processFloatToSplit(undefined, containerSessionTmp, HotAreaType.PRE_SPLIT,
      screenPropTmp, true);
    expect(assertFlag).assertTrue();
  });

  it('processFloatToSplit_it_1_2', Level.LEVEL0, () => {
    containerSessionTmp = new SCBSceneContainerSession(sceneSessionTmp, new SCBScreenProperty());
    let result = floatProcessorTmp.processFloatToSplit(activeContainerTmp, containerSessionTmp, HotAreaType.PRE_SPLIT,
        screenPropTmp, true);
    expect(assertFlag).assertTrue();
  });

  it('processFloatToSplit_it_1_3', Level.LEVEL0, () => {
    containerSessionTmp.splitParam.isPreSplit = true;
    let result = floatProcessorTmp.processFloatToSplit(activeContainerTmp, containerSessionTmp, HotAreaType.NONE,
      screenPropTmp, true);
    expect(assertFlag).assertTrue();
  });

  it('processFloatToSplit_it_1_4', Level.LEVEL0, () => {
    let mocker1: MockKit = new MockKit();
    activeContainerTmp.requestActivation();
    activeContainerTmp.isSplit = true;
    let screenPropertyTmp: SCBScreenProperty = new SCBScreenProperty();
    screenPropertyTmp.screenId = 0;
    screenPropertyTmp.rotation = 0;
    screenPropertyTmp.width = 1260;
    screenPropertyTmp.height = 2440;
    containerSessionTmp = new SCBSceneContainerSession(sceneSessionTmp, screenPropertyTmp);
    containerSessionTmp.requestActivation();
    let obj1 = SCBFloatManager.getInstance();
    let func1: Function = mocker1.mockFunc(obj1, obj1.isSupportPairSplit);
    when(func1)(ArgumentMatchers.any).afterReturn(true);
    floatProcessorTmp.processFloatToSplit(activeContainerTmp, containerSessionTmp, HotAreaType.PRE_SPLIT,
      screenPropTmp, true);
    expect(assertFlag).assertTrue();
    mocker1.clear(func1);
  });
}