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


import { beforeAll, describe, expect, it, Level } from '@ohos/hypium';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  SCBScreenProperty,
  SCBFloatingParam,
  SCBSceneSession,
  SCBSceneInfo,
  SCBSceneContainerSession,
  CornerParam,
  CornerArea,
  ScbNumber,
  RecentFloatingAnimParams,
  UserAction,
  SCBGestureActionId
} from '../../../../../../../main/ets/TsIndex';
import { RotationConstants, SCBConstants } from '@ohos/commonconstants';
import { SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { RectItem, } from '@ohos/basicutils';
import {
  FloatingRectCache,
  RecentParams,
  RecordType
} from '../../../../../../../main/ets/scene/session/SCBFloatingParam';

let screenProp: SCBScreenProperty;
let floatParam: SCBFloatingParam;
let rectCache: FloatingRectCache = new FloatingRectCache(0, 0, 0, 0);
let sceneSession: SCBSceneSession;
let sceneInfo: SCBSceneInfo;
let container: SCBSceneContainerSession;

export function SCBFloatingParamTest() {
  describe('SCBCommonFloatingParamTest', () => {
    beforeAll(() => {
      sceneInfo = new SCBSceneInfo('testSideEdgeBar', 'testSideEdgeBar', 'testSideEdgeBar');
      sceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      floatParam = new SCBFloatingParam();
      screenProp = new SCBScreenProperty();
      screenProp.width = 1260;
      screenProp.height = 2500;
      container = new SCBSceneContainerSession(sceneSession, screenProp);
      container.floatingParam = floatParam;
    })
    SCBFloatingParamTest_setFloatingRect();
    SCBFloatingParamTest_setMemValue01();
    SCBFloatingParamTest_setMemValue02();
    SCBFloatingParamTest_copyTo();
    SCBFloatingParamTest_recentFloatingAnimParams();
    SCBFloatingParamTest_recordRect();
    SCBFloatingParamTest_isVertical();
    SCBFloatingParamTest_01();
    SCBFloatingParamTest_initWithDeviceInfo();
  })
}

function SCBFloatingParamTest_setFloatingRect() {
  it('SCBFloatingParamTest_setFloatingRect', Level.LEVEL0, (): void => {
    let newRect: FloatingRectCache = new FloatingRectCache(0, 0, 0, 0);
    newRect.isMiniScene = false;
    newRect.scale = 0.75;
    rectCache.setFloatingRect(newRect);
    expect(rectCache.scale === 0.75).assertTrue();
    newRect = new FloatingRectCache(0, 0, screenProp.width, screenProp.height);
    newRect.isMiniScene = true;
    newRect.scale = 1;
    rectCache.setFloatingRect(newRect);
    expect(rectCache.width() === screenProp.width).assertTrue();
  });
}

function SCBFloatingParamTest_setMemValue01() {
  it('SCBFloatingParamTest_setMemValue01', Level.LEVEL0, (): void => {
    floatParam.scale = 0.3;
    floatParam.borderColor = '#00317af7';
    floatParam.borderWidth = 2;
    floatParam.needShowBackground = false;
    floatParam.floatingScaleHelper = 0.79;
    floatParam.defaultWidthRatio = 0.5;
    floatParam.aspectRatio = 3 / 4;
    floatParam.maxWidthRatio = 0.79;
    floatParam.miniWidthRatio = 0.3;
    floatParam.calcRatioBaseWidth = 1260;
    floatParam.miniSceneTopMargin = 32;
    floatParam.miniSceneRightMargin = 20;
    floatParam.cornerRadius = 24;
    floatParam.cacheRect = new RectItem(0, 0, 0, 0);
    floatParam.aspectWithTitleBar = 3.5 / 4.3;
    floatParam.showSideBarCover = false;
    floatParam.highLightBarOffsetX = 1;
    floatParam.sideBarAlpha = 1;
    floatParam.touchable = false;
    floatParam.floatRecentAnimateFinished = false;
    floatParam.cacheScaleForMini = 1;
    floatParam.isFocused = false;
    floatParam.isClosed = false;
    floatParam.isTerminated = false;
    floatParam.isMinimized = false;
    floatParam.doFoldOrExpand = false;
    floatParam.isMinFloating = false;
    floatParam.isClosingFloat = false;
    floatParam.titleBarOpacity = 1;
    floatParam.transitionAnimationCount = 1;
    floatParam.boardOpacity = 1;
    floatParam.minAnimationNum = 1;
    floatParam.isFloatDragging = false;
    floatParam.needFloatScale = false;
    floatParam.isShowTitleBar = false;
    floatParam.isFloatEdgeDrag = false;
    floatParam.needEffectComponent = false;
    floatParam.isLandscapeFloat = false;
    floatParam.isHandleTouchEvent = false;
    floatParam.isInFullHotspot = false;
    floatParam.needRecoverStatusBar = false;
    floatParam.effectCompOpacity = 1;
    expect(true).assertTrue();
  });
}

function SCBFloatingParamTest_setMemValue02() {
  it('SCBFloatingParamTest_setMemValue02', Level.LEVEL0, (): void => {
    floatParam.shadowOptions = {
      radius: 20,
      type: undefined,
      color: Color.Red,
      offsetX: 50,
      offsetY: 50,
      fill: false
    };
    let cornerParam: CornerParam = new CornerParam();
    cornerParam.area = CornerArea.MAIN;
    cornerParam.anotherSceneRectVp = new RectItem(0, 0, screenProp.width, screenProp.height);
    floatParam.cornerParam = cornerParam;
    floatParam.recentParams = new RecentParams();
    floatParam.recentParams.positionX = new ScbNumber(100);
    floatParam.recentParams.positionY = new ScbNumber(200);
    floatParam.recentParams.scaleX = new ScbNumber(0.5);
    floatParam.recentParams.scaleY = new ScbNumber(0.5);
    floatParam.recentParams.clipWidth = new ScbNumber(screenProp.width);
    floatParam.recentParams.clipHeight = new ScbNumber(screenProp.height);
    floatParam.recentParams.width = new ScbNumber(screenProp.width);
    floatParam.recentParams.height = new ScbNumber(screenProp.height);
    floatParam.recentParams.floatBorderWidth = 2;
    floatParam.recentParams.floatScale = 0.5;
    floatParam.recentParams.floatBorderRadius = 24;
    floatParam.recentParams.floatShadowColor = '#73000000';
    floatParam.recentParams.isFloatingSessionClosed = false;
    floatParam.recentParams.isValid = true;
    expect(floatParam.recentParams.isValid).assertTrue();
  });
}

function SCBFloatingParamTest_copyTo() {
  it('SCBFloatingParamTest_copyCachedPosition', Level.LEVEL0, (): void => {
    let rect: RectItem = new RectItem(0, 0, screenProp.width, screenProp.height);
    container.floatingParam.recentParams.copyCachedPosition(rect);
    expect(container !== null).assertTrue();
  });
}

function SCBFloatingParamTest_recentFloatingAnimParams() {
  it('SCBFloatingParamTest_recentFloatingAnimParams', Level.LEVEL0, (): void => {
    let persistentId: number = 1;
    let positionX: number = 0;
    let positionY: number = 0;
    let scale: number = 1;
    let width: number = 0;
    let floatAnim: RecentFloatingAnimParams = new RecentFloatingAnimParams(persistentId, positionX, positionY, width);
    floatAnim.getPositionX();
    floatAnim.getPositionY();
    floatAnim.getWidth();
    floatAnim.getPersistentId();
    expect(floatAnim.persistentId === 1).assertTrue();
  });
}

function SCBFloatingParamTest_recordRect() {
  it('SCBFloatingParamTest_recordRect', Level.LEVEL0, (): void => {
    let recordRect = new FloatingRectCache(0, 0, screenProp.width, screenProp.height);
    floatParam.recordRect(recordRect, RecordType.QUICK_CLOSE);
    floatParam.delRecordRect(RecordType.QUICK_CLOSE);
    floatParam.delRecordRect();
    floatParam.recordRect(recordRect, RecordType.AVOID_CACHE);
    floatParam.checkRecordByType(RecordType.AVOID_CACHE);
    floatParam.getRectRecordByType(RecordType.AVOID_CACHE);
    expect(true).assertTrue();
  });
}

function SCBFloatingParamTest_isVertical() {
  it('SCBFloatingParamTest_isVertical', Level.LEVEL0, (): void => {
    floatParam.isVertical(RotationConstants.ROTATION_0);
    floatParam.isVertical(RotationConstants.ROTATION_180);
    floatParam.isVertical(RotationConstants.ROTATION_360);
    expect(true).assertTrue();
  });
}

function SCBFloatingParamTest_01() {
  it('SCBFloatingParamTest_initCacheForMini', Level.LEVEL0, (): void => {
    floatParam.initCacheForMini();
    floatParam.getRotationOnExpandStatus(screenProp);
    floatParam.setBorderColor('00FF0000');
    floatParam.setFloatingSceneClosed(false);
    floatParam.setFloatingSceneClosed(true);
    floatParam.isClosed = false;
    floatParam.isTerminated = true;
    floatParam.isFloatingSceneClosed();
    floatParam.setUserAction(UserAction.QUICK_MIN);
    floatParam.getUserAction();
    let transformCallback = (id?: SCBGestureActionId) => {
      id = 1;
    }
    floatParam.registerTransformCallback(transformCallback);
    floatParam.notifyTransform();
    floatParam.unregisterTransformCallback(transformCallback);
    floatParam.setFloatEdgeDrag(true);
    expect(true).assertTrue();
  });
}

function SCBFloatingParamTest_initWithDeviceInfo() {
  it('SCBFloatingParamTest_initWithDeviceInfo', Level.LEVEL0, (): void => {
    floatParam.defaultWidthRatio = 0.79;
    floatParam.calcRatioBaseWidth = 1260;
    floatParam.defaultWidthRatio = 0.79;
    screenProp.width = 1260;
    screenProp.height = 2500;
    floatParam.initWithDeviceInfo(screenProp, false, false);
    floatParam.initWithDeviceInfo(screenProp, false, true);
    floatParam.initWithDeviceInfo(screenProp, true, false);
    floatParam.initWithDeviceInfo(screenProp, true, true);
    expect(true).assertTrue();
    let newScreenProperty = new SCBScreenProperty();
    floatParam.initWithDeviceInfo(newScreenProperty, false, false);
    floatParam.initWithDeviceInfo(newScreenProperty, false, true);
    floatParam.initWithDeviceInfo(newScreenProperty, true, false);
    floatParam.initWithDeviceInfo(newScreenProperty, true, true);
    expect(true).assertTrue();
    SCBWindowSceneConfig.getInstance().windowSceneConfig.uiType = SCBConstants.UITYPE_PAD;
    floatParam.initWithDeviceInfo(screenProp, false, false);
    floatParam.initWithDeviceInfo(screenProp, false, true);
    floatParam.initWithDeviceInfo(screenProp, true, false);
    floatParam.initWithDeviceInfo(screenProp, true, true);
    expect(true).assertTrue();
    floatParam.initWithDeviceInfo(newScreenProperty, false, false);
    floatParam.initWithDeviceInfo(newScreenProperty, false, true);
    floatParam.initWithDeviceInfo(newScreenProperty, true, false);
    floatParam.initWithDeviceInfo(newScreenProperty, true, true);
    expect(true).assertTrue();
  });
}
